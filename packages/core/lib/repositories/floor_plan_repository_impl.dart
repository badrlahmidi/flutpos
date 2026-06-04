import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/floor_plan_table_snapshot.dart';
import '../entities/floor_plan_zone_snapshot.dart';
import '../utils/order_totals.dart';
import 'floor_plan_repository.dart';
import 'order_repository.dart';
import 'reservation_repository.dart';

class FloorPlanRepositoryImpl implements FloorPlanRepository {
  FloorPlanRepositoryImpl(
    this._db,
    this._orders,
    this._reservations,
  );

  final AppDatabase _db;
  final OrderRepository _orders;
  final ReservationRepository _reservations;

  @override
  Future<List<FloorPlanZoneSnapshot>> loadFloorPlan() async {
    await _reservations.syncReservationTableStatuses();
    final zones = await (_db.select(_db.zones)
          ..orderBy([(z) => OrderingTerm.asc(z.sortOrder)]))
        .get();

    final snapshots = <FloorPlanZoneSnapshot>[];
    for (final zone in zones) {
      final tables = await (_db.select(_db.restaurantTables)
            ..where((t) => t.zoneId.equals(zone.id))
            ..orderBy([(t) => OrderingTerm.asc(t.name)]))
          .get();

      final tableSnapshots = <FloorPlanTableSnapshot>[];
      for (final table in tables) {
        final activeOrder = await _orders.getOpenOrderForTable(table.id);
        double? total;
        if (activeOrder != null) {
          final complete = await _orders.getCompleteOrder(activeOrder.id);
          if (complete != null) {
            total = complete.displayGrandTotal;
          }
        }
        final reservation =
            await _reservations.getConfirmedReservationForTable(table.id);

        tableSnapshots.add(
          FloorPlanTableSnapshot(
            table: table,
            activeOrder: activeOrder,
            currentGrandTotal: total,
            upcomingReservation: reservation,
          ),
        );
      }

      snapshots.add(
        FloorPlanZoneSnapshot(zone: zone, tables: tableSnapshots),
      );
    }
    return snapshots;
  }

  @override
  Stream<List<FloorPlanZoneSnapshot>> watchFloorPlan() {
    final tables = _db.select(_db.restaurantTables).watch();
    final reservations = _db.select(_db.reservations).watch();
    return Stream.multi((controller) {
      Future<void> emit() async {
        try {
          controller.add(await loadFloorPlan());
        } catch (e, st) {
          controller.addError(e, st);
        }
      }

      final sub1 = tables.listen((_) => emit());
      final sub2 = reservations.listen((_) => emit());
      emit();
      controller.onCancel = () {
        sub1.cancel();
        sub2.cancel();
      };
    });
  }
}
