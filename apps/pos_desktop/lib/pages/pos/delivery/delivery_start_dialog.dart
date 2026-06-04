import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';

/// Saisie rapide source livreur + référence externe.
Future<({OrderSource source, String? externalRef})?> showDeliveryStartDialog(
  BuildContext context, {
  OrderSource initialSource = OrderSource.glovo,
}) {
  return showDialog<({OrderSource source, String? externalRef})>(
    context: context,
    builder: (ctx) => _DeliveryStartDialog(initialSource: initialSource),
  );
}

class _DeliveryStartDialog extends StatefulWidget {
  const _DeliveryStartDialog({required this.initialSource});

  final OrderSource initialSource;

  @override
  State<_DeliveryStartDialog> createState() => _DeliveryStartDialogState();
}

class _DeliveryStartDialogState extends State<_DeliveryStartDialog> {
  late OrderSource _source;
  final _refController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _source = widget.initialSource;
  }

  String _previewLabel() {
    final ref = _refController.text.trim();
    if (ref.isEmpty) {
      return '${_source.emoji} ${_source.label.toUpperCase()}';
    }
    return '${_source.emoji} ${_source.label.toUpperCase()} #$ref';
  }

  @override
  void dispose() {
    _refController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return AlertDialog(
      title: const Text('Nouvelle livraison'),
      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Source', style: theme.textTheme.titleSmall),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final source in [
                  OrderSource.glovo,
                  OrderSource.deliveroo,
                ])
                  ChoiceChip(
                    label: Text('${source.emoji} ${source.label}'),
                    selected: _source == source,
                    onSelected: (_) => setState(() => _source = source),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.m),
            TextField(
              controller: _refController,
              decoration: InputDecoration(
                labelText: 'N° commande (optionnel)',
                hintText: 'ex: 1455',
                prefixText: _source == OrderSource.glovo ? '# ' : null,
              ),
              keyboardType: TextInputType.text,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Ticket cuisine : ${_previewLabel()}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
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
        PosButton(
          label: 'OUVRIR',
          onPressed: () {
            final ref = _refController.text.trim();
            Navigator.of(context).pop((
              source: _source,
              externalRef: ref.isEmpty ? null : ref,
            ));
          },
        ),
      ],
    );
  }
}
