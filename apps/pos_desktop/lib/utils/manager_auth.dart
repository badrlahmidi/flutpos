import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../widgets/dialogs/manager_pin_dialog.dart';
import 'pos_permissions.dart';

/// Résout l'autorisation Manager (PIN admin) si nécessaire.
Future<User?> resolveManagerAuthorization(
  BuildContext context,
  User currentUser,
) async {
  if (!PosPermissions.requiresManagerPinToVoidFiredItem(currentUser)) {
    return currentUser;
  }
  return showManagerPinDialog(context);
}
