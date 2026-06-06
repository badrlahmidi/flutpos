import 'package:core/core.dart';

import '../protocol/event_envelope.dart';
import '../protocol/order_snapshot_codec.dart';
import '../protocol/ws_action.dart';

/// Statut d'un accusé de réception ([WsAction.ack]).
abstract final class AckStatus {
  static const success = 'SUCCESS';
  static const error = 'ERROR';
}

/// Serveur par défaut si le mobile n'envoie pas [waiterId].
const kDefaultWaiterId = '00000000-0000-4000-8000-000000000012';

/// Dispatcher d'événements WebSocket côté caisse PC.
class WsMessageHandler {
  WsMessageHandler({
    OrderRepository? orderRepository,
    CashSessionRepository? cashSessionRepository,
    ProductRepository? productRepository,
  })  : _orders = orderRepository,
        _sessions = cashSessionRepository,
        _products = productRepository;

  final OrderRepository? _orders;
  final CashSessionRepository? _sessions;
  final ProductRepository? _products;

  /// Traite un message entrant et retourne l'ACK à renvoyer au client.
  Future<EventEnvelope> handle(EventEnvelope envelope) async {
    switch (envelope.action) {
      case WsAction.createOrder:
        return _handleCreateOrder(envelope);

      case WsAction.addItems:
        return _handleAddItems(envelope);

      case WsAction.getOpenOrder:
        return _handleGetOpenOrder(envelope);

      case WsAction.voidItem:
        print('[WsMessageHandler] VOID_ITEM de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.updateItemCourse:
        return _handleUpdateItemCourse(envelope);

      case WsAction.fireCourse:
        return _handleFireCourse(envelope);

      case WsAction.requestBill:
        print('[WsMessageHandler] REQUEST_BILL de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.updateStock:
        print('[WsMessageHandler] UPDATE_STOCK de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.ping:
        return EventEnvelope.create(
          action: WsAction.pong,
          deviceId: 'pos-server',
          payload: {'originalMessageId': envelope.messageId},
        );

      case WsAction.pong:
        print('[WsMessageHandler] PONG reçu de ${envelope.deviceId}');
        return EventEnvelope.create(
          action: WsAction.ack,
          deviceId: 'pos-server',
          payload: {
            'status': AckStatus.success,
            'originalMessageId': envelope.messageId,
            'message': 'PONG received',
          },
        );

      default:
        print('[WsMessageHandler] Action inconnue: ${envelope.action}');
        return _errorAck(
          envelope,
          message: 'Unknown action: ${envelope.action}',
        );
    }
  }

  Future<EventEnvelope> _handleCreateOrder(EventEnvelope envelope) async {
    print('[WsMessageHandler] CREATE_ORDER de ${envelope.deviceId}');
    final orders = _orders;
    final sessions = _sessions;
    if (orders == null || sessions == null) {
      return _errorAck(envelope, message: 'Services commande indisponibles');
    }

    try {
      final payload = envelope.payload;
      final tableId = payload['tableId'] as String?;
      if (tableId == null || tableId.isEmpty) {
        return _errorAck(envelope, message: 'tableId requis');
      }

      final existing = await orders.getOpenOrderForTable(tableId);
      if (existing != null) {
        return _successAck(envelope, data: {'orderId': existing.id});
      }

      final session = await sessions.getAnyOpenSession();
      if (session == null) {
        return _errorAck(
          envelope,
          message: 'Aucune session caisse ouverte sur le PC',
        );
      }

      final waiterId = payload['waiterId'] as String? ?? kDefaultWaiterId;
      final guestCount = payload['guestCount'] as int? ?? 1;
      final orderId = payload['orderId'] as String?;

      final order = await orders.openTableOrder(
        sessionId: session.id,
        waiterId: waiterId,
        tableId: tableId,
        guestCount: guestCount,
        orderId: orderId,
      );
      return _successAck(envelope, data: {'orderId': order.id});
    } catch (e) {
      return _errorAck(envelope, message: '$e');
    }
  }

  Future<EventEnvelope> _handleAddItems(EventEnvelope envelope) async {
    print('[WsMessageHandler] ADD_ITEMS de ${envelope.deviceId}');
    final orders = _orders;
    final products = _products;
    if (orders == null || products == null) {
      return _errorAck(envelope, message: 'Services commande indisponibles');
    }

    try {
      final payload = envelope.payload;
      final orderId = payload['orderId'] as String?;
      final productId = payload['productId'] as String?;
      if (orderId == null ||
          orderId.isEmpty ||
          productId == null ||
          productId.isEmpty) {
        return _errorAck(
          envelope,
          message: 'orderId et productId requis',
        );
      }

      final complete = await orders.getCompleteOrder(orderId);
      if (complete == null) {
        return _errorAck(envelope, message: 'Commande introuvable');
      }

      final product = await products.getProductById(productId);
      if (product == null) {
        return _errorAck(envelope, message: 'Produit introuvable');
      }

      final courseRaw = payload['courseNumber'];
      final courseNumber = courseRaw is int ? courseRaw : 1;
      final quantityRaw = payload['quantity'];
      final quantity =
          quantityRaw is num ? quantityRaw.toDouble() : 1.0;
      final customNotes = payload['customNotes'] as String?;
      final orderItemId = payload['orderItemId'] as String?;

      final item = await orders.addOrderItem(
        orderId: orderId,
        product: product,
        orderType: complete.orderType,
        quantity: quantity,
        customNotes: customNotes,
        courseNumber: courseNumber,
        orderItemId: orderItemId,
      );
      return _successAck(
        envelope,
        data: {'orderItemId': item.id},
      );
    } catch (e) {
      return _errorAck(envelope, message: '$e');
    }
  }

  Future<EventEnvelope> _handleGetOpenOrder(EventEnvelope envelope) async {
    print('[WsMessageHandler] GET_OPEN_ORDER de ${envelope.deviceId}');
    final orders = _orders;
    if (orders == null) {
      return _errorAck(envelope, message: 'OrderRepository indisponible');
    }

    try {
      final tableId = envelope.payload['tableId'] as String?;
      if (tableId == null || tableId.isEmpty) {
        return _errorAck(envelope, message: 'tableId requis');
      }

      final open = await orders.getOpenOrderForTable(tableId);
      if (open == null) {
        return _successAck(envelope, data: {'snapshot': null});
      }

      final complete = await orders.getCompleteOrder(open.id);
      return _successAck(
        envelope,
        data: {
          'snapshot': OrderSnapshotCodec.encode(complete),
        },
      );
    } catch (e) {
      return _errorAck(envelope, message: '$e');
    }
  }

  Future<EventEnvelope> _handleFireCourse(EventEnvelope envelope) async {
    print('[WsMessageHandler] FIRE_COURSE de ${envelope.deviceId}');
    final orders = _orders;
    if (orders == null) {
      return _errorAck(envelope, message: 'OrderRepository indisponible');
    }

    try {
      final payload = envelope.payload;
      final orderId = payload['orderId'] as String?;
      if (orderId == null || orderId.isEmpty) {
        return _errorAck(envelope, message: 'orderId requis');
      }

      final courseRaw = payload['courseNumber'];
      if (courseRaw is int) {
        await orders.fireCourse(orderId: orderId, courseNumber: courseRaw);
      } else {
        final result = await orders.fireNextPendingCourse(orderId);
        if (result == null) {
          return _errorAck(envelope, message: 'Aucune course en attente');
        }
      }
      return _successAck(envelope);
    } catch (e) {
      return _errorAck(envelope, message: '$e');
    }
  }

  Future<EventEnvelope> _handleUpdateItemCourse(EventEnvelope envelope) async {
    print('[WsMessageHandler] UPDATE_ITEM_COURSE de ${envelope.deviceId}');
    final orders = _orders;
    if (orders == null) {
      return _errorAck(envelope, message: 'OrderRepository indisponible');
    }

    try {
      final payload = envelope.payload;
      final orderItemId = payload['orderItemId'] as String?;
      final courseNumber = payload['courseNumber'];
      if (orderItemId == null || courseNumber is! int) {
        return _errorAck(
          envelope,
          message: 'orderItemId et courseNumber requis',
        );
      }
      await orders.updateOrderItemCourse(
        orderItemId: orderItemId,
        courseNumber: courseNumber,
      );
      return _successAck(envelope);
    } catch (e) {
      return _errorAck(envelope, message: '$e');
    }
  }

  EventEnvelope _successAck(
    EventEnvelope original, {
    Map<String, dynamic>? data,
  }) {
    return EventEnvelope.create(
      action: WsAction.ack,
      deviceId: 'pos-server',
      payload: {
        'status': AckStatus.success,
        'originalMessageId': original.messageId,
        'message': '${original.action} accepted',
        if (data != null) ...data,
      },
    );
  }

  EventEnvelope _errorAck(EventEnvelope original, {required String message}) {
    return EventEnvelope.create(
      action: WsAction.ack,
      deviceId: 'pos-server',
      payload: {
        'status': AckStatus.error,
        'originalMessageId': original.messageId,
        'message': message,
      },
    );
  }
}
