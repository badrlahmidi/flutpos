import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late AnalyticsRepository analytics;
  late String userId;
  late String sessionId;
  late String productId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    analytics = AnalyticsRepositoryImpl(db);
    userId = 'user-1';
    productId = 'prod-steak';
    sessionId = 'sess-1';

    final now = DateTime(2026, 6, 4, 14, 30);

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat-1'), name: 'Plats'),
        );

    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: Value(productId),
            categoryId: 'cat-1',
            name: 'Steak',
            priceDineIn: 100,
          ),
        );

    await db.into(db.ingredients).insert(
          IngredientsCompanion.insert(
            id: const Value('ing-1'),
            name: 'Bœuf',
            unit: 'kg',
            costPerUnit: 80,
            updatedAt: now,
          ),
        );

    await db.into(db.recipeItems).insert(
          RecipeItemsCompanion.insert(
            productId: productId,
            ingredientId: 'ing-1',
            quantityUsed: 0.2,
          ),
        );

    await db.into(db.cashSessions).insert(
          CashSessionsCompanion.insert(
            id: Value(sessionId),
            cashierId: userId,
            openedAt: now,
            openingBalance: 500,
            status: const Value('OPEN'),
          ),
        );

    final dineOrder = 'order-dine';
    final deliveryOrder = 'order-delivery';

    await db.batch((batch) {
      batch.insertAll(db.orders, [
        OrdersCompanion.insert(
          id: Value(dineOrder),
          sessionId: sessionId,
          waiterId: userId,
          orderType: OrderType.dineIn.dbValue,
          status: const Value('PAID'),
          createdAt: now,
        ),
        OrdersCompanion.insert(
          id: Value(deliveryOrder),
          sessionId: sessionId,
          waiterId: userId,
          orderType: OrderType.delivery.dbValue,
          status: const Value('PAID'),
          createdAt: now,
        ),
      ]);
    });

    await db.batch((batch) {
      batch.insertAll(db.orderItems, [
        OrderItemsCompanion.insert(
          id: const Value('line-1'),
          orderId: dineOrder,
          productId: productId,
          quantity: 2,
          unitPrice: 100,
          taxRate: 20,
          courseNumber: const Value(1),
          createdAt: now,
        ),
        OrderItemsCompanion.insert(
          id: const Value('line-2'),
          orderId: deliveryOrder,
          productId: productId,
          quantity: 1,
          unitPrice: 100,
          taxRate: 20,
          courseNumber: const Value(1),
          createdAt: now,
        ),
      ]);
    });

    await db.batch((batch) {
      batch.insertAll(db.payments, [
        PaymentsCompanion.insert(
          orderId: dineOrder,
          paymentMethod: 'CASH',
          amount: 200,
          paidAt: DateTime(2026, 6, 4, 12, 15),
        ),
        PaymentsCompanion.insert(
          orderId: deliveryOrder,
          paymentMethod: 'TPE',
          amount: 100,
          paidAt: DateTime(2026, 6, 4, 19, 45),
        ),
      ]);
    });
  });

  tearDown(() async {
    await db.close();
  });

  test('agrège CA sur place vs livraison et tickets', () async {
    final snapshot = await analytics.loadDailyDashboard(
      day: DateTime(2026, 6, 4),
    );

    expect(snapshot.revenueDineIn, 200);
    expect(snapshot.revenueDelivery, 100);
    expect(snapshot.totalRevenue, 300);
    expect(snapshot.ticketCount, 2);
    expect(snapshot.averageBasket, 150);
  });

  test('top produits et food cost', () async {
    final snapshot = await analytics.loadDailyDashboard(
      day: DateTime(2026, 6, 4),
    );

    expect(snapshot.topProducts.length, 1);
    expect(snapshot.topProducts.first.productName, 'Steak');
    expect(snapshot.topProducts.first.quantitySold, 3);

    expect(snapshot.foodCostSalesRevenue, 300);
    expect(snapshot.foodCostTheoretical, 48);
    expect(snapshot.foodCostGap, 252);
  });

  test('ventes par heure', () async {
    final snapshot = await analytics.loadDailyDashboard(
      day: DateTime(2026, 6, 4),
    );

    expect(snapshot.salesByHour[12].amount, 200);
    expect(snapshot.salesByHour[19].amount, 100);
  });
}
