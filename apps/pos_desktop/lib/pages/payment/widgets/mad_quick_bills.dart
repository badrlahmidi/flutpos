import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
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

  static Color _colorForBill(bool isDark, double bill) {
    return switch (bill.toInt()) {
      200 => isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
      100 => isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
      50 => isDark ? AppColors.accentBlue : AppColors.primary,
      20 => isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
      _ => isDark ? AppColors.textMuted : const Color(0xFF64748B),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Wrap(
      spacing: AppSpacing.s,
      runSpacing: AppSpacing.s,
      children: [
        for (final bill in bills)
          Material(
            color: _colorForBill(isDark, bill).withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.s + 4),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: enabled ? () => onBillPressed(bill) : null,
              child: Container(
                width: AppSpacing.minTouchTarget + AppSpacing.m,
                height: AppSpacing.minTouchTarget,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSpacing.s + 4),
                  border: Border.all(
                    color: _colorForBill(isDark, bill).withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  '${bill.toInt()} DH',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _colorForBill(isDark, bill),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
