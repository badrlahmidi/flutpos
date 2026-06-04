import 'package:core/core.dart';
import 'package:flutter/material.dart';

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
        for (final method in methods) ...[
          _MethodTile(
            label: method.label,
            icon: _iconFor(method),
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
}

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.theme,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.primaryContainer,
      borderRadius: BorderRadius.circular(AppSpacing.s),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: AppSpacing.minTouchTarget,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Row(
              children: [
                Icon(icon, color: scheme.onPrimaryContainer),
                const SizedBox(width: AppSpacing.m),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
