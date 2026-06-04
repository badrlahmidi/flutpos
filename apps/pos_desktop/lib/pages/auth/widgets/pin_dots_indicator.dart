import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Indicateur visuel du PIN masqué (points remplis / vides).
class PinDotsIndicator extends StatelessWidget {
  const PinDotsIndicator({
    super.key,
    required this.filledCount,
    required this.maxLength,
    this.isLoading = false,
  });

  final int filledCount;
  final int maxLength;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxLength, (index) {
          final filled = index < filledCount;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: AppSpacing.m,
              height: AppSpacing.m,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: filled
                    ? scheme.primary
                    : scheme.surfaceContainerHighest,
                border: Border.all(
                  color: filled ? scheme.primary : scheme.outline,
                  width: 2,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
