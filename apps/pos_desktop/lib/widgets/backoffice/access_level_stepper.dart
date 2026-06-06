import 'package:flutter/material.dart';

/// Sélecteur numérique 0-9 pour le niveau d'accès.
class AccessLevelStepper extends StatelessWidget {
  const AccessLevelStepper({
    super.key,
    required this.value,
    required this.onChanged,
    this.compact = false,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final level = value.clamp(0, 9);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: 'Diminuer',
          onPressed: level > 0 ? () => onChanged(level - 1) : null,
          icon: const Icon(Icons.remove),
          visualDensity: compact ? VisualDensity.compact : null,
        ),
        Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 10 : 16,
            vertical: compact ? 4 : 8,
          ),
          decoration: BoxDecoration(
            color: scheme.primaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '$level',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: compact ? 14 : 18,
              color: scheme.onPrimaryContainer,
            ),
          ),
        ),
        IconButton(
          tooltip: 'Augmenter',
          onPressed: level < 9 ? () => onChanged(level + 1) : null,
          icon: const Icon(Icons.add),
          visualDensity: compact ? VisualDensity.compact : null,
        ),
      ],
    );
  }
}
