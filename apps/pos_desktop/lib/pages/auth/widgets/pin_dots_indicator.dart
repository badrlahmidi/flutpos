import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

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
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(maxLength, (index) {
          final filled = index < filledCount;
          final isLatest = filled && index == filledCount - 1;

          Widget dot = AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: isLatest ? AppSpacing.m + 2 : AppSpacing.m,
            height: isLatest ? AppSpacing.m + 2 : AppSpacing.m,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: filled ? scheme.primary : scheme.surfaceContainerHighest,
              border: Border.all(
                color: filled ? scheme.primary : scheme.outline,
                width: 2,
              ),
              boxShadow: filled
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.45),
                        blurRadius: isLatest ? 10 : 4,
                      ),
                    ]
                  : null,
            ),
          );

          if (isLatest && !isLoading) {
            dot = dot
                .animate(key: ValueKey('pin-$filledCount'))
                .scale(
                  begin: const Offset(0.6, 0.6),
                  end: const Offset(1, 1),
                  duration: 250.ms,
                  curve: Curves.elasticOut,
                );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
            child: dot,
          );
        }),
      ),
    );
  }
}
