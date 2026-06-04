import 'package:core/core.dart';
import 'package:network/network.dart';

import '../database/desktop_database.dart';
import '../services/pos_service_mode.dart';
import 'service_locator.dart';

/// Point d'entrée des dépendances et du cycle de vie serveur (Sprint 2).
class AppBootstrap {
  AppBootstrap._();

  static final AppBootstrap instance = AppBootstrap._();

  AppDatabase? _database;
  CloudSyncSession? _cloudSync;
  PosNetworkServer? _networkServer;

  /// Base Drift locale — disponible après [initialize].
  AppDatabase get database {
    final db = _database;
    if (db == null) {
      throw StateError('AppBootstrap non initialisé — appelez initialize() d\'abord.');
    }
    return db;
  }

  /// Session PowerSync (null si cloud désactivé).
  CloudSyncSession? get cloudSync => _cloudSync;

  /// Serveur LAN Shelf + WebSocket + mDNS.
  PosNetworkServer get networkServer {
    final server = _networkServer;
    if (server == null) {
      throw StateError('AppBootstrap non initialisé — appelez initialize() d\'abord.');
    }
    return server;
  }

  /// Indique si le bootstrap a réussi.
  bool get isInitialized => _database != null && _networkServer != null;

  /// Ouvre la BDD et démarre [PosNetworkServer] (port 8080 + mDNS).
  Future<void> initialize() async {
    if (isInitialized) {
      return;
    }

    final bundle = await openDesktopDatabase();
    _database = bundle.appDatabase;
    _cloudSync = bundle.cloudSync;

    configureDependencies(_database!);
    await DatabaseSeeder.seedIfEmpty(_database!);
    await PosServiceMode.instance.loadFromDatabase();

    if (_cloudSync != null && _cloudSync!.isConnected) {
      final synced = await _cloudSync!.waitForInitialSync();
      // ignore: avoid_print
      print(
        '[AppBootstrap] PowerSync initial sync: '
        '${synced ? "OK" : "timeout (mode offline)"}',
      );
    }

    _networkServer = PosNetworkServer(database: _database!);
    await _networkServer!.start();

    // ignore: avoid_print
    print(
      '[AppBootstrap] Serveur LAN actif — '
      'ws://0.0.0.0:${_networkServer!.port}/ws '
      '(mDNS ${NsDsNetworkConstants.serviceType})'
      '${_cloudSync != null ? " | Cloud sync activé" : ""}',
    );
  }

  /// Arrête le serveur réseau et ferme la BDD.
  Future<void> dispose() async {
    await resetDependencies();

    final server = _networkServer;
    _networkServer = null;
    if (server != null && server.isRunning) {
      await server.stop();
    }

    final cloud = _cloudSync;
    _cloudSync = null;
    if (cloud != null) {
      await cloud.close();
    }

    final db = _database;
    _database = null;
    if (db != null) {
      await db.close();
    }

    // ignore: avoid_print
    print('[AppBootstrap] Arrêt propre terminé.');
  }
}
