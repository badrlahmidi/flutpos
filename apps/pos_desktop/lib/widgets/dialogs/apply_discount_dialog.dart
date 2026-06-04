import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/app_spacing.dart';

/// Saisie remise globale (% ou montant fixe MAD).
class ApplyDiscountRequest {
  const ApplyDiscountRequest({
    required this.discountType,
    required this.discountValue,
    required this.reason,
  });

  final DiscountType discountType;
  final double discountValue;
  final String reason;
}

Future<ApplyDiscountRequest?> showApplyDiscountDialog(
  BuildContext context, {
  required double maxFixedAmount,
}) {
  return showDialog<ApplyDiscountRequest>(
    context: context,
    builder: (_) => _ApplyDiscountDialog(maxFixedAmount: maxFixedAmount),
  );
}

class _ApplyDiscountDialog extends StatefulWidget {
  const _ApplyDiscountDialog({required this.maxFixedAmount});

  final double maxFixedAmount;

  @override
  State<_ApplyDiscountDialog> createState() => _ApplyDiscountDialogState();
}

class _ApplyDiscountDialogState extends State<_ApplyDiscountDialog> {
  DiscountType _type = DiscountType.percentage;
  final _valueController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _valueController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final rawValue = _valueController.text.trim().replaceAll(',', '.');
    final value = double.tryParse(rawValue);
    final reason = _reasonController.text.trim();

    if (value == null || value <= 0) {
      _showError('Montant ou pourcentage invalide');
      return;
    }
    if (reason.length < 3) {
      _showError('Indiquez une raison (3 caractères min.)');
      return;
    }
    if (_type == DiscountType.percentage && value > 100) {
      _showError('Le pourcentage ne peut dépasser 100 %');
      return;
    }
    if (_type == DiscountType.fixedAmount && value > widget.maxFixedAmount) {
      _showError('Remise supérieure au sous-total');
      return;
    }

    Navigator.of(context).pop(
      ApplyDiscountRequest(
        discountType: _type,
        discountValue: value,
        reason: reason,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: const Text('Remise globale'),
      content: SizedBox(
        width: 440,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SegmentedButton<DiscountType>(
              segments: const [
                ButtonSegment(
                  value: DiscountType.percentage,
                  label: Text('%'),
                  icon: Icon(Icons.percent),
                ),
                ButtonSegment(
                  value: DiscountType.fixedAmount,
                  label: Text('MAD'),
                  icon: Icon(Icons.payments_outlined),
                ),
              ],
              selected: {_type},
              onSelectionChanged: (set) {
                if (set.isNotEmpty) {
                  setState(() => _type = set.first);
                }
              },
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _valueController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
              ],
              decoration: InputDecoration(
                labelText: _type == DiscountType.percentage
                    ? 'Pourcentage'
                    : 'Montant (MAD)',
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _reasonController,
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Raison',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Autorisation Manager requise (sauf administrateur)',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
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
