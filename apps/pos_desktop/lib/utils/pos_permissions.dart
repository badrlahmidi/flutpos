import 'package:core/core.dart';

import '../di/service_locator.dart';
import 'security_guard.dart';

/// Règles RBAC caisse — délègue au moteur niveaux 0-9.
abstract final class PosPermissions {
  PosPermissions._();

  static Future<bool> canApplyDiscount(User user) async {
    final level = await sl<SecurityRepository>()
        .getRequiredLevel(SecurityOperations.applyDiscount);
    return SecurityGuard.hasAccess(user, level);
  }

  static Future<bool> requiresManagerPinToVoidFiredItem(User user) async {
    final level = await sl<SecurityRepository>()
        .getRequiredLevel(SecurityOperations.voidItem);
    return !SecurityGuard.hasAccess(user, level);
  }
}
