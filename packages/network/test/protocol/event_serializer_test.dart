import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/event_serializer.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:test/test.dart';

void main() {
  group('EventSerializer', () {
    test('encode / decode round-trip', () {
      final envelope = EventEnvelope.create(
        action: WsAction.voidItem,
        deviceId: 'waiter-03',
        payload: {'reason': 'Erreur saisie'},
      );

      final json = EventSerializer.encode(envelope);
      final decoded = EventSerializer.decode(json);

      expect(decoded, isNotNull);
      expect(decoded!.messageId, envelope.messageId);
      expect(decoded.action, envelope.action);
      expect(decoded.deviceId, envelope.deviceId);
    });

    test('decode JSON malformé retourne null sans crasher', () {
      expect(EventSerializer.decode('{invalid json'), isNull);
      expect(EventSerializer.decode(''), isNull);
      expect(EventSerializer.decode('[]'), isNull);
    });

    test('encode ne crashe pas sur payload complexe', () {
      final envelope = EventEnvelope.create(
        action: WsAction.addItems,
        deviceId: 'dev',
        payload: {
          'items': [
            {'id': 'p1', 'qty': 2},
          ],
        },
      );

      expect(EventSerializer.encode(envelope), contains('"items"'));
    });
  });
}
