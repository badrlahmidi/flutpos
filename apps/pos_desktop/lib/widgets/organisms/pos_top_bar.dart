import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';
import '../molecules/service_mode_toggle.dart';

enum PosWorkspace { register, deliveries }

/// Barre supérieure — maquette Ritaj POS.
class PosTopBar extends StatelessWidget {
  const PosTopBar({
    super.key,
    required this.lanOnline,
    required this.clientCount,
    required this.workspace,
    required this.onWorkspaceSelected,
    required this.onSync,
    required this.onPrint,
    required this.onHistory,
    required this.onSettings,
    required this.onLanguageToggle,
    required this.onServiceModeChanged,
    this.onHome,
  });

  final bool lanOnline;
  final int clientCount;
  final PosWorkspace workspace;
  final ValueChanged<PosWorkspace> onWorkspaceSelected;
  final VoidCallback onSync;
  final VoidCallback onPrint;
  final VoidCallback onHistory;
  final VoidCallback onSettings;
  final VoidCallback onLanguageToggle;
  final ValueChanged<ServiceMode> onServiceModeChanged;
  final VoidCallback? onHome;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: PosDesignTokens.cardBackground,
        border: Border(bottom: BorderSide(color: PosDesignTokens.borderLight)),
        boxShadow: PosDesignTokens.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          if (onHome != null)
            IconButton(
              tooltip: 'Menu principal',
              onPressed: onHome,
              icon: Icon(Icons.home_outlined, color: PosDesignTokens.primaryBlue),
            ),
          Icon(Icons.storefront, color: PosDesignTokens.primaryBlue, size: 28),
          const SizedBox(width: 10),
          const Text(
            'RITAGESTION POS',
            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(width: 12),
          _StatusPill(online: lanOnline, clientCount: clientCount),
          const Spacer(),
          _ModeCaisseMenu(
            workspace: workspace,
            onSelected: onWorkspaceSelected,
          ),
          const Spacer(),
          ServiceModeToggle(onModeChanged: onServiceModeChanged),
          const SizedBox(width: 4),
          _TopIcon(
            tooltip: 'Synchroniser',
            icon: Icons.cloud_sync_outlined,
            badge: lanOnline,
            onPressed: onSync,
          ),
          _TopIcon(tooltip: 'Imprimer', icon: Icons.print_outlined, onPressed: onPrint),
          _TopIcon(tooltip: 'Historique', icon: Icons.history, onPressed: onHistory),
          _TopIcon(tooltip: 'Paramètres', icon: Icons.settings_outlined, onPressed: onSettings),
          const SizedBox(width: 8),
          Material(
            color: PosDesignTokens.shellBackground,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: onLanguageToggle,
              customBorder: const CircleBorder(),
              child: SizedBox(
                width: 40,
                height: 40,
                child: Center(
                  child: Text(
                    'AR',
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.online, required this.clientCount});

  final bool online;
  final int clientCount;

  @override
  Widget build(BuildContext context) {
    final color = online ? PosDesignTokens.stockGreen : PosDesignTokens.offlineRed;
    final label = online ? 'En ligne · $clientCount' : 'Hors ligne';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 8, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _ModeCaisseMenu extends StatelessWidget {
  const _ModeCaisseMenu({
    required this.workspace,
    required this.onSelected,
  });

  final PosWorkspace workspace;
  final ValueChanged<PosWorkspace> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<PosWorkspace>(
      onSelected: onSelected,
      itemBuilder: (_) => [
        const PopupMenuItem(
          value: PosWorkspace.register,
          child: Text('Mode caisse'),
        ),
        const PopupMenuItem(
          value: PosWorkspace.deliveries,
          child: Text('Livraisons'),
        ),
      ],
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: PosDesignTokens.primaryBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.point_of_sale, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              workspace == PosWorkspace.register ? 'MODE CAISSE' : 'LIVRAISONS',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            const Icon(Icons.expand_more, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}

class _TopIcon extends StatelessWidget {
  const _TopIcon({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
    this.badge = false,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;
  final bool badge;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Badge(
        isLabelVisible: badge,
        smallSize: 8,
        child: Icon(icon, color: PosDesignTokens.textMuted),
      ),
    );
  }
}
