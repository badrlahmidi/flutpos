import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test/test.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('fr_FR');
  });

  group('AccountingCsvBuilder', () {
    test('génère sections TVA et modes de règlement', () {
      final report = MonthlyAccountingReport(
        restaurantName: 'Chez Ritaj',
        periodStart: DateTime(2026, 6, 1),
        periodEnd: DateTime(2026, 6, 30),
        taxByRate: const [
          TaxRateSummary(taxRate: 20, taxableBase: 1000, taxAmount: 200),
          TaxRateSummary(taxRate: 10, taxableBase: 500, taxAmount: 50),
        ],
        salesByPaymentMethod: const {
          'CASH': 800,
          'TPE': 650,
        },
        totalRevenue: 1450,
        paidOrdersCount: 12,
        closedSessions: const [],
      );

      final csv = AccountingCsvBuilder.build(report);

      expect(csv, contains('Chez Ritaj'));
      expect(csv, contains('Taux TVA'));
      expect(csv, contains('Espèces'));
      expect(csv, contains('TPE'));
      expect(csv, contains('800,00'));
    });
  });

  group('AccountingExportRepository', () {
    late AppDatabase db;
    late AccountingExportRepository export;
    late OrderRepository orders;
    late String userId;
    late String sessionId;

    setUp(() async {
      db = AppDatabase(NativeDatabase.memory());
      orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
      export = AccountingExportRepositoryImpl(
        db,
        orders,
        CashSessionRepositoryImpl(db, AuditRepositoryImpl(db)),
      );
      userId = 'cashier-1';
      sessionId = 'sess-1';

      final now = DateTime(2026, 6, 15, 12);

      await db.into(db.restaurantConfig).insert(
            RestaurantConfigCompanion.insert(
              id: const Value('cfg'),
              name: 'Test Resto',
              updatedAt: now,
            ),
          );

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
              id: const Value('prod'),
              categoryId: 'cat',
              name: 'Tajine',
              priceDineIn: 100,
              taxRate: const Value(10),
            ),
          );

      await db.into(db.cashSessions).insert(
            CashSessionsCompanion.insert(
              id: Value(sessionId),
              cashierId: userId,
              openedAt: now,
              openingBalance: 100,
              status: const Value('OPEN'),
            ),
          );

      final orderId = 'order-1';
      await db.into(db.orders).insert(
            OrdersCompanion.insert(
              id: Value(orderId),
              sessionId: sessionId,
              waiterId: userId,
              orderType: OrderType.dineIn.dbValue,
              status: const Value('PAID'),
              createdAt: now,
            ),
          );

      await db.into(db.orderItems).insert(
            OrderItemsCompanion.insert(
              id: const Value('line-1'),
              orderId: orderId,
              productId: 'prod',
              quantity: 2,
              unitPrice: 100,
              taxRate: 10,
              courseNumber: const Value(1),
              createdAt: now,
            ),
          );

      await db.into(db.payments).insert(
            PaymentsCompanion.insert(
              orderId: orderId,
              paymentMethod: 'CASH',
              amount: 220,
              paidAt: DateTime(2026, 6, 10, 18),
            ),
          );
    });

    tearDown(() async {
      await db.close();
    });

    test('agrège TVA 10% et espèces sur le mois', () async {
      final report = await export.loadMonthlyReport(DateTime(2026, 6, 5));

      expect(report.restaurantName, 'Test Resto');
      expect(report.totalRevenue, 220);
      expect(report.paidOrdersCount, 1);
      expect(report.salesByPaymentMethod['CASH'], 220);

      final tax10 = report.taxByRate.firstWhere((t) => t.taxRate == 10);
      expect(tax10.taxableBase, 200);
      expect(tax10.taxAmount, 20);
    });
  });
}
