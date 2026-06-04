import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Clavier numérique tactile (cibles ≥ 64×64 px, effet ripple).
class PinNumpad extends StatelessWidget {
  const PinNumpad({
    super.key,
    required this.onDigit,
    required this.onBackspace,
    required this.onClear,
    required this.onSubmit,
    this.enabled = true,
    this.canSubmit = false,
  });

  final ValueChanged<String> onDigit;
  final VoidCallback onBackspace;
  final VoidCallback onClear;
  final VoidCallback onSubmit;
  final bool enabled;
  final bool canSubmit;

  static const double _keySize = AppSpacing.minTouchTarget;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, theme, ['1', '2', '3']),
          const SizedBox(height: AppSpacing.s),
          _buildRow(context, theme, ['4', '5', '6']),
          const SizedBox(height: AppSpacing.s),
          _buildRow(context, theme, ['7', '8', '9']),
          const SizedBox(height: AppSpacing.s),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NumpadKey(
                label: 'C',
                icon: null,
                onPressed: enabled ? onClear : null,
                theme: theme,
                tooltip: 'Effacer',
              ),
              const SizedBox(width: AppSpacing.s),
              _NumpadKey(
                label: '0',
                onPressed: enabled ? () => onDigit('0') : null,
                theme: theme,
              ),
              const SizedBox(width: AppSpacing.s),
              _NumpadKey(
                label: null,
                icon: Icons.backspace_outlined,
                onPressed: enabled ? onBackspace : null,
                theme: theme,
                tooltip: 'Retour',
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          SizedBox(
            width: _keySize * 3 + AppSpacing.s * 2,
            height: _keySize,
            child: FilledButton.icon(
              onPressed: enabled && canSubmit ? onSubmit : null,
              icon: const Icon(Icons.lock_open),
              label: Text(
                'Valider',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    ThemeData theme,
    List<String> digits,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < digits.length; i++) ...[
          if (i > 0) const SizedBox(width: AppSpacing.s),
          _NumpadKey(
            label: digits[i],
            onPressed: enabled ? () => onDigit(digits[i]) : null,
            theme: theme,
          ),
        ],
      ],
    );
  }
}

class _NumpadKey extends StatelessWidget {
  const _NumpadKey({
    required this.theme,
    this.label,
    this.icon,
    this.onPressed,
    this.tooltip,
  });

  final ThemeData theme;
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final scheme = theme.colorScheme;

    return Semantics(
      button: true,
      label: tooltip ?? label,
      child: Material(
        color: scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.s),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: SizedBox(
            width: PinNumpad._keySize,
            height: PinNumpad._keySize,
            child: Center(
              child: icon != null
                  ? Icon(icon, size: 28, color: scheme.onSurface)
                  : Text(
                      label ?? '',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontSize: 28,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
