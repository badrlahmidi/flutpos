import 'dart:async';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart';

import '../app_database.dart';
import 'cloud_sync_config.dart';
import 'powersync_schema.dart';
import 'ritagestion_powersync_connector.dart';

/// Résultat d'ouverture de la base (Drift + PowerSync optionnel).
final class RitagestionDatabaseBundle {
  const RitagestionDatabaseBundle({
    required this.appDatabase,
    this.cloudSync,
  });

  final AppDatabase appDatabase;

  /// Non null si `CloudSyncConfig.enabled == true`.
  final CloudSyncSession? cloudSync;
}

/// Session PowerSync : connexion, statut, recovery.
final class CloudSyncSession {
  CloudSyncSession({
    required PowerSyncDatabase powerSync,
    required CloudSyncConfig config,
    required RitagestionPowerSyncConnector connector,
  })  : _powerSync = powerSync,
        _config = config,
        _connector = connector;

  final PowerSyncDatabase _powerSync;
  final CloudSyncConfig _config;
  final RitagestionPowerSyncConnector _connector;

  bool get isConnected => _connected;
  bool _connected = false;

  Stream<SyncStatus> get statusStream => _powerSync.statusStream;
  SyncStatus get currentStatus => _powerSync.currentStatus;

  /// Connecte au service PowerSync si JWT + URL configurés.
  Future<void> connect() async {
    if (!_config.canConnect) {
      return;
    }
    await _powerSync.connect(connector: _connector);
    _connected = true;
  }

  /// Déconnecte sans effacer les données locales.
  Future<void> disconnect() async {
    if (!_connected) {
      return;
    }
    await _powerSync.disconnect();
    _connected = false;
  }

  /// Attend la première synchronisation complète (recovery post-crash).
  Future<bool> waitForInitialSync({
    Duration timeout = const Duration(minutes: 1),
  }) async {
    if (!_connected) {
      return false;
    }

    if (_powerSync.currentStatus.hasSynced == true) {
      return true;
    }

    try {
      await _powerSync.waitForFirstSync().timeout(timeout);
      return true;
    } on TimeoutException {
      return false;
    }
  }

  void updateJwt(String? jwt) => _connector.updateJwt(jwt);

  Future<void> close() async {
    await disconnect();
    await _powerSync.close();
  }
}

/// Ouvre la base Ritagestion (native Drift ou PowerSync+Drift).
Future<RitagestionDatabaseBundle> openRitagestionDatabase({
  required String dbPath,
  CloudSyncConfig config = const CloudSyncConfig.disabled(),
}) async {
  if (!config.enabled) {
    final file = File(dbPath);
    final db = AppDatabase(
      NativeDatabase.createInBackground(file),
      powerSyncManaged: false,
    );
    return RitagestionDatabaseBundle(appDatabase: db);
  }

  ritagestionPowerSyncSchema.validate();

  final powerSync = PowerSyncDatabase(
    schema: ritagestionPowerSyncSchema,
    path: dbPath,
  );
  await powerSync.initialize();

  final connector = RitagestionPowerSyncConnector(config);
  final session = CloudSyncSession(
    powerSync: powerSync,
    config: config,
    connector: connector,
  );

  final driftDb = AppDatabase(
    SqliteAsyncDriftConnection(powerSync),
    powerSyncManaged: true,
  );

  if (config.canConnect) {
    await session.connect();
  }

  return RitagestionDatabaseBundle(
    appDatabase: driftDb,
    cloudSync: session,
  );
}
