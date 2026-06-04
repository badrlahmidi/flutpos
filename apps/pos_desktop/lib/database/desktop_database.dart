import 'dart:io';

import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Ouvre la base SQLite dans le dossier documents de l'application Windows.
Future<AppDatabase> openDesktopDatabase() async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File(p.join(directory.path, 'ritagestion.db'));
  return AppDatabase(NativeDatabase.createInBackground(file));
}
