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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
