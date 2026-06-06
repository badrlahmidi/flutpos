import '../database/app_database.dart';
import '../utils/pin_hasher.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);

  final AppDatabase _db;

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
}
