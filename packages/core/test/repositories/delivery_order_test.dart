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
    userId = 'user-1';
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('createDeliveryOrder sans table avec source GLOVO', () async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createDeliveryOrder(
      sessionId: session.id,
      waiterId: userId,
      source: OrderSource.glovo,
      externalRef: '1455',
    );

    expect(order.tableId, null);
    expect(order.orderType, OrderType.delivery.dbValue);
    expect(order.source, OrderSource.glovo.dbValue);
    expect(order.externalRef, '1455');

    final banner = DeliveryTicketHeader.kitchenBannerLine(order);
    expect(banner, contains('GLOVO'));
    expect(banner, contains('1455'));
    expect(banner, contains('***'));
  });

  test('listOpenDeliveryOrders retourne les tickets ouverts', () async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    await orders.createDeliveryOrder(
      sessionId: session.id,
      waiterId: userId,
      source: OrderSource.deliveroo,
      externalRef: '99',
    );

    final list = await orders.listOpenDeliveryOrders(session.id);
    expect(list.length, 1);
    expect(list.first.source, OrderSource.deliveroo.dbValue);
  });
}
