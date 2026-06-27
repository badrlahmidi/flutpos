import 'dart:io';
import 'package:core/core.dart';
import 'package:network/network.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../database/mobile_database.dart';
import 'service_locator.dart';

class AppBootstrap {
  AppBootstrap._();

  static final AppBootstrap instance = AppBootstrap._();

  AppDatabase? _database;
  CloudSyncSession? _cloudSync;
  WaiterNetworkClient? _networkClient;

  AppDatabase get database {
    final db = _database;
    if (db == null) throw StateError('AppBootstrap non initialisé');
    return db;
  }

  WaiterNetworkClient get networkClient {
    final client = _networkClient;
    if (client == null) throw StateError('AppBootstrap non initialisé');
    return client;
  }

  bool get isInitialized => _database != null && _networkClient != null;

  Future<String> _getOrCreateDeviceId() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/device_id.txt');
      if (await file.exists()) {
        final id = await file.readAsString();
        if (id.trim().isNotEmpty) return id.trim();
      }
      final newId = 'waiter-mobile-${const Uuid().v4()}';
      await file.writeAsString(newId);
      return newId;
    } catch (_) {
      return 'waiter-mobile-${DateTime.now().millisecondsSinceEpoch}';
    }
  }

  Future<void> initialize() async {
    if (isInitialized) return;

    final bundle = await openMobileDatabase();
    _database = bundle.appDatabase;
    _cloudSync = bundle.cloudSync;

    final deviceId = await _getOrCreateDeviceId();
    
    _networkClient = WaiterNetworkClient(
      database: _database!,
      deviceId: deviceId,
    );

    configureDependencies(_database!, _networkClient!);

    // On peuple la BDD en local pour le MVP si CloudSync est désactivé
    await DatabaseSeeder.seedIfEmpty(_database!);
  }

  Future<void> dispose() async {
    await resetDependencies();

    final client = _networkClient;
    _networkClient = null;
    if (client != null) {
      await client.dispose();
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
  }
}
