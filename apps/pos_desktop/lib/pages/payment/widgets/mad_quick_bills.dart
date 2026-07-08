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

  static const List<double> bills = [500, 200, 100, 50, 20, 10];

  static Color _colorForBill(bool isDark, double bill) {
    return switch (bill.toInt()) {
      500 => isDark ? const Color(0xFFE879F9) : const Color(0xFF7C3AED),
      200 => isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
      100 => isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
      50  => isDark ? AppColors.accentBlue : AppColors.primary,
      20  => isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
      _   => isDark ? AppColors.textMuted : const Color(0xFF64748B),
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
          _BillButton(
            bill: bill,
            color: _colorForBill(isDark, bill),
            enabled: enabled,
            onTap: () => onBillPressed(bill),
            theme: theme,
          ),
      ],
    );
  }
}

class _BillButton extends StatefulWidget {
  const _BillButton({
    required this.bill,
    required this.color,
    required this.enabled,
    required this.onTap,
    required this.theme,
  });
  final double bill;
  final Color color;
  final bool enabled;
  final VoidCallback onTap;
  final ThemeData theme;

  @override
  State<_BillButton> createState() => _BillButtonState();
}

class _BillButtonState extends State<_BillButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isEnabled = widget.enabled;
    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _pressed = false) : null,
      onTap: isEnabled ? widget.onTap : null,
      child: AnimatedScale(
        scale: _pressed ? 0.93 : 1.0,
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: Container(
          width: AppSpacing.minTouchTarget + AppSpacing.m,
          height: AppSpacing.minTouchTarget,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: _pressed ? 0.25 : 0.12),
            borderRadius: BorderRadius.circular(AppSpacing.s + 4),
            border: Border.all(
              color: widget.color.withValues(alpha: _pressed ? 0.8 : 0.4),
              width: _pressed ? 2 : 1,
            ),
            boxShadow: _pressed
                ? [
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            '${widget.bill.toInt()} DH',
            style: widget.theme.textTheme.titleMedium?.copyWith(
              color: widget.color,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}
