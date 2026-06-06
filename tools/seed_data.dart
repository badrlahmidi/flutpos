import 'dart:io';

import 'package:core/database/database_connection.dart';
import 'package:core/database/seed/database_seeder.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final dbPath = args.isNotEmpty
      ? args.first
      : p.join(Directory.current.path, 'ritagestion_seed.db');
  final file = File(dbPath);
  if (await file.exists()) {
    await file.delete();
  }

  final db = openNativeDatabase(filePath: dbPath);

  try {
    await DatabaseSeeder.seed(db);
    stdout.writeln('Seed terminé : $dbPath');
  } finally {
    await db.close();
  }
}
