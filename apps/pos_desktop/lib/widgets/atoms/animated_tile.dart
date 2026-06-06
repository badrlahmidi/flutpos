import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Tuile menu avec hover scale — MainMenu et grilles similaires.
class AnimatedTile extends StatefulWidget {
  const AnimatedTile({
    super.key,
    required this.icon,
    required this.label,
    required this.accent,
    required this.onTap,
    this.subtitle,
  });

  final IconData icon;
  final String label;
  final String? subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  State<AnimatedTile> createState() => _AnimatedTileState();
}

class _AnimatedTileState extends State<AnimatedTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = widget.accent;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.03 : 1,
        duration: const Duration(milliseconds: 150),
        child: Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(20),
          elevation: _hovered ? 4 : 0,
          shadowColor: accent.withValues(alpha: 0.3),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(20),
            child: Ink(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hovered ? accent : scheme.outline,
                  width: _hovered ? 1.5 : 1,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon, size: 48, color: accent),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    widget.label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  if (widget.subtitle != null &&
                      widget.subtitle!.isNotEmpty) ...[
                    Text(
                      widget.subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
