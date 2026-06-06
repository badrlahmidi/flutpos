import '../database/app_database.dart';

/// Gestion des règles RBAC (niveaux requis par opération).
abstract class SecurityRepository {
  Future<List<SecurityRule>> listRules();

  Future<int> getRequiredLevel(String operationKey);

  Future<void> ensureDefaultRules();

  Future<void> updateRequiredLevel(String operationKey, int level);

  Future<void> saveRules(
    Map<String, int> levelsByKey, {
    required String actorUserId,
  });
}

/// CRUD utilisateurs POS (PIN bcrypt, niveau d'accès).
abstract class UserRepository {
  Future<List<User>> listUsers({bool includeInactive = false});

  Future<User> createUser({
    required String actorUserId,
    required String name,
    required String role,
    required String pin,
    required int accessLevel,
  });

  Future<User> updateUser({
    required String actorUserId,
    required String id,
    String? name,
    String? role,
    int? accessLevel,
    bool? isActive,
  });

  Future<void> resetPin({
    required String actorUserId,
    required String userId,
    required String newPin,
  });

  Future<void> deleteUser({
    required String actorUserId,
    required String userId,
  });
}
