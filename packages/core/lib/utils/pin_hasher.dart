import 'package:bcrypt/bcrypt.dart';

/// Hachage et vérification des PIN utilisateurs (bcrypt).
abstract final class PinHasher {
  PinHasher._();

  static String hashPin(String pin) => BCrypt.hashpw(pin, BCrypt.gensalt());

  static bool verifyPin(String pin, String pinHash) =>
      BCrypt.checkpw(pin, pinHash);
}
