import '../database/app_database.dart';
import '../entities/clock_operation_result.dart';

/// Pointage RH (clock-in / clock-out) sur le terminal.
abstract class TimeAttendanceRepository {
  /// Entrée ouverte (clock_out null) pour [userId], le cas échéant.
  Future<TimeAttendanceData?> findOpenEntry(String userId);

  /// Enregistre une entrée. Échoue si une entrée est déjà ouverte.
  Future<TimeAttendanceData> clockIn({
    required String userId,
    String? notes,
  });

  /// Enregistre une sortie. Échoue sans entrée ouverte.
  Future<TimeAttendanceData> clockOut({
    required String userId,
    String? notes,
  });

  /// Vérifie le PIN puis pointe entrée ou sortie.
  Future<ClockOperationResult> clockWithPin({
    required String pin,
    required bool clockIn,
    String? notes,
  });
}
