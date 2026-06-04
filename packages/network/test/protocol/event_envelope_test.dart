import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:test/test.dart';

void main() {
  group('EventEnvelope', () {
    test('create génère messageId UUID et timestamp ISO-8601', () {
      final envelope = EventEnvelope.create(
        action: WsAction.createOrder,
        deviceId: 'waiter-01',
        payload: {'tableId': 'table-1'},
      );

      expect(envelope.messageId, isNotEmpty);
      expect(envelope.messageId.length, greaterThanOrEqualTo(36));
      expect(envelope.action, WsAction.createOrder);
      expect(envelope.deviceId, 'waiter-01');
      expect(envelope.payload['tableId'], 'table-1');
      expect(DateTime.parse(envelope.timestamp), isA<DateTime>());
    });

    test('fromJson / toJson round-trip', () {
      final original = EventEnvelope.create(
        action: WsAction.addItems,
        deviceId: 'waiter-02',
        payload: {'orderId': 'abc', 'items': []},
      );

      final restored = EventEnvelope.fromJson(original.toJson());
      expect(restored.messageId, original.messageId);
      expect(restored.action, original.action);
      expect(restored.timestamp, original.timestamp);
      expect(restored.deviceId, original.deviceId);
      expect(restored.payload['orderId'], 'abc');
    });

    test('fromJson avec payload absent retourne map vide', () {
      final envelope = EventEnvelope.fromJson({
        'messageId': 'id-1',
        'action': WsAction.ping,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'deviceId': 'dev-1',
      });

      expect(envelope.payload, isEmpty);
    });
  });
}
