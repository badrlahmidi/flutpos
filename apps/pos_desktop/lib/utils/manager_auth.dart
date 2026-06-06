import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'security_guard.dart';

/// Résout l'autorisation Manager (PIN) si nécessaire pour annuler un article envoyé.
Future<User?> resolveManagerAuthorization(
  BuildContext context,
  User currentUser,
) {
  return SecurityGuard.authorize(
    context,
    SecurityOperations.voidItem,
    currentUser: currentUser,
  );
}
