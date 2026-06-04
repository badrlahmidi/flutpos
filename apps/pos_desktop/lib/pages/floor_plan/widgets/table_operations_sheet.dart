import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';

/// Actions transfert / fusion / split sur une table occupée.
Future<TableOperationChoice?> showTableOperationsSheet(
  BuildContext context, {
  required FloorPlanTableSnapshot snapshot,
  required List<FloorPlanTableSnapshot> allTables,
}) {
  return showModalBottomSheet<TableOperationChoice>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) => _TableOperationsSheet(
      snapshot: snapshot,
      allTables: allTables,
    ),
  );
}

enum TableOperationKind { transfer, merge, splitBill }

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
    final order = widget.snapshot.activeOrder;

    if (order == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.m,
        right: AppSpacing.m,
        top: AppSpacing.m,
        bottom: MediaQuery.paddingOf(context).bottom + AppSpacing.m,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Table ${widget.snapshot.table.name}',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.m),
          if (_step == null) ...[
            PosButton(
              label: 'TRANSFÉRER',
              icon: Icons.swap_horiz,
              expand: true,
              onPressed: () => setState(() => _step = TableOperationKind.transfer),
            ),
            const SizedBox(height: AppSpacing.s),
            PosButton(
              label: 'FUSIONNER',
              icon: Icons.merge,
              variant: PosButtonVariant.tonal,
              expand: true,
              onPressed: () => setState(() => _step = TableOperationKind.merge),
            ),
            const SizedBox(height: AppSpacing.s),
            PosButton(
              label: 'SPLIT PAR ARTICLE',
              icon: Icons.call_split,
              variant: PosButtonVariant.outlined,
              expand: true,
              onPressed: () => Navigator.of(context).pop(
                const TableOperationChoice(kind: TableOperationKind.splitBill),
              ),
            ),
          ] else ...[
            Text(
              _step == TableOperationKind.transfer
                  ? 'Transférer vers :'
                  : 'Fusionner avec :',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            SizedBox(
              height: 240,
              child: ListView(
                children: [
                  for (final target in _step == TableOperationKind.transfer
                      ? _freeTargets
                      : _mergeTargets)
                    ListTile(
                      title: Text('Table ${target.table.name}'),
                      subtitle: target.currentGrandTotal != null
                          ? Text(
                              '${target.currentGrandTotal!.toStringAsFixed(0)} DH',
                            )
                          : null,
                      selected: _selectedTargetId == target.table.id,
                      onTap: () =>
                          setState(() => _selectedTargetId = target.table.id),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Row(
              children: [
                Expanded(
                  child: PosButton(
                    label: 'RETOUR',
                    variant: PosButtonVariant.outlined,
                    onPressed: () => setState(() {
                      _step = null;
                      _selectedTargetId = null;
                    }),
                  ),
                ),
                const SizedBox(width: AppSpacing.s),
                Expanded(
                  child: PosButton(
                    label: 'VALIDER',
                    onPressed: _selectedTargetId == null
                        ? null
                        : () => Navigator.of(context).pop(
                              TableOperationChoice(
                                kind: _step!,
                                targetTableId: _selectedTargetId,
                              ),
                            ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
