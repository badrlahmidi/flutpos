import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/reservations/reservations_bloc.dart';
import '../../blocs/reservations/reservations_event.dart';
import '../../blocs/reservations/reservations_state.dart';
import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/pos_button.dart';
import 'widgets/reservation_form_dialog.dart';

/// Gestion des réservations à venir.
class ReservationsPage extends StatelessWidget {
  const ReservationsPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReservationsBloc(
        reservationRepository: sl<ReservationRepository>(),
      )..add(const ReservationsStarted()),
      child: const _ReservationsView(),
    );
  }
}

class _ReservationsView extends StatelessWidget {
  const _ReservationsView();

  Future<void> _openCreate(BuildContext context, ReservationsReady state) async {
    final submitted = await showReservationFormDialog(
      context,
      tables: state.tables,
      zones: state.zones,
    );
    if (submitted == null || !context.mounted) {
      return;
    }

    context.read<ReservationsBloc>().add(
          ReservationCreateSubmitted(
            tableId: submitted.tableId,
            customerName: submitted.customerName,
            customerPhone: submitted.customerPhone,
            guestCount: submitted.guestCount,
            reservedAt: submitted.reservedAt,
            notes: submitted.notes,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Réservations'),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            icon: const Icon(Icons.refresh),
            onPressed: () => context
                .read<ReservationsBloc>()
                .add(const ReservationsRefreshRequested()),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<ReservationsBloc, ReservationsState>(
        buildWhen: (p, c) => c is ReservationsReady,
        builder: (context, state) {
          if (state is! ReservationsReady) {
            return const SizedBox.shrink();
          }
          return FloatingActionButton.extended(
            onPressed: () => _openCreate(context, state),
            icon: const Icon(Icons.add),
            label: const Text('Réserver'),
          );
        },
      ),
      body: BlocConsumer<ReservationsBloc, ReservationsState>(
        listenWhen: (prev, curr) =>
            curr is ReservationsError && prev is! ReservationsError,
        listener: (context, state) {
          if (state is ReservationsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: scheme.error,
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            ReservationsInitial() || ReservationsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            ReservationsReady(:final reservations, :final tables, :final zones) =>
              reservations.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.event_seat_outlined,
                            size: AppSpacing.minTouchTarget,
                            color: scheme.onSurfaceVariant,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          Text(
                            'Aucune réservation à venir',
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.m),
                          PosButton(
                            label: 'CRÉER UNE RÉSERVATION',
                            icon: Icons.add,
                            onPressed: () => _openCreate(
                              context,
                              ReservationsReady(
                                reservations: reservations,
                                tables: tables,
                                zones: zones,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      itemCount: reservations.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.s),
                      itemBuilder: (context, index) {
                        final r = reservations[index];
                        return _ReservationCard(
                          reservation: r,
                          tableLabel: state.tableLabel(r.tableId),
                          onCancel: () => context.read<ReservationsBloc>().add(
                                ReservationCancelRequested(r.id),
                              ),
                        );
                      },
                    ),
            ReservationsError(:final message) => Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message),
                    const SizedBox(height: AppSpacing.m),
                    PosButton(
                      label: 'Réessayer',
                      onPressed: () => context
                          .read<ReservationsBloc>()
                          .add(const ReservationsStarted()),
                    ),
                  ],
                ),
              ),
          };
        },
      ),
    );
  }
}

class _ReservationCard extends StatelessWidget {
  const _ReservationCard({
    required this.reservation,
    required this.tableLabel,
    required this.onCancel,
  });

  final Reservation reservation;
  final String tableLabel;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final local = reservation.reservedAt.toLocal();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: scheme.tertiaryContainer,
              child: Text(
                '${reservation.guestCount}',
                style: theme.textTheme.titleLarge?.copyWith(
                  color: scheme.onTertiaryContainer,
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    reservation.customerName,
                    style: theme.textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    tableLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    _formatWhen(local),
                    style: theme.textTheme.bodyMedium,
                  ),
                  if (reservation.customerPhone != null &&
                      reservation.customerPhone!.isNotEmpty)
                    Text(
                      reservation.customerPhone!,
                      style: theme.textTheme.bodySmall,
                    ),
                  if (reservation.notes != null &&
                      reservation.notes!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: AppSpacing.xs),
                      child: Text(
                        reservation.notes!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            IconButton(
              tooltip: 'Annuler la réservation',
              icon: Icon(Icons.cancel_outlined, color: scheme.error),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Annuler la réservation ?'),
                    content: Text(
                      '${reservation.customerName} — $tableLabel',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('Non'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Oui'),
                      ),
                    ],
                  ),
                );
                if (ok == true) {
                  onCancel();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  static String _formatWhen(DateTime local) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(local.year, local.month, local.day);
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    final time = '$h:$m';

    if (day == today) {
      return 'Aujourd\'hui · $time';
    }
    if (day == today.add(const Duration(days: 1))) {
      return 'Demain · $time';
    }
    return '${local.day}/${local.month} · $time';
  }
}
