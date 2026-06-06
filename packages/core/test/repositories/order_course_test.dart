import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late String userId;
  late Product entree;
  late Product plat;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    userId = 'user-course';

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

    const entreeId = 'prod-entree';
    const platId = 'prod-plat';
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(entreeId),
            categoryId: 'cat',
            name: 'Salade',
            priceDineIn: 45,
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(platId),
            categoryId: 'cat',
            name: 'Entrecôte',
            priceDineIn: 180,
          ),
        );

    entree = await (db.select(db.products)
          ..where((p) => p.id.equals(entreeId)))
        .getSingle();
    plat = await (db.select(db.products)
          ..where((p) => p.id.equals(platId)))
        .getSingle();
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> _openOrder() async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );
    return order.id;
  }

  test('addOrderItem enregistre courseNumber et isFired false par défaut', () async {
    final orderId = await _openOrder();
    final item = await orders.addOrderItem(
      orderId: orderId,
      product: plat,
      orderType: OrderType.dineIn,
      courseNumber: 2,
    );

    expect(item.courseNumber, 2);
    expect(item.isFired, isFalse);
  });

  test('updateOrderItemCourse change la course si non fired', () async {
    final orderId = await _openOrder();
    final item = await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
      courseNumber: 1,
    );

    final updated = await orders.updateOrderItemCourse(
      orderItemId: item.id,
      courseNumber: 3,
    );

    expect(updated.courseNumber, 3);
  });

  test('updateOrderItemCourse refuse si article déjà fired', () async {
    final orderId = await _openOrder();
    final item = await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
    );
    await orders.markOrderItemsFired([item.id]);

    expect(
      () => orders.updateOrderItemCourse(
        orderItemId: item.id,
        courseNumber: 2,
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('fireCourse n\'envoie que les lignes de la course demandée', () async {
    final orderId = await _openOrder();
    final salade = await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
      courseNumber: 1,
    );
    final steak = await orders.addOrderItem(
      orderId: orderId,
      product: plat,
      orderType: OrderType.dineIn,
      courseNumber: 2,
    );

    final result = await orders.fireCourse(orderId: orderId, courseNumber: 1);

    expect(result.courseNumber, 1);
    expect(result.firedItems.map((i) => i.id), [salade.id]);

    final steakAfter = await (db.select(db.orderItems)
          ..where((i) => i.id.equals(steak.id)))
        .getSingle();
    expect(steakAfter.isFired, isFalse);
  });

  test('fireNextPendingCourse envoie la course minimale en attente', () async {
    final orderId = await _openOrder();
    await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
      courseNumber: 1,
    );
    await orders.addOrderItem(
      orderId: orderId,
      product: plat,
      orderType: OrderType.dineIn,
      courseNumber: 2,
    );

    await orders.fireCourse(orderId: orderId, courseNumber: 1);

    final result = await orders.fireNextPendingCourse(orderId);

    expect(result, isA<FireCourseResult>());
    expect(result!.courseNumber, 2);
    expect(result.firedItems.single.productId, plat.id);
    expect(result.firedItems.single.isFired, isTrue);
  });

  test('listPendingCourseNumbers liste les courses non fired', () async {
    final orderId = await _openOrder();
    await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
      courseNumber: 1,
    );
    await orders.addOrderItem(
      orderId: orderId,
      product: plat,
      orderType: OrderType.dineIn,
      courseNumber: 2,
    );
    await orders.fireCourse(orderId: orderId, courseNumber: 1);

    final pending = await orders.listPendingCourseNumbers(orderId);

    expect(pending, [2]);
  });

  test('fireCourse sur course vide lève une erreur', () async {
    final orderId = await _openOrder();
    await orders.addOrderItem(
      orderId: orderId,
      product: entree,
      orderType: OrderType.dineIn,
      courseNumber: 1,
    );

    expect(
      () => orders.fireCourse(orderId: orderId, courseNumber: 99),
      throwsA(isA<StateError>()),
    );
  });
}
