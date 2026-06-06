import 'package:core/core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Ouvre la base locale (Drift + PowerSync) sur mobile.
Future<RitagestionDatabaseBundle> openMobileDatabase() async {
  final docsPath = await getApplicationDocumentsDirectory();
  final dbPath = p.join(docsPath.path, 'ritagestion_waiter.db');

  final config = CloudSyncConfig.fromEnvironment();

  return openRitagestionDatabase(
    dbPath: dbPath,
    config: config,
  );
}
