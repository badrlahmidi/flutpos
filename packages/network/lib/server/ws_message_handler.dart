import '../protocol/event_envelope.dart';
import '../protocol/ws_action.dart';

/// Statut d'un accusé de réception ([WsAction.ack]).
abstract final class AckStatus {
  static const success = 'SUCCESS';
  static const error = 'ERROR';
}

/// Dispatcher d'événements WebSocket côté caisse PC.
///
/// Route chaque [EventEnvelope] entrant vers le handler approprié et produit
/// un ACK idempotent. Le branchement BLoC/Drift métier viendra au sprint suivant.
class WsMessageHandler {
  /// Traite un message entrant et retourne l'ACK à renvoyer au client.
  EventEnvelope handle(EventEnvelope envelope) {
    switch (envelope.action) {
      case WsAction.createOrder:
        print('[WsMessageHandler] CREATE_ORDER de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.addItems:
        print('[WsMessageHandler] ADD_ITEMS de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.voidItem:
        print('[WsMessageHandler] VOID_ITEM de ${envelope.deviceId}');
        return _successAck(envelope);

      case WsAction.fireCourse:
        print('[WsMessageHandler] FIRE_COURSE de ${envelope.deviceId}');
        return _successAck(envelope);

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

  EventEnvelope _successAck(EventEnvelope original) {
    return EventEnvelope.create(
      action: WsAction.ack,
      deviceId: 'pos-server',
      payload: {
        'status': AckStatus.success,
        'originalMessageId': original.messageId,
        'message': '${original.action} accepted',
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
