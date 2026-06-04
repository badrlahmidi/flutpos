import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';

/// Saisie du nombre de couverts avant ouverture de table.
Future<int?> showGuestCountDialog(
  BuildContext context, {
  required String tableName,
  required int capacity,
  int? defaultGuests,
}) {
  return showDialog<int>(
    context: context,
    builder: (ctx) => _GuestCountDialog(
      tableName: tableName,
      capacity: capacity,
      defaultGuests: defaultGuests,
    ),
  );
}

class _GuestCountDialog extends StatefulWidget {
  const _GuestCountDialog({
    required this.tableName,
    required this.capacity,
    this.defaultGuests,
  });

  final String tableName;
  final int capacity;
  final int? defaultGuests;

  @override
  State<_GuestCountDialog> createState() => _GuestCountDialogState();
}

class _GuestCountDialogState extends State<_GuestCountDialog> {
  int _guests = 2;

  @override
  void initState() {
    super.initState();
    final suggested = widget.defaultGuests ?? 2;
    _guests = suggested.clamp(1, widget.capacity);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AlertDialog(
      title: Text('Table ${widget.tableName}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Nombre de couverts',
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: AppSpacing.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _guests > 1
                    ? () => setState(() => _guests--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: AppSpacing.minTouchTarget,
              ),
              SizedBox(
                width: 72,
                child: Text(
                  '$_guests',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineMedium,
                ),
              ),
              IconButton(
                onPressed: _guests < widget.capacity
                    ? () => setState(() => _guests++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
                iconSize: AppSpacing.minTouchTarget,
              ),
            ],
          ),
          Text(
            'Capacité max : ${widget.capacity}',
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        PosButton(
          label: 'OUVRIR',
          onPressed: () => Navigator.of(context).pop(_guests),
        ),
      ],
    );
  }
}
