import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../entities/monthly_accounting_report.dart';
import '../repositories/accounting_export_repository_impl.dart';
import '../usecases/money_math.dart';

/// Génère le CSV export comptable (séparateur `;` pour Excel FR).
abstract final class AccountingCsvBuilder {
  AccountingCsvBuilder._();

  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final NumberFormat _amount = NumberFormat('#,##0.00', 'fr_FR');

  static String build(MonthlyAccountingReport report) {
    final rows = <List<dynamic>>[
      ['Ritagestion — Export comptable'],
      ['Restaurant', report.restaurantName],
      [
        'Période',
        '${_date.format(report.periodStart)} — ${_date.format(report.periodEnd)}',
      ],
      [],
      ['=== CHIFFRE D\'AFFAIRES PAR TAUX DE TVA ==='],
      ['Taux TVA (%)', 'Base HT (MAD)', 'Montant TVA (MAD)', 'Total TTC (MAD)'],
    ];

    for (final row in report.taxByRate) {
      if (row.taxableBase == 0 && row.taxAmount == 0) {
        continue;
      }
      final ttc = roundMoney(row.taxableBase + row.taxAmount);
      rows.add([
        _formatRate(row.taxRate),
        _amount.format(row.taxableBase),
        _amount.format(row.taxAmount),
        _amount.format(ttc),
      ]);
    }

    rows.addAll([
      [],
      ['=== CHIFFRE D\'AFFAIRES PAR MODE DE RÈGLEMENT ==='],
      ['Mode de règlement', 'Montant TTC (MAD)'],
    ]);

    final methodOrder = ['CASH', 'CARD', 'TPE', 'CHEQUE', 'VOUCHER', 'EMPLOYEE_MEAL'];
    final emitted = <String>{};
    for (final method in methodOrder) {
      final amount = report.salesByPaymentMethod[method];
      if (amount == null || amount == 0) {
        continue;
      }
      emitted.add(method);
      rows.add([
        accountingPaymentMethodLabel(method),
        _amount.format(amount),
      ]);
    }
    for (final entry in report.salesByPaymentMethod.entries) {
      if (emitted.contains(entry.key) || entry.value == 0) {
        continue;
      }
      rows.add([
        accountingPaymentMethodLabel(entry.key),
        _amount.format(entry.value),
      ]);
    }

    rows.addAll([
      [],
      ['=== SYNTHÈSE ==='],
      ['Nombre de tickets payés', report.paidOrdersCount],
      ['CA total encaissé TTC (MAD)', _amount.format(report.totalRevenue)],
      ['Sessions clôturées (Z)', report.closedSessions.length],
      [],
      ['=== SESSIONS DE CAISSE CLÔTURÉES ==='],
      [
        'Session',
        'Ouverture',
        'Clôture Z',
        'Caissier',
        'Tickets payés',
        'CA session TTC (MAD)',
      ],
    ]);

    for (final session in report.closedSessions) {
      rows.add([
        session.sessionId.substring(0, 8),
        _date.format(session.openedAt.toLocal()),
        _date.format(session.closedAt.toLocal()),
        session.cashierName,
        session.paidOrdersCount,
        _amount.format(session.totalSales),
      ]);
    }

    return Csv(fieldDelimiter: ';').encode(rows);
  }

  static String _formatRate(double rate) {
    if (rate == rate.roundToDouble()) {
      return rate.toInt().toString();
    }
    return rate.toString();
  }
}
