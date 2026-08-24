import 'package:core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Implémentation Flutter de [EncryptionKeyProvider] utilisant
/// `flutter_secure_storage` (AndroidKeystore, Keychain iOS).
///
/// Security fix [MOY-D03] — SQLCipher encryption key storage.
class FlutterEncryptionKeyProvider implements EncryptionKeyProvider {
  FlutterEncryptionKeyProvider({FlutterSecureStorage? storage})
      : _storage =
            storage ?? const FlutterSecureStorage(aOptions: AndroidOptions());

  final FlutterSecureStorage _storage;

  static const _keyStorageKey = 'ritagestion_db_encryption_key';

  @override
  Future<String> getOrCreateEncryptionKey() async {
    final existing = await _storage.read(key: _keyStorageKey);
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }

    // Générer une nouvelle clé de 32 bytes (256 bits).
    final newKey = EncryptionKeyGenerator.generate();
    await _storage.write(key: _keyStorageKey, value: newKey);
    return newKey;
  }

  /// Vérifie si une clé existe déjà (pour décider de la migration).
  Future<bool> hasKey() async {
    final existing = await _storage.read(key: _keyStorageKey);
    return existing != null && existing.isNotEmpty;
  }
}