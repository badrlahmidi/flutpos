import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_spacing.dart';

/// Saisie du fond de caisse initial (ouverture session).
Future<double?> showOpenSessionDialog(BuildContext context) {
  return showDialog<double>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _OpenSessionDialog(),
  );
}

class _OpenSessionDialog extends StatefulWidget {
  const _OpenSessionDialog();

  @override
  State<_OpenSessionDialog> createState() => _OpenSessionDialogState();
}

class _OpenSessionDialogState extends State<_OpenSessionDialog> {
  final _controller = TextEditingController(text: '0');

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value =
        double.tryParse(_controller.text.trim().replaceAll(',', '.'));
    if (value == null || value < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Montant invalide')),
      );
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Ouverture de caisse'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Fond de caisse initial (espèces dans le tiroir)',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _controller,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Montant (MAD)',
                suffixText: 'DH',
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
          child: const Text('Ouvrir la session'),
        ),
      ],
    );
  }
}
