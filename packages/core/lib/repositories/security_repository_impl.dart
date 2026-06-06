import 'package:drift/drift.dart';

import '../constants/security_operations.dart';
import '../database/app_database.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';
import '../repositories/audit_repository.dart';
import '../utils/pin_hasher.dart';
import '../utils/uuid_generator.dart';
import 'security_repository.dart';

class SecurityRepositoryImpl implements SecurityRepository {
  SecurityRepositoryImpl(this._db, this._audit);

  final AppDatabase _db;
  final AuditRepository _audit;

  @override
  Future<void> ensureDefaultRules() async {
    final existing = await _db.select(_db.securityRules).get();
    if (existing.isNotEmpty) return;

    await _db.batch((batch) {
      batch.insertAll(
        _db.securityRules,
        [
          for (final def in DefaultSecurityRules.definitions)
            SecurityRulesCompanion.insert(
              operationKey: def.operationKey,
              category: def.category,
              label: def.label,
              requiredLevel: Value(def.defaultLevel),
              description: Value(def.description),
            ),
        ],
      );
    });
  }

  @override
  Future<List<SecurityRule>> listRules() async {
    await ensureDefaultRules();
    return (_db.select(_db.securityRules)
          ..orderBy([
            (r) => OrderingTerm.asc(r.category),
            (r) => OrderingTerm.asc(r.label),
          ]))
        .get();
  }

  @override
  Future<int> getRequiredLevel(String operationKey) async {
    await ensureDefaultRules();
    final row = await (_db.select(_db.securityRules)
          ..where((r) => r.operationKey.equals(operationKey)))
        .getSingleOrNull();
    if (row == null) {
      final fallback = DefaultSecurityRules.definitions
          .where((d) => d.operationKey == operationKey)
          .map((d) => d.defaultLevel)
          .firstOrNull;
      return fallback ?? 9;
    }
    return row.requiredLevel;
  }

  @override
  Future<void> updateRequiredLevel(String operationKey, int level) async {
    final clamped = level.clamp(0, 9);
    await (_db.update(_db.securityRules)
          ..where((r) => r.operationKey.equals(operationKey)))
        .write(SecurityRulesCompanion(requiredLevel: Value(clamped)));
  }

  @override
  Future<void> saveRules(
    Map<String, int> levelsByKey, {
    required String actorUserId,
  }) async {
    await ensureDefaultRules();
    final before = await listRules();
    final beforeByKey = {for (final r in before) r.operationKey: r.requiredLevel};

    final changes = <String, Map<String, int>>{};
    for (final entry in levelsByKey.entries) {
      final newLevel = entry.value.clamp(0, 9);
      final oldLevel = beforeByKey[entry.key];
      if (oldLevel != null && oldLevel != newLevel) {
        changes[entry.key] = {'from': oldLevel, 'to': newLevel};
      }
    }

    if (changes.isEmpty) return;

    await _db.batch((batch) {
      for (final entry in levelsByKey.entries) {
        batch.update(
          _db.securityRules,
          SecurityRulesCompanion(
            requiredLevel: Value(entry.value.clamp(0, 9)),
          ),
          where: (r) => r.operationKey.equals(entry.key),
        );
      }
    });

    await _audit.logActionTyped(
      userId: actorUserId,
      action: AuditAction.securityRuleChange,
      targetType: AuditTargetType.securityRule,
      targetId: 'security_rules',
      details: {'changes': changes},
    );
  }
}

class UserRepositoryImpl implements UserRepository {
  UserRepositoryImpl(this._db, this._audit);

  final AppDatabase _db;
  final AuditRepository _audit;

  @override
  Future<List<User>> listUsers({bool includeInactive = false}) async {
    final query = _db.select(_db.users)
      ..orderBy([(u) => OrderingTerm.asc(u.name)]);
    if (!includeInactive) {
      query.where((u) => u.isActive.equals(true));
    }
    return query.get();
  }

  @override
  Future<User> createUser({
    required String actorUserId,
    required String name,
    required String role,
    required String pin,
    required int accessLevel,
  }) async {
    final now = DateTime.now();
    final userId = newUuid();
    await _db.into(_db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: name.trim(),
            pinHash: PinHasher.hashPin(pin),
            role: role,
            accessLevel: Value(accessLevel.clamp(0, 9)),
            createdAt: Value(now),
            updatedAt: Value(now),
          ),
        );

    await _audit.logActionTyped(
      userId: actorUserId,
      action: AuditAction.userAccessChange,
      targetType: AuditTargetType.user,
      targetId: userId,
      details: {
        'action': 'create',
        'name': name.trim(),
        'role': role,
        'accessLevel': accessLevel.clamp(0, 9),
      },
    );

    return (_db.select(_db.users)..where((u) => u.id.equals(userId)))
        .getSingle();
  }

  @override
  Future<User> updateUser({
    required String actorUserId,
    required String id,
    String? name,
    String? role,
    int? accessLevel,
    bool? isActive,
  }) async {
    final existing = await (_db.select(_db.users)
          ..where((u) => u.id.equals(id)))
        .getSingle();

    await (_db.update(_db.users)..where((u) => u.id.equals(id))).write(
      UsersCompanion(
        name: name != null ? Value(name.trim()) : const Value.absent(),
        role: role != null ? Value(role) : const Value.absent(),
        accessLevel: accessLevel != null
            ? Value(accessLevel.clamp(0, 9))
            : const Value.absent(),
        isActive: isActive != null ? Value(isActive) : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    final updated = await (_db.select(_db.users)
          ..where((u) => u.id.equals(id)))
        .getSingle();

    await _audit.logActionTyped(
      userId: actorUserId,
      action: AuditAction.userAccessChange,
      targetType: AuditTargetType.user,
      targetId: id,
      details: {
        'action': 'update',
        if (name != null && name.trim() != existing.name)
          'name': {'from': existing.name, 'to': name.trim()},
        if (role != null && role != existing.role)
          'role': {'from': existing.role, 'to': role},
        if (accessLevel != null && accessLevel != existing.accessLevel)
          'accessLevel': {'from': existing.accessLevel, 'to': accessLevel},
        if (isActive != null && isActive != existing.isActive)
          'isActive': {'from': existing.isActive, 'to': isActive},
      },
    );

    return updated;
  }

  @override
  Future<void> resetPin({
    required String actorUserId,
    required String userId,
    required String newPin,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        pinHash: Value(PinHasher.hashPin(newPin)),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _audit.logActionTyped(
      userId: actorUserId,
      action: AuditAction.resetPin,
      targetType: AuditTargetType.user,
      targetId: userId,
      details: const {'action': 'reset_pin'},
    );
  }

  @override
  Future<void> deleteUser({
    required String actorUserId,
    required String userId,
  }) async {
    await (_db.update(_db.users)..where((u) => u.id.equals(userId))).write(
      UsersCompanion(
        isActive: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );

    await _audit.logActionTyped(
      userId: actorUserId,
      action: AuditAction.userAccessChange,
      targetType: AuditTargetType.user,
      targetId: userId,
      details: const {'action': 'deactivate'},
    );
  }
}
