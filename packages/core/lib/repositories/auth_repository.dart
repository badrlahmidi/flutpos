import '../database/app_database.dart';

/// Authentification locale par PIN (bcrypt).
abstract class AuthRepository {
  /// Vérifie le [pin] contre tous les utilisateurs actifs ; retourne l'utilisateur correspondant.
  Future<User?> verifyPin(String pin);

  /// Vérifie le PIN d'un administrateur (autorisation manager).
  Future<User?> verifyManagerPin(String pin);
}
