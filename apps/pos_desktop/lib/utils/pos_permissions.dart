import 'package:core/core.dart';

/// Règles RBAC caisse (cf. `07_security_and_auth.md`).
abstract final class PosPermissions {
  PosPermissions._();

  static bool canApplyDiscountWithoutManagerPin(User user) =>
      user.role == 'ADMIN';

  static bool requiresManagerPinToVoidFiredItem(User user) =>
      user.role != 'ADMIN';
}
