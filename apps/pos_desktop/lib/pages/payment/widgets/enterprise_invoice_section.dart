import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';

/// Toggle + saisie nom / ICE pour facture entreprise.
class EnterpriseInvoiceSection extends StatefulWidget {
  const EnterpriseInvoiceSection({
    super.key,
    required this.orderId,
    required this.order,
    required this.enabled,
    this.onValidationError,
  });

  final String orderId;
  final Order order;
  final bool enabled;
  final ValueChanged<String>? onValidationError;

  @override
  State<EnterpriseInvoiceSection> createState() =>
      EnterpriseInvoiceSectionState();
}

class EnterpriseInvoiceSectionState extends State<EnterpriseInvoiceSection> {
  bool _invoiceEnabled = false;
  final _nameController = TextEditingController();
  final _iceController = TextEditingController();
  int? _nextInvoicePreview;

  @override
  void initState() {
    super.initState();
    final order = widget.order;
    if (order.companyIce != null && order.companyIce!.isNotEmpty) {
      _invoiceEnabled = true;
      _nameController.text = order.companyName ?? '';
      _iceController.text = order.companyIce ?? '';
    }
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    final next = await sl<OrderRepository>().peekNextInvoiceNumber();
    if (mounted) {
      setState(() => _nextInvoicePreview = next);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _iceController.dispose();
    super.dispose();
  }

  bool get isEnabled => _invoiceEnabled;

  /// Persiste ou efface la facture avant paiement.
  Future<bool> persistInvoiceData() async {
    final repo = sl<OrderRepository>();
    if (!_invoiceEnabled) {
      await repo.clearEnterpriseInvoice(widget.orderId);
      return true;
    }

    final name = _nameController.text.trim();
    final ice = _iceController.text.trim();
    if (name.length < 2) {
      widget.onValidationError?.call('Nom entreprise requis');
      return false;
    }
    final iceMsg = MoroccanIce.validationMessage(ice);
    if (iceMsg != null) {
      widget.onValidationError?.call(iceMsg);
      return false;
    }

    try {
      await repo.setEnterpriseInvoice(
        orderId: widget.orderId,
        companyName: name,
        companyIce: ice,
      );
      return true;
    } catch (e) {
      widget.onValidationError?.call(e.toString());
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s,
          vertical: AppSpacing.xs,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Facture avec ICE',
                style: theme.textTheme.titleMedium,
              ),
              subtitle: _nextInvoicePreview != null
                  ? Text(
                      'Prochain n° : $_nextInvoicePreview',
                      style: theme.textTheme.labelSmall,
                    )
                  : null,
              value: _invoiceEnabled,
              onChanged: widget.enabled
                  ? (value) async {
                      setState(() => _invoiceEnabled = value);
                      if (!value) {
                        await sl<OrderRepository>()
                            .clearEnterpriseInvoice(widget.orderId);
                      }
                    }
                  : null,
            ),
            if (_invoiceEnabled) ...[
              TextField(
                enabled: widget.enabled,
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom entreprise',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              TextField(
                enabled: widget.enabled,
                controller: _iceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'ICE client (15 chiffres)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'ICE restaurant affiché sur la facture (config. établissement)',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
