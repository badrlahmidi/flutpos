import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/kds/kds_bloc.dart';
import '../../blocs/kds/kds_event.dart';
import '../../blocs/kds/kds_state.dart';
import '../../di/service_locator.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/loading_skeleton.dart';
import '../../widgets/organisms/top_bar.dart';

/// Écran cuisine (KDS) — tickets en attente + bouton Prêt.
class KdsPage extends StatelessWidget {
  const KdsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => KdsBloc(kdsRepository: sl<KdsRepository>())
        ..add(const KdsStarted()),
      child: const _KdsView(),
    );
  }
}

class _KdsView extends StatelessWidget {
  const _KdsView();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : scheme.surfaceContainerLowest,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(
            title: 'Cuisine — KDS',
            icon: Icons.soup_kitchen_outlined,
            onHome: () => context.go('/menu'),
            actions: [
              IconButton(
                tooltip: 'Actualiser',
                onPressed: () =>
                    context.read<KdsBloc>().add(const KdsRefreshRequested()),
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Expanded(
            child: BlocConsumer<KdsBloc, KdsState>(
              listenWhen: (prev, curr) =>
                  curr is KdsReady &&
                  curr.lastReadyProductName != null &&
                  (prev is! KdsReady ||
                      prev.lastReadyProductName != curr.lastReadyProductName),
              listener: (context, state) {
                if (state is KdsReady && state.lastReadyProductName != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: isDark
                          ? AppColors.accentGreen
                          : const Color(0xFF16A34A),
                      content: Row(
                        children: [
                          const Icon(Icons.check_circle, color: Colors.white, size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${state.lastReadyProductName} — PRÊT ✓',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                }
              },
              builder: (context, state) {
                return switch (state) {
                  KdsInitial() || KdsLoading() => const Padding(
                      padding: EdgeInsets.all(AppSpacing.m),
                      child: LoadingSkeletonGrid(
                        crossAxisCount: 2,
                        itemCount: 4,
                        aspectRatio: 1.2,
                      ),
                    ),
                  KdsError(:final message) => Center(
                      child: Text(message, style: TextStyle(color: scheme.error)),
                    ),
                  KdsReady(:final tickets) => tickets.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: (isDark
                                          ? AppColors.accentGreen
                                          : const Color(0xFF16A34A))
                                      .withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.check_circle_outline,
                                  size: 56,
                                  color: isDark
                                      ? AppColors.accentGreen
                                      : const Color(0xFF16A34A),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.m),
                              Text(
                                'Aucun plat en attente',
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'La cuisine est à jour — bon service !',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        )
                      : _KdsColumns(tickets: tickets, isDark: isDark),
                };
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// KDS column layout with urgency-aware ticket cards.
class _KdsColumns extends StatelessWidget {
  const _KdsColumns({required this.tickets, required this.isDark});
  final List<KdsOrderTicket> tickets;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth > 1400
            ? 4
            : constraints.maxWidth > 1000
                ? 3
                : 2;
        return ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(AppSpacing.m),
          children: [
            for (int col = 0; col < columnCount; col++)
              SizedBox(
                width: (constraints.maxWidth - AppSpacing.m * 2) / columnCount -
                    AppSpacing.m * (columnCount - 1) / columnCount,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: (tickets.length / columnCount).ceil(),
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.m),
                  itemBuilder: (context, row) {
                    final index = row * columnCount + col;
                    if (index >= tickets.length) return const SizedBox.shrink();
                    return _KdsTicketCard(
                      ticket: tickets[index],
                      isDark: isDark,
                    )
                        .animate(
                          delay: Duration(milliseconds: index * 40),
                        )
                        .fadeIn(duration: 250.ms)
                        .slideY(begin: 0.05, end: 0);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _KdsTicketCard extends StatelessWidget {
  const _KdsTicketCard({required this.ticket, this.isDark = false});

  final KdsOrderTicket ticket;
  final bool isDark;

  Color _urgencyColor(int elapsedMinutes) {
    if (elapsedMinutes < 5) return AppColors.accentGreen;
    if (elapsedMinutes <= 15) return AppColors.accentOrange;
    return AppColors.accentRed;
  }

  Color _urgencyColorLight(int elapsedMinutes) {
    if (elapsedMinutes < 5) return const Color(0xFF16A34A);
    if (elapsedMinutes <= 15) return const Color(0xFFEA580C);
    return const Color(0xFFDC2626);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final elapsed = DateTime.now()
        .toUtc()
        .difference(ticket.oldestItemAt)
        .inMinutes;
    final urgency = isDark ? _urgencyColor(elapsed) : _urgencyColorLight(elapsed);

    return Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.l),
        side: BorderSide(color: scheme.outline),
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSpacing.l),
          border: Border(left: BorderSide(color: urgency, width: 5)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      ticket.headerLabel ??
                          'Commande ${ticket.order.id.substring(0, 8)}',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: urgency.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '$elapsed min',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: urgency,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  )
                      .animate(onPlay: (c) => c.repeat(reverse: true))
                      .shimmer(
                        duration: 2000.ms,
                        color: urgency.withValues(alpha: 0.3),
                      ),
                ],
              ),
              Text(
                '${ticket.pendingItems.length} en cours'
                '${ticket.heldItems.isNotEmpty ? ' · ${ticket.heldItems.length} à suivre' : ''}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const Divider(height: AppSpacing.m),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final line in ticket.heldItems) ...[
                        _KdsHeldLine(line: line),
                        const SizedBox(height: AppSpacing.s),
                      ],
                      for (final line in ticket.pendingItems) ...[
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_formatQty(line.orderItem.quantity)} × ${line.product.name}',
                                    style: theme.textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (line.modifierSummary.isNotEmpty)
                                    Text(
                                      line.modifierSummary,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  if (line.orderItem.customNotes != null &&
                                      line.orderItem.customNotes!.isNotEmpty)
                                    Text(
                                      line.orderItem.customNotes!,
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: scheme.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            FilledButton.icon(
                              onPressed: () {
                                context.read<KdsBloc>().add(
                                      KdsItemReadyPressed(
                                        orderItemId: line.orderItem.id,
                                        orderId: ticket.order.id,
                                        productName: line.product.name,
                                      ),
                                    );
                              },
                              icon: const Icon(Icons.check_circle),
                              label: const Text('PRÊT'),
                              style: FilledButton.styleFrom(
                                backgroundColor: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
                                foregroundColor: Colors.white,
                                minimumSize: const Size(100, 48),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.s),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatQty(double quantity) {
    return quantity == quantity.roundToDouble()
        ? '${quantity.toInt()}'
        : quantity.toStringAsFixed(1);
  }
}

class _KdsHeldLine extends StatelessWidget {
  const _KdsHeldLine({required this.line});

  final OrderItemWithProduct line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final muted = scheme.onSurface.withValues(alpha: 0.45);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_KdsTicketCard._formatQty(line.orderItem.quantity)} × ${line.product.name}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: muted,
                ),
              ),
              Text(
                'À suivre · ${CourseHelpers.badgeLabel(line.orderItem.courseNumber)}',
                style: theme.textTheme.labelMedium?.copyWith(color: muted),
              ),
              if (line.orderItem.customNotes != null &&
                  line.orderItem.customNotes!.isNotEmpty)
                Text(
                  line.orderItem.customNotes!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: muted,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
