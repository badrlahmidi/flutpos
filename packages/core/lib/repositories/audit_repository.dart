import '../database/app_database.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';

/// Journal d'audit immuable — écriture uniquement.
abstract class AuditRepository {
  /// Enregistre une action sensible **avant** l'opération métier associée.
  Future<AuditTrailData> logAction({
    required String userId,
    required String action,
    required String targetType,
    required String targetId,
    String? details,
    DateTime? createdAt,
  });

  Future<AuditTrailData> logActionTyped({
    required String userId,
    required AuditAction action,
    required AuditTargetType targetType,
    required String targetId,
    Map<String, Object?>? details,
    DateTime? createdAt,
  });

  Future<List<AuditTrailData>> getEntriesForTarget({
    required String targetType,
    required String targetId,
    int limit = 50,
  });
}
