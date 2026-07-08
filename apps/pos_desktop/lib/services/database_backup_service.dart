import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Service de sauvegarde locale de la base de données.
class DatabaseBackupService {
  DatabaseBackupService._();

  static final DatabaseBackupService instance = DatabaseBackupService._();

  /// Exécute une sauvegarde de la base de données `ritagestion.db` dans
  /// le répertoire `Documents/Ritagestion/Backups/`.
  Future<String?> performBackup() async {
    try {
      final docDir = await getApplicationDocumentsDirectory();
      final srcPath = p.join(docDir.path, 'ritagestion.db');
      
      final srcFile = File(srcPath);
      if (!await srcFile.exists()) {
        // ignore: avoid_print
        print('[DatabaseBackupService] Base de données source introuvable à : $srcPath');
        return null;
      }

      // Création du dossier Backups
      final backupDir = Directory(p.join(docDir.path, 'Ritagestion', 'Backups'));
      if (!await backupDir.exists()) {
        await backupDir.create(recursive: true);
      }

      // Formatage du nom de fichier : backup_yyyy_MM_dd_HHmmss.db
      final dateStr = DateFormat('yyyy_MM_dd_HHmmss').format(DateTime.now());
      final destFilename = 'backup_$dateStr.db';
      final destPath = p.join(backupDir.path, destFilename);

      // Copie physique du fichier
      await srcFile.copy(destPath);
      
      // ignore: avoid_print
      print('[DatabaseBackupService] Sauvegarde réussie : $destPath');
      return destPath;
    } catch (e) {
      // ignore: avoid_print
      print('[DatabaseBackupService] Erreur lors de la sauvegarde : $e');
      return null;
    }
  }
}
