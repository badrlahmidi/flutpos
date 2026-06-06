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

  static const double _keySize = 68.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildRow(context, theme, ['1', '2', '3']),
          const SizedBox(height: AppSpacing.m),
          _buildRow(context, theme, ['4', '5', '6']),
          const SizedBox(height: AppSpacing.m),
          _buildRow(context, theme, ['7', '8', '9']),
          const SizedBox(height: AppSpacing.m),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NumpadKey(
                label: 'C',
                icon: null,
                onPressed: enabled ? onClear : null,
                theme: theme,
                tooltip: 'Effacer',
                isSpecial: true,
              ),
              const SizedBox(width: AppSpacing.m),
              _NumpadKey(
                label: '0',
                onPressed: enabled ? () => onDigit('0') : null,
                theme: theme,
              ),
              const SizedBox(width: AppSpacing.m),
              _NumpadKey(
                label: null,
                icon: Icons.backspace_outlined,
                onPressed: enabled ? onBackspace : null,
                theme: theme,
                tooltip: 'Retour',
                isSpecial: true,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          SizedBox(
            width: _keySize * 3 + AppSpacing.m * 2,
            height: 54,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: enabled && canSubmit
                    ? LinearGradient(
                        colors: [scheme.primary, scheme.tertiary],
                      )
                    : null,
                boxShadow: enabled && canSubmit
                    ? [
                        BoxShadow(
                          color: scheme.primary.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : null,
              ),
              child: FilledButton.icon(
                onPressed: enabled && canSubmit ? onSubmit : null,
                icon: const Icon(Icons.check_circle_outline, size: 22),
                label: Text(
                  'VALIDER',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: enabled && canSubmit
                        ? Colors.white
                        : theme.colorScheme.onSurface.withValues(alpha: 0.38),
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),
                style: FilledButton.styleFrom(
                  backgroundColor: enabled && canSubmit ? Colors.transparent : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.1),
                  shadowColor: Colors.transparent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
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
          if (i > 0) const SizedBox(width: AppSpacing.m),
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

class _NumpadKey extends StatefulWidget {
  const _NumpadKey({
    required this.theme,
    this.label,
    this.icon,
    this.onPressed,
    this.tooltip,
    this.isSpecial = false,
  });

  final ThemeData theme;
  final String? label;
  final IconData? icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final bool isSpecial;

  @override
  State<_NumpadKey> createState() => _NumpadKeyState();
}

class _NumpadKeyState extends State<_NumpadKey> {
  bool _hovered = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final scheme = widget.theme.colorScheme;
    final enabled = widget.onPressed != null;

    final Color bg;
    if (!enabled) {
      bg = scheme.surface.withValues(alpha: 0.05);
    } else if (_pressed) {
      bg = scheme.primary.withValues(alpha: 0.25);
    } else if (_hovered) {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.4);
    } else {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.15);
    }

    final Color borderCol;
    if (enabled && (_hovered || _pressed)) {
      borderCol = scheme.primary.withValues(alpha: 0.4);
    } else {
      borderCol = scheme.outlineVariant.withValues(alpha: 0.15);
    }

    return Semantics(
      button: true,
      label: widget.tooltip ?? widget.label,
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: PinNumpad._keySize,
            height: PinNumpad._keySize,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: borderCol, width: 1.5),
              boxShadow: enabled && (_hovered || _pressed)
                  ? [
                      BoxShadow(
                        color: scheme.primary.withValues(alpha: 0.1),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: widget.icon != null
                  ? Icon(
                      widget.icon,
                      size: 26,
                      color: enabled
                          ? scheme.onSurface
                          : scheme.onSurface.withValues(alpha: 0.38),
                    )
                  : Text(
                      widget.label ?? '',
                      style: widget.theme.textTheme.headlineMedium?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                        color: enabled
                            ? (widget.isSpecial ? scheme.primary : scheme.onSurface)
                            : scheme.onSurface.withValues(alpha: 0.38),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
