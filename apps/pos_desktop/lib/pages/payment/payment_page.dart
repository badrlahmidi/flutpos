import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/payment/payment_bloc.dart';
import '../../blocs/payment/payment_event.dart';
import '../../blocs/payment/payment_state.dart';
import '../../di/service_locator.dart';
import '../../services/print/pos_print_service.dart';
import '../../utils/manager_auth.dart';
import '../../widgets/dialogs/apply_discount_dialog.dart';
import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';
import '../../widgets/atoms/amount_numpad.dart';
import '../../widgets/atoms/pos_button.dart';
import '../../widgets/atoms/price_tag.dart';
import 'widgets/enterprise_invoice_section.dart';
import 'widgets/mad_quick_bills.dart';
import 'widgets/payment_method_bar.dart';

/// Écran d'encaissement (split, monnaie MAD, multi-paiements).
class PaymentPage extends StatelessWidget {
  const PaymentPage({
    super.key,
    required this.orderId,
    required this.user,
  });

  final String orderId;
  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PaymentBloc(orderRepository: sl<OrderRepository>())
        ..add(PaymentStarted(orderId)),
      child: _PaymentView(user: user),
    );
  }
}

Future<void> _onCashDrawerPulse(BuildContext context) async {
  final result = await sl<PosPrintService>().openCashDrawer();
  if (!context.mounted) {
    return;
  }
  context.read<PaymentBloc>().add(const PaymentCashDrawerHandled());
  if (!result.ok && result.error != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(result.error!)),
    );
  }
}

Future<void> _onPaymentCompleted(
  BuildContext context,
  PaymentSuccess state,
) async {
  final printService = sl<PosPrintService>();
  final orderRepo = sl<OrderRepository>();
  final fresh =
      await orderRepo.getCompleteOrder(state.order.order.id) ?? state.order;
  final isEnterpriseInvoice =
      fresh.order.companyIce != null && fresh.order.companyIce!.isNotEmpty;

  final receipt = isEnterpriseInvoice
      ? await printService.printEnterpriseInvoice(fresh)
      : await printService.printCustomerReceipt(fresh);
  if (state.openCashDrawer) {
    await printService.openCashDrawer();
  }

  if (!context.mounted) {
    return;
  }

  final message = receipt.ok
      ? (receipt.simulated
          ? (isEnterpriseInvoice
              ? 'Facture ICE — simulation (console / logs)'
              : 'Reçu client — simulation (console / logs)')
          : (isEnterpriseInvoice
              ? 'Facture ICE imprimée'
              : 'Reçu client imprimé'))
      : (receipt.error ?? 'Erreur impression');
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
  Navigator.of(context).pop(true);
}

class _PaymentView extends StatelessWidget {
  const _PaymentView({required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listenWhen: (prev, curr) =>
          curr is PaymentSuccess ||
          (curr is PaymentReady &&
              curr.pendingCashDrawer &&
              (prev is! PaymentReady || !prev.pendingCashDrawer)),
      listener: (context, state) {
        if (state is PaymentReady && state.pendingCashDrawer) {
          _onCashDrawerPulse(context);
          return;
        }
        if (state is PaymentSuccess) {
          _onPaymentCompleted(context, state);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Encaissement'),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(false),
            ),
          ),
          body: switch (state) {
            PaymentLoading() || PaymentInitial() =>
              const Center(child: CircularProgressIndicator()),
            PaymentFailure(:final message) => _ErrorView(message: message),
            PaymentReady ready => _ReadyView(ready: ready, user: user),
            PaymentSuccess() =>
              const Center(child: CircularProgressIndicator()),
          },
        );
      },
    );
  }
}

class _ReadyView extends StatefulWidget {
  const _ReadyView({required this.ready, required this.user});

  final PaymentReady ready;
  final User user;

  @override
  State<_ReadyView> createState() => _ReadyViewState();
}

class _ReadyViewState extends State<_ReadyView> {
  final _invoiceSectionKey = GlobalKey<EnterpriseInvoiceSectionState>();

  Future<void> _onPaymentMethod(PaymentMethod method) async {
    final section = _invoiceSectionKey.currentState;
    if (section != null) {
      final ok = await section.persistInvoiceData();
      if (!ok) {
        return;
      }
    }

    if (!mounted) {
      return;
    }
    context.read<PaymentBloc>().add(PaymentMethodPressed(method));
  }

  void _showInvoiceError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ready = widget.ready;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bloc = context.read<PaymentBloc>();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Montant saisi', style: theme.textTheme.titleMedium),
                const SizedBox(height: AppSpacing.s),
                Container(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  decoration: BoxDecoration(
                    color: scheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppSpacing.s),
                  ),
                  child: Text(
                    ready.entryAmount.isEmpty ? '0' : ready.entryAmount,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.headlineLarge,
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Expanded(
                  child: Center(
                    child: AmountNumpad(
                      enabled: !ready.isProcessing,
                      onDigit: (d) => bloc.add(PaymentDigitEntered(d)),
                      onBackspace: () =>
                          bloc.add(const PaymentBackspacePressed()),
                      onClear: () =>
                          bloc.add(const PaymentClearEntryPressed()),
                    ),
                  ),
                ),
                MadQuickBills(
                  enabled: !ready.isProcessing,
                  onBillPressed: (v) =>
                      bloc.add(PaymentQuickBillPressed(v)),
                ),
                const SizedBox(height: AppSpacing.s),
                PosButton(
                  label: 'Reste à payer',
                  icon: Icons.price_check,
                  variant: PosButtonVariant.outlined,
                  expand: true,
                  onPressed: ready.isProcessing
                      ? null
                      : () => bloc.add(const PaymentSetRemainingPressed()),
                ),
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1, color: scheme.outlineVariant),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _SummaryCard(ready: ready, user: widget.user),
                const SizedBox(height: AppSpacing.m),
                EnterpriseInvoiceSection(
                  key: _invoiceSectionKey,
                  orderId: ready.order.order.id,
                  order: ready.order.order,
                  enabled: !ready.isProcessing,
                  onValidationError: _showInvoiceError,
                ),
                const SizedBox(height: AppSpacing.m),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    'Paiement fractionné',
                    style: theme.textTheme.titleMedium,
                  ),
                  value: ready.isSplitMode,
                  onChanged: ready.isProcessing
                      ? null
                      : (_) => bloc.add(const PaymentSplitModeToggled()),
                ),
                if (ready.isSplitMode) ...[
                  Text(
                    'Paiements enregistrés',
                    style: theme.textTheme.labelSmall,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Expanded(
                    child: _PaymentsList(payments: ready.order.payments),
                  ),
                ] else
                  const Spacer(),
                if (ready.changePreview != null &&
                    ready.changePreview!.changeAmount > 0) ...[
                  _ChangeCard(change: ready.changePreview!),
                  const SizedBox(height: AppSpacing.m),
                ],
                if (ready.errorMessage != null) ...[
                  Text(
                    ready.errorMessage!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.s),
                ],
                if (ready.isProcessing)
                  const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
        VerticalDivider(width: 1, color: scheme.outlineVariant),
        Expanded(
          flex: 3,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: PaymentMethodBar(
              enabled: !ready.isProcessing,
              onMethodPressed: _onPaymentMethod,
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.ready, required this.user});

  final PaymentReady ready;
  final User user;

  Future<void> _onDiscount(BuildContext context) async {
    final request = await showApplyDiscountDialog(
      context,
      maxFixedAmount: ready.order.displaySubtotal,
    );
    if (request == null || !context.mounted) {
      return;
    }

    final manager = await resolveManagerAuthorization(context, user);
    if (manager == null || !context.mounted) {
      return;
    }

    context.read<PaymentBloc>().add(
          PaymentDiscountApplied(
            managerUserId: manager.id,
            discountType: request.discountType,
            discountValue: request.discountValue,
            reason: request.reason,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _line(theme, 'Sous-total', PriceFormatter.format(ready.totals.subtotal)),
            _line(theme, 'TVA', PriceFormatter.format(ready.totals.taxAmount)),
            if (ready.totals.discountAmount > 0)
              _line(
                theme,
                'Remise',
                '- ${PriceFormatter.format(ready.totals.discountAmount)}',
              ),
            const Divider(height: AppSpacing.l),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total', style: theme.textTheme.titleMedium),
                PriceTag(amount: ready.amountDue, emphasized: true),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            _line(theme, 'Déjà payé', PriceFormatter.format(ready.totalPaid)),
            _line(
              theme,
              'Reste à payer',
              PriceFormatter.format(ready.remainingToPay),
              bold: true,
            ),
            const SizedBox(height: AppSpacing.m),
            PosButton(
              label: 'REMISE',
              icon: Icons.discount_outlined,
              variant: PosButtonVariant.outlined,
              expand: true,
              onPressed:
                  ready.isProcessing ? null : () => _onDiscount(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(
    ThemeData theme,
    String label,
    String value, {
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          Text(
            value,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: bold ? FontWeight.w700 : null,
              color: bold ? theme.colorScheme.primary : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentsList extends StatelessWidget {
  const _PaymentsList({required this.payments});

  final List<Payment> payments;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (payments.isEmpty) {
      return Center(
        child: Text(
          'Aucun paiement — ajoutez un mode',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return ListView.separated(
      itemCount: payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
      itemBuilder: (context, index) {
        final payment = payments[index];
        final method =
            PaymentMethod.fromDb(payment.paymentMethod)?.label ??
                payment.paymentMethod;
        return ListTile(
          tileColor: theme.colorScheme.surfaceContainerHighest,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppSpacing.s),
          ),
          title: Text(method, style: theme.textTheme.titleMedium),
          trailing: Text(
            PriceFormatter.format(payment.amount),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.primary,
            ),
          ),
        );
      },
    );
  }
}

class _ChangeCard extends StatelessWidget {
  const _ChangeCard({required this.change});

  final ChangeResult change;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      color: theme.colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Monnaie à rendre',
              style: theme.textTheme.titleMedium,
            ),
            PriceTag(amount: change.changeAmount, emphasized: true),
            const SizedBox(height: AppSpacing.s),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final entry in change.breakdown)
                  Chip(
                    label: Text(
                      '${entry.count}× ${entry.denomination.label}',
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}
