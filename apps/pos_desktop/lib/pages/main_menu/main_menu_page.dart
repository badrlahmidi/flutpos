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
    final isDark = theme.brightness == Brightness.dark;
    final isAdmin = _canAccessBackoffice(widget.user);

    final allTiles = <_MenuTileData>[
      _MenuTileData(
        icon: Icons.point_of_sale_rounded,
        label: 'CAISSE (POS)',
        subtitle: 'Prise de commande rapide',
        accent: isDark ? AppColors.accentBlue : AppColors.primary,
        route: '/pos',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.table_bar_rounded,
        label: 'PLAN DE SALLE',
        subtitle: 'Suivi des tables en direct',
        accent: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
        route: '/floor',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.soup_kitchen_rounded,
        label: 'CUISINE (KDS)',
        subtitle: 'Suivi des préparations',
        accent: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
        route: '/kds',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.monitor_heart_rounded,
        label: 'SUIVI TABLES',
        subtitle: 'Statut de préparation & service',
        accent: isDark ? AppColors.accentBlue : AppColors.primary,
        route: '/floor/monitor',
        visible: true,
      ),
      _MenuTileData(
        icon: Icons.menu_book_rounded,
        label: 'CATALOGUE & MENU',
        subtitle: 'Plats, prix et modificateurs',
        accent: isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
        route: '/backoffice/menu/categories',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.account_balance_wallet_rounded,
        label: 'TRÉSORERIE HUB',
        subtitle: 'Sessions & fonds de caisse',
        accent: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
        route: '/backoffice/treasury',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.analytics_rounded,
        label: 'STATISTIQUES',
        subtitle: 'Rapports & CA du restaurant',
        accent: isDark ? AppColors.accentBlue : AppColors.primary,
        route: '/backoffice/analytics',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.calendar_month_rounded,
        label: 'RÉSERVATIONS',
        subtitle: 'Planificateur de réservations',
        accent: isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
        route: '/backoffice/reservations',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.upload_file_rounded,
        label: 'EXPORT COMPTABLE',
        subtitle: 'Rapports financiers DGI',
        accent: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
        route: '/backoffice/accounting',
        visible: isAdmin,
      ),
      _MenuTileData(
        icon: Icons.settings_rounded,
        label: 'PARAMÈTRES',
        subtitle: 'Matériels & configuration',
        accent: isDark ? AppColors.textMuted : const Color(0xFF64748B),
        route: '/backoffice/settings',
        visible: isAdmin,
      ),
    ].where((t) => t.visible).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.scaffoldDark : scheme.surfaceContainerLow,
      body: Stack(
        children: [
          // Subtly glowing radial gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0),
                  radius: 1.3,
                  colors: isDark
                      ? const [
                          Color(0xFF1E2638),
                          Color(0xFF0F1117),
                        ]
                      : [
                          scheme.surfaceContainerLow,
                          scheme.surface,
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
                // ── Daily Stats Bar ───────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l, 0, AppSpacing.l, AppSpacing.s),
                  child: _DailyStatsBar(isDark: isDark, scheme: scheme, theme: theme),
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

// ── Daily Stats Bar ───────────────────────────────────────────────────────────
class _DailyStatsBar extends StatelessWidget {
  const _DailyStatsBar({
    required this.isDark,
    required this.scheme,
    required this.theme,
  });
  final bool isDark;
  final ColorScheme scheme;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('EEEE d MMMM', 'fr_FR').format(DateTime.now());

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.m,
        vertical: AppSpacing.s,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1A1F2E)
            : scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 14,
            color: scheme.onSurfaceVariant,
          ),
          const SizedBox(width: 6),
          Text(
            today,
            style: theme.textTheme.labelMedium?.copyWith(
              color: scheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: AppSpacing.l),
          _StatChip(
            icon: Icons.receipt_long_rounded,
            label: '—',
            hint: 'Commandes',
            color: isDark ? AppColors.accentBlue : const Color(0xFF1D4ED8),
          ),
          const SizedBox(width: AppSpacing.s),
          _StatChip(
            icon: Icons.monetization_on_rounded,
            label: '— DH',
            hint: 'CA jour',
            color: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
          ),
          const SizedBox(width: AppSpacing.s),
          _StatChip(
            icon: Icons.people_rounded,
            label: '—',
            hint: 'Couverts',
            color: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.accentGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.accentGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 7,
                  height: 7,
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accentGreen.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Service actif',
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.accentGreen,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
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

class _StatChip extends StatelessWidget {
  const _StatChip({
    required this.icon,
    required this.label,
    required this.hint,
    required this.color,
  });
  final IconData icon;
  final String label;
  final String hint;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: theme.textTheme.labelSmall?.copyWith(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 12,
              ),
            ),
            Text(
              hint,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 9,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
