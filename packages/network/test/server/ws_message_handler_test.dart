import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:network/server/ws_message_handler.dart';
import 'package:test/test.dart';

void main() {
  group('WsMessageHandler', () {
    late WsMessageHandler handler;

    setUp(() {
      handler = WsMessageHandler();
    });

    EventEnvelope _incoming(String action, {Map<String, dynamic>? payload}) {
      return EventEnvelope(
        messageId: 'msg-in-001',
        action: action,
        timestamp: DateTime.now().toUtc().toIso8601String(),
        deviceId: 'waiter-test',
        payload: payload ?? const {},
      );
    }

    test('CREATE_ORDER retourne ACK SUCCESS', () {
      final ack = handler.handle(_incoming(WsAction.createOrder));

      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], AckStatus.success);
      expect(ack.payload['originalMessageId'], 'msg-in-001');
    });

    test('ADD_ITEMS retourne ACK SUCCESS', () {
      final ack = handler.handle(_incoming(WsAction.addItems));
      expect(ack.payload['status'], AckStatus.success);
    });

    test('VOID_ITEM retourne ACK SUCCESS', () {
      final ack = handler.handle(_incoming(WsAction.voidItem));
      expect(ack.payload['status'], AckStatus.success);
    });

    test('FIRE_COURSE retourne ACK SUCCESS', () {
      final ack = handler.handle(_incoming(WsAction.fireCourse));
      expect(ack.payload['status'], AckStatus.success);
    });

    test('PING retourne PONG', () {
      final response = handler.handle(_incoming(WsAction.ping));
      expect(response.action, WsAction.pong);
      expect(response.payload['originalMessageId'], 'msg-in-001');
    });

    test('action inconnue retourne ACK ERROR', () {
      final ack = handler.handle(_incoming('UNKNOWN_ACTION'));
      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['message'], contains('Unknown action'));
    });
  });
}
