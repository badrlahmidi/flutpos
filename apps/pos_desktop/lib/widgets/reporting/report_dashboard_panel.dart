import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';
import '../../pages/backoffice/widgets/dashboard_kpi_card.dart';
import '../../pages/backoffice/widgets/food_cost_panel.dart';
import '../../pages/backoffice/widgets/hourly_sales_chart.dart';
import '../../pages/backoffice/widgets/top_products_chart.dart';

/// Panneau dashboard KPI + graphiques intégré dans un onglet de rapport.
class ReportDashboardPanel extends StatelessWidget {
  const ReportDashboardPanel({
    super.key,
    required this.snapshot,
    this.onRefresh,
  });

  final DailyAnalyticsSnapshot snapshot;
  final VoidCallback? onRefresh;

  static final DateFormat _dayLabel = DateFormat('EEEE d MMMM yyyy', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = snapshot;

    return RefreshIndicator(
      onRefresh: () async => onRefresh?.call(),
      child: ListView(
        padding: const EdgeInsets.all(AppSpacing.l),
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  _dayLabel.format(s.day),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (onRefresh != null)
                IconButton(
                  tooltip: 'Actualiser',
                  onPressed: onRefresh,
                  icon: const Icon(Icons.refresh),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          LayoutBuilder(
            builder: (context, constraints) {
              final crossCount = constraints.maxWidth > 900 ? 4 : 2;
              return GridView.count(
                crossAxisCount: crossCount,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: AppSpacing.m,
                crossAxisSpacing: AppSpacing.m,
                childAspectRatio: 1.6,
                children: [
                  DashboardKpiCard(
                    title: 'CA total',
                    value: PriceFormatter.format(s.totalRevenue),
                    subtitle: 'Journée sélectionnée',
                    icon: Icons.payments_outlined,
                  ),
                  DashboardKpiCard(
                    title: 'Sur place',
                    value: PriceFormatter.format(s.revenueDineIn),
                    subtitle: 'Dine-in + emporter',
                    icon: Icons.restaurant,
                  ),
                  DashboardKpiCard(
                    title: 'Livraison',
                    value: PriceFormatter.format(s.revenueDelivery),
                    subtitle: 'Delivery & plateformes',
                    icon: Icons.delivery_dining,
                  ),
                  DashboardKpiCard(
                    title: 'Tickets / panier',
                    value: '${s.ticketCount}',
                    subtitle:
                        'Panier moy. ${PriceFormatter.format(s.averageBasket)}',
                    icon: Icons.receipt_long,
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 900) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: HourlySalesChart(points: s.salesByHour)),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(child: TopProductsChart(products: s.topProducts)),
                  ],
                );
              }
              return Column(
                children: [
                  HourlySalesChart(points: s.salesByHour),
                  const SizedBox(height: AppSpacing.m),
                  TopProductsChart(products: s.topProducts),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),
          FoodCostPanel(
            salesRevenue: s.foodCostSalesRevenue,
            theoreticalCost: s.foodCostTheoretical,
            gap: s.foodCostGap,
            ratioPercent: s.foodCostRatioPercent,
          ),
        ],
      ),
    );
  }
}
