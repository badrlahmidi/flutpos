import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../utils/pin_hasher.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);

  final AppDatabase _db;

  /// Seuil de tentatives avant verrouillage temporel.
  static const int maxFailedAttempts = 3;

  /// Délais de verrouillage progressifs (exponentiel).
  static const _lockoutDurations = [
    Duration(seconds: 30),  // après 3 échecs
    Duration(minutes: 2),   // après 6 échecs
    Duration(minutes: 15),  // après 9 échecs
    Duration(minutes: 60),  // après 12+ échecs
  ];

  @override
  Future<User?> verifyPin(String pin) async {
    if (pin.isEmpty) {
      return null;
    }

    final users = await (_db.select(_db.users)
          ..where((u) => u.isActive.equals(true)))
        .get();

    for (final user in users) {
      if (PinHasher.verifyPin(pin, user.pinHash)) {
        return user;
      }
    }
    return null;
  }

  @override
  Future<User?> verifyManagerPin(String pin, {int minLevel = 1}) async {
    final user = await verifyPin(pin);
    if (user != null && user.accessLevel >= minLevel) {
      return user;
    }
    return null;
  }

  @override
  Future<int> recordFailedAttempt() async {
    // Incrémente les tentatives échouées sur TOUS les utilisateurs actifs
    // (on ne sait pas quel user est visé par le PIN erroné).
    // On utilise le premier user comme référence pour le compteur global.
    final activeUsers = await (_db.select(_db.users)
          ..where((u) => u.isActive.equals(true)))
        .get();

    if (activeUsers.isEmpty) return 0;

    // On utilise le max des compteurs comme valeur de référence.
    int maxFailed = 0;
    for (final user in activeUsers) {
      final newCount = user.failedAttempts + 1;
      if (newCount > maxFailed) maxFailed = newCount;

      DateTime? lockUntil;
      // Verrouiller si seuil atteint (multiple de maxFailedAttempts)
      if (newCount >= maxFailedAttempts && newCount % maxFailedAttempts == 0) {
        final tier = (newCount ~/ maxFailedAttempts) - 1;
        final idx = tier.clamp(0, _lockoutDurations.length - 1);
        lockUntil = DateTime.now().add(_lockoutDurations[idx]);
      }

      await (_db.update(_db.users)..where((u) => u.id.equals(user.id))).write(
        UsersCompanion(
          failedAttempts: Value(newCount),
          lockedUntil: Value(lockUntil ?? user.lockedUntil),
        ),
      );
    }

    return maxFailed;
  }

  @override
  Future<void> resetFailedAttempts() async {
    await (_db.update(_db.users)
          ..where((u) => u.isActive.equals(true)))
        .write(
      const UsersCompanion(
        failedAttempts: Value(0),
        lockedUntil: Value(null),
      ),
    );
  }

  @override
  Future<Duration?> checkLockStatus() async {
    final activeUsers = await (_db.select(_db.users)
          ..where((u) => u.isActive.equals(true)))
        .get();

    DateTime? latestLock;
    for (final user in activeUsers) {
      if (user.lockedUntil != null) {
        if (latestLock == null || user.lockedUntil!.isAfter(latestLock)) {
          latestLock = user.lockedUntil;
        }
      }
    }

    if (latestLock == null) return null;

    final remaining = latestLock.difference(DateTime.now());
    if (remaining.isNegative) {
      // Le verrouillage a expiré → réinitialiser
      await resetFailedAttempts();
      return null;
    }

    return remaining;
  }
}
