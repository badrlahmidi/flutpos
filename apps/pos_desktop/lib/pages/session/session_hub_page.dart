import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../utils/manager_auth.dart';
import '../../widgets/atoms/pos_button.dart';
import 'widgets/cash_movement_dialog.dart';
import 'widgets/open_session_dialog.dart';
import 'widgets/session_report_panel.dart';
import 'z_close_page.dart';
import '../backoffice/analytics_dashboard_page.dart';
import '../backoffice/accounting_export_page.dart';

/// Hub trésorerie : ouverture, pay-in/out, X-Report.
class SessionHubPage extends StatefulWidget {
  const SessionHubPage({super.key, required this.user});

  final User user;

  @override
  State<SessionHubPage> createState() => _SessionHubPageState();
}

class _SessionHubPageState extends State<SessionHubPage> {
  CashSession? _session;
  CashSessionReport? _report;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final repo = sl<CashSessionRepository>();
      final session =
          await repo.getOpenSessionForCashier(widget.user.id);
      CashSessionReport? report;
      if (session != null) {
        report = await repo.buildSessionReport(session.id);
      }
      if (!mounted) {
        return;
      }
      setState(() {
        _session = session;
        _report = report;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  Future<void> _openSession() async {
    final balance = await showOpenSessionDialog(context);
    if (balance == null || !mounted) {
      return;
    }

    await sl<CashSessionRepository>().openSession(
      userId: widget.user.id,
      openingBalance: balance,
    );
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Session ouverte — fond ${balance.toStringAsFixed(2)} DH',
        ),
      ),
    );
    await _load();
  }

  Future<void> _cashMovement(CashMovementType type) async {
    final session = _session;
    if (session == null) {
      return;
    }

    final request = await showCashMovementDialog(context, type: type);
    if (request == null || !mounted) {
      return;
    }

    final manager = await resolveManagerAuthorization(context, widget.user);
    if (manager == null || !mounted) {
      return;
    }

    final repo = sl<CashSessionRepository>();
    try {
      if (request.type == CashMovementType.payIn) {
        await repo.payIn(
          userId: manager.id,
          sessionId: session.id,
          amount: roundMoney(request.amount),
          reason: request.reason,
        );
      } else {
        await repo.payOut(
          userId: manager.id,
          sessionId: session.id,
          amount: roundMoney(request.amount),
          reason: request.reason,
        );
      }
    } catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$e')),
      );
      return;
    }

    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          request.type == CashMovementType.payIn
              ? 'Pay-in enregistré'
              : 'Pay-out enregistré',
        ),
      ),
    );
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trésorerie'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(true),
        ),
        actions: [
          IconButton(
            tooltip: 'Dashboard analytique',
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (_) => const AnalyticsDashboardPage(),
                ),
              );
            },
            icon: const Icon(Icons.insights_outlined),
          ),
          IconButton(
            tooltip: 'Actualiser',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PosButton(
                        label: 'EXPORT COMPTABLE CSV',
                        icon: Icons.file_download_outlined,
                        variant: PosButtonVariant.outlined,
                        expand: true,
                        onPressed: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const AccountingExportPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.s),
                      PosButton(
                        label: 'DASHBOARD ANALYTIQUE',
                        icon: Icons.insights_outlined,
                        variant: PosButtonVariant.tonal,
                        expand: true,
                        onPressed: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => const AnalyticsDashboardPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: AppSpacing.m),
                      if (_session == null) ...[
                        Text(
                          'Aucune session ouverte',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        PosButton(
                          label: 'OUVRIR LA CAISSE',
                          icon: Icons.lock_open,
                          expand: true,
                          onPressed: _openSession,
                        ),
                      ] else ...[
                        if (_report != null)
                          SessionReportPanel(report: _report!),
                        const SizedBox(height: AppSpacing.m),
                        PosButton(
                          label: 'PAY-IN (entrée)',
                          icon: Icons.add_circle_outline,
                          variant: PosButtonVariant.tonal,
                          expand: true,
                          onPressed: () =>
                              _cashMovement(CashMovementType.payIn),
                        ),
                        const SizedBox(height: AppSpacing.s),
                        PosButton(
                          label: 'PAY-OUT (sortie)',
                          icon: Icons.remove_circle_outline,
                          variant: PosButtonVariant.outlined,
                          expand: true,
                          onPressed: () =>
                              _cashMovement(CashMovementType.payOut),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        PosButton(
                          label: 'CLÔTURE Z',
                          icon: Icons.receipt_long,
                          expand: true,
                          onPressed: _report == null
                              ? null
                              : () async {
                                  final closed =
                                      await Navigator.of(context).push<bool>(
                                    MaterialPageRoute<bool>(
                                      builder: (_) => ZClosePage(
                                        user: widget.user,
                                        report: _report!,
                                      ),
                                    ),
                                  );
                                  if (closed == true && mounted) {
                                    Navigator.of(context).pop(true);
                                  } else {
                                    await _load();
                                  }
                                },
                        ),
                      ],
                    ],
                  ),
                ),
    );
  }
}
