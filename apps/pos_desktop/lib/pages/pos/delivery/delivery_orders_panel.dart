import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';
import 'delivery_start_dialog.dart';

/// Liste des tickets livraison ouverts + création rapide.
class DeliveryOrdersPanel extends StatefulWidget {
  const DeliveryOrdersPanel({
    super.key,
    required this.cashierId,
    required this.selectedOrderId,
    required this.onOrderSelected,
    required this.onNewDelivery,
  });

  final String cashierId;
  final String? selectedOrderId;
  final ValueChanged<String> onOrderSelected;
  final Future<void> Function(OrderSource source, String? externalRef)
      onNewDelivery;

  @override
  State<DeliveryOrdersPanel> createState() => _DeliveryOrdersPanelState();
}

class _DeliveryOrdersPanelState extends State<DeliveryOrdersPanel> {
  List<Order> _orders = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final session = await sl<CashSessionRepository>()
          .getOpenSessionForCashier(widget.cashierId);
      if (session == null) {
        setState(() {
          _orders = [];
          _error = 'Session caisse fermée';
          _loading = false;
        });
        return;
      }

      final orders =
          await sl<OrderRepository>().listOpenDeliveryOrders(session.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _orders = orders;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  Future<void> _onNew() async {
    final data = await showDeliveryStartDialog(context);
    if (data == null || !mounted) {
      return;
    }
    await widget.onNewDelivery(data.source, data.externalRef);
    if (mounted) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ColoredBox(
      color: scheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Text(
              'Livraisons en cours',
              style: theme.textTheme.titleMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: PosButton(
              label: 'NOUVELLE LIVRAISON',
              icon: Icons.delivery_dining,
              expand: true,
              onPressed: _onNew,
            ),
          ),
          const SizedBox(height: AppSpacing.m),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.m),
                          child: Text(_error!, textAlign: TextAlign.center),
                        ),
                      )
                    : _orders.isEmpty
                        ? Center(
                            child: Text(
                              'Aucune commande livraison',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.m,
                            ),
                            itemCount: _orders.length,
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: AppSpacing.s),
                            itemBuilder: (context, index) {
                              final order = _orders[index];
                              final label =
                                  DeliveryTicketHeader.displayLabel(order) ??
                                      'Livraison';
                              final selected =
                                  order.id == widget.selectedOrderId;

                              return Material(
                                color: selected
                                    ? scheme.primaryContainer
                                    : scheme.surfaceContainerHighest,
                                borderRadius:
                                    BorderRadius.circular(AppSpacing.s),
                                child: InkWell(
                                  onTap: () =>
                                      widget.onOrderSelected(order.id),
                                  borderRadius:
                                      BorderRadius.circular(AppSpacing.s),
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      minHeight: AppSpacing.minTouchTarget,
                                    ),
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.all(AppSpacing.m),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            label,
                                            style: theme.textTheme.titleMedium
                                                ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          Text(
                                            'Ticket ${order.id.substring(0, 8)}',
                                            style: theme.textTheme.labelMedium,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
          IconButton(
            tooltip: 'Actualiser',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }
}
