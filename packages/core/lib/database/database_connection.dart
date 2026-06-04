import 'dart:io';

import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

import 'app_database.dart';

/// Ouvre la base SQLite native (VM / Desktop / outils CLI).
AppDatabase openNativeDatabase({String? filePath}) {
  final path = filePath ?? p.join(Directory.current.path, 'ritagestion.db');
  return AppDatabase(NativeDatabase(File(path)));
}
