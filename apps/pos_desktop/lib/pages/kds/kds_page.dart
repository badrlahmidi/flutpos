import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/kds/kds_bloc.dart';
import '../../blocs/kds/kds_event.dart';
import '../../blocs/kds/kds_state.dart';
import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/pos_button.dart';

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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cuisine — KDS'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            onPressed: () =>
                context.read<KdsBloc>().add(const KdsRefreshRequested()),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: BlocConsumer<KdsBloc, KdsState>(
        listenWhen: (prev, curr) =>
            curr is KdsReady &&
            curr.lastReadyProductName != null &&
            (prev is! KdsReady ||
                prev.lastReadyProductName != curr.lastReadyProductName),
        listener: (context, state) {
          if (state is KdsReady && state.lastReadyProductName != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${state.lastReadyProductName} — PRÊT'),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        builder: (context, state) {
          return switch (state) {
            KdsInitial() || KdsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            KdsError(:final message) => Center(
                child: Text(message, style: TextStyle(color: scheme.error)),
              ),
            KdsReady(:final tickets) => tickets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: AppSpacing.minTouchTarget,
                          color: scheme.primary,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Text(
                          'Aucun plat en attente',
                          style: theme.textTheme.titleLarge,
                        ),
                      ],
                    ),
                  )
                : RefreshIndicator(
                    onRefresh: () async {
                      context
                          .read<KdsBloc>()
                          .add(const KdsRefreshRequested());
                      await context.read<KdsBloc>().stream.firstWhere(
                            (s) => s is KdsReady || s is KdsError,
                          );
                    },
                    child: ListView.separated(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      itemCount: tickets.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: AppSpacing.m),
                      itemBuilder: (context, index) {
                        return _KdsTicketCard(ticket: tickets[index]);
                      },
                    ),
                  ),
          };
        },
      ),
    );
  }
}

class _KdsTicketCard extends StatelessWidget {
  const _KdsTicketCard({required this.ticket});

  final KdsOrderTicket ticket;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final elapsed = DateTime.now()
        .toUtc()
        .difference(ticket.oldestItemAt)
        .inMinutes;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (ticket.headerLabel != null)
              Text(
                ticket.headerLabel!,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scheme.primary,
                ),
              )
            else
              Text(
                'Commande ${ticket.order.id.substring(0, 8)}',
                style: theme.textTheme.titleLarge,
              ),
            Text(
              '$elapsed min · ${ticket.pendingItems.length} ligne(s)',
              style: theme.textTheme.labelLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
            const Divider(height: AppSpacing.m),
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
                  PosButton(
                    label: 'PRÊT',
                    icon: Icons.check_circle,
                    onPressed: () {
                      context.read<KdsBloc>().add(
                            KdsItemReadyPressed(
                              orderItemId: line.orderItem.id,
                              orderId: ticket.order.id,
                              productName: line.product.name,
                            ),
                          );
                    },
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
            ],
          ],
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
