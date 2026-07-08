import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Classement des performances serveurs.
class WaiterPerformancePanel extends StatelessWidget {
  const WaiterPerformancePanel({
    super.key,
    required this.performances,
  });

  final List<WaiterPerformance> performances;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (performances.isEmpty) {
      return Card(
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Performances Staff', style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Aucune vente attribuée au staff aujourd\'hui.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.people_outline, color: scheme.primary),
                const SizedBox(width: AppSpacing.s),
                Text('Performances Staff', style: theme.textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.onSurfaceVariant,
                ),
                dataTextStyle: theme.textTheme.bodyMedium,
                columnSpacing: 24,
                columns: const [
                  DataColumn(label: Text('Serveur')),
                  DataColumn(label: Text('CA Généré'), numeric: true),
                  DataColumn(label: Text('Tickets'), numeric: true),
                  DataColumn(label: Text('Panier Moy.'), numeric: true),
                ],
                rows: performances.map((p) {
                  return DataRow(
                    cells: [
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 12,
                              backgroundColor: scheme.primaryContainer,
                              child: Text(
                                p.userName.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  color: scheme.onPrimaryContainer,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Text(p.userName, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      DataCell(Text(PriceFormatter.format(p.totalRevenue))),
                      DataCell(Text('${p.ticketCount}')),
                      DataCell(Text(PriceFormatter.format(p.averageBasket))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
