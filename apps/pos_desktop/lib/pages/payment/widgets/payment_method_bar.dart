import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';

/// Boutons rapides de mode de paiement — largeur 64px, animation pression,
/// montant restant affiché dans le label Espèces.
class PaymentMethodBar extends StatelessWidget {
  const PaymentMethodBar({
    super.key,
    required this.onMethodPressed,
    this.enabled = true,
    this.remainingAmount,
  });

  final ValueChanged<PaymentMethod> onMethodPressed;
  final bool enabled;
  final double? remainingAmount;

  static const List<PaymentMethod> methods = [
    PaymentMethod.cash,
    PaymentMethod.tpe,
    PaymentMethod.cheque,
    PaymentMethod.voucher,
    PaymentMethod.employeeMeal,
    PaymentMethod.account,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.payment_rounded,
                size: 16,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Mode de paiement',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        for (final method in methods) ...[
          _MethodTile(
            method: method,
            accent: _accentFor(isDark, method),
            icon: _iconFor(method),
            onTap: enabled ? () => onMethodPressed(method) : null,
            isDark: isDark,
            // Inject remaining amount hint only for CASH button
            amountHint: method == PaymentMethod.cash && remainingAmount != null
                ? PriceFormatter.format(remainingAmount!)
                : null,
          ),
          const SizedBox(height: AppSpacing.s),
        ],
      ],
    );
  }

  IconData _iconFor(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => Icons.payments_rounded,
      PaymentMethod.tpe => Icons.credit_card_rounded,
      PaymentMethod.card => Icons.credit_card_rounded,
      PaymentMethod.cheque => Icons.receipt_long_rounded,
      PaymentMethod.voucher => Icons.card_giftcard_rounded,
      PaymentMethod.employeeMeal => Icons.restaurant_rounded,
      PaymentMethod.account => Icons.account_balance_wallet_rounded,
    };
  }

  Color _accentFor(bool isDark, PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash =>
        isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
      PaymentMethod.tpe =>
        isDark ? AppColors.accentBlue : const Color(0xFF1D4ED8),
      PaymentMethod.card =>
        isDark ? AppColors.accentBlue : const Color(0xFF1D4ED8),
      PaymentMethod.cheque =>
        isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
      PaymentMethod.voucher =>
        isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
      PaymentMethod.employeeMeal =>
        isDark ? AppColors.textMuted : const Color(0xFF64748B),
      PaymentMethod.account =>
        isDark ? const Color(0xFF14B8A6) : const Color(0xFF0F766E), // Teal
    };
  }
}

class _MethodTile extends StatefulWidget {
  const _MethodTile({
    required this.method,
    required this.accent,
    required this.icon,
    required this.isDark,
    this.onTap,
    this.amountHint,
  });

  final PaymentMethod method;
  final Color accent;
  final IconData icon;
  final bool isDark;
  final VoidCallback? onTap;
  final String? amountHint;

  @override
  State<_MethodTile> createState() => _MethodTileState();
}

class _MethodTileState extends State<_MethodTile>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isEnabled = widget.onTap != null;

    return GestureDetector(
      onTapDown: isEnabled ? (_) => setState(() => _pressed = true) : null,
      onTapUp: isEnabled ? (_) => setState(() => _pressed = false) : null,
      onTapCancel: isEnabled ? () => setState(() => _pressed = false) : null,
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: _pressed
                ? widget.accent.withValues(alpha: 0.18)
                : (isEnabled
                    ? (widget.isDark
                        ? const Color(0xFF1E2435)
                        : scheme.surfaceContainerLowest)
                    : scheme.surfaceContainerHighest.withValues(alpha: 0.4)),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isEnabled
                  ? widget.accent.withValues(alpha: _pressed ? 0.7 : 0.35)
                  : scheme.outlineVariant.withValues(alpha: 0.3),
              width: _pressed ? 2 : 1.5,
            ),
            boxShadow: isEnabled && !_pressed
                ? [
                    BoxShadow(
                      color: widget.accent.withValues(alpha: 0.08),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.accent
                      .withValues(alpha: isEnabled ? 0.15 : 0.06),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  widget.icon,
                  color: isEnabled
                      ? widget.accent
                      : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                  size: 22,
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              // Label + amount hint
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.method.label.toUpperCase(),
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: isEnabled
                            ? (widget.isDark
                                ? Colors.white
                                : const Color(0xFF1E293B))
                            : scheme.onSurfaceVariant.withValues(alpha: 0.4),
                        letterSpacing: 0.3,
                        fontSize: 13,
                      ),
                    ),
                    if (widget.amountHint != null)
                      Text(
                        widget.amountHint!,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: widget.accent,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              // Chevron or lock icon
              Icon(
                isEnabled ? Icons.chevron_right_rounded : Icons.lock_outline,
                color: isEnabled
                    ? widget.accent.withValues(alpha: 0.6)
                    : scheme.onSurfaceVariant.withValues(alpha: 0.3),
                size: 22,
              ),
            ],
          ),
        ),
      ),
    )
        .animate(target: _pressed ? 1 : 0)
        .custom(
          duration: 80.ms,
          builder: (context, value, child) => child,
        );
  }
}
