import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/daily_analytics_snapshot.dart';
import '../enums/order_type.dart';
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
}
