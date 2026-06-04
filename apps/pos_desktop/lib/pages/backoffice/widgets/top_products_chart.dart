import 'package:core/core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Top 5 produits (barres horizontales).
class TopProductsChart extends StatelessWidget {
  const TopProductsChart({
    super.key,
    required this.products,
  });

  final List<TopProductSale> products;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (products.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Top 5 produits', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Aucune vente enregistrée aujourd\'hui.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final maxQty = products
        .map((p) => p.quantitySold)
        .reduce((a, b) => a > b ? a : b);

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Top 5 produits', style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.m),
            SizedBox(
              height: 240,
              child: BarChart(
                BarChartData(
                  maxY: maxQty * 1.2,
                  barTouchData: BarTouchData(
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final product = products[group.x.toInt()];
                        return BarTooltipItem(
                          '${product.productName}\n'
                          '${product.quantitySold.toStringAsFixed(0)} vendus\n'
                          '${PriceFormatter.format(product.revenue)}',
                          theme.textTheme.bodySmall!,
                        );
                      },
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (_) => FlLine(
                      color: scheme.outlineVariant,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 112,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < 0 || index >= products.length) {
                            return const SizedBox.shrink();
                          }
                          final name = products[index].productName;
                          final label = name.length > 12
                              ? '${name.substring(0, 12)}…'
                              : name;
                          return Text(
                            label,
                            style: theme.textTheme.labelSmall,
                            textAlign: TextAlign.end,
                          );
                        },
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: [
                    for (var i = 0; i < products.length; i++)
                      BarChartGroupData(
                        x: i,
                        barRods: [
                          BarChartRodData(
                            toY: products[i].quantitySold,
                            color: scheme.secondary,
                            width: 16,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
