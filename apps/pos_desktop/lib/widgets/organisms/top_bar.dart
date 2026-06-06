import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';

/// Barre supérieure réutilisable (plan de salle, KDS, modules fullscreen).
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    this.icon = Icons.grid_view_rounded,
    this.onHome,
    this.actions = const [],
  });

  final String title;
  final IconData icon;
  final VoidCallback? onHome;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: PosDesignTokens.cardBackground,
        border: Border(bottom: BorderSide(color: scheme.outline)),
        boxShadow: PosDesignTokens.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          if (onHome != null)
            IconButton(
              tooltip: 'Menu principal',
              onPressed: onHome,
              icon: Icon(Icons.home_outlined, color: scheme.primary),
            ),
          Icon(icon, color: scheme.primary, size: 26),
          const SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: scheme.onSurface,
            ),
          ),
          const Spacer(),
          ...actions,
        ],
      ),
    );
  }
}
