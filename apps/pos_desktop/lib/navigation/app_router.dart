import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../navigation/app_session.dart';
import 'page_transitions.dart';
import '../pages/auth/auth_page.dart';
import '../pages/backoffice/accounting/accounting_export_page.dart';
import '../pages/backoffice/analytics/reporting_page.dart';
import '../pages/backoffice/backoffice_shell.dart';
import '../pages/backoffice/menu_management/categories_page.dart';
import '../pages/backoffice/menu_management/modifiers_page.dart';
import '../pages/backoffice/menu_management/notes_page.dart';
import '../pages/backoffice/menu_management/products_page.dart';
import '../pages/backoffice/menu_management/ingredients_page.dart';
import '../pages/backoffice/treasury/treasury_page.dart';
import '../pages/backoffice/customers/customers_admin_page.dart';
import '../pages/backoffice/security/users_security_page.dart';
import '../pages/backoffice/settings/settings_page.dart';
import '../pages/floor_plan/floor_plan_page.dart';
import '../pages/floor_plan/split_bill_page.dart';
import '../pages/floor_plan/active_table_monitor_page.dart';
import '../pages/kds/kds_page.dart';
import '../pages/main_menu/main_menu_page.dart';
import '../pages/payment/payment_page.dart';
import '../pages/pos/pos_page.dart';
import '../pages/backoffice/reservations/reservations_page.dart';
import '../pages/backoffice/treasury/z_close_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

User _requireUser() {
  final user = AppSession.instance.user;
  if (user == null) {
    throw StateError('Utilisateur non authentifié');
  }
  return user;
}

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  refreshListenable: AppSession.instance,
  initialLocation: '/',
  redirect: (context, state) {
    final loggedIn = AppSession.instance.isAuthenticated;
    final path = state.matchedLocation;
    final isAuthRoute = path == '/';

    if (!loggedIn && !isAuthRoute) {
      return '/';
    }
    if (loggedIn && isAuthRoute) {
      return '/menu';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/',
      pageBuilder: (context, state) => fadeSlidePage(
        state: state,
        child: const AuthPage(),
      ),
    ),
    GoRoute(
      path: '/menu',
      pageBuilder: (context, state) => scaleUpPage(
        state: state,
        child: MainMenuPage(user: _requireUser()),
      ),
    ),
    GoRoute(
      path: '/pos',
      pageBuilder: (context, state) {
        final user = _requireUser();
        return slideLeftPage(
          state: state,
          child: PosPage(
            user: user,
            orderId: state.uri.queryParameters['orderId'],
            tableLabel: state.uri.queryParameters['tableLabel'],
          ),
        );
      },
    ),
    GoRoute(
      path: '/floor',
      pageBuilder: (context, state) => slideLeftPage(
        state: state,
        child: FloorPlanPage(user: _requireUser()),
      ),
    ),
    GoRoute(
      path: '/floor/monitor',
      pageBuilder: (context, state) => slideLeftPage(
        state: state,
        child: ActiveTableMonitorPage(user: _requireUser()),
      ),
    ),
    GoRoute(
      path: '/kds',
      pageBuilder: (context, state) => slideLeftPage(
        state: state,
        child: const KdsPage(),
      ),
    ),
    GoRoute(
      path: '/payment/:orderId',
      pageBuilder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return slideLeftPage(
          state: state,
          child: PaymentPage(orderId: orderId, user: _requireUser()),
        );
      },
    ),
    GoRoute(
      path: '/treasury',
      pageBuilder: (context, state) => scaleUpPage(
        state: state,
        child: Scaffold(
          body: TreasuryPage(
            user: _requireUser(),
            embeddedInShell: false,
          ),
        ),
      ),
    ),
    GoRoute(
      path: '/z-close',
      pageBuilder: (context, state) {
        final extra = state.extra;
        if (extra is! ZCloseRouteArgs) {
          return scaleUpPage(
            state: state,
            child: const Scaffold(
              body: Center(child: Text('Paramètres clôture manquants')),
            ),
          );
        }
        return scaleUpPage(
          state: state,
          child: ZClosePage(user: extra.user, report: extra.report),
        );
      },
    ),
    GoRoute(
      path: '/split-bill',
      pageBuilder: (context, state) {
        final orderId = state.uri.queryParameters['orderId'];
        final tableName = state.uri.queryParameters['tableName'] ?? '';
        if (orderId == null) {
          return scaleUpPage(
            state: state,
            child: const Scaffold(
              body: Center(child: Text('Commande introuvable')),
            ),
          );
        }
        return scaleUpPage(
          state: state,
          child: SplitBillPage(
            sourceOrderId: orderId,
            tableName: tableName,
          ),
        );
      },
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => BackofficeShell(child: child),
      routes: [
        GoRoute(
          path: '/backoffice/menu/categories',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const CategoriesPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/menu/products',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const ProductsPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/menu/modifiers',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const ModifiersPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/menu/notes',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const NotesPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/menu/ingredients',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const IngredientsPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/treasury',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: TreasuryPage(
              user: _requireUser(),
              embeddedInShell: true,
            ),
          ),
        ),
        GoRoute(
          path: '/backoffice/customers',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const CustomersAdminPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/treasury/z-close',
          pageBuilder: (context, state) {
            final extra = state.extra;
            if (extra is! ZCloseRouteArgs) {
              return fadeThroughPage(
                state: state,
                child: const Center(
                  child: Text('Accédez via la trésorerie pour la clôture Z'),
                ),
              );
            }
            return fadeThroughPage(
              state: state,
              child: ZClosePage(
                user: extra.user,
                report: extra.report,
                embeddedInShell: true,
              ),
            );
          },
        ),
        GoRoute(
          path: '/backoffice/analytics',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const ReportingPage(
              embeddedInShell: true,
            ),
          ),
        ),
        GoRoute(
          path: '/backoffice/accounting',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const AccountingExportPage(
              embeddedInShell: true,
            ),
          ),
        ),
        GoRoute(
          path: '/backoffice/reservations',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: ReservationsPage(
              user: _requireUser(),
              embeddedInShell: true,
            ),
          ),
        ),
        GoRoute(
          path: '/backoffice/settings',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const SettingsPage(),
          ),
        ),
        GoRoute(
          path: '/backoffice/security',
          pageBuilder: (context, state) => fadeThroughPage(
            state: state,
            child: const UsersSecurityPage(),
          ),
        ),
      ],
    ),
  ],
);

/// Arguments pour la route clôture Z.
class ZCloseRouteArgs {
  const ZCloseRouteArgs({required this.user, required this.report});

  final User user;
  final CashSessionReport report;
}
