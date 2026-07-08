import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../blocs/analytics_dashboard/analytics_dashboard_bloc.dart';
import '../../../blocs/analytics_dashboard/analytics_dashboard_event.dart';
import '../../../blocs/analytics_dashboard/analytics_dashboard_state.dart';
import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../../widgets/atoms/loading_skeleton.dart';
import '../widgets/dashboard_kpi_card.dart';
import '../widgets/food_cost_panel.dart';
import '../widgets/hourly_sales_chart.dart';
import '../widgets/top_products_chart.dart';
import '../widgets/payment_breakdown_chart.dart';
import '../widgets/category_breakdown_chart.dart';
import '../widgets/waiter_performance_panel.dart';

/// Tableau de bord analytique — KPI, graphiques, food cost.
class AnalyticsDashboardPage extends StatelessWidget {
  const AnalyticsDashboardPage({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  static final DateFormat _dayLabel = DateFormat('EEEE d MMMM yyyy', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AnalyticsDashboardBloc(
        analyticsRepository: sl<AnalyticsRepository>(),
      )..add(const AnalyticsDashboardStarted()),
      child: _AnalyticsDashboardView(embeddedInShell: embeddedInShell),
    );
  }
}

class _AnalyticsDashboardView extends StatelessWidget {
  const _AnalyticsDashboardView({required this.embeddedInShell});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: embeddedInShell
          ? null
          : AppBar(
              title: const Text('Dashboard analytique'),
              actions: [
                IconButton(
                  tooltip: 'Choisir une date',
                  onPressed: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: context.read<AnalyticsDashboardBloc>().state is AnalyticsDashboardReady 
                          ? (context.read<AnalyticsDashboardBloc>().state as AnalyticsDashboardReady).snapshot.day
                          : DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null && context.mounted) {
                      context
                          .read<AnalyticsDashboardBloc>()
                          .add(AnalyticsDashboardDateChanged(date));
                    }
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
                IconButton(
                  tooltip: 'Export comptable CSV',
                  onPressed: () => context.go('/backoffice/accounting'),
                  icon: const Icon(Icons.file_download_outlined),
                ),
                IconButton(
                  tooltip: 'Actualiser',
                  onPressed: () => context
                      .read<AnalyticsDashboardBloc>()
                      .add(const AnalyticsDashboardRefreshRequested()),
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
      body: BlocBuilder<AnalyticsDashboardBloc, AnalyticsDashboardState>(
        builder: (context, state) {
          if (state is AnalyticsDashboardLoading ||
              state is AnalyticsDashboardInitial) {
            return const Padding(
              padding: EdgeInsets.all(AppSpacing.l),
              child: LoadingSkeletonList(itemCount: 6, itemHeight: 96),
            );
          }

          if (state is AnalyticsDashboardError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: scheme.error),
                    const SizedBox(height: AppSpacing.m),
                    Text(state.message, textAlign: TextAlign.center),
                    const SizedBox(height: AppSpacing.m),
                    FilledButton.icon(
                      onPressed: () => context
                          .read<AnalyticsDashboardBloc>()
                          .add(const AnalyticsDashboardRefreshRequested()),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Réessayer'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is! AnalyticsDashboardReady) {
            return const SizedBox.shrink();
          }

          final s = state.snapshot;
          final dayLabel = AnalyticsDashboardPage._dayLabel.format(s.day);

          return RefreshIndicator(
            onRefresh: () async {
              context
                  .read<AnalyticsDashboardBloc>()
                  .add(const AnalyticsDashboardRefreshRequested());
              await context.read<AnalyticsDashboardBloc>().stream.firstWhere(
                    (st) =>
                        st is AnalyticsDashboardReady ||
                        st is AnalyticsDashboardError,
                  );
            },
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                if (embeddedInShell)
                  BackofficePageHeader(
                    title: 'Dashboard analytique',
                    subtitle: dayLabel,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: s.day,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (date != null && context.mounted) {
                              context
                                  .read<AnalyticsDashboardBloc>()
                                  .add(AnalyticsDashboardDateChanged(date));
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 18),
                          label: const Text('Changer de date'),
                        ),
                        const SizedBox(width: AppSpacing.s),
                        IconButton(
                          tooltip: 'Actualiser',
                          onPressed: () => context
                              .read<AnalyticsDashboardBloc>()
                              .add(const AnalyticsDashboardRefreshRequested()),
                          icon: const Icon(Icons.refresh),
                        ),
                      ],
                    ),
                  )
                else
                  Text(dayLabel, style: theme.textTheme.titleMedium),
                if (embeddedInShell)
                  const SizedBox(height: AppSpacing.l)
                else
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
                          subtitle: 'Journée en cours',
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
                      return Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: HourlySalesChart(points: s.salesByHour)),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(child: TopProductsChart(products: s.topProducts)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.m),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: PaymentBreakdownChart(breakdown: s.paymentBreakdown)),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(child: CategoryBreakdownChart(breakdown: s.categoryBreakdown)),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.m),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: WaiterPerformancePanel(performances: s.waiterPerformance)),
                              const SizedBox(width: AppSpacing.m),
                              Expanded(
                                child: FoodCostPanel(
                                  salesRevenue: s.foodCostSalesRevenue,
                                  theoreticalCost: s.foodCostTheoretical,
                                  gap: s.foodCostGap,
                                  ratioPercent: s.foodCostRatioPercent,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    }
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        HourlySalesChart(points: s.salesByHour),
                        const SizedBox(height: AppSpacing.m),
                        TopProductsChart(products: s.topProducts),
                        const SizedBox(height: AppSpacing.m),
                        PaymentBreakdownChart(breakdown: s.paymentBreakdown),
                        const SizedBox(height: AppSpacing.m),
                        CategoryBreakdownChart(breakdown: s.categoryBreakdown),
                        const SizedBox(height: AppSpacing.m),
                        WaiterPerformancePanel(performances: s.waiterPerformance),
                        const SizedBox(height: AppSpacing.m),
                        FoodCostPanel(
                          salesRevenue: s.foodCostSalesRevenue,
                          theoreticalCost: s.foodCostTheoretical,
                          gap: s.foodCostGap,
                          ratioPercent: s.foodCostRatioPercent,
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
