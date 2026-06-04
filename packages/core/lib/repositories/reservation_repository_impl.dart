import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../enums/reservation_status.dart';
import '../utils/uuid_generator.dart';
import 'order_repository.dart';
import 'reservation_repository.dart';

class ReservationRepositoryImpl implements ReservationRepository {
  ReservationRepositoryImpl(this._db, this._orders);

  final AppDatabase _db;
  final OrderRepository _orders;

  static const _noShowGrace = Duration(hours: 2);

  @override
  Future<Reservation> createReservation({
    required String tableId,
    required String customerName,
    String? customerPhone,
    required int guestCount,
    required DateTime reservedAt,
    String? notes,
  }) async {
    final name = customerName.trim();
    if (name.length < 2) {
      throw ArgumentError('Nom client invalide');
    }
    if (guestCount < 1) {
      throw ArgumentError('Nombre de couverts invalide');
    }

    final table = await (_db.select(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingleOrNull();
    if (table == null) {
      throw StateError('Table introuvable');
    }

    final openOrder = await _orders.getOpenOrderForTable(tableId);
    if (openOrder != null) {
      throw StateError('Table occupée — réservation impossible');
    }

    final conflicting = await _findConflictingReservation(tableId, reservedAt);
    if (conflicting != null) {
      throw StateError(
        'Créneau déjà réservé (${conflicting.customerName})',
      );
    }

    final id = newUuid();
    final utcReserved = reservedAt.toUtc();
    await _db.into(_db.reservations).insert(
          ReservationsCompanion.insert(
            id: Value(id),
            tableId: tableId,
            customerName: name,
            customerPhone: Value(customerPhone?.trim()),
            guestCount: guestCount,
            reservedAt: utcReserved,
            notes: Value(notes?.trim()),
            createdAt: DateTime.now().toUtc(),
          ),
        );

    if (_shouldBlockTableNow(utcReserved)) {
      await _setTableStatus(tableId, 'RESERVED');
    }

    return (_db.select(_db.reservations)..where((r) => r.id.equals(id)))
        .getSingle();
  }

  @override
  Future<Reservation> cancelReservation(String reservationId) async {
    final row = await (_db.select(_db.reservations)
          ..where((r) => r.id.equals(reservationId)))
        .getSingleOrNull();
    if (row == null) {
      throw StateError('Réservation introuvable');
    }

    await (_db.update(_db.reservations)
          ..where((r) => r.id.equals(reservationId)))
        .write(
      ReservationsCompanion(
        status: Value(ReservationStatus.cancelled.dbValue),
      ),
    );

    await _releaseTableIfNoActiveReservation(row.tableId);
    return (_db.select(_db.reservations)
          ..where((r) => r.id.equals(reservationId)))
        .getSingle();
  }

  @override
  Future<List<Reservation>> listUpcomingReservations({
    DateTime? from,
    DateTime? to,
  }) async {
    final now = DateTime.now().toUtc();
    final fromUtc = (from ?? now).toUtc();
    final toUtc = (to ?? now.add(const Duration(days: 7))).toUtc();

    return (_db.select(_db.reservations)
          ..where(
            (r) =>
                r.status.equals(ReservationStatus.confirmed.dbValue) &
                r.reservedAt.isBiggerOrEqualValue(fromUtc) &
                r.reservedAt.isSmallerOrEqualValue(toUtc),
          )
          ..orderBy([(r) => OrderingTerm.asc(r.reservedAt)]))
        .get();
  }

  @override
  Future<Reservation?> getConfirmedReservationForTable(String tableId) async {
    final now = DateTime.now().toUtc();
    final rows = await (_db.select(_db.reservations)
          ..where(
            (r) =>
                r.tableId.equals(tableId) &
                r.status.equals(ReservationStatus.confirmed.dbValue),
          )
          ..orderBy([(r) => OrderingTerm.asc(r.reservedAt)]))
        .get();

    for (final row in rows) {
      if (_isInActivationWindow(row.reservedAt, now)) {
        return row;
      }
    }
    return null;
  }

  @override
  Future<int> syncReservationTableStatuses() async {
    final now = DateTime.now().toUtc();
    var updated = 0;

    final confirmed = await (_db.select(_db.reservations)
          ..where(
            (r) => r.status.equals(ReservationStatus.confirmed.dbValue),
          ))
        .get();

    for (final reservation in confirmed) {
      if (reservation.reservedAt.add(_noShowGrace).isBefore(now)) {
        await (_db.update(_db.reservations)
              ..where((r) => r.id.equals(reservation.id)))
            .write(
          ReservationsCompanion(
            status: Value(ReservationStatus.noShow.dbValue),
          ),
        );
        await _releaseTableIfNoActiveReservation(reservation.tableId);
        updated++;
        continue;
      }

      if (!_shouldBlockTableNow(reservation.reservedAt)) {
        continue;
      }

      final table = await (_db.select(_db.restaurantTables)
            ..where((t) => t.id.equals(reservation.tableId)))
          .getSingleOrNull();
      if (table == null) {
        continue;
      }

      final openOrder = await _orders.getOpenOrderForTable(reservation.tableId);
      if (openOrder != null) {
        continue;
      }

      if (table.status != 'RESERVED') {
        await _setTableStatus(reservation.tableId, 'RESERVED');
        updated++;
      }
    }

    final reservedTables = await (_db.select(_db.restaurantTables)
          ..where((t) => t.status.equals('RESERVED')))
        .get();

    for (final table in reservedTables) {
      final openOrder = await _orders.getOpenOrderForTable(table.id);
      if (openOrder != null) {
        continue;
      }

      final active = await getConfirmedReservationForTable(table.id);
      if (active == null) {
        await _setTableStatus(table.id, 'FREE');
        updated++;
      }
    }

    return updated;
  }

  @override
  Future<void> markSeatedForTable(String tableId) async {
    final now = DateTime.now().toUtc();
    final rows = await (_db.select(_db.reservations)
          ..where(
            (r) =>
                r.tableId.equals(tableId) &
                r.status.equals(ReservationStatus.confirmed.dbValue),
          )
          ..orderBy([(r) => OrderingTerm.asc(r.reservedAt)]))
        .get();

    Reservation? target;
    for (final row in rows) {
      if (_isInActivationWindow(row.reservedAt, now) ||
          row.reservedAt.isAfter(now)) {
        target = row;
        break;
      }
    }
    target ??= rows.isNotEmpty ? rows.first : null;

    if (target == null) {
      return;
    }

    await (_db.update(_db.reservations)..where((r) => r.id.equals(target!.id)))
        .write(
      ReservationsCompanion(
        status: Value(ReservationStatus.seated.dbValue),
      ),
    );
  }

  @override
  Future<List<RestaurantTable>> listAllTables() {
    return (_db.select(_db.restaurantTables)
          ..orderBy([(t) => OrderingTerm.asc(t.name)]))
        .get();
  }

  @override
  Future<List<Zone>> listAllZones() {
    return (_db.select(_db.zones)
          ..orderBy([(z) => OrderingTerm.asc(z.sortOrder)]))
        .get();
  }

  bool _shouldBlockTableNow(DateTime reservedAtUtc) {
    final now = DateTime.now().toUtc();
    return !reservedAtUtc.subtract(ReservationRepository.reserveLeadTime).isAfter(now);
  }

  bool _isInActivationWindow(DateTime reservedAtUtc, DateTime nowUtc) {
    final blockFrom = reservedAtUtc.subtract(ReservationRepository.reserveLeadTime);
    final blockUntil = reservedAtUtc.add(_noShowGrace);
    return !nowUtc.isBefore(blockFrom) && nowUtc.isBefore(blockUntil);
  }

  Future<Reservation?> _findConflictingReservation(
    String tableId,
    DateTime reservedAt,
  ) async {
    final utc = reservedAt.toUtc();
    final rows = await (_db.select(_db.reservations)
          ..where(
            (r) =>
                r.tableId.equals(tableId) &
                r.status.equals(ReservationStatus.confirmed.dbValue),
          ))
        .get();

    for (final row in rows) {
      final diff = row.reservedAt.difference(utc).inMinutes.abs();
      if (diff < 90) {
        return row;
      }
    }
    return null;
  }

  Future<void> _releaseTableIfNoActiveReservation(String tableId) async {
    final openOrder = await _orders.getOpenOrderForTable(tableId);
    if (openOrder != null) {
      return;
    }

    final active = await getConfirmedReservationForTable(tableId);
    if (active == null) {
      final table = await (_db.select(_db.restaurantTables)
            ..where((t) => t.id.equals(tableId)))
          .getSingleOrNull();
      if (table != null && table.status == 'RESERVED') {
        await _setTableStatus(tableId, 'FREE');
      }
    }
  }

  Future<void> _setTableStatus(String tableId, String status) async {
    await (_db.update(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .write(RestaurantTablesCompanion(status: Value(status)));
  }
}
