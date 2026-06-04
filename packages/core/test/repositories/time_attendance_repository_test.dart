import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late TimeAttendanceRepository attendance;
  late String userId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    attendance = TimeAttendanceRepositoryImpl(
      db,
      AuthRepositoryImpl(db),
    );
    userId = 'user-waiter';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Serveur Test',
            pinHash: PinHasher.hashPin('9012'),
            role: 'WAITER',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('clockIn crée une entrée ouverte', () async {
    final entry = await attendance.clockIn(userId: userId);
    expect(entry.clockOut, null);
    expect(entry.userId, userId);

    final open = await attendance.findOpenEntry(userId);
    expect(open?.id, entry.id);
  });

  test('double clockIn est refusé', () async {
    await attendance.clockIn(userId: userId);
    expect(
      () => attendance.clockIn(userId: userId),
      throwsA(isA<StateError>()),
    );
  });

  test('clockOut ferme l\'entrée ouverte', () async {
    await attendance.clockIn(userId: userId);
    final closed = await attendance.clockOut(userId: userId);
    expect(closed.clockOut, isNot(null));

    final open = await attendance.findOpenEntry(userId);
    expect(open, null);
  });

  test('clockWithPin pointe entrée avec PIN valide', () async {
    final result = await attendance.clockWithPin(
      pin: '9012',
      clockIn: true,
    );

    expect(result.isClockIn, isTrue);
    expect(result.userName, 'Serveur Test');
  });

  test('clockWithPin refuse PIN invalide', () async {
    expect(
      () => attendance.clockWithPin(pin: '0000', clockIn: true),
      throwsA(isA<StateError>()),
    );
  });
}
