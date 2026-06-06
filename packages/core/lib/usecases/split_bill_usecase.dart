import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../enums/order_source.dart';
import '../enums/order_type.dart';
import '../repositories/order_repository.dart';
import '../utils/uuid_generator.dart';

class SplitBillUseCase {
  const SplitBillUseCase(this._db, this._orders);

  final AppDatabase _db;
  final OrderRepository _orders;

  Future<({Order subOrder, OrderItem movedItem})> splitOrderItemToSubOrder({
    required String sourceOrderId,
    required String orderItemId,
    String? targetSubOrderId,
    double quantityToMove = 1,
  }) async {
    final sourceOrder = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(sourceOrderId)))
        .getSingleOrNull();
    if (sourceOrder == null) throw StateError('Commande source introuvable');

    final validStatuses = ['OPEN', 'SENT', 'PROFORMA'];
    if (!validStatuses.contains(sourceOrder.status)) {
      throw StateError('Ticket source non modifiable');
    }

    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId) & i.orderId.equals(sourceOrderId)))
        .getSingleOrNull();
    if (item == null) throw StateError('Article introuvable');

    if (quantityToMove <= 0 || quantityToMove > item.quantity) {
      throw ArgumentError('Quantité invalide');
    }

    Order targetSubOrder;
    if (targetSubOrderId == null) {
      targetSubOrder = await _orders.createOrder(
        sessionId: sourceOrder.sessionId,
        waiterId: sourceOrder.waiterId,
        orderType: OrderType.values.firstWhere((e) => e.dbValue == sourceOrder.orderType),
        guestCount: 1,
        source: OrderSource.values.firstWhere((e) => e.dbValue == sourceOrder.source),
        externalRef: sourceOrder.externalRef != null
            ? '${sourceOrder.externalRef}-SPLIT'
            : 'SPLIT-$sourceOrderId',
      );
    } else {
      final existing = await (_db.select(_db.orders)
            ..where((o) => o.id.equals(targetSubOrderId)))
          .getSingleOrNull();
      if (existing == null) throw StateError('Sous-ticket introuvable');
      targetSubOrder = existing;
    }

    if (targetSubOrder.status == 'PROFORMA') {
      throw StateError('Sous-ticket en proforma non modifiable');
    }

    OrderItem resultingItem;

    if (quantityToMove == item.quantity) {
      await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
          .write(OrderItemsCompanion(orderId: Value(targetSubOrder.id)));

      resultingItem = await (_db.select(_db.orderItems)..where((i) => i.id.equals(orderItemId))).getSingle();
    } else {
      final newQuantity = item.quantity - quantityToMove;
      await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
          .write(OrderItemsCompanion(quantity: Value(newQuantity)));

      final newId = newUuid();
      await _db.into(_db.orderItems).insert(
            OrderItemsCompanion.insert(
              id: Value(newId),
              orderId: targetSubOrder.id,
              productId: item.productId,
              unitPrice: item.unitPrice,
              taxRate: item.taxRate,
              quantity: quantityToMove,
              customNotes: Value(item.customNotes),
              isFired: Value(item.isFired),
              createdAt: item.createdAt,
            ),
          );

      final modifiers = await (_db.select(_db.orderItemModifiers)
            ..where((m) => m.orderItemId.equals(orderItemId)))
          .get();

      for (final mod in modifiers) {
        await _db.into(_db.orderItemModifiers).insert(
              OrderItemModifiersCompanion.insert(
                id: Value(newUuid()),
                orderItemId: newId,
                modifierOptionId: mod.modifierOptionId,
                priceExtra: mod.priceExtra,
              ),
            );
      }
      resultingItem = await (_db.select(_db.orderItems)..where((i) => i.id.equals(newId))).getSingle();
    }

    return (subOrder: targetSubOrder, movedItem: resultingItem);
  }
}
