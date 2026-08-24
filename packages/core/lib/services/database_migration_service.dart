import 'dart:io';

/// Service de migration de la base de données clair → chiffrée
/// (security fix [MOY-D03]).
///
/// Processus atomique :
/// 1. Vérifier si la DB actuelle est non chiffrée (legacy).
/// 2. Créer un backup de la DB claire.
/// 3. Ouvrir la DB claire et exporter le contenu SQL.
/// 4. Créer une nouvelle DB chiffrée (SQLCipher) et importer le contenu.
/// 5. Vérifier l'intégrité de la nouvelle DB.
/// 6. En cas de succès : supprimer l'ancienne DB claire.
/// 7. En cas d'échec : restaurer depuis le backup.
class DatabaseMigrationService {
  DatabaseMigrationService._();

  /// Suffixe pour le backup de la DB claire avant migration.
  static const _backupSuffix = '.plain.bak';

  /// Vérifie si une migration clair → chiffré est nécessaire.
  ///
  /// Retourne `true` si un fichier DB non chiffré existe et qu'aucune clé
  /// de chiffrement n'est enregistrée.
  static bool needsMigration({
    required String dbPath,
    required bool hasEncryptionKey,
  }) {
    if (hasEncryptionKey) return false;
    final file = File(dbPath);
    return file.existsSync();
  }

  /// Chemin du fichier backup.
  static String backupPath(String dbPath) => '$_backupSuffix$dbPath';

  /// Crée un backup de la DB claire.
  static Future<void> createBackup(String dbPath) async {
    final source = File(dbPath);
    if (source.existsSync()) {
      await source.copy(backupPath(dbPath));
    }
  }

  /// Supprime le backup après migration réussie.
  static Future<void> cleanupBackup(String dbPath) async {
    final backup = File(backupPath(dbPath));
    if (backup.existsSync()) {
      await backup.delete();
    }
  }

  /// Restaure la DB claire depuis le backup (en cas d'échec de migration).
  static Future<void> restoreFromBackup(String dbPath) async {
    final backup = File(backupPath(dbPath));
    final target = File(dbPath);
    if (backup.existsSync()) {
      if (target.existsSync()) {
        await target.delete();
      }
      await backup.copy(dbPath);
    }
  }

  /// Vérifie l'existence d'un backup (pour diagnostic).
  static bool hasBackup(String dbPath) {
    return File(backupPath(dbPath)).existsSync();
  }
}