import '../database/app_database.dart';

/// Authentification locale par PIN (bcrypt) avec verrouillage persistant.
abstract class AuthRepository {
  /// Vérifie le [pin] contre tous les utilisateurs actifs ; retourne l'utilisateur correspondant.
  Future<User?> verifyPin(String pin);

  /// Vérifie le PIN d'un utilisateur avec niveau d'accès suffisant.
  Future<User?> verifyManagerPin(String pin, {int minLevel = 1});

  /// Enregistre un échec de tentative PIN pour tous les utilisateurs
  /// et retourne le nombre d'échecs global (max parmi tous les users).
  /// Applique le verrouillage temporel si le seuil est atteint.
  Future<int> recordFailedAttempt();

  /// Réinitialise les compteurs d'échec (après une connexion réussie).
  Future<void> resetFailedAttempts();

  /// Vérifie si la caisse est verrouillée (basé sur `lockedUntil` persisté).
  /// Retourne la durée restante si verrouillé, null sinon.
  Future<Duration?> checkLockStatus();
}
