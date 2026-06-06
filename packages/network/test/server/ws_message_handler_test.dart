import 'package:core/core.dart';
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

    test('CREATE_ORDER sans services retourne ACK ERROR', () async {
      final ack = await handler.handle(_incoming(WsAction.createOrder));

      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['originalMessageId'], 'msg-in-001');
    });

    test('ADD_ITEMS sans services retourne ACK ERROR', () async {
      final ack = await handler.handle(
        _incoming(
          WsAction.addItems,
          payload: {
            'orderId': 'order-1',
            'productId': 'prod-1',
          },
        ),
      );
      expect(ack.payload['status'], AckStatus.error);
    });

    test('VOID_ITEM retourne ACK SUCCESS', () async {
      final ack = await handler.handle(_incoming(WsAction.voidItem));
      expect(ack.payload['status'], AckStatus.success);
    });

    test('FIRE_COURSE sans repository retourne ACK ERROR', () async {
      final ack = await handler.handle(_incoming(WsAction.fireCourse));
      expect(ack.payload['status'], AckStatus.error);
    });

    test('PING retourne PONG', () async {
      final response = await handler.handle(_incoming(WsAction.ping));
      expect(response.action, WsAction.pong);
      expect(response.payload['originalMessageId'], 'msg-in-001');
    });

    test('action inconnue retourne ACK ERROR', () async {
      final ack = await handler.handle(_incoming('UNKNOWN_ACTION'));
      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['message'], contains('Unknown action'));
    });
  });
}
