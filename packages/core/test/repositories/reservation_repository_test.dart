import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late ReservationRepository reservations;
  late String tableId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    reservations = ReservationRepositoryImpl(db, orders);

    await db.into(db.zones).insert(
          ZonesCompanion.insert(id: const Value('z1'), name: 'Salle'),
        );
    tableId = 't1';
    await db.into(db.restaurantTables).insert(
          RestaurantTablesCompanion.insert(
            id: Value(tableId),
            zoneId: 'z1',
            name: 'S3',
            capacity: 4,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('table RESERVED 30 min avant l\'heure prévue', () async {
    final reservedAt = DateTime.now().toUtc().add(const Duration(minutes: 20));

    await reservations.createReservation(
      tableId: tableId,
      customerName: 'Benali',
      guestCount: 2,
      reservedAt: reservedAt,
    );

    final table = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(table.status, 'RESERVED');
  });

  test('table reste FREE si réservation dans plus de 30 min', () async {
    final reservedAt = DateTime.now().toUtc().add(const Duration(hours: 2));

    await reservations.createReservation(
      tableId: tableId,
      customerName: 'Alaoui',
      guestCount: 4,
      reservedAt: reservedAt,
    );

    final table = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(table.status, 'FREE');

    await reservations.syncReservationTableStatuses();
    final afterSync = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(afterSync.status, 'FREE');
  });

  test('sync active une réservation entrée dans la fenêtre 30 min', () async {
    final row = await reservations.createReservation(
      tableId: tableId,
      customerName: 'Client',
      guestCount: 2,
      reservedAt: DateTime.now().toUtc().add(const Duration(hours: 2)),
    );

    await (db.update(db.reservations)..where((r) => r.id.equals(row.id))).write(
      ReservationsCompanion(
        reservedAt: Value(
          DateTime.now().toUtc().add(const Duration(minutes: 20)),
        ),
      ),
    );

    await reservations.syncReservationTableStatuses();
    final table = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(table.status, 'RESERVED');
  });

  test('annulation libère la table', () async {
    final reservedAt = DateTime.now().toUtc().add(const Duration(minutes: 15));
    final row = await reservations.createReservation(
      tableId: tableId,
      customerName: 'Test',
      guestCount: 2,
      reservedAt: reservedAt,
    );

    await reservations.cancelReservation(row.id);
    final table = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(table.status, 'FREE');
  });
}
