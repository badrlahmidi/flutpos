import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/kds_order_ticket.dart';
import '../utils/delivery_ticket_header.dart';
import 'kds_repository.dart';
import 'order_repository.dart';

class KdsRepositoryImpl implements KdsRepository {
  KdsRepositoryImpl(this._db, this._orders);

  final AppDatabase _db;
  final OrderRepository _orders;

  static const _pendingStatuses = ['PENDING'];

  @override
  Future<List<KdsOrderTicket>> loadPendingTickets() async {
    final pendingItems = await (_db.select(_db.orderItems)
          ..where(
            (i) =>
                i.isFired.equals(true) &
                i.status.isIn(_pendingStatuses),
          )
          ..orderBy([(i) => OrderingTerm.asc(i.createdAt)]))
        .get();

    if (pendingItems.isEmpty) {
      return [];
    }

    final byOrder = <String, List<OrderItem>>{};
    for (final item in pendingItems) {
      byOrder.putIfAbsent(item.orderId, () => []).add(item);
    }

    final tickets = <KdsOrderTicket>[];
    for (final entry in byOrder.entries) {
      final complete = await _orders.getCompleteOrder(entry.key);
      if (complete == null) {
        continue;
      }

      final ids = entry.value.map((i) => i.id).toSet();
      final lines = complete.items
          .where(
            (line) =>
                ids.contains(line.orderItem.id) &&
                line.orderItem.status != 'VOIDED',
          )
          .toList();

      if (lines.isEmpty) {
        continue;
      }

      tickets.add(
        KdsOrderTicket(
          order: complete.order,
          table: complete.table,
          pendingItems: lines,
          headerLabel: _headerLabel(complete.order, complete.table),
        ),
      );
    }

    tickets.sort(
      (a, b) => a.oldestItemAt.compareTo(b.oldestItemAt),
    );
    return tickets;
  }

  @override
  Stream<List<KdsOrderTicket>> watchPendingTickets() {
    return _db.select(_db.orderItems).watch().asyncMap((_) {
      return loadPendingTickets();
    });
  }

  @override
  Future<OrderItem> markOrderItemReady(String orderItemId) async {
    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId)))
        .getSingleOrNull();
    if (item == null) {
      throw StateError('Ligne introuvable');
    }
    if (!item.isFired) {
      throw StateError('Article non envoyé en cuisine');
    }

    await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .write(
      const OrderItemsCompanion(status: Value('PREPARING')),
    );

    return (_db.select(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .getSingle();
  }

  String? _headerLabel(Order order, RestaurantTable? table) {
    final delivery = DeliveryTicketHeader.displayLabel(order);
    if (delivery != null) {
      return delivery;
    }
    if (table != null) {
      return 'Table ${table.name}';
    }
    return null;
  }
}
