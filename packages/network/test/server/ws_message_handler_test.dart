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

    EventEnvelope _incoming(
      String action, {
      Map<String, dynamic>? payload,
      String? userRole = UserRole.waiter,
    }) {
      return EventEnvelope(
        messageId: 'msg-in-001',
        action: action,
        timestamp: DateTime.now().toUtc().toIso8601String(),
        deviceId: 'waiter-test',
        userRole: userRole,
        payload: payload ?? const {},
      );
    }

    test('CREATE_ORDER sans services retourne ERROR', () async {
      final ack = await handler.handle(
        _incoming(WsAction.createOrder, payload: {
          'tableId': 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d',
        }),
      );

      expect(ack.action, WsAction.error);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['code'], ErrorCode.unknown);
      expect(ack.payload['message'], contains('indisponibles'));
      expect(ack.payload['originalMessageId'], 'msg-in-001');
    });

    test('CREATE_ORDER sans tableId retourne VALIDATION', () async {
      final ack = await handler.handle(_incoming(WsAction.createOrder));

      expect(ack.action, WsAction.error);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['code'], ErrorCode.validation);
    });

    test('ADD_ITEMS sans services retourne ERROR', () async {
      final ack = await handler.handle(
        _incoming(
          WsAction.addItems,
          payload: {
            'orderId': '3f2504e0-4f89-11d3-9a0c-0305e82c3301',
            'productId': 'c9bf9e57-1685-4c89-bafb-ff5af830be8a',
            'quantity': 1,
            'courseNumber': 1,
          },
        ),
      );
      expect(ack.action, WsAction.error);
      expect(ack.payload['status'], AckStatus.error);
    });

    test('VOID_ITEM retourne ACK SUCCESS', () async {
      final ack = await handler.handle(_incoming(WsAction.voidItem));
      expect(ack.action, WsAction.ack);
      expect(ack.payload['status'], AckStatus.success);
    });

    test('FIRE_COURSE sans repository retourne ERROR', () async {
      final ack = await handler.handle(_incoming(WsAction.fireCourse));
      expect(ack.action, WsAction.error);
      expect(ack.payload['status'], AckStatus.error);
    });

    test('PING retourne PONG', () async {
      final response = await handler.handle(_incoming(WsAction.ping));
      expect(response.action, WsAction.pong);
      expect(response.payload['originalMessageId'], 'msg-in-001');
    });

    test('action inconnue retourne ERROR', () async {
      final ack = await handler.handle(_incoming('UNKNOWN_ACTION'));
      expect(ack.action, WsAction.error);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['code'], ErrorCode.unknown);
      expect(ack.payload['message'], contains('Action inconnue'));
    });

    test('commande connue sans rôle est refusée (RBAC)', () async {
      final ack = await handler.handle(
        _incoming(WsAction.createOrder, userRole: null),
      );
      expect(ack.action, WsAction.error);
      expect(ack.payload['code'], ErrorCode.forbidden);
      expect(ack.payload['status'], AckStatus.error);
    });

    test('APPLY_DISCOUNT refusé pour un serveur (RBAC manager-only)',
        () async {
      final ack = await handler.handle(_incoming(WsAction.applyDiscount));
      expect(ack.action, WsAction.error);
      expect(ack.payload['code'], ErrorCode.forbidden);
    });
  });
}
