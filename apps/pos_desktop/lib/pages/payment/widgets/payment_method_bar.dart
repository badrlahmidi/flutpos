import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// Boutons rapides de mode de paiement.
class PaymentMethodBar extends StatelessWidget {
  const PaymentMethodBar({
    super.key,
    required this.onMethodPressed,
    this.enabled = true,
  });

  final ValueChanged<PaymentMethod> onMethodPressed;
  final bool enabled;

  static const List<PaymentMethod> methods = [
    PaymentMethod.cash,
    PaymentMethod.tpe,
    PaymentMethod.cheque,
    PaymentMethod.voucher,
    PaymentMethod.employeeMeal,
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Mode de paiement',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.m),
        for (final method in methods) ...[
          _MethodTile(
            label: method.label,
            icon: _iconFor(method),
            accent: _accentFor(method),
            onTap: enabled ? () => onMethodPressed(method) : null,
            theme: theme,
          ),
          const SizedBox(height: AppSpacing.s),
        ],
      ],
    );
  }

  IconData _iconFor(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => Icons.payments_outlined,
      PaymentMethod.tpe => Icons.credit_card,
      PaymentMethod.card => Icons.credit_card,
      PaymentMethod.cheque => Icons.receipt_long,
      PaymentMethod.voucher => Icons.card_giftcard,
      PaymentMethod.employeeMeal => Icons.restaurant,
    };
  }

  Color _accentFor(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => AppColors.accentGreen,
      PaymentMethod.tpe => AppColors.accentBlue,
      PaymentMethod.card => AppColors.accentBlue,
      PaymentMethod.cheque => AppColors.accentPurple,
      PaymentMethod.voucher => AppColors.accentOrange,
      PaymentMethod.employeeMeal => AppColors.textMuted,
    };
  }
}

class _MethodTile extends StatefulWidget {
  const _MethodTile({
    required this.label,
    required this.icon,
    required this.accent,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;
  final ThemeData theme;

  @override
  State<_MethodTile> createState() => _MethodTileState();
}

class _MethodTileState extends State<_MethodTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = widget.theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Material(
        color: _hovered
            ? widget.accent.withValues(alpha: 0.2)
            : AppColors.surfaceElevated,
        borderRadius: BorderRadius.circular(AppSpacing.l),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: widget.onTap,
          child: Container(
            height: AppSpacing.minTouchTarget + 8,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.l),
              border: Border.all(
                color: widget.onTap != null
                    ? widget.accent.withValues(alpha: 0.4)
                    : scheme.outline,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: widget.accent.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.accent, size: 24),
                ),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    widget.label,
                    style: widget.theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
