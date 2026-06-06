// Test de recovery PowerSync — vérifie la configuration et la logique
// de reconnexion sans nécessiter un vrai backend Supabase.
//
// Pour un test bout-en-bout réel, définir les variables d'environnement :
//   RITAGESTION_CLOUD_SYNC=true
//   RITAGESTION_POWERSYNC_URL=https://xxx.powersync.journeyapps.com
//   RITAGESTION_SUPABASE_URL=https://xxx.supabase.co
//   RITAGESTION_SUPABASE_ANON_KEY=eyJ...
//   RITAGESTION_CLOUD_JWT=eyJ...
//   RITAGESTION_CLOUD_USER_ID=test-user
//   RITAGESTION_RESTAURANT_ID=test-restaurant
//
// Puis exécuter : dart test test/database/cloud_recovery_test.dart

import 'package:test/test.dart';

import 'package:core/core.dart';

void main() {
  group('CloudSyncConfig', () {
    test('disabled par défaut → canConnect = false', () {
      const config = CloudSyncConfig.disabled();
      expect(config.enabled, isFalse);
      expect(config.canConnect, isFalse);
      expect(config.canUploadToSupabase, isFalse);
    });

    test('enabled sans JWT → canConnect = false', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: 'https://example.powersync.journeyapps.com',
        supabaseUrl: 'https://example.supabase.co',
        supabaseAnonKey: 'anon-key',
        jwtToken: null,
      );
      expect(config.enabled, isTrue);
      expect(config.canConnect, isFalse,
          reason: 'JWT manquant → pas de connexion cloud');
    });

    test('enabled avec JWT → canConnect = true', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: 'https://example.powersync.journeyapps.com',
        supabaseUrl: 'https://example.supabase.co',
        supabaseAnonKey: 'anon-key',
        jwtToken: 'eyJhbGciOiJIUzI1NiJ9.test.sig',
      );
      expect(config.canConnect, isTrue);
      expect(config.canUploadToSupabase, isTrue);
    });

    test('enabled avec powerSyncUrl vide → canConnect = false', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: '',
        jwtToken: 'eyJhbGciOiJIUzI1NiJ9.test.sig',
      );
      expect(config.canConnect, isFalse,
          reason: 'URL vide ne doit pas permettre la connexion');
    });

    test('canUploadToSupabase = false si supabaseUrl manquant', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: 'https://example.powersync.journeyapps.com',
        supabaseUrl: null,
        supabaseAnonKey: 'anon-key',
        jwtToken: 'jwt',
      );
      expect(config.canConnect, isTrue);
      expect(config.canUploadToSupabase, isFalse);
    });

    test('canUploadToSupabase = false si anonKey manquant', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: 'https://example.powersync.journeyapps.com',
        supabaseUrl: 'https://example.supabase.co',
        supabaseAnonKey: null,
        jwtToken: 'jwt',
      );
      expect(config.canConnect, isTrue);
      expect(config.canUploadToSupabase, isFalse);
    });
  });

  group('PowerSync Schema', () {
    test('ritagestionPowerSyncSchema contient les tables critiques', () {
      final tableNames = ritagestionPowerSyncSchema.tables
          .map((t) => t.name)
          .toSet();

      // Tables transactionnelles critiques pour le recovery
      expect(tableNames, contains('orders'));
      expect(tableNames, contains('order_items'));
      expect(tableNames, contains('order_item_modifiers'));
      expect(tableNames, contains('payments'));
      expect(tableNames, contains('cash_sessions'));
      expect(tableNames, contains('cash_movements'));
      expect(tableNames, contains('audit_trail'));

      // Tables catalogue
      expect(tableNames, contains('products'));
      expect(tableNames, contains('categories'));
      expect(tableNames, contains('modifier_groups'));
      expect(tableNames, contains('modifier_options'));

      // Tables restaurant
      expect(tableNames, contains('restaurant_config'));
      expect(tableNames, contains('zones'));
      expect(tableNames, contains('restaurant_tables'));
      expect(tableNames, contains('users'));
    });

    test('sync_queue est localOnly (pas répliquée cloud)', () {
      final syncQueue = ritagestionPowerSyncSchema.tables
          .where((t) => t.name == 'sync_queue')
          .first;
      expect(syncQueue.localOnly, isTrue,
          reason: 'sync_queue contient les events LAN non cloud');
    });

    test('product_modifiers n\'est PAS dans le schema PowerSync', () {
      // product_modifiers a une PK composite gérée par Drift uniquement
      final tableNames = ritagestionPowerSyncSchema.tables
          .map((t) => t.name)
          .toSet();
      expect(tableNames, isNot(contains('product_modifiers')),
          reason: 'PK composite → créée localement par Drift, pas par PowerSync');
    });

    test('tables transactionnelles ont les colonnes temporelles', () {
      final orders = ritagestionPowerSyncSchema.tables
          .firstWhere((t) => t.name == 'orders');
      final orderColNames = orders.columns.map((c) => c.name).toSet();
      expect(orderColNames, contains('created_at'));
      expect(orderColNames, contains('updated_at'));
      expect(orderColNames, contains('status'));
    });
  });
}
