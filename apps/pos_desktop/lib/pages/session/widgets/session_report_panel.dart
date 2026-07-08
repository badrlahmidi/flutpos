import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Affichage brouillard X / données clôture Z.
class SessionReportPanel extends StatelessWidget {
  const SessionReportPanel({
    super.key,
    required this.report,
    this.title = 'Brouillard de caisse (X)',
  });

  final CashSessionReport report;
  final String title;

  static final DateFormat _dateTime =
      DateFormat('dd/MM/yyyy HH:mm', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final session = report.session;
    final isClosed = session.status == 'CLOSED';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.s),
            _row(theme, 'Caissier', report.cashierName),
            _row(
              theme,
              'Ouverte',
              _dateTime.format(session.openedAt.toLocal()),
            ),
            _row(
              theme,
              'Statut',
              session.status == 'OPEN' ? 'Ouverte' : 'Clôturée',
            ),
            const Divider(height: AppSpacing.l),
            _row(
              theme,
              'Fond de caisse',
              PriceFormatter.format(report.openingBalance),
            ),
            _row(
              theme,
              'Ventes espèces',
              isClosed ? PriceFormatter.format(report.cashSales) : '***',
            ),
            _row(
              theme,
              'Ventes carte/TPE',
              isClosed ? PriceFormatter.format(report.cardSales) : '***',
            ),
            _row(
              theme,
              'Autres paiements',
              isClosed ? PriceFormatter.format(report.otherSales) : '***',
            ),
            _row(
              theme,
              'Total encaissé',
              isClosed ? PriceFormatter.format(report.totalSales) : '***',
              bold: true,
            ),
            const Divider(height: AppSpacing.m),
            _row(
              theme,
              'Entrées (Pay-in)',
              PriceFormatter.format(report.payInTotal),
            ),
            _row(
              theme,
              'Sorties (Pay-out)',
              PriceFormatter.format(report.payOutTotal),
            ),
            const Divider(height: AppSpacing.m),
            _row(
              theme,
              'Espèces théoriques tiroir',
              isClosed ? PriceFormatter.format(report.expectedCashBalance) : '*** (Clôture à l\'aveugle)',
              bold: true,
              highlight: true,
            ),
            const SizedBox(height: AppSpacing.s),
            _row(
              theme,
              'Tickets payés',
              '${report.paidOrdersCount}',
            ),
            _row(
              theme,
              'Tickets en cours',
              '${report.openOrdersCount}',
            ),
            if (report.salesByMethod.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              Text('Par mode de paiement', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.s),
              for (final entry in report.salesByMethod.entries)
                _row(
                  theme,
                  PaymentMethod.fromDb(entry.key)?.label ?? entry.key,
                  isClosed ? PriceFormatter.format(entry.value) : '***',
                ),
            ],
            if (report.movements.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              Text('Mouvements caisse', style: theme.textTheme.titleSmall),
              const SizedBox(height: AppSpacing.s),
              ...report.movements.take(8).map(
                (m) => Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: Text(
                    '${m.type == 'PAY_IN' ? '+' : '-'} '
                    '${PriceFormatter.format(m.amount)} — ${m.reason}',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
    bool highlight = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : null,
              color: highlight ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}
