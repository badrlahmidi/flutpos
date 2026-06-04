import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late CashSessionRepository sessions;
  late OrderRepository orders;
  late String userId;
  late Product product;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    final audit = AuditRepositoryImpl(db);
    sessions = CashSessionRepositoryImpl(db, audit);
    orders = OrderRepositoryImpl(db, audit);
    userId = '00000000-0000-4000-8000-000000000099';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Test Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );

    final catId = 'cat-1';
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: Value(catId),
            name: 'Test',
            sortOrder: const Value(0),
          ),
        );

    final productId = 'prod-1';
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: Value(productId),
            categoryId: catId,
            name: 'Café',
            priceDineIn: 120,
            taxRate: const Value(20),
          ),
        );
    product = await (db.select(db.products)..where((p) => p.id.equals(productId)))
        .getSingle();
  });

  tearDown(() async {
    await db.close();
  });

  test('buildSessionReport calcule espèces théoriques', () async {
    final session = await sessions.openSession(
      userId: userId,
      openingBalance: 500,
    );
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );

    await orders.addOrderItem(
      orderId: order.id,
      product: product,
      orderType: OrderType.dineIn,
    );

    final complete = (await orders.getCompleteOrder(order.id))!;
    final due = complete.computedTotals.grandTotal;

    await orders.addPayment(
      orderId: order.id,
      method: PaymentMethod.cash,
      amount: due,
    );
    await orders.finalizeOrderIfFullyPaid(order.id);

    await sessions.payIn(
      userId: userId,
      sessionId: session.id,
      amount: 50,
      reason: 'Monnaie',
    );
    await sessions.payOut(
      userId: userId,
      sessionId: session.id,
      amount: 30,
      reason: 'Pain',
    );

    final report = await sessions.buildSessionReport(session.id);

    expect(report.openingBalance, 500);
    expect(report.cashSales, due);
    expect(report.payInTotal, 50);
    expect(report.payOutTotal, 30);
    expect(report.expectedCashBalance, roundMoney(500 + due + 50 - 30));
    expect(report.paidOrdersCount, 1);
  });
}
