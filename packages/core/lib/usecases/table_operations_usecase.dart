import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../repositories/order_repository.dart';

class TableOperationsUseCase {
  const TableOperationsUseCase(this._db, this._orders);

  final AppDatabase _db;
  final OrderRepository _orders;

  Future<Order> transferTableOrder({
    required String orderId,
    required String targetTableId,
  }) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) throw StateError('Commande introuvable');
    if (order.status != 'OPEN' && order.status != 'SENT' && order.status != 'PROFORMA') {
      throw StateError('Seuls les tickets ouverts peuvent être transférés');
    }

    final fromTableId = order.tableId;
    if (fromTableId == null) throw StateError('Commande sans table');
    if (fromTableId == targetTableId) return order;

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

    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId))).getSingle();
  }

  Future<Order> mergeTableOrders({
    required String targetOrderId,
    required String sourceOrderId,
  }) async {
    if (targetOrderId == sourceOrderId) {
      throw ArgumentError('Impossible de fusionner un ticket avec lui-même');
    }

    final target = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(targetOrderId)))
        .getSingleOrNull();
    final source = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(sourceOrderId)))
        .getSingleOrNull();

    if (target == null || source == null) throw StateError('Commande introuvable');

    final validStatuses = ['OPEN', 'SENT', 'PROFORMA'];
    if (!validStatuses.contains(target.status) || !validStatuses.contains(source.status)) {
      throw StateError('Seuls les tickets ouverts peuvent être fusionnés');
    }

    if (target.status == 'PROFORMA') {
      throw StateError('Ticket proforma non modifiable (encaissement en cours)');
    }

    await (_db.update(_db.orderItems)..where((i) => i.orderId.equals(sourceOrderId)))
        .write(OrderItemsCompanion(orderId: Value(targetOrderId)));

    await (_db.update(_db.orders)..where((o) => o.id.equals(sourceOrderId))).write(
      OrdersCompanion(
        status: const Value('CANCELLED'),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );

    if (source.tableId != null) {
      await _releaseTableIfNoOpenOrders(source.tableId!);
    }
    if (target.tableId != null) {
      await _setTableStatus(target.tableId!, 'OCCUPIED');
    }

    return (_db.select(_db.orders)..where((o) => o.id.equals(targetOrderId))).getSingle();
  }

  Future<void> _releaseTableIfNoOpenOrders(String tableId) async {
    final openOrder = await _orders.getOpenOrderForTable(tableId);
    if (openOrder == null) {
      await _setTableStatus(tableId, 'FREE');
    }
  }

  Future<void> _setTableStatus(String tableId, String status) async {
    await (_db.update(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .write(RestaurantTablesCompanion(status: Value(status)));
  }
}
