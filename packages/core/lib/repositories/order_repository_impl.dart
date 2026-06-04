import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/complete_order.dart';
import '../entities/order_item_with_product.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';
import '../enums/discount_type.dart';
import '../enums/order_type.dart';
import '../enums/payment_method.dart';
import '../usecases/calculate_order_total.dart';
import '../usecases/money_math.dart';
import '../utils/payment_order_mapper.dart';
import '../utils/moroccan_ice.dart';
import '../utils/order_pricing.dart';
import '../utils/uuid_generator.dart';
import 'audit_repository.dart';
import 'order_repository.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._db, this._audit);

  final AppDatabase _db;
  final AuditRepository _audit;

  @override
  double resolveUnitPrice(Product product, OrderType orderType) =>
      OrderPricing.resolveUnitPrice(product, orderType);

  @override
  Future<CashSession?> getOpenSessionForCashier(String cashierId) {
    return (_db.select(_db.cashSessions)
          ..where(
            (s) =>
                s.cashierId.equals(cashierId) & s.status.equals('OPEN'),
          )
          ..orderBy([(s) => OrderingTerm.desc(s.openedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<CashSession> ensureOpenSession({
    required String cashierId,
    double openingBalance = 0,
  }) async {
    final existing = await getOpenSessionForCashier(cashierId);
    if (existing != null) {
      return existing;
    }

    final id = newUuid();
    final session = CashSessionsCompanion.insert(
      id: Value(id),
      cashierId: cashierId,
      openedAt: DateTime.now().toUtc(),
      openingBalance: openingBalance,
    );
    await _db.into(_db.cashSessions).insert(session);
    return (_db.select(_db.cashSessions)..where((s) => s.id.equals(id)))
        .getSingle();
  }

  @override
  Future<Order> createOrder({
    required String sessionId,
    required String waiterId,
    required OrderType orderType,
    String? tableId,
    int guestCount = 1,
  }) async {
    final id = newUuid();
    final now = DateTime.now().toUtc();
    await _db.into(_db.orders).insert(
          OrdersCompanion.insert(
            id: Value(id),
            sessionId: sessionId,
            waiterId: waiterId,
            tableId: Value(tableId),
            orderType: orderType.dbValue,
            guestCount: Value(guestCount),
            createdAt: now,
          ),
        );
    return (_db.select(_db.orders)..where((o) => o.id.equals(id))).getSingle();
  }

  @override
  Future<Order> markOrderProforma(String orderId) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) {
      throw StateError('Commande introuvable');
    }
    if (order.status == 'PAID' ||
        order.status == 'CANCELLED' ||
        order.status == 'VOID') {
      throw StateError('Impossible d\'imprimer une proforma sur cette commande');
    }
    if (order.status == 'PROFORMA') {
      return order;
    }

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            status: const Value('PROFORMA'),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  @override
  Future<OrderItem> addOrderItem({
    required String orderId,
    required Product product,
    required OrderType orderType,
    double quantity = 1,
    String? customNotes,
  }) async {
    await _assertOrderAcceptsNewItems(orderId);
    final id = newUuid();
    final unitPrice = resolveUnitPrice(product, orderType);
    await _db.into(_db.orderItems).insert(
          OrderItemsCompanion.insert(
            id: Value(id),
            orderId: orderId,
            productId: product.id,
            quantity: quantity,
            unitPrice: unitPrice,
            taxRate: product.taxRate,
            customNotes: Value(customNotes),
            createdAt: DateTime.now().toUtc(),
          ),
        );
    return (_db.select(_db.orderItems)..where((i) => i.id.equals(id)))
        .getSingle();
  }

  @override
  Future<OrderItemModifier> addOrderItemModifier({
    required String orderItemId,
    required ModifierOption option,
  }) async {
    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId)))
        .getSingleOrNull();
    if (item != null) {
      await _assertOrderAcceptsNewItems(item.orderId);
    }
    final id = newUuid();
    await _db.into(_db.orderItemModifiers).insert(
          OrderItemModifiersCompanion.insert(
            id: Value(id),
            orderItemId: orderItemId,
            modifierOptionId: option.id,
            priceExtra: option.priceExtra,
          ),
        );
    return (_db.select(_db.orderItemModifiers)
          ..where((m) => m.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateOrderItemQuantity({
    required String orderItemId,
    required double quantity,
  }) async {
    await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .write(OrderItemsCompanion(quantity: Value(quantity)));
  }

  @override
  Future<void> updateOrderType({
    required String orderId,
    required OrderType orderType,
  }) async {
    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            orderType: Value(orderType.dbValue),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
  }

  @override
  Future<Order> applyDiscount({
    required String userId,
    required String orderId,
    required DiscountType discountType,
    required double discountValue,
    required String reason,
    String? authorizedByUserId,
  }) async {
    await _audit.logActionTyped(
      userId: userId,
      action: AuditAction.applyDiscount,
      targetType: AuditTargetType.order,
      targetId: orderId,
      details: {
        'discountType': discountType.dbValue,
        'discountValue': discountValue,
        'reason': reason,
        if (authorizedByUserId != null)
          'authorizedByUserId': authorizedByUserId,
      },
    );

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            discountType: Value(discountType.dbValue),
            discountValue: Value(discountValue),
            discountReason: Value(reason),
            discountAuthorizedBy: Value(authorizedByUserId),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  @override
  Future<OrderItem> voidOrderItem({
    required String userId,
    required String orderItemId,
    required String reason,
    String? authorizedByUserId,
  }) async {
    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId)))
        .getSingle();

    final lineAmount = roundMoney(item.quantity * item.unitPrice);

    await _audit.logActionTyped(
      userId: userId,
      action: AuditAction.voidItem,
      targetType: AuditTargetType.orderItem,
      targetId: orderItemId,
      details: {
        'orderId': item.orderId,
        'reason': reason,
        'amount': lineAmount,
        'wasFired': item.isFired,
        if (authorizedByUserId != null)
          'authorizedByUserId': authorizedByUserId,
      },
    );

    await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .write(
      OrderItemsCompanion(
        status: const Value('VOIDED'),
        voidReason: Value(reason),
        voidAuthorizedBy: Value(authorizedByUserId),
      ),
    );

    return (_db.select(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .getSingle();
  }

  @override
  Future<void> markOrderItemsFired(Iterable<String> orderItemIds) async {
    final ids = orderItemIds.toList();
    if (ids.isEmpty) {
      return;
    }

    await (_db.update(_db.orderItems)
          ..where((i) => i.id.isIn(ids)))
        .write(const OrderItemsCompanion(isFired: Value(true)));
  }

  @override
  Future<void> removeOrderItem(String orderItemId) async {
    await (_db.delete(_db.orderItemModifiers)
          ..where((m) => m.orderItemId.equals(orderItemId)))
        .go();
    await (_db.delete(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .go();
  }

  @override
  Future<CompleteOrder?> getCompleteOrder(String orderId) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) {
      return null;
    }

    final waiter = await (_db.select(_db.users)
          ..where((u) => u.id.equals(order.waiterId)))
        .getSingle();

    RestaurantTable? table;
    final tableId = order.tableId;
    if (tableId != null) {
      table = await (_db.select(_db.restaurantTables)
            ..where((t) => t.id.equals(tableId)))
          .getSingleOrNull();
    }

    final orderItems = await (_db.select(_db.orderItems)
          ..where((i) => i.orderId.equals(orderId))
          ..orderBy([(i) => OrderingTerm.asc(i.createdAt)]))
        .get();

    final items = <OrderItemWithProduct>[];
    for (final orderItem in orderItems) {
      final product = await (_db.select(_db.products)
            ..where((p) => p.id.equals(orderItem.productId)))
          .getSingle();
      final modifiers = await (_db.select(_db.orderItemModifiers)
            ..where((m) => m.orderItemId.equals(orderItem.id)))
          .get();
      final modifierOptions = <ModifierOption>[];
      for (final modifier in modifiers) {
        final option = await (_db.select(_db.modifierOptions)
              ..where((o) => o.id.equals(modifier.modifierOptionId)))
            .getSingle();
        modifierOptions.add(option);
      }
      items.add(
        OrderItemWithProduct(
          orderItem: orderItem,
          product: product,
          modifiers: modifiers,
          modifierOptions: modifierOptions,
        ),
      );
    }

    final payments = await (_db.select(_db.payments)
          ..where((p) => p.orderId.equals(orderId)))
        .get();

    return CompleteOrder(
      order: order,
      table: table,
      waiter: waiter,
      items: items,
      payments: payments,
    );
  }

  @override
  Future<Payment> addPayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    String? reference,
  }) async {
    final id = newUuid();
    await _db.into(_db.payments).insert(
          PaymentsCompanion.insert(
            id: Value(id),
            orderId: orderId,
            paymentMethod: method.dbValue,
            amount: amount,
            reference: Value(reference),
            paidAt: DateTime.now().toUtc(),
          ),
        );
    return (_db.select(_db.payments)..where((p) => p.id.equals(id)))
        .getSingle();
  }

  @override
  Future<Order> finalizeOrderIfFullyPaid(String orderId) async {
    final complete = await getCompleteOrder(orderId);
    if (complete == null) {
      throw StateError('Commande introuvable');
    }

    final totals = CalculateOrderTotal.call(
      lines: PaymentOrderMapper.toLineInputs(complete),
      discount: PaymentOrderMapper.toDiscountInput(complete.order),
    );
    final remaining = roundMoney(totals.grandTotal - complete.totalPaid);
    if (remaining > 0.009) {
      return complete.order;
    }

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            status: const Value('PAID'),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

    await issueInvoiceNumberIfNeeded(orderId);

    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  @override
  Future<Order> setEnterpriseInvoice({
    required String orderId,
    required String companyName,
    required String companyIce,
  }) async {
    final name = companyName.trim();
    final ice = MoroccanIce.normalize(companyIce);
    if (name.length < 2) {
      throw ArgumentError('Nom entreprise invalide');
    }
    final iceError = MoroccanIce.validationMessage(ice);
    if (iceError != null) {
      throw ArgumentError(iceError);
    }

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            companyName: Value(name),
            companyIce: Value(ice),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  @override
  Future<Order> clearEnterpriseInvoice(String orderId) async {
    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            companyName: const Value(null),
            companyIce: const Value(null),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  @override
  Future<int> peekNextInvoiceNumber() async {
    final row = await _db
        .customSelect(
          'SELECT MAX(invoice_number) AS max_num FROM orders',
          readsFrom: {_db.orders},
        )
        .getSingleOrNull();
    final max = row?.read<int?>('max_num') ?? 0;
    return max + 1;
  }

  @override
  Future<Order> issueInvoiceNumberIfNeeded(String orderId) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingle();
    final ice = order.companyIce;
    if (ice == null || ice.isEmpty || order.invoiceNumber != null) {
      return order;
    }

    final next = await peekNextInvoiceNumber();
    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            invoiceNumber: Value(next),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );
    return (_db.select(_db.orders)..where((o) => o.id.equals(orderId)))
        .getSingle();
  }

  Future<void> _assertOrderAcceptsNewItems(String orderId) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) {
      throw StateError('Commande introuvable');
    }
    const locked = {'PROFORMA', 'PAID', 'CANCELLED', 'VOID'};
    if (locked.contains(order.status)) {
      throw StateError('Commande verrouillée — ajout impossible');
    }
  }
}
