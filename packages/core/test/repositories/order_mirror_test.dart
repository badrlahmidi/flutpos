import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late String userId;
  late Product product;
  late String tableId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    userId = 'user-mirror';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Serveur',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
    await db.into(db.zones).insert(
          ZonesCompanion.insert(id: const Value('zone-1'), name: 'Salle'),
        );
    final table = await db.into(db.restaurantTables).insertReturning(
          RestaurantTablesCompanion.insert(
            zoneId: 'zone-1',
            name: 'T1',
            capacity: 4,
          ),
        );
    tableId = table.id;

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value('prod-1'),
            categoryId: 'cat',
            name: 'Couscous',
            priceDineIn: 95,
            nameAr: const Value('كسكس'),
          ),
        );
    product = await (db.select(db.products)
          ..where((p) => p.id.equals('prod-1')))
        .getSingle();
  });

  tearDown(() async {
    await db.close();
  });

  test('mirrorOrderSnapshot réplique orderId et itemIds du PC', () async {
    final localSession = await orders.ensureOpenSession(cashierId: userId);

    // Simule la BDD PC (source)
    final pcSession = await orders.ensureOpenSession(cashierId: 'pc-cashier');
    final pcOrder = await orders.openTableOrder(
      sessionId: pcSession.id,
      waiterId: userId,
      tableId: tableId,
      orderId: 'order-pc-001',
    );
    await orders.addOrderItem(
      orderId: pcOrder.id,
      product: product,
      orderType: OrderType.dineIn,
      courseNumber: 1,
      orderItemId: 'item-pc-001',
    );
    final pcComplete = await orders.getCompleteOrder(pcOrder.id);
    expect(pcComplete, isA<CompleteOrder>());

    // Mobile : base vide côté commande (nouvelle instance simulée)
    final mobileDb = AppDatabase(NativeDatabase.memory());
    addTearDown(mobileDb.close);
    final mobileOrders = OrderRepositoryImpl(mobileDb, AuditRepositoryImpl(mobileDb));
    await mobileDb.into(mobileDb.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Serveur',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
    await mobileDb.into(mobileDb.zones).insert(
          ZonesCompanion.insert(id: const Value('zone-1'), name: 'Salle'),
        );
    await mobileDb.into(mobileDb.restaurantTables).insert(
          RestaurantTablesCompanion.insert(
            id: Value(tableId),
            zoneId: 'zone-1',
            name: 'T1',
            capacity: 4,
          ),
        );
    await mobileDb.into(mobileDb.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
    await mobileDb.into(mobileDb.products).insert(
          ProductsCompanion.insert(
            id: const Value('prod-1'),
            categoryId: 'cat',
            name: 'Couscous',
            priceDineIn: 95,
          ),
        );
    final mobileSession =
        await mobileOrders.ensureOpenSession(cashierId: userId);

    final snapshot = {
      'order': {
        'id': pcComplete!.order.id,
        'waiterId': pcComplete.order.waiterId,
        'tableId': pcComplete.order.tableId,
        'orderType': pcComplete.order.orderType,
        'status': pcComplete.order.status,
        'guestCount': pcComplete.order.guestCount,
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
    final mirrored = await mobileOrders.mirrorOrderSnapshot(
      localSessionId: mobileSession.id,
      snapshot: snapshot,
    );

    expect(mirrored, isA<CompleteOrder>());
    expect(mirrored!.order.id, 'order-pc-001');
    expect(mirrored.items.single.orderItem.id, 'item-pc-001');
    expect(mirrored.order.sessionId, mobileSession.id);
    expect(mirrored.order.sessionId, isNot(pcSession.id));

    final table = await (mobileDb.select(mobileDb.restaurantTables)
          ..where((t) => t.id.equals(tableId)))
        .getSingle();
    expect(table.status, 'OCCUPIED');

    await mobileOrders.clearLocalOpenOrderForTable(tableId);
    expect(await mobileOrders.getOpenOrderForTable(tableId), null);

    expect(localSession.id, isNotEmpty);
  });
}
