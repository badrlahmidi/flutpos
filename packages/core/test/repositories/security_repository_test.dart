import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late AuditRepository audit;
  late SecurityRepository security;
  late UserRepository users;
  late String adminId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    audit = AuditRepositoryImpl(db);
    security = SecurityRepositoryImpl(db, audit);
    users = UserRepositoryImpl(db, audit);
    adminId = 'admin-1';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(adminId),
            name: 'Admin',
            pinHash: 'hash',
            role: 'ADMIN',
            accessLevel: const Value(9),
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('SecurityRepository', () {
    test('seed les règles par défaut', () async {
      final rules = await security.listRules();
      expect(rules.length, DefaultSecurityRules.definitions.length);
      expect(
        await security.getRequiredLevel(SecurityOperations.voidItem),
        9,
      );
    });

    test('saveRules met à jour et audite les changements', () async {
      await security.ensureDefaultRules();
      await security.saveRules(
        {SecurityOperations.applyDiscount: 3},
        actorUserId: adminId,
      );

      expect(
        await security.getRequiredLevel(SecurityOperations.applyDiscount),
        3,
      );

      final entries = await audit.getEntriesForTarget(
        targetType: AuditTargetType.securityRule.dbValue,
        targetId: 'security_rules',
      );
      expect(entries, hasLength(1));
      expect(entries.first.action, AuditAction.securityRuleChange.dbValue);
    });

    test('saveRules ignore si aucun changement', () async {
      await security.ensureDefaultRules();
      final level =
          await security.getRequiredLevel(SecurityOperations.voidItem);
      await security.saveRules(
        {SecurityOperations.voidItem: level},
        actorUserId: adminId,
      );

      final entries = await audit.getEntriesForTarget(
        targetType: AuditTargetType.securityRule.dbValue,
        targetId: 'security_rules',
      );
      expect(entries, isEmpty);
    });
  });

  group('UserRepository', () {
    test('createUser enregistre et audite', () async {
      final created = await users.createUser(
        actorUserId: adminId,
        name: 'Nouveau Caissier',
        role: 'CASHIER',
        pin: '4321',
        accessLevel: 3,
      );

      expect(created.name, 'Nouveau Caissier');
      expect(created.accessLevel, 3);

      final entries = await audit.getEntriesForTarget(
        targetType: AuditTargetType.user.dbValue,
        targetId: created.id,
      );
      expect(entries, hasLength(1));
      expect(entries.first.action, AuditAction.userAccessChange.dbValue);
    });

    test('updateUser audite changement de niveau', () async {
      final created = await users.createUser(
        actorUserId: adminId,
        name: 'Serveur',
        role: 'WAITER',
        pin: '1111',
        accessLevel: 0,
      );

      await users.updateUser(
        actorUserId: adminId,
        id: created.id,
        accessLevel: 5,
      );

      final updated = await (db.select(db.users)
            ..where((u) => u.id.equals(created.id)))
          .getSingle();
      expect(updated.accessLevel, 5);

      final entries = await audit.getEntriesForTarget(
        targetType: AuditTargetType.user.dbValue,
        targetId: created.id,
      );
      expect(entries.length, greaterThanOrEqualTo(2));
    });

    test('resetPin audite RESET_PIN', () async {
      final created = await users.createUser(
        actorUserId: adminId,
        name: 'Test',
        role: 'WAITER',
        pin: '1111',
        accessLevel: 0,
      );

      await users.resetPin(
        actorUserId: adminId,
        userId: created.id,
        newPin: '2222',
      );

      final entries = await audit.getEntriesForTarget(
        targetType: AuditTargetType.user.dbValue,
        targetId: created.id,
      );
      expect(
        entries.any((e) => e.action == AuditAction.resetPin.dbValue),
        isTrue,
      );
    });

    test('deleteUser désactive le compte', () async {
      final created = await users.createUser(
        actorUserId: adminId,
        name: 'Temp',
        role: 'WAITER',
        pin: '1111',
        accessLevel: 0,
      );

      await users.deleteUser(
        actorUserId: adminId,
        userId: created.id,
      );

      final row = await (db.select(db.users)
            ..where((u) => u.id.equals(created.id)))
          .getSingle();
      expect(row.isActive, isFalse);
    });
  });
}
