import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/clock_operation_result.dart';
import '../utils/uuid_generator.dart';
import 'auth_repository.dart';
import 'time_attendance_repository.dart';

class TimeAttendanceRepositoryImpl implements TimeAttendanceRepository {
  TimeAttendanceRepositoryImpl(this._db, this._auth);

  final AppDatabase _db;
  final AuthRepository _auth;

  @override
  Future<TimeAttendanceData?> findOpenEntry(String userId) {
    return (_db.select(_db.timeAttendance)
          ..where(
            (t) => t.userId.equals(userId) & t.clockOut.isNull(),
          )
          ..orderBy([(t) => OrderingTerm.desc(t.clockIn)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<TimeAttendanceData> clockIn({
    required String userId,
    String? notes,
  }) async {
    final open = await findOpenEntry(userId);
    if (open != null) {
      throw StateError('Entrée déjà pointée — pointez la sortie d\'abord.');
    }

    final now = DateTime.now().toUtc();
    final id = newUuid();

    await _db.into(_db.timeAttendance).insert(
          TimeAttendanceCompanion.insert(
            id: Value(id),
            userId: userId,
            clockIn: now,
            notes: Value(notes),
            createdAt: now,
          ),
        );

    return (_db.select(_db.timeAttendance)..where((t) => t.id.equals(id)))
        .getSingle();
  }

  @override
  Future<TimeAttendanceData> clockOut({
    required String userId,
    String? notes,
  }) async {
    final open = await findOpenEntry(userId);
    if (open == null) {
      throw StateError('Aucune entrée ouverte — pointez l\'entrée d\'abord.');
    }

    final now = DateTime.now().toUtc();
    await (_db.update(_db.timeAttendance)..where((t) => t.id.equals(open.id)))
        .write(
      TimeAttendanceCompanion(
        clockOut: Value(now),
        notes: notes != null ? Value(notes) : const Value.absent(),
      ),
    );

    return (_db.select(_db.timeAttendance)..where((t) => t.id.equals(open.id)))
        .getSingle();
  }

  @override
  Future<ClockOperationResult> clockWithPin({
    required String pin,
    required bool clockIn,
    String? notes,
  }) async {
    final user = await _auth.verifyPin(pin);
    if (user == null) {
      throw StateError('PIN incorrect');
    }

    if (clockIn) {
      final entry = await this.clockIn(userId: user.id, notes: notes);
      return ClockOperationResult(
        userName: user.name,
        isClockIn: true,
        recordedAt: entry.clockIn,
      );
    }

    final open = await findOpenEntry(user.id);
    final entry = await clockOut(userId: user.id, notes: notes);
    return ClockOperationResult(
      userName: user.name,
      isClockIn: false,
      recordedAt: entry.clockOut!,
      openSince: open?.clockIn,
    );
  }
}
