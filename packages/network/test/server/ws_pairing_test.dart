import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:network/server/ws_message_handler.dart';
import 'package:test/test.dart';

void main() {
  group('WsMessageHandler — pairing (HAUTE-N02)', () {
    late AppDatabase db;
    late DevicePairingRepository pairings;
    late WsMessageHandler handler;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      pairings = DevicePairingRepository(db);
      handler = WsMessageHandler(devicePairingRepository: pairings);
    });

    tearDown(() => db.close());

    EventEnvelope _incoming(Map<String, dynamic> payload) {
      return EventEnvelope.create(
        action: WsAction.pairingRequest,
        deviceId: 'waiter-pair-001',
        payload: payload,
      );
    }

    test('PAIRING_REQUEST sans repo retourne ERROR', () async {
      final bare = WsMessageHandler();
      final ack = await bare.handle(_incoming({'pairingToken': 'x'}));
      expect(ack.action, WsAction.error);
      expect(ack.payload['code'], ErrorCode.unknown);
    });

    test('PAIRING_REQUEST sans token retourne VALIDATION', () async {
      final ack = await handler.handle(_incoming(const {}));
      expect(ack.action, WsAction.error);
      expect(ack.payload['code'], ErrorCode.validation);
    });

    test('token invalide → PAIRING_RESPONSE ERROR', () async {
      final ack = await handler.handle(
        _incoming({'pairingToken': '3f2504e0-4f89-11d3-9a0c-0305e82c3301'}),
      );
      expect(ack.action, WsAction.pairingResponse);
      expect(ack.payload['status'], AckStatus.error);
      expect(ack.payload['code'], ErrorCode.unauthorized);
    });

    test('token valide → PAIRING_RESPONSE SUCCESS + device actif', () async {
      final request = await pairings.createPairingRequest(
        deviceId: 'waiter-pair-001',
        deviceName: 'Samsung A14',
      );

      final ack = await handler.handle(
        _incoming({
          'pairingToken': request.pairingToken,
          'confirmedBy': 'manager-1',
        }),
      );

      expect(ack.action, WsAction.pairingResponse);
      expect(ack.payload['status'], AckStatus.success);
      expect(ack.payload['deviceId'], 'waiter-pair-001');
      expect(await pairings.isDeviceActive('waiter-pair-001'), isTrue);
      // Un device pairé ne peut pas se re-coupler avec le même token.
      final replay = await handler.handle(
        _incoming({'pairingToken': request.pairingToken}),
      );
      expect(replay.payload['status'], AckStatus.error);
    });
  });
}
