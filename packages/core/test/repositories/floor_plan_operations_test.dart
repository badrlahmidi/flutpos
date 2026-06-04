import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late FloorPlanRepository floorPlan;
  late String userId;
  late String tableS1;
  late String tableS2;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    floorPlan = FloorPlanRepositoryImpl(
      db,
      orders,
      ReservationRepositoryImpl(db, orders),
    );
    userId = '00000000-0000-4000-8000-000000000099';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Serveur',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
    await db.into(db.zones).insert(
          ZonesCompanion.insert(
            id: const Value('zone-1'),
            name: 'Salle',
          ),
        );
    tableS1 = 'table-s1';
    tableS2 = 'table-s2';
    await db.batch((batch) {
      batch.insertAll(db.restaurantTables, [
        RestaurantTablesCompanion.insert(
          id: Value(tableS1),
          zoneId: 'zone-1',
          name: 'S1',
          capacity: 4,
        ),
        RestaurantTablesCompanion.insert(
          id: Value(tableS2),
          zoneId: 'zone-1',
          name: 'S2',
          capacity: 4,
        ),
      ]);
    });
  });

  tearDown(() async {
    await db.close();
  });

  Future<String> _openSession() async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    return session.id;
  }

  test('openTableOrder occupe la table et apparaît sur le plan', () async {
    final sessionId = await _openSession();
    final order = await orders.openTableOrder(
      sessionId: sessionId,
      waiterId: userId,
      tableId: tableS1,
      guestCount: 3,
    );

    expect(order.tableId, tableS1);
    expect(order.guestCount, 3);

    final tableRow = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableS1)))
        .getSingle();
    expect(tableRow.status, 'OCCUPIED');

    final plan = await floorPlan.loadFloorPlan();
    final snapshot = plan.first.tables.firstWhere((t) => t.table.id == tableS1);
    expect(snapshot.tileStatus, FloorPlanTileStatus.occupied);
    expect(snapshot.activeOrder?.id, order.id);
  });

  test('transferTableOrder libère la source et occupe la cible', () async {
    final sessionId = await _openSession();
    final order = await orders.openTableOrder(
      sessionId: sessionId,
      waiterId: userId,
      tableId: tableS1,
    );

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Boissons'),
        );
    const productId = 'prod-the';
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

    await orders.addOrderItem(
      orderId: order.id,
      product: product,
      orderType: OrderType.dineIn,
    );

    await orders.transferTableOrder(
      orderId: order.id,
      targetTableId: tableS2,
    );

    final t1 = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableS1)))
        .getSingle();
    final t2 = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableS2)))
        .getSingle();
    expect(t1.status, 'FREE');
    expect(t2.status, 'OCCUPIED');

    final moved = await orders.getOpenOrderForTable(tableS2);
    expect(moved?.id, order.id);
    expect(await orders.getOpenOrderForTable(tableS1), null);
  });

  test('mergeTableOrders regroupe les lignes et libère la table source', () async {
    final sessionId = await _openSession();
    final target = await orders.openTableOrder(
      sessionId: sessionId,
      waiterId: userId,
      tableId: tableS1,
    );
    final source = await orders.openTableOrder(
      sessionId: sessionId,
      waiterId: userId,
      tableId: tableS2,
    );

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Plats'),
        );
    const productId = 'prod-couscous';
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(productId),
            categoryId: 'cat',
            name: 'Couscous',
            priceDineIn: 90,
          ),
        );
    final product = await (db.select(db.products)
          ..where((p) => p.id.equals(productId)))
        .getSingle();

    await orders.addOrderItem(
      orderId: source.id,
      product: product,
      orderType: OrderType.dineIn,
    );

    await orders.mergeTableOrders(
      targetOrderId: target.id,
      sourceOrderId: source.id,
    );

    final complete = await orders.getCompleteOrder(target.id);
    expect(complete?.items.length, 1);

    final sourceRow = await (db.select(db.orders)
          ..where((o) => o.id.equals(source.id)))
        .getSingle();
    expect(sourceRow.status, 'CANCELLED');

    final table2 = await (db.select(db.restaurantTables)
          ..where((t) => t.id.equals(tableS2)))
        .getSingle();
    expect(table2.status, 'FREE');
  });

  test('splitOrderItemToSubOrder crée un sous-ticket', () async {
    final sessionId = await _openSession();
    final main = await orders.openTableOrder(
      sessionId: sessionId,
      waiterId: userId,
      tableId: tableS1,
    );

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(id: const Value('cat'), name: 'Boissons'),
        );
    const cocaId = 'prod-coca';
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(cocaId),
            categoryId: 'cat',
            name: 'Coca',
            priceDineIn: 18,
          ),
        );
    final coca = await (db.select(db.products)
          ..where((p) => p.id.equals(cocaId)))
        .getSingle();

    final line = await orders.addOrderItem(
      orderId: main.id,
      product: coca,
      orderType: OrderType.dineIn,
      quantity: 2,
    );

    final split = await orders.splitOrderItemToSubOrder(
      sourceOrderId: main.id,
      orderItemId: line.id,
      quantityToMove: 1,
    );

    expect(split.subOrder.tableId, null);
    expect(split.movedItem.orderId, split.subOrder.id);
    expect(split.movedItem.quantity, 1);

    final mainComplete = await orders.getCompleteOrder(main.id);
    expect(mainComplete?.items.first.orderItem.quantity, 1);
  });
}
