import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../theme/app_spacing.dart';

enum CashMovementType { payIn, payOut }

/// Saisie pay-in / pay-out (montant + raison).
Future<CashMovementRequest?> showCashMovementDialog(
  BuildContext context, {
  required CashMovementType type,
}) {
  return showDialog<CashMovementRequest>(
    context: context,
    builder: (_) => _CashMovementDialog(type: type),
  );
}

class CashMovementRequest {
  const CashMovementRequest({
    required this.type,
    required this.amount,
    required this.reason,
  });

  final CashMovementType type;
  final double amount;
  final String reason;
}

class _CashMovementDialog extends StatefulWidget {
  const _CashMovementDialog({required this.type});

  final CashMovementType type;

  @override
  State<_CashMovementDialog> createState() => _CashMovementDialogState();
}

class _CashMovementDialogState extends State<_CashMovementDialog> {
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final amount =
        double.tryParse(_amountController.text.trim().replaceAll(',', '.'));
    final reason = _reasonController.text.trim();
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Montant invalide')),
      );
      return;
    }
    if (reason.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Raison obligatoire (3 car. min.)')),
      );
      return;
    }
    Navigator.of(context).pop(
      CashMovementRequest(
        type: widget.type,
        amount: amount,
        reason: reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isIn = widget.type == CashMovementType.payIn;
    final title = isIn ? 'Entrée de caisse (Pay-in)' : 'Sortie de caisse (Pay-out)';

    return AlertDialog(
      title: Text(title),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _amountController,
              autofocus: true,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: const InputDecoration(
                labelText: 'Montant (MAD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: isIn ? 'Motif entrée' : 'Motif sortie',
                hintText: isIn ? 'Ex. Apport monnaie' : 'Ex. Achat fournitures',
                border: const OutlineInputBorder(),
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
