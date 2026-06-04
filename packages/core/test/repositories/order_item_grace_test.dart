import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late String userId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    userId = 'user-grace';
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Serveur',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
  });

  tearDown(() async {
    await db.close();
  });

  Future<({String orderId, String itemId})> _line({bool fired = false}) async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );
    const productId = 'prod-grace';
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(productId),
            categoryId: 'cat',
            name: 'Thé',
            priceDineIn: 15,
          ),
        );
    final product = await (db.select(db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingle();
    final item = await orders.addOrderItem(
      orderId: order.id,
      product: product,
      orderType: OrderType.dineIn,
    );
    if (fired) {
      await orders.markOrderItemsFired([item.id]);
    }
    return (orderId: order.id, itemId: item.id);
  }

  test('removeOrderItem grâce si < 30s et non fired', () async {
    final ids = await _line();
    final item = await (db.select(db.orderItems)
          ..where((i) => i.id.equals(ids.itemId)))
        .getSingle();

    expect(OrderItemGrace.isEligible(item), isTrue);

    final graceful = await orders.removeOrderItem(ids.itemId);
    expect(graceful, isTrue);

    final audits = await db.select(db.auditTrail).get();
    expect(audits, isEmpty);
  });

  test('removeOrderItem refuse si article fired', () async {
    final ids = await _line(fired: true);

    expect(
      () => orders.removeOrderItem(ids.itemId),
      throwsA(isA<OrderItemVoidRequired>()),
    );
  });

  test('OrderItemGrace.isEligible false après 30s', () async {
    final ids = await _line();
    final past = DateTime.now().toUtc().subtract(const Duration(seconds: 31));
    await (db.update(db.orderItems)..where((i) => i.id.equals(ids.itemId)))
        .write(OrderItemsCompanion(createdAt: Value(past)));

    final item = await (db.select(db.orderItems)
          ..where((i) => i.id.equals(ids.itemId)))
        .getSingle();
    expect(OrderItemGrace.isEligible(item), isFalse);
  });
}
