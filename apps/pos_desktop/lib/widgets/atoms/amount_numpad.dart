import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';

/// Pavé numérique montants (≥ 64 px, virgule décimale).
class AmountNumpad extends StatelessWidget {
  const AmountNumpad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    this.enabled = true,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final bool enabled;

  static const double _keySize = AppSpacing.minTouchTarget + 4;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _row(context, theme, const ['1', '2', '3']),
          const SizedBox(height: AppSpacing.s),
          _row(context, theme, const ['4', '5', '6']),
          const SizedBox(height: AppSpacing.s),
          _row(context, theme, const ['7', '8', '9']),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _key(theme, label: 'C', onTap: onClear, tooltip: 'Effacer'),
              const SizedBox(width: AppSpacing.s),
              _key(theme, label: '0', onTap: () => onDigit('0')),
              const SizedBox(width: AppSpacing.s),
              _key(theme, label: ',', onTap: () => onDigit(',')),
              const SizedBox(width: AppSpacing.s),
              _key(
                theme,
                icon: Icons.backspace_outlined,
                onTap: onBackspace,
                tooltip: 'Retour',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(BuildContext context, ThemeData theme, List<String> digits) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < digits.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s),
          _key(theme, label: digits[i], onTap: () => onDigit(digits[i])),
        ],
      ],
    );
  }

  Widget _key(
    ThemeData theme, {
    String? label,
    IconData? icon,
    VoidCallback? onTap,
    String? tooltip,
  }) {
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: tooltip ?? label,
      child: Material(
        color: scheme.brightness == Brightness.dark
            ? AppColors.surfaceElevated
            : scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppSpacing.s + 4),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: enabled ? onTap : null,
          splashColor: scheme.primary.withValues(alpha: 0.15),
          child: SizedBox(
            width: _keySize,
            height: _keySize,
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 28, color: scheme.onSurface)
                  : Text(
                      label ?? '',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
