import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Panneau Food Cost — coût matière vs CA produits avec recette.
class FoodCostPanel extends StatelessWidget {
  const FoodCostPanel({
    super.key,
    required this.salesRevenue,
    required this.theoreticalCost,
    required this.gap,
    required this.ratioPercent,
  });

  final double salesRevenue;
  final double theoreticalCost;
  final double gap;
  final double ratioPercent;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasData = salesRevenue > 0;

    return Card(
      elevation: 0,
      color: scheme.surfaceContainerHighest,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant_menu, color: scheme.primary),
                const SizedBox(width: AppSpacing.s),
                Text('Food Cost (recettes)', style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            if (!hasData)
              Text(
                'Aucune vente avec recette enregistrée aujourd\'hui.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              )
            else ...[
              _MetricRow(
                label: 'CA produits avec recette',
                value: PriceFormatter.format(salesRevenue),
              ),
              const SizedBox(height: AppSpacing.s),
              _MetricRow(
                label: 'Coût matière théorique',
                value: PriceFormatter.format(theoreticalCost),
              ),
              const SizedBox(height: AppSpacing.s),
              _MetricRow(
                label: 'Marge brute matière',
                value: PriceFormatter.format(gap),
                emphasize: true,
              ),
              const SizedBox(height: AppSpacing.m),
              ClipRRect(
                borderRadius: BorderRadius.circular(AppSpacing.s),
                child: LinearProgressIndicator(
                  value: (ratioPercent / 100).clamp(0.0, 1.0),
                  minHeight: AppSpacing.m,
                  backgroundColor: scheme.surfaceContainerHigh,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Food cost : ${ratioPercent.toStringAsFixed(1)} % du CA recettes',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(label, style: theme.textTheme.bodyMedium),
        ),
        Text(
          value,
          style: emphasize
              ? theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                )
              : theme.textTheme.titleMedium,
        ),
      ],
    );
  }
}
