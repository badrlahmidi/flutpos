import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../navigation/app_session.dart';
import '../../utils/security_guard.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/molecules/sidebar_item.dart';

/// Layout backoffice avec sidebar persistante (260px).
class BackofficeShell extends StatelessWidget {
  const BackofficeShell({super.key, required this.child});

  final Widget child;

  static const _sidebarWidth = 260.0;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).uri.path;
    final user = AppSession.instance.user;

    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? AppColors.scaffoldDark
          : scheme.surfaceContainerLow,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: _sidebarWidth,
            child: ColoredBox(
              color: scheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SidebarHeader(
                    userName: user?.name ?? 'Utilisateur',
                    onBackToMenu: () => context.go('/menu'),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
                      children: [
                        _SidebarGroup(
                          title: 'MENU',
                          items: [
                            SidebarItem(
                              icon: Icons.category_outlined,
                              label: 'Catégories',
                              path: '/backoffice/menu/categories',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.inventory_2_outlined,
                              label: 'Produits',
                              path: '/backoffice/menu/products',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.receipt_long_outlined,
                              label: 'Ingrédients',
                              path: '/backoffice/menu/ingredients',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.tune_outlined,
                              label: 'Modificateurs',
                              path: '/backoffice/menu/modifiers',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.note_alt_outlined,
                              label: 'Notes cuisine',
                              path: '/backoffice/menu/notes',
                              currentPath: location,
                            ),
                          ],
                        ),
                        _SidebarGroup(
                          title: 'FINANCE',
                          items: [
                            SidebarItem(
                              icon: Icons.account_balance_wallet_outlined,
                              label: 'Trésorerie',
                              path: '/backoffice/treasury',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.people_outline,
                              label: 'Clients',
                              path: '/backoffice/customers',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.file_download_outlined,
                              label: 'Export comptable',
                              path: '/backoffice/accounting',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.insights_outlined,
                              label: 'Dashboard',
                              path: '/backoffice/analytics',
                              currentPath: location,
                            ),
                          ],
                        ),
                        _SidebarGroup(
                          title: 'AUTRES',
                          items: [
                            SidebarItem(
                              icon: Icons.event_seat_outlined,
                              label: 'Réservations',
                              path: '/backoffice/reservations',
                              currentPath: location,
                            ),
                            SidebarItem(
                              icon: Icons.settings_outlined,
                              label: 'Paramètres',
                              path: '/backoffice/settings',
                              currentPath: location,
                            ),
                          ],
                        ),
                        _SidebarGroup(
                          title: 'ADMINISTRATION',
                          items: [
                            SidebarItem(
                              icon: Icons.shield_outlined,
                              label: 'Utilisateurs & Sécurité',
                              path: '/backoffice/security',
                              currentPath: location,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(AppSpacing.m),
                    child: Text(
                      'v1.0 · Ritagestion',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          VerticalDivider(width: 1, color: scheme.outline),
          Expanded(
            child: SecurityGate(
              operationKey: SecurityGuard.operationForBackofficePath(location),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarHeader extends StatelessWidget {
  const _SidebarHeader({
    required this.userName,
    required this.onBackToMenu,
  });

  final String userName;
  final VoidCallback onBackToMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton.icon(
            onPressed: onBackToMenu,
            icon: const Icon(Icons.home_outlined, size: 18),
            label: const Text('Retour menu'),
            style: TextButton.styleFrom(
              foregroundColor: scheme.onSurfaceVariant,
              padding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Backoffice',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            userName,
            style: theme.textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}

class _SidebarGroup extends StatelessWidget {
  const _SidebarGroup({required this.title, required this.items});

  final String title;
  final List<SidebarItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.s),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.m,
              AppSpacing.s,
              AppSpacing.m,
              AppSpacing.xs,
            ),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          ...items,
        ],
      ),
    );
  }
}
