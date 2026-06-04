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
    userId = '00000000-0000-4000-8000-000000000099';
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Admin',
            pinHash: 'hash',
            role: 'ADMIN',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('setEnterpriseInvoice et numéro séquentiel', () async {
    final session = await orders.ensureOpenSession(cashierId: userId);
    final order = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );

    await orders.setEnterpriseInvoice(
      orderId: order.id,
      companyName: 'SARL Test',
      companyIce: '001234567000089',
    );

    final issued = await orders.issueInvoiceNumberIfNeeded(order.id);
    expect(issued.invoiceNumber, 1);
    expect(issued.companyName, 'SARL Test');
    expect(issued.companyIce, '001234567000089');

    final order2 = await orders.createOrder(
      sessionId: session.id,
      waiterId: userId,
      orderType: OrderType.dineIn,
    );
    await orders.setEnterpriseInvoice(
      orderId: order2.id,
      companyName: 'Autre Co',
      companyIce: '001234567000099',
    );
    final issued2 = await orders.issueInvoiceNumberIfNeeded(order2.id);
    expect(issued2.invoiceNumber, 2);
  });

  test('MoroccanIce valide 15 chiffres', () {
    expect(MoroccanIce.isValid('001234567000089'), isTrue);
    expect(MoroccanIce.isValid('123'), isFalse);
  });
}
