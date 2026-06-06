import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:network/network.dart';

/// Script manuel — démarre le serveur POS et vérifie /ping + WebSocket ACK.
///
/// Usage :
/// ```bash
/// cd tools
/// dart pub get
/// dart run test_network.dart
/// ```
///
/// Puis dans un autre terminal :
/// ```bash
/// curl http://localhost:8080/ping
/// ```
Future<void> main() async {
  final dbFile = File('test_network.db');
  if (await dbFile.exists()) {
    await dbFile.delete();
  }

  final db = AppDatabase(NativeDatabase(dbFile));
  final server = PosNetworkServer(database: db);

  await server.start();
  print('Serveur démarré sur :8080 — mDNS annoncé (_ritajpos._tcp)');

  // Test HTTP /ping
  final client = HttpClient();
  try {
    final request = await client.get('localhost', 8080, '/ping');
    final response = await request.close();
    final body = await response.transform(utf8.decoder).join();
    print('GET /ping → ${response.statusCode}: $body');
  } finally {
    client.close(force: true);
  }

  // Test WebSocket CREATE_ORDER → ACK
  try {
    final socket = await WebSocket.connect('ws://localhost:8080/ws');
    final completer = Completer<void>();

    socket.listen(
      (dynamic data) {
        print('WS reçu: $data');
        final envelope = EventSerializer.decode(data as String);
        if (envelope?.action == WsAction.ack) {
          print('ACK OK — status: ${envelope!.payload['status']}');
          completer.complete();
        }
      },
      onError: print,
    );

    final order = EventEnvelope.create(
      action: WsAction.createOrder,
      deviceId: 'test-waiter-manual',
      payload: {'tableId': 'S1', 'guestCount': 2},
    );
    socket.add(EventSerializer.encode(order));
    print('WS envoyé: CREATE_ORDER');

    await completer.future.timeout(const Duration(seconds: 5));
    await socket.close();
  } catch (error) {
    print('Test WebSocket échoué: $error');
  }

  print('Appuyez sur Ctrl+C pour arrêter le serveur…');
  await ProcessSignal.sigint.watch().first;
  await server.stop();
  await db.close();
  if (await dbFile.exists()) {
    await dbFile.delete();
  }
}
