import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/floor_plan/floor_plan_bloc.dart';
import '../../blocs/floor_plan/floor_plan_event.dart';
import '../../blocs/floor_plan/floor_plan_state.dart';
import '../../di/service_locator.dart';
import '../../navigation/app_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/molecules/service_mode_toggle.dart';
import '../../widgets/organisms/top_bar.dart';
import 'widgets/floor_plan_table_tile.dart';
import 'widgets/guest_count_dialog.dart';
import 'widgets/table_operations_sheet.dart';
import '../../utils/security_guard.dart';

/// Plan de salle interactif par zone.
class FloorPlanPage extends StatelessWidget {
  const FloorPlanPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FloorPlanBloc(
        floorPlanRepository: sl<FloorPlanRepository>(),
        orderRepository: sl<OrderRepository>(),
        cashSessionRepository: sl<CashSessionRepository>(),
        reservationRepository: sl<ReservationRepository>(),
      )..add(FloorPlanStarted(user)),
      child: _FloorPlanView(user: user),
    );
  }
}

class _FloorPlanView extends StatelessWidget {
  const _FloorPlanView({required this.user});

  final User user;

  Future<void> _navigateToPos(
    BuildContext context, {
    required String orderId,
    required String tableName,
  }) async {
    context.read<FloorPlanBloc>().add(const FloorPlanNavigationHandled());
    await context.push<void>(
      '/pos?orderId=$orderId&tableLabel=${Uri.encodeComponent(tableName)}',
    );
    if (context.mounted) {
      context.read<FloorPlanBloc>().add(const FloorPlanRefreshRequested());
    }
  }

  Future<void> _onTableTap(
    BuildContext context,
    FloorPlanTableSnapshot snapshot,
  ) async {
    final bloc = context.read<FloorPlanBloc>();

    final order = snapshot.activeOrder;
    if (order == null) {
      final guests = await showGuestCountDialog(
        context,
        tableName: snapshot.table.name,
        capacity: snapshot.table.capacity,
        defaultGuests: snapshot.upcomingReservation?.guestCount,
      );
      if (guests == null || !context.mounted) {
        return;
      }
      bloc.add(
        FloorPlanOpenTableRequested(
          tableId: snapshot.table.id,
          guestCount: guests,
        ),
      );
      return;
    }

    bloc.add(
      FloorPlanResumeTableRequested(
        orderId: order.id,
        tableName: snapshot.table.name,
      ),
    );
  }

  Future<void> _onTableLongPress(
    BuildContext context,
    FloorPlanTableSnapshot snapshot,
    List<FloorPlanTableSnapshot> allTables,
  ) async {
    if (snapshot.activeOrder == null) {
      return;
    }

    final choice = await showTableOperationsSheet(
      context,
      snapshot: snapshot,
      allTables: allTables,
    );
    if (choice == null || !context.mounted) {
      return;
    }

    final bloc = context.read<FloorPlanBloc>();
    final orderId = snapshot.activeOrder!.id;

    switch (choice.kind) {
      case TableOperationKind.transfer:
        if (choice.targetTableId != null) {
          bloc.add(
            FloorPlanTransferRequested(
              orderId: orderId,
              targetTableId: choice.targetTableId!,
            ),
          );
        }
      case TableOperationKind.merge:
        final sourceOrderId = allTables
            .where((t) => t.table.id == choice.targetTableId)
            .firstOrNull
            ?.activeOrder
            ?.id;
        if (sourceOrderId != null) {
          bloc.add(
            FloorPlanMergeRequested(
              targetOrderId: orderId,
              sourceOrderId: sourceOrderId,
            ),
          );
        }
      case TableOperationKind.splitBill:
        final refreshed = await context.push<bool>(
          '/split-bill?orderId=$orderId&tableName=${Uri.encodeComponent(snapshot.table.name)}',
        );
        if (refreshed == true && context.mounted) {
          bloc.add(const FloorPlanRefreshRequested());
        }
      case TableOperationKind.liberate:
        final authorized = await SecurityGuard.authorize(
          context,
          SecurityOperations.voidOrder,
          currentUser: user,
        );
        if (authorized == null || !context.mounted) {
          return;
        }

        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Libérer la table ${snapshot.table.name} ?'),
            content: const Text(
              'Cela annulera et supprimera définitivement le ticket en cours sur cette table.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Non, garder'),
              ),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Oui, libérer'),
              ),
            ],
          ),
        );
        if (confirm == true && context.mounted) {
          await sl<OrderRepository>().clearLocalOpenOrderForTable(snapshot.table.id);
          if (context.mounted) {
            bloc.add(const FloorPlanRefreshRequested());
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Table ${snapshot.table.name} libérée avec succès'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return BlocConsumer<FloorPlanBloc, FloorPlanState>(
      listenWhen: (prev, curr) {
        if (curr is FloorPlanReady && curr.navigateToPos != null) {
          return true;
        }
        return curr is FloorPlanError && prev is! FloorPlanError;
      },
      listener: (context, state) {
        if (state is FloorPlanReady && state.navigateToPos != null) {
          final nav = state.navigateToPos!;
          _navigateToPos(
            context,
            orderId: nav.orderId,
            tableName: nav.tableName,
          );
        }
        if (state is FloorPlanError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: scheme.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TopBar(
                title: 'Plan de salle',
                icon: Icons.table_restaurant_outlined,
                onHome: () => context.go('/menu'),
                actions: [
                  ServiceModeToggle(
                    onModeChanged: (mode) {
                      if (mode == ServiceMode.quickService && context.mounted) {
                        context.go('/pos');
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Écran cuisine (KDS)',
                    icon: const Icon(Icons.soup_kitchen_outlined),
                    onPressed: () => context.go('/kds'),
                  ),
                  IconButton(
                    tooltip: 'Suivi des tables (Monitor)',
                    icon: const Icon(Icons.monitor_heart_outlined),
                    onPressed: () => context.go('/floor/monitor'),
                  ),
                  IconButton(
                    tooltip: 'Réservations',
                    icon: const Icon(Icons.event_seat_outlined),
                    onPressed: () async {
                      await context.push<void>('/backoffice/reservations');
                      if (context.mounted) {
                        context
                            .read<FloorPlanBloc>()
                            .add(const FloorPlanRefreshRequested());
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Comptoir (sans table)',
                    icon: const Icon(Icons.fastfood_outlined),
                    onPressed: () async {
                      await context.push<void>('/pos');
                      if (context.mounted) {
                        context
                            .read<FloorPlanBloc>()
                            .add(const FloorPlanRefreshRequested());
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Trésorerie',
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    onPressed: () async {
                      await context.push<bool>('/treasury');
                      if (context.mounted) {
                        context
                            .read<FloorPlanBloc>()
                            .add(const FloorPlanRefreshRequested());
                      }
                    },
                  ),
                  IconButton(
                    tooltip: 'Verrouiller',
                    icon: const Icon(Icons.lock_outline),
                    onPressed: () {
                      AppSession.instance.clear();
                      context.go('/');
                    },
                  ),
                ],
              ),
              Expanded(
                child: switch (state) {
                  FloorPlanLoading() || FloorPlanInitial() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  FloorPlanError(:final message) => Center(
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacing.l),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.error_outline,
                                color: scheme.error, size: 48),
                            const SizedBox(height: AppSpacing.m),
                            Text(message, textAlign: TextAlign.center),
                            const SizedBox(height: AppSpacing.m),
                            FilledButton(
                              onPressed: () => context
                                  .read<FloorPlanBloc>()
                                  .add(FloorPlanStarted(user)),
                              child: const Text('Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  FloorPlanReady(:final zones, :final selectedZoneIndex) =>
                    _FloorPlanBody(
                      zones: zones,
                      selectedZoneIndex: selectedZoneIndex,
                      onZoneSelected: (i) => context
                          .read<FloorPlanBloc>()
                          .add(FloorPlanZoneSelected(i)),
                      onTableTap: (s) => _onTableTap(context, s),
                      onTableLongPress: (s, all) =>
                          _onTableLongPress(context, s, all),
                    ),
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _FloorPlanBody extends StatelessWidget {
  const _FloorPlanBody({
    required this.zones,
    required this.selectedZoneIndex,
    required this.onZoneSelected,
    required this.onTableTap,
    required this.onTableLongPress,
  });

  final List<FloorPlanZoneSnapshot> zones;
  final int selectedZoneIndex;
  final ValueChanged<int> onZoneSelected;
  final ValueChanged<FloorPlanTableSnapshot> onTableTap;
  final void Function(
    FloorPlanTableSnapshot snapshot,
    List<FloorPlanTableSnapshot> allTables,
  ) onTableLongPress;

  @override
  Widget build(BuildContext context) {
    final zone = zones[selectedZoneIndex.clamp(0, zones.length - 1)];
    final allTables = zones.expand((z) => z.tables).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Live stats
    final totalTables = allTables.length;
    final occupiedTables =
        allTables.where((t) => t.tileStatus == FloorPlanTileStatus.occupied).length;
    final freeTables = allTables
        .where((t) => t.tileStatus == FloorPlanTileStatus.free)
        .length;
    final totalRevenue = allTables
        .where((t) => t.currentGrandTotal != null)
        .fold<double>(0, (sum, t) => sum + (t.currentGrandTotal ?? 0));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ── Live Summary Bar ──────────────────────────────────────────────
        _LiveSummaryBar(
          totalTables: totalTables,
          occupiedTables: occupiedTables,
          freeTables: freeTables,
          totalRevenue: totalRevenue,
          isDark: isDark,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.m,
            vertical: AppSpacing.s,
          ),
          child: Row(
            children: [
              _LegendDot(
                color: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
                label: 'Libre',
              ),
              const SizedBox(width: AppSpacing.m),
              _LegendDot(
                color: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
                label: 'Occupée',
              ),
              const SizedBox(width: AppSpacing.m),
              _LegendDot(
                color: isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
                label: 'Réservée / Proforma',
              ),
            ],
          ),
        ),
        SizedBox(
          height: AppSpacing.minTouchTarget,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            itemCount: zones.length,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.s),
            itemBuilder: (context, index) {
              final z = zones[index];
              final selected = index == selectedZoneIndex;
              return FilterChip(
                label: Text(z.zone.name),
                selected: selected,
                onSelected: (_) => onZoneSelected(index),
                showCheckmark: false,
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.m),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: LayoutBuilder(
              builder: (context, constraints) {
                const tileWidth = 140.0;
                const tileHeight = 120.0;
                final maxX = zone.tables.fold<double>(
                  0,
                  (m, t) {
                    final x = t.table.posX ?? 0;
                    return x > m ? x : m;
                  },
                );
                final maxY = zone.tables.fold<double>(
                  0,
                  (m, t) {
                    final y = t.table.posY ?? 0;
                    return y > m ? y : m;
                  },
                );
                final canvasWidth = (maxX + tileWidth + AppSpacing.m)
                    .clamp(constraints.maxWidth, 2000.0);
                final canvasHeight = maxY + tileHeight + AppSpacing.m;

                return SizedBox(
                  width: canvasWidth,
                  height: canvasHeight,
                  child: Stack(
                    children: [
                      for (final snap in zone.tables)
                        Positioned(
                          left: snap.table.posX ?? 0,
                          top: snap.table.posY ?? 0,
                          width: tileWidth,
                          height: tileHeight,
                          child: FloorPlanTableTile(
                            snapshot: snap,
                            onTap: () => onTableTap(snap),
                            onLongPress: snap.activeOrder != null
                                ? () => onTableLongPress(snap, allTables)
                                : null,
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _LiveSummaryBar extends StatelessWidget {
  const _LiveSummaryBar({
    required this.totalTables,
    required this.occupiedTables,
    required this.freeTables,
    required this.totalRevenue,
    required this.isDark,
  });

  final int totalTables;
  final int occupiedTables;
  final int freeTables;
  final double totalRevenue;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final occupancyRate = totalTables > 0
        ? (occupiedTables / totalTables * 100).round()
        : 0;

    return Container(
      margin: const EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.s,
        AppSpacing.m,
        0,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1F2E)
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          _SummaryChip(
            label: 'Tables',
            value: '$totalTables',
            icon: Icons.table_bar_rounded,
            color: scheme.primary,
          ),
          _SummaryDivider(),
          _SummaryChip(
            label: 'Occupées',
            value: '$occupiedTables',
            icon: Icons.people_rounded,
            color: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
          ),
          _SummaryDivider(),
          _SummaryChip(
            label: 'Libres',
            value: '$freeTables',
            icon: Icons.check_circle_outline_rounded,
            color: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
          ),
          _SummaryDivider(),
          _SummaryChip(
            label: 'Taux',
            value: '$occupancyRate%',
            icon: Icons.donut_small_rounded,
            color: occupancyRate >= 80
                ? (isDark ? AppColors.accentRed : const Color(0xFFDC2626))
                : scheme.primary,
          ),
          const Spacer(),
          if (totalRevenue > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: scheme.primaryContainer.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.monetization_on_rounded,
                    size: 14,
                    color: scheme.primary,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    '${totalRevenue.toStringAsFixed(0)} DH',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 5),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: theme.textTheme.titleSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 9,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: Theme.of(context).colorScheme.outlineVariant.withValues(alpha: 0.4),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: AppSpacing.s),
        Text(label, style: theme.textTheme.labelMedium),
      ],
    );
  }
}

extension _IterableFirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}
