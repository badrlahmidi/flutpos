import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('CloudSyncConfig', () {
    test('disabled par défaut', () {
      const config = CloudSyncConfig.disabled();
      expect(config.enabled, isFalse);
      expect(config.canConnect, isFalse);
      expect(config.canUploadToSupabase, isFalse);
    });

    test('canConnect exige URL + JWT', () {
      const config = CloudSyncConfig(
        enabled: true,
        powerSyncUrl: 'https://ps.example.com',
        jwtToken: 'eyJ.test',
      );
      expect(config.canConnect, isTrue);
    });

    test('canUploadToSupabase exige Supabase + JWT', () {
      const config = CloudSyncConfig(
        enabled: true,
        supabaseUrl: 'https://abc.supabase.co',
        supabaseAnonKey: 'anon-key',
        jwtToken: 'eyJ.test',
      );
      expect(config.canUploadToSupabase, isTrue);
    });
  });

  group('ritagestionPowerSyncSchema', () {
    test('valide sans erreur', () {
      expect(() => ritagestionPowerSyncSchema.validate(), returnsNormally);
    });

    test('contient les tables métier critiques', () {
      final names = ritagestionPowerSyncSchema.tables.map((t) => t.name).toSet();
      expect(names, containsAll(['products', 'orders', 'users', 'restaurant_config']));
      expect(names, isNot(contains('product_modifiers')));
    });

    test('sync_queue est local-only', () {
      final syncQueue = ritagestionPowerSyncSchema.tables
          .singleWhere((t) => t.name == 'sync_queue');
      expect(syncQueue.localOnly, isTrue);
    });
  });
}
