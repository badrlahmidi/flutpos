import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late String userId;
  late Product product;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    userId = 'user-notes';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value('prod-1'),
            categoryId: 'cat',
            name: 'Tajine',
            priceDineIn: 80,
          ),
        );
    product = await (db.select(db.products)
          ..where((p) => p.id.equals('prod-1')))
        .getSingle();
  });

  tearDown(() async {
    await db.close();
  });

  test('updateOrderNotes persiste et normalise les chaînes vides', () async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );

    final withNote = await orders.updateOrderNotes(
      orderId: order.id,
      notes: '  Sans oignons  ',
    );
    expect(withNote.notes, 'Sans oignons');

    final cleared = await orders.updateOrderNotes(
      orderId: order.id,
      notes: '   ',
    );
    expect(cleared.notes, null);

    final reloaded = await orders.getCompleteOrder(order.id);
    expect(reloaded?.order.notes, null);
  });

  test('mirrorOrderSnapshot réplique la note de commande', () async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
      orderId: 'order-notes-001',
    );
    await orders.updateOrderNotes(
      orderId: order.id,
      notes: 'Anniversaire table 5',
    );
    await orders.addOrderItem(
      orderId: order.id,
      product: product,
      orderType: OrderType.dineIn,
      orderItemId: 'item-001',
    );

    final pcComplete = await orders.getCompleteOrder(order.id);
    expect(pcComplete, isA<CompleteOrder>());

    final snapshot = {
      'order': {
        'id': pcComplete!.order.id,
        'waiterId': pcComplete.order.waiterId,
        'tableId': pcComplete.order.tableId,
        'orderType': pcComplete.order.orderType,
        'status': pcComplete.order.status,
        'guestCount': pcComplete.order.guestCount,
        'notes': pcComplete.order.notes,
        'createdAt': pcComplete.order.createdAt.toUtc().toIso8601String(),
      },
      'items': [
        for (final line in pcComplete.items)
          {
            'id': line.orderItem.id,
            'productId': line.orderItem.productId,
            'quantity': line.orderItem.quantity,
            'unitPrice': line.orderItem.unitPrice,
            'taxRate': line.orderItem.taxRate,
            'courseNumber': line.orderItem.courseNumber,
            'isFired': line.orderItem.isFired,
            'status': line.orderItem.status,
            'customNotes': line.orderItem.customNotes,
            'createdAt': line.orderItem.createdAt.toUtc().toIso8601String(),
          },
      ],
    };

    final mobileDb = AppDatabase(NativeDatabase.memory());
    addTearDown(mobileDb.close);
    final mobileOrders = OrderRepositoryImpl(mobileDb, AuditRepositoryImpl(mobileDb));
    await mobileDb.into(mobileDb.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );
    await mobileDb.into(mobileDb.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
    await mobileDb.into(mobileDb.products).insert(
          ProductsCompanion.insert(
            id: const Value('prod-1'),
            categoryId: 'cat',
            name: 'Tajine',
            priceDineIn: 80,
          ),
        );
    final mobileSession = await mobileOrders.ensureOpenSession(cashierId: userId);

    final mirrored = await mobileOrders.mirrorOrderSnapshot(
      localSessionId: mobileSession.id,
      snapshot: snapshot,
    );

    expect(mirrored?.order.notes, 'Anniversaire table 5');
  });
}
