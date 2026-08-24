import 'package:core/core.dart';

import '../protocol/event_envelope.dart';
import '../protocol/order_snapshot_codec.dart';
import '../protocol/ws_action.dart';
import '../utils/app_logger.dart';
import 'validators/add_items_validator.dart';
import 'validators/apply_discount_validator.dart';
import 'validators/base_validator.dart';
import 'validators/create_order_validator.dart';

/// Statut d'un accusé de réception ([WsAction.ack]).
abstract final class AckStatus {
  static const success = 'SUCCESS';
  static const error = 'ERROR';
}

/// Serveur par défaut si le mobile n'envoie pas [waiterId].
const kDefaultWaiterId = '00000000-0000-4000-8000-000000000012';

/// Codes d'erreur standardisés (security fix [HAUTE-N03]).
abstract final class ErrorCode {
  static const rateLimited = 'RATE_LIMITED';
  static const unauthorized = 'UNAUTHORIZED';
  static const forbidden = 'FORBIDDEN';
  static const validation = 'VALIDATION';
  static const duplicate = 'DUPLICATE';
  static const unknown = 'UNKNOWN';
}

/// Dispatcher d'événements WebSocket côté caisse PC.
///
/// Intègre :
/// * RBAC (security fix [HAUTE-A04]) — `RbacPermissionChecker`.
/// * Validation des payloads (security fix [HAUTE-N03]).
/// * Déduplication messageId (security fix [BAS-N06]).
/// * Logging structuré (security fix [MOY-N04]).
class WsMessageHandler {
  WsMessageHandler({
    OrderRepository? orderRepository,
    CashSessionRepository? cashSessionRepository,
    ProductRepository? productRepository,
    this.devicePairingRepository,
    RbacPermissionChecker? permissionChecker,
    int messageIdCacheSize = 1000,
  })  : _orders = orderRepository,
        _sessions = cashSessionRepository,
        _products = productRepository,
        _rbac = permissionChecker ?? RbacPermissionChecker(),
        _seenMessageIds = _LruCache(messageIdCacheSize);

  final OrderRepository? _orders;
  final CashSessionRepository? _sessions;
  final ProductRepository? _products;

  /// Couplage des terminaux (security fix [HAUTE-N02]).
  final DevicePairingRepository? devicePairingRepository;

  final RbacPermissionChecker _rbac;
  final _LruCache<String, bool> _seenMessageIds;

  /// Validators per command (security fix [HAUTE-N03]).
  final Map<String, WsPayloadValidator> _validators = {
    WsAction.createOrder: const CreateOrderValidator(),
    WsAction.addItems: const AddItemsValidator(),
    WsAction.applyDiscount: const ApplyDiscountValidator(),
  };

  /// Traite un message entrant et retourne l'ACK à renvoyer au client.
  Future<EventEnvelope> handle(EventEnvelope envelope) async {
    // [BAS-N06] Deduplication by messageId (idempotence réseau).
    if (_seenMessageIds.containsKey(envelope.messageId)) {
      AppLogger.instance.info(
        'Duplicate messageId ignored: ${envelope.messageId} '
        '(${AppLogger.maskDeviceId(envelope.deviceId)})',
      );
      // Silent ACK (idempotent reply).
      return _successAck(envelope, data: {'duplicate': true});
    }
    _seenMessageIds[envelope.messageId] = true;

    // [HAUTE-A04] RBAC check.
    if (_rbac.isKnownCommand(envelope.action) &&
        !_rbac.isAllowed(envelope.action, envelope.userRole)) {
      AppLogger.instance.warning(
        'RBAC: ${envelope.action} denied for role ${envelope.userRole} '
        '(${AppLogger.maskDeviceId(envelope.deviceId)})',
      );
      return _errorEnvelope(
        envelope,
        code: ErrorCode.forbidden,
        message:
            'Permission refusée : ${envelope.action} nécessite un rôle manager',
      );
    }

    // [HAUTE-N03] Validation des payloads.
    final validator = _validators[envelope.action];
    if (validator != null) {
      final result = validator.validate(envelope.payload);
      if (!result.isValid) {
        AppLogger.instance.warning(
          'Validation failed: ${envelope.action} '
          '(${AppLogger.maskDeviceId(envelope.deviceId)}) '
          '${result.errors.map((e) => e.toJson()).toList()}',
        );
        return EventEnvelope.create(
          action: WsAction.error,
          deviceId: 'pos-server',
          payload: {
            'status': AckStatus.error,
            'code': ErrorCode.validation,
            'originalMessageId': envelope.messageId,
            'errors': result.errors.map((e) => e.toJson()).toList(),
          },
        );
      }
    }

    switch (envelope.action) {
      case WsAction.createOrder:
        return _handleCreateOrder(envelope);

      case WsAction.addItems:
        return _handleAddItems(envelope);

      case WsAction.getOpenOrder:
        return _handleGetOpenOrder(envelope);

      case WsAction.voidItem:
        AppLogger.instance.info(
          'VOID_ITEM from ${AppLogger.maskDeviceId(envelope.deviceId)}',
        );
        return _successAck(envelope);

      case WsAction.updateItemCourse:
        return _handleUpdateItemCourse(envelope);

      case WsAction.fireCourse:
        return _handleFireCourse(envelope);

      case WsAction.requestBill:
        AppLogger.instance.info(
          'REQUEST_BILL from ${AppLogger.maskDeviceId(envelope.deviceId)}',
        );
        return _successAck(envelope);

      case WsAction.updateStock:
        AppLogger.instance.info(
          'UPDATE_STOCK from ${AppLogger.maskDeviceId(envelope.deviceId)}',
        );
        return _successAck(envelope);

      case WsAction.pairingRequest:
        return _handlePairingRequest(envelope);

      case WsAction.ping:
        return EventEnvelope.create(
          action: WsAction.pong,
          deviceId: 'pos-server',
          payload: {'originalMessageId': envelope.messageId},
        );

      case WsAction.pong:
        AppLogger.instance.info(
          'PONG received from ${AppLogger.maskDeviceId(envelope.deviceId)}',
        );
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
        AppLogger.instance.warning(
          'Unknown action: ${envelope.action}',
        );
        return _errorEnvelope(
          envelope,
          code: ErrorCode.unknown,
          message: 'Action inconnue: ${envelope.action}',
        );
    }
  }

  Future<EventEnvelope> _handleCreateOrder(EventEnvelope envelope) async {
    AppLogger.instance.info(
      'CREATE_ORDER from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final orders = _orders;
    final sessions = _sessions;
    if (orders == null || sessions == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown, message: 'Services commande indisponibles');
    }

    try {
      final payload = envelope.payload;
      final tableId = payload['tableId'] as String?;
      if (tableId == null || tableId.isEmpty) {
        return _errorEnvelope(envelope,
            code: ErrorCode.validation, message: 'tableId requis');
      }

      final existing = await orders.getOpenOrderForTable(tableId);
      if (existing != null) {
        return _successAck(envelope, data: {'orderId': existing.id});
      }

      final session = await sessions.getAnyOpenSession();
      if (session == null) {
        return _errorEnvelope(
          envelope,
          code: ErrorCode.unknown,
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
    } catch (e, st) {
      AppLogger.instance.severe('CREATE_ORDER error', error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
    }
  }

  Future<EventEnvelope> _handleAddItems(EventEnvelope envelope) async {
    AppLogger.instance.info(
      'ADD_ITEMS from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final orders = _orders;
    final products = _products;
    if (orders == null || products == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown, message: 'Services commande indisponibles');
    }

    try {
      final payload = envelope.payload;
      final orderId = payload['orderId'] as String?;
      final productId = payload['productId'] as String?;
      if (orderId == null ||
          orderId.isEmpty ||
          productId == null ||
          productId.isEmpty) {
        return _errorEnvelope(
          envelope,
          code: ErrorCode.validation,
          message: 'orderId et productId requis',
        );
      }

      final complete = await orders.getCompleteOrder(orderId);
      if (complete == null) {
        return _errorEnvelope(envelope,
            code: ErrorCode.unknown, message: 'Commande introuvable');
      }

      final product = await products.getProductById(productId);
      if (product == null) {
        return _errorEnvelope(envelope,
            code: ErrorCode.unknown, message: 'Produit introuvable');
      }

      final courseRaw = payload['courseNumber'];
      final courseNumber = courseRaw is int ? courseRaw : 1;
      final quantityRaw = payload['quantity'];
      final quantity = quantityRaw is num ? quantityRaw.toDouble() : 1.0;
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
    } catch (e, st) {
      AppLogger.instance.severe('ADD_ITEMS error', error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
    }
  }

  Future<EventEnvelope> _handleGetOpenOrder(EventEnvelope envelope) async {
    AppLogger.instance.info(
      'GET_OPEN_ORDER from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final orders = _orders;
    if (orders == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown, message: 'OrderRepository indisponible');
    }

    try {
      final tableId = envelope.payload['tableId'] as String?;
      if (tableId == null || tableId.isEmpty) {
        return _errorEnvelope(envelope,
            code: ErrorCode.validation, message: 'tableId requis');
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
    } catch (e, st) {
      AppLogger.instance.severe('GET_OPEN_ORDER error',
          error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
    }
  }

  Future<EventEnvelope> _handleFireCourse(EventEnvelope envelope) async {
    AppLogger.instance.info(
      'FIRE_COURSE from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final orders = _orders;
    if (orders == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown, message: 'OrderRepository indisponible');
    }

    try {
      final payload = envelope.payload;
      final orderId = payload['orderId'] as String?;
      if (orderId == null || orderId.isEmpty) {
        return _errorEnvelope(envelope,
            code: ErrorCode.validation, message: 'orderId requis');
      }

      final courseRaw = payload['courseNumber'];
      if (courseRaw is int) {
        await orders.fireCourse(orderId: orderId, courseNumber: courseRaw);
      } else {
        final result = await orders.fireNextPendingCourse(orderId);
        if (result == null) {
          return _errorEnvelope(envelope,
              code: ErrorCode.unknown,
              message: 'Aucune course en attente');
        }
      }
      return _successAck(envelope);
    } catch (e, st) {
      AppLogger.instance.severe('FIRE_COURSE error', error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
    }
  }

  Future<EventEnvelope> _handleUpdateItemCourse(
      EventEnvelope envelope) async {
    AppLogger.instance.info(
      'UPDATE_ITEM_COURSE from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final orders = _orders;
    if (orders == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown, message: 'OrderRepository indisponible');
    }

    try {
      final payload = envelope.payload;
      final orderItemId = payload['orderItemId'] as String?;
      final courseNumber = payload['courseNumber'];
      if (orderItemId == null || courseNumber is! int) {
        return _errorEnvelope(
          envelope,
          code: ErrorCode.validation,
          message: 'orderItemId et courseNumber requis',
        );
      }
      await orders.updateOrderItemCourse(
        orderItemId: orderItemId,
        courseNumber: courseNumber,
      );
      return _successAck(envelope);
    } catch (e, st) {
      AppLogger.instance.severe('UPDATE_ITEM_COURSE error',
          error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
    }
  }

  Future<EventEnvelope> _handlePairingRequest(EventEnvelope envelope) async {
    AppLogger.instance.info(
      'PAIRING_REQUEST from ${AppLogger.maskDeviceId(envelope.deviceId)}',
    );
    final pairings = devicePairingRepository;
    if (pairings == null) {
      return _errorEnvelope(envelope,
          code: ErrorCode.unknown,
          message: 'Service de couplage indisponible');
    }

    try {
      final pairingToken = envelope.payload['pairingToken'] as String?;
      final confirmedBy = envelope.payload['confirmedBy'] as String?;
      if (pairingToken == null || pairingToken.isEmpty) {
        return _errorEnvelope(envelope,
            code: ErrorCode.validation, message: 'pairingToken requis');
      }

      final valid = await pairings.isTokenValid(pairingToken);
      if (!valid) {
        return EventEnvelope.create(
          action: WsAction.pairingResponse,
          deviceId: 'pos-server',
          payload: {
            'status': AckStatus.error,
            'code': ErrorCode.unauthorized,
            'originalMessageId': envelope.messageId,
            'message': 'Token de couplage invalide ou expiré',
          },
        );
      }

      final confirmed = await pairings.confirmPairing(
        pairingToken: pairingToken,
        confirmedBy: confirmedBy ?? envelope.deviceId,
      );
      if (confirmed == null) {
        return EventEnvelope.create(
          action: WsAction.pairingResponse,
          deviceId: 'pos-server',
          payload: {
            'status': AckStatus.error,
            'code': ErrorCode.unauthorized,
            'originalMessageId': envelope.messageId,
            'message': 'Token de couplage invalide ou expiré',
          },
        );
      }
      AppLogger.instance.info(
        'Pairing confirmed for ${AppLogger.maskDeviceId(envelope.deviceId)}',
      );
      return EventEnvelope.create(
        action: WsAction.pairingResponse,
        deviceId: 'pos-server',
        payload: {
          'status': AckStatus.success,
          'originalMessageId': envelope.messageId,
          'deviceId': envelope.deviceId,
          'message': 'Terminal couplé',
        },
      );
    } catch (e, st) {
      AppLogger.instance.severe('PAIRING_REQUEST error',
          error: e, stackTrace: st);
      return _errorEnvelope(envelope, code: ErrorCode.unknown, message: '$e');
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

  EventEnvelope _errorEnvelope(
    EventEnvelope original, {
    required String code,
    required String message,
  }) {
    return EventEnvelope.create(
      action: WsAction.error,
      deviceId: 'pos-server',
      payload: {
        'status': AckStatus.error,
        'code': code,
        'originalMessageId': original.messageId,
        'message': message,
      },
    );
  }
}

/// Simple LRU cache for messageId deduplication (security fix [BAS-N06]).
class _LruCache<K, V> {
  _LruCache(this.maxSize);

  final int maxSize;
  final Map<K, V> _map = {};

  bool containsKey(K key) => _map.containsKey(key);

  V? operator [](K key) {
    final value = _map.remove(key);
    if (value != null) {
      _map[key] = value;
    }
    return value;
  }

  void operator []=(K key, V value) {
    if (_map.containsKey(key)) {
      _map.remove(key);
    }
    _map[key] = value;
    while (_map.length > maxSize) {
      _map.remove(_map.keys.first);
    }
  }
}