import 'package:drift/drift.dart';
import 'package:intl/intl.dart';

import '../database/app_database.dart';
import '../entities/daily_analytics_snapshot.dart';
import '../entities/report_entities.dart';
import '../enums/order_type.dart';
import '../enums/payment_method.dart';
import '../usecases/money_math.dart';
import 'analytics_repository.dart';

class AnalyticsRepositoryImpl implements AnalyticsRepository {
  AnalyticsRepositoryImpl(this._db);

  final AppDatabase _db;


  @override
  Future<DailyAnalyticsSnapshot> loadDailyDashboard({DateTime? day}) async {
    final localDay = day ?? DateTime.now();
    final start = DateTime(localDay.year, localDay.month, localDay.day);
    final end = start.add(const Duration(days: 1));

    final payments = await (_db.select(_db.payments)
          ..where(
            (p) =>
                p.paidAt.isBiggerOrEqualValue(start) &
                p.paidAt.isSmallerThanValue(end),
          ))
        .get();

    if (payments.isEmpty) {
      return _emptySnapshot(start);
    }

    final orderIds = payments.map((p) => p.orderId).toSet();
    final orders = await (_db.select(_db.orders)
          ..where((o) => o.id.isIn(orderIds.toList())))
        .get();
    final orderById = {for (final o in orders) o.id: o};

    var revenueDineIn = 0.0;
    var revenueDelivery = 0.0;
    final revenueByOrder = <String, double>{};

    for (final payment in payments) {
      revenueByOrder[payment.orderId] =
          (revenueByOrder[payment.orderId] ?? 0) + payment.amount;
    }

    for (final entry in revenueByOrder.entries) {
      final order = orderById[entry.key];
      if (order == null || order.status != 'PAID') {
        continue;
      }
      final amount = entry.value;
      if (order.orderType == OrderType.delivery.dbValue) {
        revenueDelivery += amount;
      } else {
        revenueDineIn += amount;
      }
    }

    revenueDineIn = roundMoney(revenueDineIn);
    revenueDelivery = roundMoney(revenueDelivery);
    final totalRevenue = roundMoney(revenueDineIn + revenueDelivery);
    final ticketCount = revenueByOrder.keys
        .where((id) => orderById[id]?.status == 'PAID')
        .length;
    final averageBasket = ticketCount == 0
        ? 0.0
        : roundMoney(totalRevenue / ticketCount);

    final hourlyBuckets = List<double>.filled(24, 0);
    for (final payment in payments) {
      final order = orderById[payment.orderId];
      if (order?.status != 'PAID') {
        continue;
      }
      hourlyBuckets[payment.paidAt.hour] += payment.amount;
    }

    final salesByHour = [
      for (var h = 0; h < 24; h++)
        HourlySalesPoint(hour: h, amount: roundMoney(hourlyBuckets[h])),
    ];

    final paidOrderIds =
        orderIds.where((id) => orderById[id]?.status == 'PAID').toList();

    final topProducts = await _loadTopProducts(paidOrderIds);
    final foodCost = await _computeFoodCost(paidOrderIds);
    final paymentBreakdown = _buildPaymentBreakdown(payments, orderById);
    final categoryBreakdown = await _buildCategoryBreakdown(paidOrderIds);
    final waiterPerformance = _buildWaiterPerformance(
      orders.where((o) => o.status == 'PAID').toList(),
      revenueByOrder,
    );

    // Résolution des noms de serveurs
    final waiterIds = waiterPerformance.map((w) => w.userId).toSet().toList();
    if (waiterIds.isNotEmpty) {
      final users = await (_db.select(_db.users)
            ..where((u) => u.id.isIn(waiterIds)))
          .get();
      final nameById = {for (final u in users) u.id: u.name};
      for (var i = 0; i < waiterPerformance.length; i++) {
        final wp = waiterPerformance[i];
        waiterPerformance[i] = WaiterPerformance(
          userId: wp.userId,
          userName: nameById[wp.userId] ?? wp.userId,
          ticketCount: wp.ticketCount,
          totalRevenue: wp.totalRevenue,
          averageBasket: wp.averageBasket,
        );
      }
    }

    return DailyAnalyticsSnapshot(
      day: start,
      revenueDineIn: revenueDineIn,
      revenueDelivery: revenueDelivery,
      totalRevenue: totalRevenue,
      ticketCount: ticketCount,
      averageBasket: averageBasket,
      salesByHour: salesByHour,
      topProducts: topProducts,
      foodCostSalesRevenue: foodCost.salesRevenue,
      foodCostTheoretical: foodCost.theoreticalCost,
      foodCostGap: foodCost.gap,
      foodCostRatioPercent: foodCost.ratioPercent,
      paymentBreakdown: paymentBreakdown,
      categoryBreakdown: categoryBreakdown,
      waiterPerformance: waiterPerformance,
    );
  }

  DailyAnalyticsSnapshot _emptySnapshot(DateTime day) {
    return DailyAnalyticsSnapshot(
      day: day,
      revenueDineIn: 0,
      revenueDelivery: 0,
      totalRevenue: 0,
      ticketCount: 0,
      averageBasket: 0,
      salesByHour: [
        for (var h = 0; h < 24; h++) HourlySalesPoint(hour: h, amount: 0),
      ],
      topProducts: const [],
      foodCostSalesRevenue: 0,
      foodCostTheoretical: 0,
      foodCostGap: 0,
      foodCostRatioPercent: 0,
    );
  }

  Future<List<TopProductSale>> _loadTopProducts(List<String> orderIds) async {
    if (orderIds.isEmpty) {
      return [];
    }

    final items = await (_db.select(_db.orderItems)
          ..where(
            (i) => i.orderId.isIn(orderIds) & i.status.isNotValue('VOIDED'),
          ))
        .get();

    if (items.isEmpty) {
      return [];
    }

    final productIds = items.map((i) => i.productId).toSet().toList();
    final products = await (_db.select(_db.products)
          ..where((p) => p.id.isIn(productIds)))
        .get();
    final nameById = {for (final p in products) p.id: p.name};

    final qtyByProduct = <String, double>{};
    final revenueByProduct = <String, double>{};

    for (final item in items) {
      qtyByProduct[item.productId] =
          (qtyByProduct[item.productId] ?? 0) + item.quantity;
      revenueByProduct[item.productId] = (revenueByProduct[item.productId] ?? 0) +
          roundMoney(item.quantity * item.unitPrice);
    }

    final modifiers = await (_db.select(_db.orderItemModifiers)
          ..where((m) => m.orderItemId.isIn(items.map((i) => i.id).toList())))
        .get();
    final modByItem = <String, double>{};
    for (final mod in modifiers) {
      modByItem[mod.orderItemId] =
          (modByItem[mod.orderItemId] ?? 0) + mod.priceExtra;
    }
    for (final item in items) {
      final extra = modByItem[item.id] ?? 0;
      revenueByProduct[item.productId] = roundMoney(
        (revenueByProduct[item.productId] ?? 0) + item.quantity * extra,
      );
    }

    final ranked = qtyByProduct.entries.map((entry) {
      return TopProductSale(
        productId: entry.key,
        productName: nameById[entry.key] ?? entry.key,
        quantitySold: entry.value,
        revenue: revenueByProduct[entry.key] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.quantitySold.compareTo(a.quantitySold));

    return ranked.take(5).toList();
  }

  Future<
      ({
        double salesRevenue,
        double theoreticalCost,
        double gap,
        double ratioPercent,
      })> _computeFoodCost(List<String> orderIds) async {
    if (orderIds.isEmpty) {
      return (
        salesRevenue: 0.0,
        theoreticalCost: 0.0,
        gap: 0.0,
        ratioPercent: 0.0,
      );
    }

    final items = await (_db.select(_db.orderItems)
          ..where(
            (i) => i.orderId.isIn(orderIds) & i.status.isNotValue('VOIDED'),
          ))
        .get();

    if (items.isEmpty) {
      return (
        salesRevenue: 0.0,
        theoreticalCost: 0.0,
        gap: 0.0,
        ratioPercent: 0.0,
      );
    }

    final productIds = items.map((i) => i.productId).toSet().toList();
    final recipes = await (_db.select(_db.recipeItems)
          ..where((r) => r.productId.isIn(productIds)))
        .get();

    if (recipes.isEmpty) {
      return (
        salesRevenue: 0.0,
        theoreticalCost: 0.0,
        gap: 0.0,
        ratioPercent: 0.0,
      );
    }

    final ingredientIds = recipes.map((r) => r.ingredientId).toSet().toList();
    final ingredients = await (_db.select(_db.ingredients)
          ..where((i) => i.id.isIn(ingredientIds)))
        .get();
    final costByIngredient = {
      for (final i in ingredients) i.id: i.costPerUnit,
    };

    final unitCostByProduct = <String, double>{};
    for (final recipe in recipes) {
      final ingredientCost = costByIngredient[recipe.ingredientId] ?? 0;
      unitCostByProduct[recipe.productId] =
          (unitCostByProduct[recipe.productId] ?? 0) +
              recipe.quantityUsed * ingredientCost;
    }

    var salesRevenue = 0.0;
    var theoreticalCost = 0.0;

    for (final item in items) {
      final unitRecipeCost = unitCostByProduct[item.productId];
      if (unitRecipeCost == null) {
        continue;
      }
      salesRevenue += item.quantity * item.unitPrice;
      theoreticalCost += item.quantity * unitRecipeCost;
    }

    salesRevenue = roundMoney(salesRevenue);
    theoreticalCost = roundMoney(theoreticalCost);
    final gap = roundMoney(salesRevenue - theoreticalCost);
    final ratioPercent = salesRevenue == 0
        ? 0.0
        : roundMoney(theoreticalCost / salesRevenue * 100);

    return (
      salesRevenue: salesRevenue,
      theoreticalCost: theoreticalCost,
      gap: gap,
      ratioPercent: ratioPercent,
    );
  }

  // ─── DASHBOARD HELPERS ──────────────────────────────────────────────────

  List<PaymentMethodBreakdown> _buildPaymentBreakdown(
    List<Payment> payments,
    Map<String, Order> orderById,
  ) {
    final amountByMethod = <String, double>{};
    final countByMethod = <String, int>{};

    for (final p in payments) {
      if (orderById[p.orderId]?.status != 'PAID') continue;
      amountByMethod[p.paymentMethod] =
          roundMoney((amountByMethod[p.paymentMethod] ?? 0) + p.amount);
      countByMethod[p.paymentMethod] =
          (countByMethod[p.paymentMethod] ?? 0) + 1;
    }

    final result = amountByMethod.entries.map((e) {
      final pm = PaymentMethod.fromDb(e.key);
      return PaymentMethodBreakdown(
        method: e.key,
        label: pm?.label ?? e.key,
        amount: e.value,
        count: countByMethod[e.key] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    return result;
  }

  Future<List<CategoryBreakdown>> _buildCategoryBreakdown(
    List<String> orderIds,
  ) async {
    if (orderIds.isEmpty) return [];

    final items = await (_db.select(_db.orderItems)
          ..where(
            (i) => i.orderId.isIn(orderIds) & i.status.isNotValue('VOIDED'),
          ))
        .get();
    if (items.isEmpty) return [];

    final productIds = items.map((i) => i.productId).toSet().toList();
    final products = await (_db.select(_db.products)
          ..where((p) => p.id.isIn(productIds)))
        .get();
    final catIdByProduct = {for (final p in products) p.id: p.categoryId};

    final categoryIds =
        catIdByProduct.values.toSet().toList();
    final categories = await (_db.select(_db.categories)
          ..where((c) => c.id.isIn(categoryIds)))
        .get();
    final catNameById = {for (final c in categories) c.id: c.name};

    final revenueByCat = <String, double>{};
    final qtyByCat = <String, double>{};

    for (final item in items) {
      final catId = catIdByProduct[item.productId] ?? '';
      revenueByCat[catId] = roundMoney(
        (revenueByCat[catId] ?? 0) + item.quantity * item.unitPrice,
      );
      qtyByCat[catId] = (qtyByCat[catId] ?? 0) + item.quantity;
    }

    final result = revenueByCat.entries.map((e) {
      return CategoryBreakdown(
        categoryId: e.key,
        categoryName: catNameById[e.key] ?? 'Sans catégorie',
        revenue: e.value,
        quantity: qtyByCat[e.key] ?? 0,
      );
    }).toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    return result;
  }

  List<WaiterPerformance> _buildWaiterPerformance(
    List<Order> paidOrders,
    Map<String, double> revenueByOrder,
  ) {
    final ttcByUser = <String, double>{};
    final countByUser = <String, int>{};
    for (final o in paidOrders) {
      final amount = revenueByOrder[o.id] ?? 0;
      ttcByUser[o.waiterId] =
          roundMoney((ttcByUser[o.waiterId] ?? 0) + amount);
      countByUser[o.waiterId] = (countByUser[o.waiterId] ?? 0) + 1;
    }

    // Résolution des noms de serveurs de manière synchrone
    // (déjà chargé en mémoire via les orders)
    return _resolveWaiterNames(ttcByUser, countByUser);
  }

  List<WaiterPerformance> _resolveWaiterNames(
    Map<String, double> ttcByUser,
    Map<String, int> countByUser,
  ) {
    // On retourne des WaiterPerformance avec les IDs comme noms temporaires;
    // les noms seront résolus dans la méthode `loadDailyDashboard` ci-dessous.
    return ttcByUser.entries.map((e) {
      final count = countByUser[e.key] ?? 1;
      return WaiterPerformance(
        userId: e.key,
        userName: e.key, // placeholder
        ticketCount: count,
        totalRevenue: e.value,
        averageBasket: roundMoney(e.value / count),
      );
    }).toList()
      ..sort((a, b) => b.totalRevenue.compareTo(a.totalRevenue));
  }

  // ─── REPORTING METHODS ────────────────────────────────────────────────────

  /// Résout les IDs de commandes PAID sur la période, filtrées par utilisateur.
  Future<List<String>> _paidOrderIds(ReportFilters f) async {
    final endInclusive = f.endDate.add(const Duration(days: 1));
    final payments = await (_db.select(_db.payments)
          ..where(
            (p) =>
                p.paidAt.isBiggerOrEqualValue(f.startDate) &
                p.paidAt.isSmallerThanValue(endInclusive),
          ))
        .get();

    if (payments.isEmpty) return [];

    final orderIds = payments.map((p) => p.orderId).toSet().toList();
    var query = _db.select(_db.orders)
      ..where(
        (o) =>
            o.id.isIn(orderIds) &
            o.status.equals('PAID'),
      );

    final orders = await query.get();

    var filtered = orders;
    if (f.userId != null) {
      filtered = filtered.where((o) => o.waiterId == f.userId).toList();
    }
    if (f.sessionId != null) {
      filtered = filtered.where((o) => o.sessionId == f.sessionId).toList();
    }

    return filtered.map((o) => o.id).toList();
  }

  Future<Set<String>> _paidOrderIdSet(ReportFilters filters) async {
    return (await _paidOrderIds(filters)).toSet();
  }

  ReportHeader _buildHeader(
    String title,
    ReportFilters filters, {
    required double totalTTC,
    required double totalHT,
    required double totalTax,
    required int ticketCount,
  }) {
    return ReportHeader(
      title: title,
      generatedAt: DateTime.now(),
      filters: filters,
      totalTTC: totalTTC,
      totalHT: totalHT,
      totalTax: totalTax,
      ticketCount: ticketCount,
    );
  }

  @override
  Future<({ReportHeader header, List<ProductSalesReportLine> lines})>
      getProductSalesReport(ReportFilters filters) async {
    final orderIds = await _paidOrderIds(filters);
    if (orderIds.isEmpty) {
      const emptyLines = <ProductSalesReportLine>[];
      return (
        header: _buildHeader(
          'Ventes par Produit',
          filters,
          totalTTC: 0,
          totalHT: 0,
          totalTax: 0,
          ticketCount: 0,
        ),
        lines: emptyLines,
      );
    }

    var itemsQuery = _db.select(_db.orderItems)
      ..where(
        (i) => i.orderId.isIn(orderIds) & i.status.isNotValue('VOIDED'),
      );
    final items = await itemsQuery.get();

    if (items.isEmpty) {
      const emptyLines = <ProductSalesReportLine>[];
      return (
        header: _buildHeader(
          'Ventes par Produit',
          filters,
          totalTTC: 0,
          totalHT: 0,
          totalTax: 0,
          ticketCount: orderIds.length,
        ),
        lines: emptyLines,
      );
    }

    final productIds = items.map((i) => i.productId).toSet().toList();
    var prodQuery = _db.select(_db.products)
      ..where((p) => p.id.isIn(productIds));
    if (filters.categoryId != null) {
      prodQuery = _db.select(_db.products)
        ..where(
          (p) =>
              p.id.isIn(productIds) &
              p.categoryId.equals(filters.categoryId!),
        );
    }
    final products = await prodQuery.get();
    final productMap = {for (final p in products) p.id: p};

    final categoryIds = products
        .map((p) => p.categoryId)
        .whereType<String>()
        .toSet()
        .toList();
    final categories = await (_db.select(_db.categories)
          ..where((c) => c.id.isIn(categoryIds)))
        .get();
    final categoryMap = {for (final c in categories) c.id: c.name};

    final qtyByProduct = <String, double>{};
    final ttcByProduct = <String, double>{};
    final htByProduct = <String, double>{};
    final taxByProduct = <String, double>{};

    for (final item in items) {
      if (!productMap.containsKey(item.productId)) continue;
      final lineTtc = roundMoney(item.quantity * item.unitPrice);
      final taxRate = item.taxRate / 100;
      final lineHt = roundMoney(lineTtc / (1 + taxRate));
      final lineTax = roundMoney(lineTtc - lineHt);

      qtyByProduct[item.productId] =
          (qtyByProduct[item.productId] ?? 0) + item.quantity;
      ttcByProduct[item.productId] =
          (ttcByProduct[item.productId] ?? 0) + lineTtc;
      htByProduct[item.productId] =
          (htByProduct[item.productId] ?? 0) + lineHt;
      taxByProduct[item.productId] =
          (taxByProduct[item.productId] ?? 0) + lineTax;
    }

    double grandTTC = 0;
    double grandHT = 0;
    double grandTax = 0;

    final lines = productMap.values.map<ProductSalesReportLine>((p) {
      final qty = qtyByProduct[p.id] ?? 0;
      final ttc = roundMoney(ttcByProduct[p.id] ?? 0);
      final ht = roundMoney(htByProduct[p.id] ?? 0);
      final tax = roundMoney(taxByProduct[p.id] ?? 0);
      grandTTC += ttc;
      grandHT += ht;
      grandTax += tax;
      return ProductSalesReportLine(
        productId: p.id,
        productCode: p.barcode ?? p.id.substring(0, 8),
        productName: p.name,
        categoryName: categoryMap[p.categoryId] ?? '—',
        quantitySold: qty,
        totalHT: ht,
        totalTax: tax,
        totalTTC: ttc,
      );
    }).toList()
      ..sort((a, b) => b.totalTTC.compareTo(a.totalTTC));

    return (
      header: _buildHeader(
        'Ventes par Produit',
        filters,
        totalTTC: roundMoney(grandTTC),
        totalHT: roundMoney(grandHT),
        totalTax: roundMoney(grandTax),
        ticketCount: orderIds.length,
      ),
      lines: lines,
    );
  }

  @override
  Future<({ReportHeader header, List<CategorySalesReportLine> lines})>
      getCategorySalesReport(ReportFilters filters) async {
    final orderIds = await _paidOrderIds(filters);
    final emptyHeader = _buildHeader(
      'Ventes par Catégorie',
      filters,
      totalTTC: 0,
      totalHT: 0,
      totalTax: 0,
      ticketCount: orderIds.length,
    );
    if (orderIds.isEmpty) {
      const emptyLines = <CategorySalesReportLine>[];
      return (header: emptyHeader, lines: emptyLines);
    }

    final items = await (_db.select(_db.orderItems)
          ..where(
            (i) => i.orderId.isIn(orderIds) & i.status.isNotValue('VOIDED'),
          ))
        .get();
    if (items.isEmpty) {
      const emptyLines = <CategorySalesReportLine>[];
      return (header: emptyHeader, lines: emptyLines);
    }

    final productIds = items.map((i) => i.productId).toSet().toList();
    final products = await (_db.select(_db.products)
          ..where((p) => p.id.isIn(productIds)))
        .get();
    final productMap = {for (final p in products) p.id: p};

    final categoryIds = products
        .map((p) => p.categoryId)
        .whereType<String>()
        .toSet()
        .toList();
    final categories = await (_db.select(_db.categories)
          ..where((c) => c.id.isIn(categoryIds)))
        .get();
    final categoryMap = {for (final c in categories) c.id: c};

    final qtyByCat = <String, double>{};
    final ttcByCat = <String, double>{};
    final htByCat = <String, double>{};
    final taxByCat = <String, double>{};

    for (final item in items) {
      final product = productMap[item.productId];
      if (product == null) continue;
      final catId = product.categoryId;
      final lineTtc = roundMoney(item.quantity * item.unitPrice);
      final taxRate = item.taxRate / 100;
      final lineHt = roundMoney(lineTtc / (1 + taxRate));
      final lineTax = roundMoney(lineTtc - lineHt);

      qtyByCat[catId] = (qtyByCat[catId] ?? 0) + item.quantity;
      ttcByCat[catId] = (ttcByCat[catId] ?? 0) + lineTtc;
      htByCat[catId] = (htByCat[catId] ?? 0) + lineHt;
      taxByCat[catId] = (taxByCat[catId] ?? 0) + lineTax;
    }

    double grandTTC = 0;
    double grandHT = 0;
    double grandTax = 0;

    final lines = categoryMap.values.map<CategorySalesReportLine>((cat) {
      final qty = qtyByCat[cat.id] ?? 0;
      final ttc = roundMoney(ttcByCat[cat.id] ?? 0);
      final ht = roundMoney(htByCat[cat.id] ?? 0);
      final tax = roundMoney(taxByCat[cat.id] ?? 0);
      grandTTC += ttc;
      grandHT += ht;
      grandTax += tax;
      return CategorySalesReportLine(
        categoryId: cat.id,
        categoryName: cat.name,
        quantitySold: qty,
        totalHT: ht,
        totalTax: tax,
        totalTTC: ttc,
      );
    }).toList()
      ..sort((a, b) => b.totalTTC.compareTo(a.totalTTC));

    return (
      header: _buildHeader(
        'Ventes par Catégorie',
        filters,
        totalTTC: roundMoney(grandTTC),
        totalHT: roundMoney(grandHT),
        totalTax: roundMoney(grandTax),
        ticketCount: orderIds.length,
      ),
      lines: lines,
    );
  }

  @override
  Future<({ReportHeader header, List<PaymentMethodReportLine> lines})>
      getPaymentMethodReport(ReportFilters filters) async {
    final endInclusive = filters.endDate.add(const Duration(days: 1));
    var payments = await (_db.select(_db.payments)
          ..where(
            (p) =>
                p.paidAt.isBiggerOrEqualValue(filters.startDate) &
                p.paidAt.isSmallerThanValue(endInclusive),
          ))
        .get();

    final allowedOrderIds = await _paidOrderIdSet(filters);
    if (allowedOrderIds.isEmpty && (filters.userId != null || filters.sessionId != null)) {
      return (
        header: _buildHeader(
          'Ventes par Mode de Règlement',
          filters,
          totalTTC: 0,
          totalHT: 0,
          totalTax: 0,
          ticketCount: 0,
        ),
        lines: <PaymentMethodReportLine>[],
      );
    }

    if (filters.userId != null || filters.sessionId != null) {
      payments = payments.where((p) => allowedOrderIds.contains(p.orderId)).toList();
    }

    final orderIds = payments.map((p) => p.orderId).toSet();
    int ticketCount = 0;

    if (payments.isNotEmpty) {
      final orders = await (_db.select(_db.orders)
            ..where((o) => o.id.isIn(orderIds.toList()) & o.status.equals('PAID')))
          .get();
      ticketCount = orders.length;
    }

    final countByMethod = <String, int>{};
    final amountByMethod = <String, double>{};

    for (final p in payments) {
      final m = p.paymentMethod;
      countByMethod[m] = (countByMethod[m] ?? 0) + 1;
      amountByMethod[m] = roundMoney((amountByMethod[m] ?? 0) + p.amount);
    }

    final grandTTC = roundMoney(amountByMethod.values.fold(0.0, (a, b) => a + b));

    final lines = amountByMethod.entries.map<PaymentMethodReportLine>((e) {
      return PaymentMethodReportLine(
        method: e.key,
        transactionCount: countByMethod[e.key] ?? 0,
        totalAmount: e.value,
      );
    }).toList()
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    return (
      header: _buildHeader(
        'Ventes par Mode de Règlement',
        filters,
        totalTTC: grandTTC,
        totalHT: 0,
        totalTax: 0,
        ticketCount: ticketCount,
      ),
      lines: lines,
    );
  }

  @override
  Future<({ReportHeader header, List<UserSalesReportLine> lines})>
      getUserSalesReport(ReportFilters filters) async {
    final endInclusive = filters.endDate.add(const Duration(days: 1));
    var payments = await (_db.select(_db.payments)
          ..where(
            (p) =>
                p.paidAt.isBiggerOrEqualValue(filters.startDate) &
                p.paidAt.isSmallerThanValue(endInclusive),
          ))
        .get();

    if (payments.isEmpty) {
      return (
        header: _buildHeader(
          'Ventes par Serveur',
          filters,
          totalTTC: 0,
          totalHT: 0,
          totalTax: 0,
          ticketCount: 0,
        ),
        lines: <UserSalesReportLine>[],
      );
    }

    final allowedOrderIds = await _paidOrderIdSet(filters);
    payments = payments.where((p) => allowedOrderIds.contains(p.orderId)).toList();
    if (payments.isEmpty) {
      return (
        header: _buildHeader(
          'Ventes par Serveur',
          filters,
          totalTTC: 0,
          totalHT: 0,
          totalTax: 0,
          ticketCount: 0,
        ),
        lines: <UserSalesReportLine>[],
      );
    }

    final orderIds = payments.map((p) => p.orderId).toSet().toList();
    final orders = await (_db.select(_db.orders)
          ..where((o) => o.id.isIn(orderIds) & o.status.equals('PAID')))
        .get();

    final userIds = orders.map((o) => o.waiterId).toSet().toList();
    final users = await (_db.select(_db.users)
          ..where((u) => u.id.isIn(userIds)))
        .get();
    final userMap = {for (final u in users) u.id: u.name};

    final paymentsByOrder = <String, double>{};
    for (final p in payments) {
      paymentsByOrder[p.orderId] =
          (paymentsByOrder[p.orderId] ?? 0) + p.amount;
    }

    final ttcByUser = <String, double>{};
    final countByUser = <String, int>{};

    for (final o in orders) {
      final amount = paymentsByOrder[o.id] ?? 0;
      ttcByUser[o.waiterId] =
          roundMoney((ttcByUser[o.waiterId] ?? 0) + amount);
      countByUser[o.waiterId] = (countByUser[o.waiterId] ?? 0) + 1;
    }

    double grandTTC = 0;

    final lines = ttcByUser.entries.map<UserSalesReportLine>((e) {
      final userId = e.key;
      final ttc = e.value;
      final count = countByUser[userId] ?? 1;
      grandTTC += ttc;
      return UserSalesReportLine(
        userId: userId,
        userName: userMap[userId] ?? userId,
        ticketCount: count,
        totalTTC: ttc,
        averageBasket: roundMoney(ttc / count),
      );
    }).toList()
      ..sort((a, b) => b.totalTTC.compareTo(a.totalTTC));

    return (
      header: _buildHeader(
        'Ventes par Serveur',
        filters,
        totalTTC: roundMoney(grandTTC),
        totalHT: 0,
        totalTax: 0,
        ticketCount: orders.length,
      ),
      lines: lines,
    );
  }

  @override
  Future<ReportingFilterOptions> loadReportingFilterOptions({
    DateTime? sessionPeriodStart,
    DateTime? sessionPeriodEnd,
  }) async {
    final users = await (_db.select(_db.users)
          ..where((u) => u.isActive.equals(true))
          ..orderBy([(u) => OrderingTerm.asc(u.name)]))
        .get();

    final categories = await (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();

    final sessionQuery = _db.select(_db.cashSessions)
      ..orderBy([(s) => OrderingTerm.desc(s.openedAt)]);

    if (sessionPeriodStart != null && sessionPeriodEnd != null) {
      final endInclusive = sessionPeriodEnd.add(const Duration(days: 1));
      sessionQuery.where(
        (s) =>
            s.openedAt.isBiggerOrEqualValue(sessionPeriodStart) &
            s.openedAt.isSmallerThanValue(endInclusive),
      );
    }

    final sessions = await sessionQuery.get();
    final cashierIds = sessions.map((s) => s.cashierId).toSet().toList();
    final cashiers = cashierIds.isEmpty
        ? <User>[]
        : await (_db.select(_db.users)
              ..where((u) => u.id.isIn(cashierIds)))
            .get();
    final cashierNames = {for (final u in cashiers) u.id: u.name};

    final sessionFmt = DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');
    return ReportingFilterOptions(
      users: users
          .map((u) => ReportFilterUser(id: u.id, name: u.name))
          .toList(),
      categories: categories
          .map((c) => ReportFilterCategory(id: c.id, name: c.name))
          .toList(),
      sessions: sessions
          .map(
            (s) => ReportFilterSession(
              id: s.id,
              openedAt: s.openedAt,
              closedAt: s.closedAt,
              label:
                  '${sessionFmt.format(s.openedAt)} — ${cashierNames[s.cashierId] ?? s.cashierId}${s.status == 'OPEN' ? ' (ouverte)' : ''}',
            ),
          )
          .toList(),
    );
  }
}

