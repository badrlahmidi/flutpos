import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../di/service_locator.dart';
import '../navigation/app_session.dart';
import '../theme/app_spacing.dart';
import '../widgets/dialogs/manager_pin_dialog.dart';

/// Vérifie l'accès à une opération (niveau 0-9) avec surpassement PIN manager.
abstract final class SecurityGuard {
  SecurityGuard._();

  /// Retourne l'utilisateur autorisé (session ou PIN manager), ou `null`.
  static Future<User?> authorize(
    BuildContext context,
    String operationKey, {
    User? currentUser,
  }) async {
    final user = currentUser ?? AppSession.instance.user;
    if (user == null) return null;

    final requiredLevel =
        await sl<SecurityRepository>().getRequiredLevel(operationKey);
    if (user.accessLevel >= requiredLevel) {
      return user;
    }

    if (!context.mounted) return null;
    return showManagerPinDialog(
      context,
      requiredLevel: requiredLevel,
      operationLabel: labelFor(operationKey),
    );
  }

  static Future<bool> checkAccess(
    BuildContext context,
    String operationKey, {
    User? currentUser,
  }) async {
    final authorized = await authorize(
      context,
      operationKey,
      currentUser: currentUser,
    );
    return authorized != null;
  }

  static bool hasAccess(User user, int requiredLevel) =>
      user.accessLevel >= requiredLevel;

  static String labelFor(String operationKey) {
    final def = DefaultSecurityRules.definitions
        .where((d) => d.operationKey == operationKey)
        .firstOrNull;
    return def?.label ?? operationKey;
  }

  /// Opération RBAC associée à une route backoffice.
  static String operationForBackofficePath(String path) {
    if (path.startsWith('/backoffice/security')) {
      return SecurityOperations.securityManage;
    }
    if (path.startsWith('/backoffice/settings')) {
      return SecurityOperations.settingsAccess;
    }
    if (path.startsWith('/backoffice/analytics')) {
      return SecurityOperations.analyticsAccess;
    }
    if (path.startsWith('/backoffice/accounting')) {
      return SecurityOperations.analyticsAccess;
    }
    if (path.startsWith('/backoffice/menu')) {
      return SecurityOperations.productsManage;
    }
    if (path.startsWith('/backoffice/treasury/z-close')) {
      return SecurityOperations.closeSession;
    }
    if (path.startsWith('/backoffice/treasury')) {
      return SecurityOperations.backofficeAccess;
    }
    if (path.startsWith('/backoffice/reservations')) {
      return SecurityOperations.backofficeAccess;
    }
    return SecurityOperations.backofficeAccess;
  }
}

/// Bloque l'affichage d'une page backoffice si le niveau d'accès est insuffisant.
class SecurityGate extends StatefulWidget {
  const SecurityGate({
    super.key,
    required this.operationKey,
    required this.child,
  });

  final String operationKey;
  final Widget child;

  @override
  State<SecurityGate> createState() => _SecurityGateState();
}

class _SecurityGateState extends State<SecurityGate> {
  bool _checking = true;
  bool _allowed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void didUpdateWidget(SecurityGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.operationKey != widget.operationKey) {
      setState(() {
        _checking = true;
        _allowed = false;
      });
      _check();
    }
  }

  Future<void> _check() async {
    final ok = await SecurityGuard.checkAccess(context, widget.operationKey);
    if (mounted) {
      setState(() {
        _checking = false;
        _allowed = ok;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Center(child: CircularProgressIndicator());
    }
    if (!_allowed) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                size: 56,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: AppSpacing.m),
              Text(
                'Accès refusé',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Votre niveau d\'accès est insuffisant pour '
                '« ${SecurityGuard.labelFor(widget.operationKey)} ».',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.l),
              FilledButton.icon(
                onPressed: () => Navigator.of(context).canPop()
                    ? Navigator.of(context).pop()
                    : null,
                icon: const Icon(Icons.arrow_back),
                label: const Text('Retour'),
              ),
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}
