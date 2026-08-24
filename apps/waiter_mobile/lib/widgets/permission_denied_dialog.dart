import 'package:flutter/material.dart';

import 'package:permission_handler/permission_handler.dart';

/// Dialog affiché quand la permission caméra est refusée (security fix [MOY-M03]).
class PermissionDeniedDialog {
  PermissionDeniedDialog._();

  /// Affiche le dialog. Si `permanentlyDenied`, propose d'ouvrir les réglages.
  static Future<void> show(BuildContext context,
      {required bool permanentlyDenied}) async {
    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Permission caméra requise'),
        content: Text(permanentlyDenied
            ? 'La permission caméra a été refusée définitivement. '
                'Veuillez l\'activer dans les réglages du système.'
            : 'La permission caméra est nécessaire pour scanner les tables. '
                'Veuillez l\'autoriser pour continuer.'),
        actions: [
          if (!permanentlyDenied)
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Annuler'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.of(ctx).pop();
              if (permanentlyDenied) {
                await openAppSettings();
              }
            },
            child: Text(permanentlyDenied ? 'Ouvrir les réglages' : 'Réessayer'),
          ),
        ],
      ),
    );
  }
}