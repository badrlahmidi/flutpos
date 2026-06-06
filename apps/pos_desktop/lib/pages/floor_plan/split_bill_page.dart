import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/pos_button.dart';

/// Split bill par article — glisser-déposer vers sous-tickets.
class SplitBillPage extends StatefulWidget {
  const SplitBillPage({
    super.key,
    required this.sourceOrderId,
    required this.tableName,
  });

  final String sourceOrderId;
  final String tableName;

  @override
  State<SplitBillPage> createState() => _SplitBillPageState();
}

class _SplitBillPageState extends State<SplitBillPage> {
  final _orders = sl<OrderRepository>();
  CompleteOrder? _source;
  final List<({String id, String label})> _subTickets = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(initSubTickets: true);
  }

  Future<void> _load({bool initSubTickets = false}) async {
    setState(() => _loading = true);
    final complete = await _orders.getCompleteOrder(widget.sourceOrderId);
    if (!mounted) {
      return;
    }

    if (initSubTickets && complete != null && _subTickets.isEmpty) {
      for (final label in ['A', 'B', 'C']) {
        final sub = await _orders.createOrder(
          sessionId: complete.order.sessionId,
          waiterId: complete.order.waiterId,
          orderType: complete.orderType,
        );
        _subTickets.add((id: sub.id, label: label));
      }
    }

    if (!mounted) {
      return;
    }
    setState(() {
      _source = complete;
      _loading = false;
    });
  }

  Future<void> _onItemDropped(
    OrderItemWithProduct line,
    String? subOrderId,
  ) async {
    if (subOrderId == null) {
      return;
    }
    try {
      await _orders.splitOrderItemToSubOrder(
        sourceOrderId: widget.sourceOrderId,
        orderItemId: line.orderItem.id,
        targetSubOrderId: subOrderId,
      );
      await _load();
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final source = _source;

    return Scaffold(
      appBar: AppBar(
        title: Text('Split — ${widget.tableName}'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : source == null
              ? const Center(child: Text('Commande introuvable'))
              : Padding(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 3,
                        child: _TicketPanel(
                          title: 'Ticket principal',
                          lines: source.activeItems,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Sous-tickets',
                              style: theme.textTheme.titleMedium,
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Expanded(
                              child: ListView(
                                children: [
                                  for (final sub in _subTickets)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        bottom: AppSpacing.s,
                                      ),
                                      child: _SubTicketDropZone(
                                        label: 'Sous-ticket ${sub.label}',
                                        subOrderId: sub.id,
                                        onAccept: (line) =>
                                            _onItemDropped(line, sub.id),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            PosButton(
                              label: 'TERMINÉ',
                              expand: true,
                              onPressed: () => context.pop(true),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _TicketPanel extends StatelessWidget {
  const _TicketPanel({
    required this.title,
    required this.lines,
  });

  final String title;
  final List<OrderItemWithProduct> lines;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: theme.textTheme.titleLarge),
            const SizedBox(height: AppSpacing.m),
            Expanded(
              child: ListView(
                children: [
                  for (final line in lines)
                    LongPressDraggable<OrderItemWithProduct>(
                      data: line,
                      feedback: Material(
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.s),
                          child: Text(line.product.name),
                        ),
                      ),
                      childWhenDragging: Opacity(
                        opacity: 0.35,
                        child: _LineTile(line: line),
                      ),
                      child: _LineTile(line: line),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LineTile extends StatelessWidget {
  const _LineTile({required this.line});

  final OrderItemWithProduct line;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      title: Text(line.product.name),
      subtitle: line.modifierSummary.isNotEmpty
          ? Text(line.modifierSummary)
          : null,
      trailing: Text(
        '×${line.orderItem.quantity.toStringAsFixed(
          line.orderItem.quantity.truncateToDouble() == line.orderItem.quantity
              ? 0
              : 1,
        )}',
        style: theme.textTheme.titleMedium,
      ),
    );
  }
}

class _SubTicketDropZone extends StatelessWidget {
  const _SubTicketDropZone({
    required this.label,
    required this.subOrderId,
    required this.onAccept,
  });

  final String label;
  final String? subOrderId;
  final void Function(OrderItemWithProduct line) onAccept;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DragTarget<OrderItemWithProduct>(
      onWillAcceptWithDetails: (_) => subOrderId != null,
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        final highlighted = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(minHeight: AppSpacing.minTouchTarget),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.s),
            border: Border.all(
              color: highlighted ? scheme.primary : scheme.outline,
              width: highlighted ? 2 : 1,
            ),
            color: highlighted
                ? scheme.primaryContainer.withValues(alpha: 0.4)
                : scheme.surfaceContainerHighest,
          ),
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Center(
            child: Text(
              label,
              style: theme.textTheme.titleMedium,
            ),
          ),
        );
      },
    );
  }
}
