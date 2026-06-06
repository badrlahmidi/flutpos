import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../navigation/app_session.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/atoms/animated_tile.dart';

/// Menu principal — tuiles par module (post-authentification).
class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key, required this.user});

  final User user;

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  static final _timeFormat = DateFormat('HH:mm', 'fr_FR');
  late Timer _clockTimer;
  String _currentTime = _timeFormat.format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) {
        setState(() {
          _currentTime = _timeFormat.format(DateTime.now());
        });
      }
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  void _lock() {
    AppSession.instance.clear();
    context.go('/');
  }

  bool _canAccessBackoffice(User user) => user.accessLevel >= 7;



  Widget _buildTilesGrid(List<_MenuTileData> tiles) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: AppSpacing.l,
        crossAxisSpacing: AppSpacing.l,
        childAspectRatio: 1.35,
      ),
      itemCount: tiles.length,
      itemBuilder: (context, index) {
        final tile = tiles[index];
        return AnimatedTile(
          icon: tile.icon,
          label: tile.label,
          subtitle: tile.subtitle.isEmpty ? null : tile.subtitle,
          accent: tile.accent,
          onTap: () => context.go(tile.route),
        )
            .animate(delay: Duration(milliseconds: index * 40))
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isAdmin = _canAccessBackoffice(widget.user);

    final allTiles = <_MenuTileData>[
      _MenuTileData(
        icon: Icons.point_of_sale_rounded,
        label: 'CAISSE (POS)',
        subtitle: 'Prise de commande rapide',
        accent: AppColors.accentBlue,
        route: '/pos',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.table_bar_rounded,
        label: 'PLAN DE SALLE',
        subtitle: 'Suivi des tables en direct',
        accent: AppColors.accentOrange,
        route: '/floor',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.soup_kitchen_rounded,
        label: 'CUISINE (KDS)',
        subtitle: 'Suivi des préparations',
        accent: AppColors.accentGreen,
        route: '/kds',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.menu_book_rounded,
        label: 'CATALOGUE & MENU',
        subtitle: 'Plats, prix et modificateurs',
        accent: AppColors.accentPurple,
        route: '/backoffice/menu/categories',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.account_balance_wallet_rounded,
        label: 'TRÉSORERIE HUB',
        subtitle: 'Sessions & fonds de caisse',
        accent: AppColors.accentOrange,
        route: '/backoffice/treasury',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.analytics_rounded,
        label: 'STATISTIQUES',
        subtitle: 'Rapports & CA du restaurant',
        accent: AppColors.accentBlue,
        route: '/backoffice/analytics',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.calendar_month_rounded,
        label: 'RÉSERVATIONS',
        subtitle: 'Planificateur de réservations',
        accent: AppColors.accentPurple,
        route: '/backoffice/reservations',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.upload_file_rounded,
        label: 'EXPORT COMPTABLE',
        subtitle: 'Rapports financiers DGI',
        accent: AppColors.accentGreen,
        route: '/backoffice/accounting',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.settings_rounded,
        label: 'PARAMÈTRES',
        subtitle: 'Matériels & configuration',
        accent: AppColors.textMuted,
        route: '/backoffice/settings',
        visible: isAdmin,
      ),
    ].where((t) => t.visible).toList();

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Stack(
        children: [
          // Subtly glowing radial gradient background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, 0),
                  radius: 1.3,
                  colors: [
                    Color(0xFF1E2638),
                    Color(0xFF0F1117),
                  ],
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Premium header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.l,
                    AppSpacing.l,
                    AppSpacing.s,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: scheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: scheme.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.storefront_rounded,
                              size: 18,
                              color: scheme.primary,
                            ),
                            const SizedBox(width: AppSpacing.s),
                            Text(
                              'RITAGESTION POS',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 1.2,
                                color: scheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.xs),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: scheme.surfaceContainerHighest,
                            ),
                            child: Icon(
                              Icons.person_outline_rounded,
                              size: 18,
                              color: scheme.onSurface,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.s),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                widget.user.name,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                widget.user.role.toUpperCase(),
                                style: theme.textTheme.labelSmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: AppSpacing.l),
                      IconButton(
                        tooltip: 'Verrouiller la session',
                        style: IconButton.styleFrom(
                          backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _lock,
                        icon: const Icon(Icons.lock_outline_rounded),
                      ),
                      const SizedBox(width: AppSpacing.m),
                      Text(
                        _currentTime,
                        style: theme.textTheme.titleMedium?.copyWith(
                           fontFeatures: const [FontFeature.tabularFigures()],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                // Centered Main Content
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m,
                      ),
                      child: Container(
                        constraints: const BoxConstraints(maxWidth: 820),
                        child: _buildTilesGrid(allTiles),
                      ),
                    ),
                  ),
                ),
                // Footer
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l,
                    vertical: AppSpacing.m,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.circle, size: 8, color: AppColors.accentGreen),
                      const SizedBox(width: AppSpacing.s),
                      Text(
                        'En ligne · Service Local Actif',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Ritagestion POS v3.40 · Mode Hybride Offline-First',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MenuTileData {
  const _MenuTileData({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.accent,
    required this.route,
    required this.visible,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color accent;
  final String route;
  final bool visible;
}
