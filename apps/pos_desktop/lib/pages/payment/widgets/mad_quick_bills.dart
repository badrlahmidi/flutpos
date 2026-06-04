import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Billets rapides MAD pour saisie accélérée.
class MadQuickBills extends StatelessWidget {
  const MadQuickBills({
    super.key,
    required this.onBillPressed,
    this.enabled = true,
  });

  final ValueChanged<double> onBillPressed;
  final bool enabled;

  static const List<double> bills = [200, 100, 50, 20, 10];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        for (final bill in bills)
          Material(
            color: scheme.secondaryContainer,
            borderRadius: BorderRadius.circular(AppSpacing.s),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? () => onBillPressed(bill) : null,
              child: SizedBox(
                width: AppSpacing.minTouchTarget + AppSpacing.m,
                height: AppSpacing.minTouchTarget,
                child: Center(
                  child: Text(
                    '${bill.toInt()} DH',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onSecondaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
