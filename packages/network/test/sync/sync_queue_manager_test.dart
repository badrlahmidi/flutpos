import 'dart:convert';

import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:network/client/network_sender.dart';
import 'package:network/protocol/event_envelope.dart';
import 'package:network/protocol/ws_action.dart';
import 'package:network/sync/sync_queue_manager.dart';
import 'package:test/test.dart';

class _FakeSender implements NetworkSender {
  bool failSend = false;
  int sendCount = 0;

  @override
  bool isConnected = true;

  @override
  Future<void> sendDirect(EventEnvelope envelope) async {
    if (failSend) {
      throw StateError('socket down');
    }
    sendCount++;
  }
}

EventEnvelope _envelope(String messageId) => EventEnvelope(
      messageId: messageId,
      action: WsAction.createOrder,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      deviceId: 'waiter-test',
      userRole: UserRole.waiter,
      payload: {'tableId': 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d'},
    );

Future<void> _insertRaw(
  AppDatabase db, {
  required String id,
  required String messageId,
  required String status,
}) async {
  await db.into(db.syncQueue).insert(
        SyncQueueCompanion.insert(
          id: Value(id),
          action: WsAction.createOrder,
          payload: jsonEncode(_envelope(messageId).toJson()),
          status: Value(status),
          createdAt: DateTime.now().toUtc(),
        ),
      );
}

void main() {
  late AppDatabase db;
  late SyncQueueManager queue;
  late _FakeSender sender;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    queue = SyncQueueManager(db);
    sender = _FakeSender();
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> countByStatus(String status) async {
    final rows = await (db.select(db.syncQueue)
          ..where((row) => row.status.equals(status)))
        .get();
    return rows.length;
  }

  test('flush envoie mais garde PENDING_SYNC tant que pas d\'ACK', () async {
    await queue.enqueue(_envelope('msg-1'));

    await queue.flush(sender);

    expect(sender.sendCount, 1);
    expect(await countByStatus(SyncQueueStatus.pendingSync), 1);
    expect(await countByStatus(SyncQueueStatus.sent), 0);
  });

  test('onAck passe l\'entrée en ACKED', () async {
    await queue.enqueue(_envelope('msg-1'));
    await queue.flush(sender);

    await queue.onAck('msg-1');

    expect(await countByStatus(SyncQueueStatus.acked), 1);
    expect(await countByStatus(SyncQueueStatus.pendingSync), 0);
  });

  test('sans ACK, le flush suivant renvoie la même entrée (reprise)',
      () async {
    await queue.enqueue(_envelope('msg-1'));
    await queue.flush(sender);

    await queue.flush(sender);

    expect(sender.sendCount, 2);
  });

  test('les entrées SENT orphelines héritées sont re-envoyées', () async {
    await _insertRaw(
      db,
      id: 'legacy-1',
      messageId: 'msg-legacy',
      status: SyncQueueStatus.sent,
    );

    await queue.flush(sender);

    expect(sender.sendCount, 1);
    expect(await countByStatus(SyncQueueStatus.sent), 0);
    expect(await countByStatus(SyncQueueStatus.pendingSync), 1);
  });

  test('un échec d\'envoi marque FAILED puis retryFailed remet en file',
      () async {
    await queue.enqueue(_envelope('msg-1'));
    sender.failSend = true;

    await queue.flush(sender);
    expect(await countByStatus(SyncQueueStatus.failed), 1);

    sender.failSend = false;
    await queue.retryFailed();
    expect(await countByStatus(SyncQueueStatus.pendingSync), 1);

    await queue.flush(sender);
    expect(sender.sendCount, 1);
  });
}
