import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/complete_order.dart';
import '../entities/order_item_with_product.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';
import '../enums/discount_type.dart';
import '../enums/order_source.dart';
import '../enums/order_type.dart';
import '../enums/payment_method.dart';
import '../usecases/calculate_order_total.dart';
import '../usecases/money_math.dart';
import '../utils/payment_order_mapper.dart';
import '../utils/moroccan_ice.dart';
import '../entities/fire_course_result.dart';
import '../exceptions/order_item_void_required.dart';
import '../utils/order_item_grace.dart';
import '../utils/order_pricing.dart';
import '../utils/uuid_generator.dart';
import '../usecases/split_bill_usecase.dart';
import '../usecases/table_operations_usecase.dart';
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
    OrderSource source = OrderSource.manual,
    String? externalRef,
    String? orderId,
  }) async {
    final id = orderId ?? newUuid();
    final now = DateTime.now().toUtc();
    final ref = _normalizeExternalRef(externalRef);
    await _db.into(_db.orders).insert(
          OrdersCompanion.insert(
            id: Value(id),
            sessionId: sessionId,
            waiterId: waiterId,
            tableId: Value(tableId),
            orderType: orderType.dbValue,
            source: Value(source.dbValue),
            externalRef: Value(ref),
            guestCount: Value(guestCount),
            createdAt: now,
          ),
        );
    if (tableId != null) {
      await _setTableStatus(tableId, 'OCCUPIED');
    }
    return (_db.select(_db.orders)..where((o) => o.id.equals(id))).getSingle();
  }

  @override
  Future<Order> createDeliveryOrder({
    required String sessionId,
    required String waiterId,
    required OrderSource source,
    String? externalRef,
  }) {
    if (source == OrderSource.manual) {
      throw ArgumentError('Source livraison invalide');
    }
    return createOrder(
      sessionId: sessionId,
      waiterId: waiterId,
      orderType: OrderType.delivery,
      tableId: null,
      source: source,
      externalRef: externalRef,
    );
  }

  @override
  Future<List<Order>> listOpenDeliveryOrders(String sessionId) {
    return (_db.select(_db.orders)
          ..where(
            (o) =>
                o.sessionId.equals(sessionId) &
                o.orderType.equals(OrderType.delivery.dbValue) &
                o.status.isIn(_openOrderStatuses),
          )
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)]))
        .get();
  }

  String? _normalizeExternalRef(String? ref) {
    if (ref == null) {
      return null;
    }
    final trimmed = ref.trim();
    return trimmed.isEmpty ? null : trimmed;
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
    int courseNumber = 1,
    String? orderItemId,
  }) async {
    await _assertOrderAcceptsNewItems(orderId);
    if (courseNumber < 1) {
      throw ArgumentError.value(courseNumber, 'courseNumber', 'Doit être >= 1');
    }
    final id = orderItemId ?? newUuid();
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
            courseNumber: Value(courseNumber),
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
  Future<Order> updateOrderNotes({
    required String orderId,
    required String? notes,
  }) async {
    final trimmed = notes?.trim();
    final normalized = (trimmed == null || trimmed.isEmpty) ? null : trimmed;

    await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
          OrdersCompanion(
            notes: Value(normalized),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        );

    final updated = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (updated == null) {
      throw StateError('Commande introuvable');
    }
    return updated;
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
  Future<OrderItem> updateOrderItemCourse({
    required String orderItemId,
    required int courseNumber,
  }) async {
    if (courseNumber < 1) {
      throw ArgumentError.value(courseNumber, 'courseNumber', 'Doit être >= 1');
    }

    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId)))
        .getSingleOrNull();
    if (item == null) {
      throw StateError('Ligne introuvable');
    }
    if (item.status == 'VOIDED') {
      throw StateError('Impossible de modifier une ligne annulée');
    }
    if (item.isFired) {
      throw StateError('Impossible de changer la course d\'un article déjà envoyé');
    }

    await (_db.update(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .write(OrderItemsCompanion(courseNumber: Value(courseNumber)));

    return (_db.select(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .getSingle();
  }

  @override
  Future<List<int>> listPendingCourseNumbers(String orderId) async {
    final items = await (_db.select(_db.orderItems)
          ..where(
            (i) =>
                i.orderId.equals(orderId) &
                i.isFired.equals(false) &
                i.status.isNotValue('VOIDED'),
          ))
        .get();

    final numbers = items.map((i) => i.courseNumber).toSet().toList()..sort();
    return numbers;
  }

  @override
  Future<FireCourseResult> fireCourse({
    required String orderId,
    required int courseNumber,
  }) async {
    if (courseNumber < 1) {
      throw ArgumentError.value(courseNumber, 'courseNumber', 'Doit être >= 1');
    }

    await _assertOrderCanFireCourses(orderId);

    final pending = await (_db.select(_db.orderItems)
          ..where(
            (i) =>
                i.orderId.equals(orderId) &
                i.courseNumber.equals(courseNumber) &
                i.isFired.equals(false) &
                i.status.isNotValue('VOIDED'),
          ))
        .get();

    if (pending.isEmpty) {
      throw StateError(
        'Aucune ligne à envoyer pour la course $courseNumber',
      );
    }

    final ids = pending.map((i) => i.id).toList();
    await markOrderItemsFired(ids);

    final fired = await (_db.select(_db.orderItems)
          ..where((i) => i.id.isIn(ids)))
        .get();

    return FireCourseResult(
      orderId: orderId,
      courseNumber: courseNumber,
      firedItems: fired,
    );
  }

  @override
  Future<FireCourseResult?> fireNextPendingCourse(String orderId) async {
    final pendingCourses = await listPendingCourseNumbers(orderId);
    if (pendingCourses.isEmpty) {
      return null;
    }
    return fireCourse(orderId: orderId, courseNumber: pendingCourses.first);
  }

  @override
  Future<bool> removeOrderItem(String orderItemId) async {
    final item = await (_db.select(_db.orderItems)
          ..where((i) => i.id.equals(orderItemId)))
        .getSingleOrNull();
    if (item == null) {
      return false;
    }
    if (item.isFired) {
      throw const OrderItemVoidRequired();
    }

    final graceful = OrderItemGrace.isEligible(item);

    await (_db.delete(_db.orderItemModifiers)
          ..where((m) => m.orderItemId.equals(orderItemId)))
        .go();
    await (_db.delete(_db.orderItems)..where((i) => i.id.equals(orderItemId)))
        .go();

    return graceful;
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
    await _releaseTableIfNoOpenOrders(complete.order.tableId);

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

  static const _openOrderStatuses = ['OPEN', 'SENT', 'PROFORMA'];

  @override
  Future<Order?> getOpenOrderForTable(String tableId) {
    return (_db.select(_db.orders)
          ..where(
            (o) =>
                o.tableId.equals(tableId) &
                o.status.isIn(_openOrderStatuses),
          )
          ..orderBy([(o) => OrderingTerm.desc(o.createdAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<Order> openTableOrder({
    required String sessionId,
    required String waiterId,
    required String tableId,
    int guestCount = 1,
    String? orderId,
  }) async {
    final existing = await getOpenOrderForTable(tableId);
    if (existing != null) {
      throw StateError('La table possède déjà un ticket ouvert');
    }

    final targetTable = await (_db.select(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingleOrNull();
    if (targetTable == null) {
      throw StateError('Table introuvable');
    }

    final occupiedElsewhere = await (_db.select(_db.orders)
          ..where(
            (o) =>
                o.tableId.equals(tableId) &
                o.status.isIn(_openOrderStatuses),
          ))
        .get();
    if (occupiedElsewhere.isNotEmpty) {
      throw StateError('Table occupée');
    }

    return createOrder(
      sessionId: sessionId,
      waiterId: waiterId,
      orderType: OrderType.dineIn,
      tableId: tableId,
      guestCount: guestCount,
      orderId: orderId,
    );
  }

  @override
  Future<Order> transferTableOrder({
    required String orderId,
    required String targetTableId,
  }) async {
    final useCase = TableOperationsUseCase(_db, this);
    return useCase.transferTableOrder(orderId: orderId, targetTableId: targetTableId);
  }

  @override
  Future<Order> mergeTableOrders({
    required String targetOrderId,
    required String sourceOrderId,
  }) async {
    final useCase = TableOperationsUseCase(_db, this);
    return useCase.mergeTableOrders(targetOrderId: targetOrderId, sourceOrderId: sourceOrderId);
  }

  @override
  Future<({Order subOrder, OrderItem movedItem})> splitOrderItemToSubOrder({
    required String sourceOrderId,
    required String orderItemId,
    String? targetSubOrderId,
    double quantityToMove = 1,
  }) async {
    final useCase = SplitBillUseCase(_db, this);
    return useCase.splitOrderItemToSubOrder(
      sourceOrderId: sourceOrderId,
      orderItemId: orderItemId,
      targetSubOrderId: targetSubOrderId,
      quantityToMove: quantityToMove,
    );
  }

  @override
  Future<List<Order>> getOpenSubOrdersForSession(String sessionId) {
    return (_db.select(_db.orders)
          ..where(
            (o) =>
                o.sessionId.equals(sessionId) &
                o.tableId.isNull() &
                o.status.isIn(_openOrderStatuses),
          )
          ..orderBy([(o) => OrderingTerm.asc(o.createdAt)]))
        .get();
  }

  @override
  Future<CompleteOrder?> mirrorOrderSnapshot({
    required String localSessionId,
    required Map<String, dynamic> snapshot,
  }) async {
    final orderMap = snapshot['order'];
    if (orderMap is! Map<String, dynamic>) {
      return null;
    }

    final orderId = orderMap['id'] as String;
    final tableId = orderMap['tableId'] as String?;
    final createdAt = DateTime.parse(orderMap['createdAt'] as String).toUtc();
    final updatedAtRaw = orderMap['updatedAt'] as String?;
    final updatedAt =
        updatedAtRaw != null ? DateTime.parse(updatedAtRaw).toUtc() : null;

    final existing = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();

    if (existing == null) {
      await _db.into(_db.orders).insert(
            OrdersCompanion.insert(
              id: Value(orderId),
              sessionId: localSessionId,
              waiterId: orderMap['waiterId'] as String,
              tableId: Value(tableId),
              orderType: orderMap['orderType'] as String,
              status: Value(orderMap['status'] as String? ?? 'OPEN'),
              guestCount: Value(orderMap['guestCount'] as int? ?? 1),
              notes: Value(orderMap['notes'] as String?),
              createdAt: createdAt,
              updatedAt: Value(updatedAt),
            ),
          );
    } else {
      await (_db.update(_db.orders)..where((o) => o.id.equals(orderId))).write(
            OrdersCompanion(
              status: Value(orderMap['status'] as String? ?? existing.status),
              guestCount: Value(
                orderMap['guestCount'] as int? ?? existing.guestCount,
              ),
              notes: Value(orderMap['notes'] as String?),
              updatedAt: Value(updatedAt ?? DateTime.now().toUtc()),
            ),
          );
    }

    if (tableId != null) {
      await _setTableStatus(tableId, 'OCCUPIED');
    }

    final remoteItems = snapshot['items'] as List<dynamic>? ?? [];
    final remoteIds = <String>{};

    for (final raw in remoteItems) {
      if (raw is! Map<String, dynamic>) {
        continue;
      }
      final itemId = raw['id'] as String;
      remoteIds.add(itemId);
      final itemCreated =
          DateTime.parse(raw['createdAt'] as String).toUtc();
      final companion = OrderItemsCompanion(
        id: Value(itemId),
        orderId: Value(orderId),
        productId: Value(raw['productId'] as String),
        quantity: Value((raw['quantity'] as num).toDouble()),
        unitPrice: Value((raw['unitPrice'] as num).toDouble()),
        taxRate: Value((raw['taxRate'] as num).toDouble()),
        courseNumber: Value(raw['courseNumber'] as int? ?? 1),
        isFired: Value(raw['isFired'] as bool? ?? false),
        status: Value(raw['status'] as String? ?? 'ACTIVE'),
        customNotes: Value(raw['customNotes'] as String?),
        createdAt: Value(itemCreated),
      );

      final localItem = await (_db.select(_db.orderItems)
            ..where((i) => i.id.equals(itemId)))
          .getSingleOrNull();
      if (localItem == null) {
        await _db.into(_db.orderItems).insert(companion);
      } else {
        await (_db.update(_db.orderItems)..where((i) => i.id.equals(itemId)))
            .write(
          OrderItemsCompanion(
            productId: Value(raw['productId'] as String),
            quantity: Value((raw['quantity'] as num).toDouble()),
            unitPrice: Value((raw['unitPrice'] as num).toDouble()),
            taxRate: Value((raw['taxRate'] as num).toDouble()),
            courseNumber: Value(raw['courseNumber'] as int? ?? 1),
            isFired: Value(raw['isFired'] as bool? ?? false),
            status: Value(raw['status'] as String? ?? 'ACTIVE'),
            customNotes: Value(raw['customNotes'] as String?),
          ),
        );
      }
    }

    final localItems = await (_db.select(_db.orderItems)
          ..where((i) => i.orderId.equals(orderId)))
        .get();
    for (final local in localItems) {
      if (!remoteIds.contains(local.id)) {
        await (_db.delete(_db.orderItems)..where((i) => i.id.equals(local.id)))
            .go();
      }
    }

    return getCompleteOrder(orderId);
  }

  @override
  Future<void> clearLocalOpenOrderForTable(String tableId) async {
    final open = await getOpenOrderForTable(tableId);
    if (open == null) {
      return;
    }
    await (_db.delete(_db.orderItems)
          ..where((i) => i.orderId.equals(open.id)))
        .go();
    await (_db.delete(_db.orders)..where((o) => o.id.equals(open.id))).go();
    await _releaseTableIfNoOpenOrders(tableId);
  }

  Future<void> _setTableStatus(String tableId, String status) async {
    await (_db.update(_db.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .write(RestaurantTablesCompanion(status: Value(status)));
  }

  Future<void> _releaseTableIfNoOpenOrders(String? tableId) async {
    if (tableId == null) {
      return;
    }
    final stillOpen = await getOpenOrderForTable(tableId);
    if (stillOpen == null) {
      await _setTableStatus(tableId, 'FREE');
    }
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

  Future<void> _assertOrderCanFireCourses(String orderId) async {
    final order = await (_db.select(_db.orders)
          ..where((o) => o.id.equals(orderId)))
        .getSingleOrNull();
    if (order == null) {
      throw StateError('Commande introuvable');
    }
    const blocked = {'PAID', 'CANCELLED', 'VOID'};
    if (blocked.contains(order.status)) {
      throw StateError('Commande clôturée — envoi cuisine impossible');
    }
  }
}
