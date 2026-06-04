import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Bouton tactile standardisé (cible ≥ 64×64, effet ripple).
class PosButton extends StatelessWidget {
  const PosButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.variant = PosButtonVariant.filled,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final PosButtonVariant variant;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final minSize = const Size(AppSpacing.minTouchTarget, AppSpacing.minTouchTarget);

    final Widget child = icon != null
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: AppSpacing.s),
              Flexible(
                child: Text(
                  label,
                  style: theme.textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          )
        : Text(label, style: theme.textTheme.titleMedium);

    final Widget button = switch (variant) {
      PosButtonVariant.filled => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(minimumSize: minSize),
          child: child,
        ),
      PosButtonVariant.outlined => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(minimumSize: minSize),
          child: child,
        ),
      PosButtonVariant.tonal => FilledButton.tonal(
          onPressed: onPressed,
          style: FilledButton.styleFrom(minimumSize: minSize),
          child: child,
        ),
      PosButtonVariant.text => TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(minimumSize: minSize),
          child: child,
        ),
    };

    if (expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

enum PosButtonVariant { filled, outlined, tonal, text }
