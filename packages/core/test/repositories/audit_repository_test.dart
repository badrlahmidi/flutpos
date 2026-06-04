import 'package:core/core.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late AuditRepository audit;
  late String userId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    audit = AuditRepositoryImpl(db);
    userId = '00000000-0000-4000-8000-000000000099';

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: Value(userId),
            name: 'Test Caissier',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  group('AuditRepository', () {
    test('logActionTyped enregistre VOID_ITEM', () async {
      final entry = await audit.logActionTyped(
        userId: userId,
        action: AuditAction.voidItem,
        targetType: AuditTargetType.orderItem,
        targetId: 'item-1',
        details: {
          'orderId': 'order-1',
          'reason': 'Erreur saisie',
          'amount': 45.0,
        },
      );

      expect(entry.action, 'VOID_ITEM');
      expect(entry.targetType, 'ORDER_ITEM');
      expect(entry.details, isNotNull);
    });

    test('rejette une action inconnue', () async {
      expect(
        () => audit.logAction(
          userId: userId,
          action: 'INVALID',
          targetType: 'ORDER',
          targetId: 'x',
        ),
        throwsArgumentError,
      );
    });

    test('CashSessionRepository logue PAY_IN avant mouvement', () async {
      final sessions = CashSessionRepositoryImpl(db, audit);
      final session = await sessions.openSession(
        userId: userId,
        openingBalance: 500,
      );

      await sessions.payIn(
        userId: userId,
        sessionId: session.id,
        amount: 100,
        reason: 'Fond monnaie',
      );

      final logs = await audit.getEntriesForTarget(
        targetType: AuditTargetType.cashSession.dbValue,
        targetId: session.id,
      );

      expect(logs.any((e) => e.action == 'PAY_IN'), isTrue);

      final movements = await db.select(db.cashMovements).get();
      expect(movements, hasLength(1));
      expect(movements.first.amount, 100);
    });

    test('OrderRepository logue APPLY_DISCOUNT avant mise à jour', () async {
      final orders = OrderRepositoryImpl(db, audit);
      final session = await orders.ensureOpenSession(cashierId: userId);
      final order = await orders.createOrder(
        sessionId: session.id,
        waiterId: userId,
        orderType: OrderType.dineIn,
      );

      await orders.applyDiscount(
        userId: userId,
        orderId: order.id,
        discountType: DiscountType.percentage,
        discountValue: 10,
        reason: 'Client fidèle',
        authorizedByUserId: userId,
      );

      final updated =
          await (db.select(db.orders)..where((o) => o.id.equals(order.id)))
              .getSingle();

      expect(updated.discountType, 'PERCENTAGE');
      expect(updated.discountValue, 10);

      final logs = await audit.getEntriesForTarget(
        targetType: AuditTargetType.order.dbValue,
        targetId: order.id,
      );
      expect(logs.first.action, 'APPLY_DISCOUNT');
    });
  });
}
