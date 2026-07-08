import 'package:core/core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../di/service_locator.dart';
import '../../../services/print/pos_print_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';

/// Actions transfert / fusion / split sur une table occupée — bottom sheet premium.
Future<TableOperationChoice?> showTableOperationsSheet(
  BuildContext context, {
  required FloorPlanTableSnapshot snapshot,
  required List<FloorPlanTableSnapshot> allTables,
}) {
  return showModalBottomSheet<TableOperationChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Colors.transparent,
    builder: (ctx) => _TableOperationsSheet(
      snapshot: snapshot,
      allTables: allTables,
    ),
  );
}

enum TableOperationKind { transfer, merge, splitBill, liberate }

class TableOperationChoice {
  const TableOperationChoice({
    required this.kind,
    this.targetTableId,
  });

  final TableOperationKind kind;
  final String? targetTableId;
}

class _TableOperationsSheet extends StatefulWidget {
  const _TableOperationsSheet({
    required this.snapshot,
    required this.allTables,
  });

  final FloorPlanTableSnapshot snapshot;
  final List<FloorPlanTableSnapshot> allTables;

  @override
  State<_TableOperationsSheet> createState() => _TableOperationsSheetState();
}

class _TableOperationsSheetState extends State<_TableOperationsSheet> {
  TableOperationKind? _step;
  String? _selectedTargetId;
  List<CompleteOrder> _subOrders = [];
  bool _loadingSubOrders = false;

  @override
  void initState() {
    super.initState();
    _loadSubOrders();
  }

  Future<void> _loadSubOrders() async {
    final order = widget.snapshot.activeOrder;
    if (order == null) return;
    if (!mounted) return;
    setState(() => _loadingSubOrders = true);

    try {
      final db = sl<AppDatabase>();
      final ordersRepo = sl<OrderRepository>();
      final existing = await (db.select(db.orders)
            ..where((o) =>
                o.externalRef.lower().like('split-${order.id.toLowerCase()}-%') &
                o.status.isIn(['OPEN', 'SENT', 'PROFORMA'])))
          .get();

      final List<CompleteOrder> loaded = [];
      for (final sub in existing) {
        final comp = await ordersRepo.getCompleteOrder(sub.id);
        if (comp != null && comp.activeItems.isNotEmpty) {
          loaded.add(comp);
        }
      }
      if (mounted) {
        setState(() {
          _subOrders = loaded;
          _loadingSubOrders = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loadingSubOrders = false);
      }
    }
  }

  Future<void> _printSubProforma(CompleteOrder subOrder) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await sl<OrderRepository>().markOrderProforma(subOrder.order.id);
      final updated = await sl<OrderRepository>().getCompleteOrder(subOrder.order.id);
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
        _loadSubOrders();
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
      _loadSubOrders();
      // If we paid all/some suborders, let's close this sheet so the floor plan updates!
      Navigator.of(context).pop(const TableOperationChoice(kind: TableOperationKind.splitBill));
    }
  }

  List<FloorPlanTableSnapshot> get _freeTargets => widget.allTables
      .where(
        (t) =>
            t.table.id != widget.snapshot.table.id &&
            t.tileStatus == FloorPlanTileStatus.free,
      )
      .toList();

  List<FloorPlanTableSnapshot> get _mergeTargets => widget.allTables
      .where(
        (t) =>
            t.table.id != widget.snapshot.table.id &&
            t.tileStatus == FloorPlanTileStatus.occupied &&
            t.activeOrder != null,
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final order = widget.snapshot.activeOrder;

    if (order == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1A1F2E) : scheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.s,
        bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Header ─────────────────────────────────────────────────────
          _SheetHeader(snapshot: widget.snapshot, isDark: isDark, scheme: scheme),
          const SizedBox(height: AppSpacing.m),

          // ── Content ─────────────────────────────────────────────────────
          if (_step == null) ...[
            _ActionGrid(
              onTransfer: () => setState(() => _step = TableOperationKind.transfer),
              onMerge: () => setState(() => _step = TableOperationKind.merge),
              onSplit: () => Navigator.of(context).pop(
                const TableOperationChoice(kind: TableOperationKind.splitBill),
              ),
              onLiberate: () => Navigator.of(context).pop(
                const TableOperationChoice(kind: TableOperationKind.liberate),
              ),
              isDark: isDark,
              scheme: scheme,
            ),
            if (_loadingSubOrders)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.m),
                  child: CircularProgressIndicator(),
                ),
              )
            else if (_subOrders.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.m),
              const Divider(),
              const SizedBox(height: AppSpacing.s),
              Text(
                'SOUS-TICKETS EN COURS',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.textSecondary : Colors.grey[700],
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 180),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _subOrders.length,
                  itemBuilder: (context, index) {
                    final sub = _subOrders[index];
                    final label = sub.order.externalRef?.split('-').last ?? 'A';
                    return Card(
                      color: isDark ? AppColors.surfaceElevated : Colors.grey[50],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isDark ? AppColors.borderSubtle : Colors.grey[200]!,
                        ),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                          vertical: AppSpacing.xs,
                        ),
                        title: Text(
                          'Convive $label',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          '${sub.activeItems.length} article(s)',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: isDark ? AppColors.textSecondary : Colors.grey[600],
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${sub.displayGrandTotal.toStringAsFixed(2)} DH',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w900,
                                color: isDark ? AppColors.accentBlue : theme.primaryColor,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.m),
                            // Bouton d'impression
                            IconButton(
                              icon: const Icon(Icons.print_rounded, size: 20),
                              onPressed: () => _printSubProforma(sub),
                            ),
                            // Bouton de paiement
                            IconButton(
                              icon: const Icon(Icons.payment_rounded, size: 20),
                              color: isDark ? AppColors.accentGreen : Colors.green[700],
                              onPressed: () => _paySubOrder(sub),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ] else
            _TargetPicker(
              step: _step!,
              targets: _step == TableOperationKind.transfer
                  ? _freeTargets
                  : _mergeTargets,
              selectedId: _selectedTargetId,
              onSelect: (id) => setState(() => _selectedTargetId = id),
              onBack: () => setState(() {
                _step = null;
                _selectedTargetId = null;
              }),
              onConfirm: _selectedTargetId == null
                  ? null
                  : () => Navigator.of(context).pop(
                        TableOperationChoice(
                          kind: _step!,
                          targetTableId: _selectedTargetId,
                        ),
                      ),
              isDark: isDark,
              scheme: scheme,
            ),
        ],
      ),
    );
  }
}

// ── Sheet header with table info ──────────────────────────────────────────────
class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.snapshot,
    required this.isDark,
    required this.scheme,
  });
  final FloorPlanTableSnapshot snapshot;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = snapshot.currentGrandTotal;
    final timer = snapshot.occupiedDurationLabel;
    final guests = snapshot.activeOrder?.guestCount;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: (isDark ? AppColors.accentOrange : const Color(0xFFEA580C))
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            Icons.table_restaurant_rounded,
            color: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Table ${snapshot.table.name}',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Row(
                children: [
                  if (guests != null) ...[
                    Icon(Icons.people, size: 13, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Text(
                      '$guests pers.',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 8),
                  ],
                  if (timer != null) ...[
                    Icon(Icons.schedule, size: 13, color: scheme.onSurfaceVariant),
                    const SizedBox(width: 3),
                    Text(
                      timer,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        if (total != null && total > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: scheme.primaryContainer.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${total.toStringAsFixed(0)} DH',
              style: theme.textTheme.titleSmall?.copyWith(
                color: scheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
      ],
    );
  }
}

// ── Main action grid (Transférer / Fusionner / Split / Libérer) ─────────────────────────
class _ActionGrid extends StatelessWidget {
  const _ActionGrid({
    required this.onTransfer,
    required this.onMerge,
    required this.onSplit,
    required this.onLiberate,
    required this.isDark,
    required this.scheme,
  });
  final VoidCallback onTransfer;
  final VoidCallback onMerge;
  final VoidCallback onSplit;
  final VoidCallback onLiberate;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.swap_horiz_rounded,
                label: 'TRANSFÉRER',
                subtitle: 'Changer de table',
                color: isDark ? AppColors.accentBlue : const Color(0xFF1D4ED8),
                onTap: onTransfer,
                isDark: isDark,
              ).animate(delay: 0.ms).fadeIn(duration: 200.ms).slideY(begin: 0.1),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: _ActionCard(
                icon: Icons.merge_rounded,
                label: 'FUSIONNER',
                subtitle: 'Combiner 2 tables',
                color: isDark
                    ? AppColors.accentPurple
                    : const Color(0xFF6D28D9),
                onTap: onMerge,
                isDark: isDark,
              ).animate(delay: 60.ms).fadeIn(duration: 200.ms).slideY(begin: 0.1),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.call_split_rounded,
                label: 'SPLIT ARTICLE',
                subtitle: 'Diviser l\'addition',
                color: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
                onTap: onSplit,
                isDark: isDark,
              ).animate(delay: 120.ms).fadeIn(duration: 200.ms).slideY(begin: 0.1),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: _ActionCard(
                icon: Icons.delete_outline_rounded,
                label: 'LIBÉRER TABLE',
                subtitle: 'Annuler le ticket',
                color: isDark ? AppColors.accentRed : const Color(0xFFDC2626),
                onTap: onLiberate,
                isDark: isDark,
              ).animate(delay: 180.ms).fadeIn(duration: 200.ms).slideY(begin: 0.1),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onTap,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.m),
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: color.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: color, size: 28),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: theme.textTheme.titleSmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: color.withValues(alpha: 0.7),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Target picker grid (free/occupied tables) ─────────────────────────────────
class _TargetPicker extends StatelessWidget {
  const _TargetPicker({
    required this.step,
    required this.targets,
    required this.selectedId,
    required this.onSelect,
    required this.onBack,
    required this.onConfirm,
    required this.isDark,
    required this.scheme,
  });

  final TableOperationKind step;
  final List<FloorPlanTableSnapshot> targets;
  final String? selectedId;
  final ValueChanged<String> onSelect;
  final VoidCallback onBack;
  final VoidCallback? onConfirm;
  final bool isDark;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isTransfer = step == TableOperationKind.transfer;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: onBack,
            ),
            Expanded(
              child: Text(
                isTransfer ? 'Transférer vers :' : 'Fusionner avec :',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.s),
        if (targets.isEmpty)
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              children: [
                Icon(
                  isTransfer
                      ? Icons.table_restaurant_outlined
                      : Icons.merge_outlined,
                  size: 40,
                  color: scheme.onSurfaceVariant.withValues(alpha: 0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  isTransfer
                      ? 'Aucune table libre disponible'
                      : 'Aucune autre table occupée',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          )
        else
          SizedBox(
            height: 200,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.1,
              ),
              itemCount: targets.length,
              itemBuilder: (context, index) {
                final t = targets[index];
                final isSelected = selectedId == t.table.id;
                final accentColor = isTransfer
                    ? (isDark ? AppColors.accentGreen : const Color(0xFF16A34A))
                    : (isDark
                        ? AppColors.accentPurple
                        : const Color(0xFF6D28D9));
                return GestureDetector(
                  onTap: () => onSelect(t.table.id),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 160),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? accentColor.withValues(alpha: 0.15)
                          : (isDark
                              ? const Color(0xFF232937)
                              : scheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? accentColor
                            : scheme.outlineVariant.withValues(alpha: 0.4),
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          t.table.name,
                          style: theme.textTheme.titleSmall?.copyWith(
                            color: isSelected ? accentColor : scheme.onSurface,
                            fontWeight: FontWeight.w800,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (t.currentGrandTotal != null && !isTransfer)
                          Text(
                            '${t.currentGrandTotal!.toStringAsFixed(0)} DH',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: accentColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 10,
                            ),
                          ),
                        if (isTransfer)
                          Text(
                            '${t.table.capacity} pl.',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: AppSpacing.m),
        Row(
          children: [
            Expanded(
              child: PosButton(
                label: 'RETOUR',
                variant: PosButtonVariant.outlined,
                onPressed: onBack,
              ),
            ),
            const SizedBox(width: AppSpacing.s),
            Expanded(
              child: PosButton(
                label: 'VALIDER',
                onPressed: onConfirm,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
