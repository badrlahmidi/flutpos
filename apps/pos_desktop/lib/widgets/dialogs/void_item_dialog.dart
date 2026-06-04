import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Raison obligatoire pour annuler un article envoyé en cuisine.
Future<String?> showVoidItemReasonDialog(
  BuildContext context, {
  required String productName,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => _VoidItemReasonDialog(productName: productName),
  );
}

class _VoidItemReasonDialog extends StatefulWidget {
  const _VoidItemReasonDialog({required this.productName});

  final String productName;

  @override
  State<_VoidItemReasonDialog> createState() => _VoidItemReasonDialogState();
}

class _VoidItemReasonDialogState extends State<_VoidItemReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _controller.text.trim();
    if (reason.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Indiquez une raison (3 caractères minimum)'),
        ),
      );
      return;
    }
    Navigator.of(context).pop(reason);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Annuler l\'article'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              widget.productName,
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Article déjà envoyé en cuisine — autorisation Manager obligatoire.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _controller,
              autofocus: true,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Raison de l\'annulation',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Continuer'),
        ),
      ],
    );
  }
}
