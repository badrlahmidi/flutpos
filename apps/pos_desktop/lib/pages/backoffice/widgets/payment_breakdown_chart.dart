import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Diagramme circulaire (Pie Chart) pour les modes de paiement.
class PaymentBreakdownChart extends StatelessWidget {
  const PaymentBreakdownChart({
    super.key,
    required this.breakdown,
  });

  final List<PaymentMethodBreakdown> breakdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (breakdown.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Encaissements', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Aucun encaissement aujourd\'hui.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final colors = [
      scheme.primary,
      scheme.secondary,
      scheme.tertiary,
      scheme.error,
      scheme.primaryContainer,
      scheme.secondaryContainer,
      scheme.tertiaryContainer,
    ];

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Encaissements', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.m),
            SizedBox(
              height: 220,
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: PieChart(
                      PieChartData(
                        sectionsSpace: 2,
                        centerSpaceRadius: 40,
                        sections: [
                          for (var i = 0; i < breakdown.length; i++)
                            PieChartSectionData(
                              color: colors[i % colors.length],
                              value: breakdown[i].amount,
                              title: '${(breakdown[i].amount / breakdown.fold(0.0, (sum, item) => sum + item.amount) * 100).toStringAsFixed(0)}%',
                              radius: 50,
                              titleStyle: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: breakdown.length,
                      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xs),
                      itemBuilder: (context, index) {
                        final b = breakdown[index];
                        return Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: colors[index % colors.length],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Expanded(
                              child: Text(
                                b.label,
                                style: theme.textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Text(
                              PriceFormatter.format(b.amount),
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
