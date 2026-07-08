import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_colors.dart';
import '../../widgets/atoms/pos_button.dart';
import '../../services/print/pos_print_service.dart';

/// Écran de Split d'Addition par article avec vue détaillée et encaissement direct.
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
  final List<CompleteOrder> _subTicketOrders = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load(initSubTickets: true);
  }

  Future<void> _load({bool initSubTickets = false}) async {
    setState(() => _loading = true);
    final complete = await _orders.getCompleteOrder(widget.sourceOrderId);
    if (!mounted) return;

    if (initSubTickets && complete != null && _subTickets.isEmpty) {
      final db = sl<AppDatabase>();
      final existing = await (db.select(db.orders)
            ..where((o) =>
                o.externalRef.lower().like('split-${widget.sourceOrderId.toLowerCase()}-%') &
                o.status.isIn(['OPEN', 'SENT', 'PROFORMA'])))
          .get();

      if (existing.isNotEmpty) {
        for (final order in existing) {
          final parts = order.externalRef?.split('-');
          final label = parts != null && parts.isNotEmpty ? parts.last : 'A';
          _subTickets.add((id: order.id, label: label));
        }
        _subTickets.sort((a, b) => a.label.compareTo(b.label));
      } else {
        // Création initiale de 3 sous-tickets (A, B, C)
        for (final label in ['A', 'B', 'C']) {
          final sub = await _orders.createOrder(
            sessionId: complete.order.sessionId,
            waiterId: complete.order.waiterId,
            orderType: complete.orderType,
            externalRef: 'SPLIT-${complete.order.id}-$label',
          );
          _subTickets.add((id: sub.id, label: label));
        }
      }
    }

    if (!mounted) return;

    _subTicketOrders.clear();
    for (final sub in _subTickets) {
      final subComplete = await _orders.getCompleteOrder(sub.id);
      if (subComplete != null) {
        _subTicketOrders.add(subComplete);
      }
    }

    if (!mounted) return;

    setState(() {
      _source = complete;
      _loading = false;
    });
  }

  Future<void> _onItemDropped(
    OrderItemWithProduct line,
    String subOrderId,
  ) async {
    // Vérifier si déjà payé
    CompleteOrder? targetSub;
    for (final o in _subTicketOrders) {
      if (o.order.id == subOrderId) {
        targetSub = o;
        break;
      }
    }

    if (targetSub != null && targetSub.order.status == 'PAID') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ce sous-ticket est déjà payé !'),
          backgroundColor: AppColors.accentRed,
        ),
      );
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
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
    }
  }

  Future<void> _printSubProforma(CompleteOrder subOrder) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _orders.markOrderProforma(subOrder.order.id);
      final updated = await _orders.getCompleteOrder(subOrder.order.id);
      if (updated != null && mounted) {
        final result = await sl<PosPrintService>().printProforma(updated);
        final label = subOrder.order.externalRef?.split('-').last ?? '';
        messenger.showSnackBar(
          SnackBar(
            content: Text(
              result.ok
                  ? 'Note Proforma imprimée pour le sous-ticket $label'
                  : (result.error ?? 'Erreur impression note'),
            ),
          ),
        );
        await _load();
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  Future<void> _paySubOrder(CompleteOrder subOrder) async {
    final router = GoRouter.of(context);
    final paid = await router.push<bool>('/payment/${subOrder.order.id}');
    if (paid == true && mounted) {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final source = _source;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : AppColors.background,
      appBar: AppBar(
        title: Text(
          'Partage d\'Addition — ${widget.tableName}',
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: isDark ? AppColors.surfaceDark : theme.appBarTheme.backgroundColor,
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
                      // Panneau gauche : Ticket principal
                      Expanded(
                        flex: 5,
                        child: _TicketPanel(
                          title: 'Ticket Principal (Table ${widget.tableName})',
                          lines: source.activeItems,
                          total: source.displayGrandTotal,
                          isDark: isDark,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      // Panneau droit : Les sous-tickets (A, B, C)
                      Expanded(
                        flex: 7,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'Répartition Convives',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.s),
                            Expanded(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  for (final sub in _subTickets)
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: AppSpacing.xs,
                                        ),
                                        child: Builder(
                                          builder: (context) {
                                            // Retrouver la commande correspondante
                                            CompleteOrder? subOrder;
                                            for (final o in _subTicketOrders) {
                                              if (o.order.id == sub.id) {
                                                subOrder = o;
                                                break;
                                              }
                                            }
                                            return _SubTicketPanel(
                                              label: 'Convive ${sub.label}',
                                              subOrderId: sub.id,
                                              subOrder: subOrder,
                                              onAccept: (line) =>
                                                  _onItemDropped(line, sub.id),
                                              onPrint: subOrder != null &&
                                                      subOrder.activeItems.isNotEmpty
                                                  ? () => _printSubProforma(subOrder!)
                                                  : null,
                                              onPay: subOrder != null &&
                                                      subOrder.activeItems.isNotEmpty
                                                  ? () => _paySubOrder(subOrder!)
                                                  : null,
                                              isDark: isDark,
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            PosButton(
                              label: 'TERMINER & RETOURNER AU PLAN DE SALLE',
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
    required this.total,
    required this.isDark,
  });

  final String title;
  final List<OrderItemWithProduct> lines;
  final double total;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: isDark ? AppColors.surfaceDark : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isDark ? AppColors.borderSubtle : theme.dividerColor.withValues(alpha: 0.1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Glissez-déposez les articles vers les convives',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? AppColors.textSecondary : Colors.grey[600],
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Expanded(
              child: lines.isEmpty
                  ? Center(
                      child: Text(
                        'Aucun article restant',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.textMuted : Colors.grey,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: lines.length,
                      itemBuilder: (context, index) {
                        final line = lines[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.s),
                          key: ValueKey(line.orderItem.id),
                          child: LongPressDraggable<OrderItemWithProduct>(
                            data: line,
                            feedback: Material(
                              elevation: 8,
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.m,
                                  vertical: AppSpacing.s,
                                ),
                                color: isDark ? AppColors.accentBlue : theme.primaryColor,
                                child: Text(
                                  '${line.product.name} (x${line.orderItem.quantity.toStringAsFixed(0)})',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            childWhenDragging: Opacity(
                              opacity: 0.35,
                              child: _LineTile(line: line, isDark: isDark),
                            ),
                            child: _LineTile(line: line, isDark: isDark),
                          ),
                        );
                      },
                    ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL RESTANT',
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} DH',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                      color: isDark ? AppColors.accentBlue : theme.primaryColor,
                    ),
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
  const _LineTile({required this.line, required this.isDark});

  final OrderItemWithProduct line;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: isDark ? AppColors.surfaceElevated : Colors.grey[50],
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isDark ? AppColors.borderSubtle : Colors.grey[200]!,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.xs),
        title: Text(
          line.product.name,
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: line.modifierSummary.isNotEmpty
            ? Text(
                line.modifierSummary,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? AppColors.textSecondary : Colors.grey[600],
                ),
              )
            : null,
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s, vertical: AppSpacing.xs),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '×${line.orderItem.quantity.toStringAsFixed(
              line.orderItem.quantity.truncateToDouble() == line.orderItem.quantity
                  ? 0
                  : 1,
            )}',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}

class _SubTicketPanel extends StatelessWidget {
  const _SubTicketPanel({
    required this.label,
    required this.subOrderId,
    required this.subOrder,
    required this.onAccept,
    required this.onPrint,
    required this.onPay,
    required this.isDark,
  });

  final String label;
  final String subOrderId;
  final CompleteOrder? subOrder;
  final void Function(OrderItemWithProduct line) onAccept;
  final VoidCallback? onPrint;
  final VoidCallback? onPay;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isPaid = subOrder?.order.status == 'PAID';
    final isProforma = subOrder?.order.status == 'PROFORMA';

    return DragTarget<OrderItemWithProduct>(
      onWillAcceptWithDetails: (_) => !isPaid,
      onAcceptWithDetails: (d) => onAccept(d.data),
      builder: (context, candidate, rejected) {
        final highlighted = candidate.isNotEmpty;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: isPaid
                ? (isDark ? const Color(0xFF0F2D1D) : const Color(0xFFE8F5E9))
                : (highlighted
                    ? (isDark ? const Color(0xFF1E2D4A) : scheme.primaryContainer.withValues(alpha: 0.2))
                    : (isDark ? AppColors.surfaceDark : theme.cardColor)),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isPaid
                  ? AppColors.accentGreen
                  : (highlighted
                      ? (isDark ? AppColors.accentBlue : scheme.primary)
                      : (isDark ? AppColors.borderSubtle : theme.dividerColor.withValues(alpha: 0.1))),
              width: highlighted ? 2 : 1,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header du convive
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isPaid ? AppColors.accentGreen : null,
                      ),
                    ),
                    if (isPaid)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentGreen.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PAYÉ',
                          style: TextStyle(
                            color: AppColors.accentGreen,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                    else if (isProforma)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: const Text(
                          'PROFORMA',
                          style: TextStyle(
                            color: AppColors.accentOrange,
                            fontWeight: FontWeight.bold,
                            fontSize: 10,
                          ),
                        ),
                      )
                  ],
                ),
                const SizedBox(height: AppSpacing.s),
                // Liste des articles transférés
                Expanded(
                  child: subOrder == null || subOrder!.activeItems.isEmpty
                      ? Center(
                          child: Text(
                            'Glisser un article ici',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: isDark ? AppColors.textMuted : Colors.grey,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: subOrder!.activeItems.length,
                          itemBuilder: (context, index) {
                            final line = subOrder!.activeItems[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.s,
                                  vertical: AppSpacing.xs,
                                ),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.surfaceElevated : Colors.grey[100],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        line.product.name,
                                        style: theme.textTheme.bodySmall?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '×${line.orderItem.quantity.toStringAsFixed(0)}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const Divider(),
                // Total convive
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total',
                        style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${(subOrder?.displayGrandTotal ?? 0.0).toStringAsFixed(2)} DH',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isPaid
                              ? AppColors.accentGreen
                              : (isDark ? AppColors.textPrimary : Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                // Boutons d'actions directs
                if (!isPaid)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: onPrint,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(Icons.print_rounded, size: 20),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: onPay,
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.zero,
                            backgroundColor: isDark ? AppColors.accentBlue : scheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('PAYER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
