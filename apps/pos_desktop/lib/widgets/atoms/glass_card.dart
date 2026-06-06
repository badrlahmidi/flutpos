import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Carte glassmorphism — bordure lumineuse + flou d'arrière-plan.
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.l),
    this.maxWidth = 480,
  });

  final Widget child;
  final EdgeInsets padding;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.l),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withValues(alpha: 0.85),
              borderRadius: BorderRadius.circular(AppSpacing.l),
              border: Border.all(
                color: scheme.primary.withValues(alpha: 0.25),
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.08),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Padding(padding: padding, child: child),
          ),
        ),
      ),
    );
  }
}
