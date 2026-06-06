import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../../di/service_locator.dart';
import '../../../services/print/pos_print_service.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/atoms/pos_button.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../session/widgets/session_report_panel.dart';

/// Clôture Z — comptage réel vs théorique, raison d'écart obligatoire.
class ZClosePage extends StatefulWidget {
  const ZClosePage({
    super.key,
    required this.user,
    required this.report,
    this.embeddedInShell = false,
  });

  final User user;
  final CashSessionReport report;
  final bool embeddedInShell;

  @override
  State<ZClosePage> createState() => _ZClosePageState();
}

class _ZClosePageState extends State<ZClosePage> {
  final _countedController = TextEditingController();
  final _noteController = TextEditingController();
  bool _closing = false;

  @override
  void dispose() {
    _countedController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _close() async {
    final counted = double.tryParse(
      _countedController.text.trim().replaceAll(',', '.'),
    );
    if (counted == null || counted < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comptage espèces invalide')),
      );
      return;
    }

    final expected = widget.report.expectedCashBalance;
    final variance = roundMoney(counted - expected);
    final note = _noteController.text.trim();

    if (variance.abs() > 0.009 && note.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Écart détecté — indiquez une raison (3 caractères min.)',
          ),
        ),
      );
      return;
    }

    setState(() => _closing = true);

    try {
      final session = await sl<CashSessionRepository>().closeSession(
        userId: widget.user.id,
        sessionId: widget.report.session.id,
        closingBalance: roundMoney(counted),
        expectedBalance: expected,
        closingNote: variance.abs() > 0.009 ? note : null,
      );

      final closedReport = widget.report.copyWithSession(session);
      final printResult = await sl<PosPrintService>().printZReport(
        closedReport,
        closingBalance: roundMoney(counted),
        variance: variance,
        closingNote: variance.abs() > 0.009 ? note : null,
      );

      if (!mounted) {
        return;
      }

      final msg = printResult.ok
          ? (printResult.simulated
              ? 'Z-Report — simulation (console / logs)'
              : 'Z-Report imprimé — session clôturée')
          : (printResult.error ?? 'Clôture OK, erreur impression');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg)),
      );
      context.pop(true);
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() => _closing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Clôture : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final expected = widget.report.expectedCashBalance;

    return Scaffold(
      appBar: widget.embeddedInShell
          ? null
          : AppBar(
              title: const Text('Clôture Z'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _closing ? null : () => context.pop(false),
              ),
            ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (widget.embeddedInShell)
              BackofficePageHeader(
                title: 'Clôture Z',
                subtitle: 'Comptage physique et impression du rapport',
                trailing: IconButton(
                  tooltip: 'Retour trésorerie',
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _closing ? null : () => context.pop(false),
                ),
              ),
            SessionReportPanel(
              report: widget.report,
              title: 'Rapport Z — récapitulatif',
            ),
            const SizedBox(height: AppSpacing.m),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Comptage physique du tiroir',
                      style: theme.textTheme.titleMedium,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    Text(
                      'Théorique : ${PriceFormatter.format(expected)}',
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    TextField(
                      controller: _countedController,
                      enabled: !_closing,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[\d.,]')),
                      ],
                      decoration: const InputDecoration(
                        labelText: 'Espèces comptées (réel)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    TextField(
                      controller: _noteController,
                      enabled: !_closing,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Raison écart (si différence)',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            if (_closing)
              const Center(child: CircularProgressIndicator())
            else
              PosButton(
                label: 'CLÔTURER ET IMPRIMER Z',
                icon: Icons.check_circle_outline,
                expand: true,
                onPressed: _close,
              ),
          ],
        ),
      ),
    );
  }
}

extension on CashSessionReport {
  CashSessionReport copyWithSession(CashSession session) {
    return CashSessionReport(
      session: session,
      cashierName: cashierName,
      openingBalance: openingBalance,
      cashSales: cashSales,
      cardSales: cardSales,
      otherSales: otherSales,
      totalSales: totalSales,
      payInTotal: payInTotal,
      payOutTotal: payOutTotal,
      expectedCashBalance: expectedCashBalance,
      paidOrdersCount: paidOrdersCount,
      openOrdersCount: openOrdersCount,
      movements: movements,
      salesByMethod: salesByMethod,
    );
  }
}
