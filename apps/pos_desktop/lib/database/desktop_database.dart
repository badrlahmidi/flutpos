import 'package:core/core.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Bundle BDD desktop (Drift + sync cloud optionnelle).
final class DesktopDatabaseBundle {
  const DesktopDatabaseBundle({
    required this.appDatabase,
    this.cloudSync,
    required this.dbPath,
  });

  final AppDatabase appDatabase;
  final CloudSyncSession? cloudSync;
  final String dbPath;
}

/// Ouvre la base SQLite dans le dossier documents de l'application Windows.
Future<DesktopDatabaseBundle> openDesktopDatabase({
  CloudSyncConfig? cloudConfig,
}) async {
  final directory = await getApplicationDocumentsDirectory();
  final dbPath = p.join(directory.path, 'ritagestion.db');
  final config = cloudConfig ?? CloudSyncConfig.fromEnvironment();

  final bundle = await openRitagestionDatabase(
    dbPath: dbPath,
    config: config,
  );

  return DesktopDatabaseBundle(
    appDatabase: bundle.appDatabase,
    cloudSync: bundle.cloudSync,
    dbPath: dbPath,
  );
}
