import 'dart:convert';

import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../client/network_sender.dart';
import '../protocol/event_envelope.dart';
import '../protocol/event_serializer.dart';

const _uuid = Uuid();

/// Statuts possibles d'une entrée [SyncQueue].
abstract final class SyncQueueStatus {
  static const pendingSync = 'PENDING_SYNC';
  static const sent = 'SENT';
  static const acked = 'ACKED';
  static const failed = 'FAILED';
}

/// Gestionnaire offline-first de la file [SyncQueue] Drift.
class SyncQueueManager {
  SyncQueueManager(this._database);

  final AppDatabase _database;

  /// Insère un message dans la file d'attente locale.
  Future<void> enqueue(EventEnvelope envelope) async {
    await _database.into(_database.syncQueue).insert(
          SyncQueueCompanion.insert(
            id: Value(_uuid.v4()),
            action: envelope.action,
            payload: jsonEncode(envelope.toJson()),
            status: const Value(SyncQueueStatus.pendingSync),
            createdAt: DateTime.now().toUtc(),
          ),
        );
    print('[SyncQueueManager] Enqueued ${envelope.action} (${envelope.messageId})');
  }

  /// Envoie toutes les entrées en attente via le client réseau.
  ///
  /// Durabilité offline-first : une entrée reste `PENDING_SYNC` jusqu'à la
  /// réception de l'ACK serveur ([onAck]). Si la connexion tombe entre
  /// l'envoi et l'acquittement, elle est renvoyée au prochain flush —
  /// la dédup messageId côté caisse et les orderItemId déterministes
  /// rendent cette reprise idempotente.
  ///
  /// Les entrées `SENT` héritées d'anciennes versions (marquées avant ACK,
  /// donc potentiellement orphelines) sont re-envoyées elles aussi.
  Future<void> flush(NetworkSender client) async {
    if (!client.isConnected) {
      print('[SyncQueueManager] Flush ignoré — client déconnecté.');
      return;
    }

    final pending = await (_database.select(_database.syncQueue)
          ..where(
            (row) => row.status.isIn([
              SyncQueueStatus.pendingSync,
              SyncQueueStatus.sent,
            ]),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();

    var sentCount = 0;
    for (final entry in pending) {
      final envelope = EventSerializer.decode(entry.payload);
      if (envelope == null) {
        await _markFailed(entry.id, entry.retryCount);
        continue;
      }

      try {
        await client.sendDirect(envelope);
        sentCount++;
      } catch (_) {
        await _markFailed(entry.id, entry.retryCount);
        continue;
      }
      // L'entrée reste PENDING_SYNC jusqu'à l'ACK : un crash ici ne perd
      // pas le message, il sera renvoyé au prochain flush. Les anciennes
      // lignes SENT sont normalisées vers ce flux durable.
      await (_database.update(_database.syncQueue)
            ..where((row) => row.id.equals(entry.id)))
          .write(
        SyncQueueCompanion(
          status: entry.status == SyncQueueStatus.sent
              ? const Value(SyncQueueStatus.pendingSync)
              : const Value.absent(),
          lastAttemptAt: Value(DateTime.now().toUtc()),
        ),
      );
    }

    if (sentCount > 0) {
      print('[SyncQueueManager] Flush de $sentCount message(s).');
    }
  }

  /// Marque une entrée comme acquittée via [originalMessageId].
  Future<void> onAck(String originalMessageId) async {
    final entries = await (_database.select(_database.syncQueue)
          ..where(
            (row) => row.status.isIn([
              SyncQueueStatus.pendingSync,
              SyncQueueStatus.sent,
            ]),
          ))
        .get();

    for (final entry in entries) {
      final envelope = EventSerializer.decode(entry.payload);
      if (envelope?.messageId == originalMessageId) {
        await (_database.update(_database.syncQueue)
              ..where((row) => row.id.equals(entry.id)))
            .write(
          SyncQueueCompanion(
            status: const Value(SyncQueueStatus.acked),
            lastAttemptAt: Value(DateTime.now().toUtc()),
          ),
        );
        print('[SyncQueueManager] ACK reçu pour $originalMessageId');
      }
    }

    await _purgeOldAcked();
  }

  /// Reprend les entrées `FAILED` avec `retryCount < 5`.
  Future<void> retryFailed() async {
    final failed = await (_database.select(_database.syncQueue)
          ..where(
            (row) =>
                row.status.equals(SyncQueueStatus.failed) &
                row.retryCount.isSmallerThanValue(5),
          )
          ..orderBy([(row) => OrderingTerm.asc(row.createdAt)]))
        .get();

    for (final entry in failed) {
      await (_database.update(_database.syncQueue)
            ..where((row) => row.id.equals(entry.id)))
          .write(
        SyncQueueCompanion(
          status: const Value(SyncQueueStatus.pendingSync),
          retryCount: Value(entry.retryCount + 1),
          lastAttemptAt: Value(DateTime.now().toUtc()),
        ),
      );
    }

    if (failed.isNotEmpty) {
      print('[SyncQueueManager] ${failed.length} entrée(s) remise(s) en file.');
    }
  }

  Future<void> _markFailed(String id, int retryCount) async {
    await (_database.update(_database.syncQueue)..where((row) => row.id.equals(id)))
        .write(
      SyncQueueCompanion(
        status: const Value(SyncQueueStatus.failed),
        retryCount: Value(retryCount + 1),
        lastAttemptAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<void> _purgeOldAcked() async {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(hours: 24));
    await (_database.delete(_database.syncQueue)
          ..where(
            (row) =>
                row.status.equals(SyncQueueStatus.acked) &
                row.createdAt.isSmallerThanValue(cutoff),
          ))
        .go();
  }
}
