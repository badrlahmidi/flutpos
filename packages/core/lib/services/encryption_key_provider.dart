import 'dart:math';
import 'dart:typed_data';

/// Fournisseur abstrait de clé de chiffrement (security fix [MOY-D03]).
///
/// Le package `core` étant pur Dart, il ne peut pas dépendre de
/// `flutter_secure_storage` directement. L'implémentation concrète est fournie
/// par les apps (`pos_desktop`, `waiter_mobile`) via les bridges plateforme
/// (DPAPI sur Windows, AndroidKeystore sur Android, Keychain sur iOS).
abstract class EncryptionKeyProvider {
  /// Retourne la clé de chiffrement SQLCipher (32 bytes hex).
  ///
  /// Si aucune clé n'existe encore (premier lancement), une nouvelle clé
  /// aléatoire de 32 bytes est générée puis stockée de façon sécurisée.
  Future<String> getOrCreateEncryptionKey();
}

/// Générateur de clé aléatoire cryptographiquement sûr.
class EncryptionKeyGenerator {
  EncryptionKeyGenerator._();

  /// Génère 32 bytes aléatoires (256 bits) et retourne en hexadécimal.
  static String generate() {
    final random = Random.secure();
    final bytes = Uint8List(32);
    for (int i =  0; i < 32; i++) {
      bytes[i] = random.nextInt(256);
    }
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }
}