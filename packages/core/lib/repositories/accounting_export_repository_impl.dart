import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/monthly_accounting_report.dart';
import '../enums/payment_method.dart';
import '../usecases/money_math.dart';
import '../usecases/tax_breakdown.dart';
import '../utils/payment_order_mapper.dart';
import 'accounting_export_repository.dart';
import 'cash_session_repository.dart';
import 'order_repository.dart';

class AccountingExportRepositoryImpl implements AccountingExportRepository {
  AccountingExportRepositoryImpl(
    this._db,
    this._orders,
    this._sessions,
  );

  final AppDatabase _db;
  final OrderRepository _orders;
  final CashSessionRepository _sessions;

  static const _standardVatRates = [20.0, 10.0, 7.0];

  @override
  Future<MonthlyAccountingReport> loadMonthlyReport(DateTime month) async {
    final periodStart = DateTime(month.year, month.month, 1);
    final periodEnd = DateTime(month.year, month.month + 1, 1);

    final config = await (_db.select(_db.restaurantConfig)).getSingleOrNull();
    final restaurantName = config?.name ?? 'Ritagestion';

    final payments = await (_db.select(_db.payments)
          ..where(
            (p) =>
                p.paidAt.isBiggerOrEqualValue(periodStart) &
                p.paidAt.isSmallerThanValue(periodEnd),
          ))
        .get();

    if (payments.isEmpty) {
      return MonthlyAccountingReport(
        restaurantName: restaurantName,
        periodStart: periodStart,
        periodEnd: periodEnd.subtract(const Duration(days: 1)),
        taxByRate: _emptyTaxRows(),
        salesByPaymentMethod: {},
        totalRevenue: 0,
        paidOrdersCount: 0,
        closedSessions: const [],
      );
    }

    final orderIds = payments.map((p) => p.orderId).toSet().toList();
    final orders = await (_db.select(_db.orders)
          ..where((o) => o.id.isIn(orderIds)))
        .get();
    final paidOrderIds = orders
        .where((o) => o.status == 'PAID')
        .map((o) => o.id)
        .toSet();

    final salesByMethod = <String, double>{};
    var totalRevenue = 0.0;

    for (final payment in payments) {
      if (!paidOrderIds.contains(payment.orderId)) {
        continue;
      }
      totalRevenue += payment.amount;
      salesByMethod[payment.paymentMethod] =
          (salesByMethod[payment.paymentMethod] ?? 0) + payment.amount;
    }

    totalRevenue = roundMoney(totalRevenue);
    for (final key in salesByMethod.keys.toList()) {
      salesByMethod[key] = roundMoney(salesByMethod[key]!);
    }

    final taxByRate = await _aggregateTax(paidOrderIds.toList());

    final closedSessions = await _loadClosedSessions(periodStart, periodEnd);

    return MonthlyAccountingReport(
      restaurantName: restaurantName,
      periodStart: periodStart,
      periodEnd: periodEnd.subtract(const Duration(days: 1)),
      taxByRate: taxByRate,
      salesByPaymentMethod: salesByMethod,
      totalRevenue: totalRevenue,
      paidOrdersCount: paidOrderIds.length,
      closedSessions: closedSessions,
    );
  }

  List<TaxRateSummary> _emptyTaxRows() {
    return [
      for (final rate in _standardVatRates)
        TaxRateSummary(taxRate: rate, taxableBase: 0, taxAmount: 0),
    ];
  }

  Future<List<TaxRateSummary>> _aggregateTax(List<String> paidOrderIds) async {
    final acc = <double, ({double base, double tax})>{};
    for (final rate in _standardVatRates) {
      acc[rate] = (base: 0, tax: 0);
    }

    for (final orderId in paidOrderIds) {
      final complete = await _orders.getCompleteOrder(orderId);
      if (complete == null) {
        continue;
      }
      final summaries = TaxBreakdown.fromLines(
        PaymentOrderMapper.toLineInputs(complete),
      );
      for (final row in summaries) {
        final bucket = acc.putIfAbsent(
          row.taxRate,
          () => (base: 0, tax: 0),
        );
        acc[row.taxRate] = (
          base: bucket.base + row.taxableBase,
          tax: bucket.tax + row.taxAmount,
        );
      }
    }

    final rates = {..._standardVatRates, ...acc.keys}.toList()
      ..sort((a, b) => b.compareTo(a));

    return [
      for (final rate in rates)
        TaxRateSummary(
          taxRate: rate,
          taxableBase: roundMoney(acc[rate]?.base ?? 0),
          taxAmount: roundMoney(acc[rate]?.tax ?? 0),
        ),
    ];
  }

  Future<List<MonthlySessionSummary>> _loadClosedSessions(
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await (_db.select(_db.cashSessions)
          ..where(
            (s) =>
                s.status.equals('CLOSED') &
                s.closedAt.isBiggerOrEqualValue(start) &
                s.closedAt.isSmallerThanValue(end),
          )
          ..orderBy([(s) => OrderingTerm.asc(s.closedAt)]))
        .get();

    final summaries = <MonthlySessionSummary>[];
    for (final session in sessions) {
      if (session.closedAt == null) {
        continue;
      }
      final report = await _sessions.buildSessionReport(session.id);
      summaries.add(
        MonthlySessionSummary(
          sessionId: session.id,
          openedAt: session.openedAt,
          closedAt: session.closedAt!,
          cashierName: report.cashierName,
          totalSales: report.totalSales,
          paidOrdersCount: report.paidOrdersCount,
        ),
      );
    }
    return summaries;
  }
}

/// Libellé comptable d'un mode de paiement.
String accountingPaymentMethodLabel(String dbValue) {
  return PaymentMethod.fromDb(dbValue)?.label ?? dbValue;
}
