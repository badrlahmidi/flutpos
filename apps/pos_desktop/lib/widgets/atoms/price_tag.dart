import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';

/// Affichage prix MAD (`XX,XX DH`).
class PriceTag extends StatelessWidget {
  const PriceTag({
    super.key,
    required this.amount,
    this.emphasized = false,
    this.align = TextAlign.start,
  });

  final double amount;
  final bool emphasized;
  final TextAlign align;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final style = emphasized
        ? theme.textTheme.headlineLarge?.copyWith(
            fontSize: 20,
            color: scheme.primary,
          )
        : theme.textTheme.titleMedium?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w700,
          );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Text(
        PriceFormatter.format(amount),
        textAlign: align,
        style: style,
      ),
    );
  }
}
