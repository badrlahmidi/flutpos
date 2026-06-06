import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../repositories/order_repository.dart';

class TransferTableUseCase {
  const TransferTableUseCase(this._db, this._orders);

  final AppDatabase _db;
  final OrderRepository _orders;

  Future<Order> execute({
    required String orderId,
    required String targetTableId,
  }) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) {
      throw StateError('Commande introuvable');
    }
    
    final openStatuses = ['OPEN', 'SENT', 'PROFORMA'];
    if (!openStatuses.contains(order.status)) {
      throw StateError('Seuls les tickets ouverts peuvent être transférés');
    }

    final fromTableId = order.tableId;
    if (fromTableId == null) {
      throw StateError('Commande sans table');
    }
    if (fromTableId == targetTableId) {
      return order;
    }

    final targetOpen = await _orders.getOpenOrderForTable(targetTableId);
    if (targetOpen != null) {
      throw StateError('La table cible est déjà occupée');
    }

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            tableId: Value(targetTableId),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

    await _releaseTableIfNoOpenOrders(fromTableId);
    await _setTableStatus(targetTableId, 'OCCUPIED');

    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  Future<void> _releaseTableIfNoOpenOrders(String tableId) async {
    final openOrder = await _orders.getOpenOrderForTable(tableId);
    if (openOrder == null) {
      // Check for reservations? No, reservation repository handles that.
      // Actually, we just set to FREE. The syncReservationTableStatuses will fix it if needed.
      await _setTableStatus(tableId, 'FREE');
    }
  }

  Future<void> _setTableStatus(String tableId, String status) async {
    await (_db.update(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .write(RestaurantTablesCompanion(status: Value(status)));
  }
}
