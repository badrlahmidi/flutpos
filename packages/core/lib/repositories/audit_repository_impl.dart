import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';
import '../utils/audit_details_codec.dart';
import '../utils/uuid_generator.dart';
import 'audit_repository.dart';

class AuditRepositoryImpl implements AuditRepository {
  AuditRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<AuditTrailData> logAction({
    required String userId,
    required String action,
    required String targetType,
    required String targetId,
    String? details,
    DateTime? createdAt,
  }) async {
    final parsedAction = AuditAction.fromDb(action);
    final parsedTarget = AuditTargetType.fromDb(targetType);

    if (parsedAction == null) {
      throw ArgumentError.value(action, 'action', 'Action d\'audit inconnue');
    }
    if (parsedTarget == null) {
      throw ArgumentError.value(
        targetType,
        'targetType',
        'Type de cible d\'audit inconnu',
      );
    }

    final id = newUuid();
    final now = (createdAt ?? DateTime.now()).toUtc();

    await _db.into(_db.auditTrail).insert(
          AuditTrailCompanion.insert(
            id: Value(id),
            userId: userId,
            action: parsedAction.dbValue,
            targetType: parsedTarget.dbValue,
            targetId: targetId,
            details: Value(details),
            createdAt: now,
          ),
        );

    return (_db.select(_db.auditTrail)..where((a) => a.id.equals(id)))
        .getSingle();
  }

  @override
  Future<AuditTrailData> logActionTyped({
    required String userId,
    required AuditAction action,
    required AuditTargetType targetType,
    required String targetId,
    Map<String, Object?>? details,
    DateTime? createdAt,
  }) async {
    final id = newUuid();
    final now = (createdAt ?? DateTime.now()).toUtc();

    await _db.into(_db.auditTrail).insert(
          AuditTrailCompanion.insert(
            id: Value(id),
            userId: userId,
            action: action.dbValue,
            targetType: targetType.dbValue,
            targetId: targetId,
            details: Value(
              details != null && details.isNotEmpty
                  ? AuditDetailsCodec.encode(details)
                  : null,
            ),
            createdAt: now,
          ),
        );

    return (_db.select(_db.auditTrail)..where((a) => a.id.equals(id)))
        .getSingle();
  }

  @override
  Future<List<AuditTrailData>> getEntriesForTarget({
    required String targetType,
    required String targetId,
    int limit = 50,
  }) {
    if (!AuditTargetType.isValid(targetType)) {
      throw ArgumentError.value(
        targetType,
        'targetType',
        'Type de cible d\'audit inconnu',
      );
    }

    return (_db.select(_db.auditTrail)
          ..where(
            (a) =>
                a.targetType.equals(targetType) &
                a.targetId.equals(targetId),
          )
          ..orderBy([(a) => OrderingTerm.desc(a.createdAt)])
          ..limit(limit))
        .get();
  }
}
