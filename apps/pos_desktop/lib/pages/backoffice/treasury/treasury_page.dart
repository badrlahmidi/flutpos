import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../di/service_locator.dart';
import '../../../navigation/app_router.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/security_guard.dart';
import '../../../widgets/atoms/pos_button.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../../widgets/atoms/loading_skeleton.dart';
import '../../session/widgets/cash_movement_dialog.dart';
import '../../session/widgets/open_session_dialog.dart';
import '../../session/widgets/session_report_panel.dart';

/// Trésorerie backoffice — session, mouvements, clôture Z.
class TreasuryPage extends StatefulWidget {
  const TreasuryPage({
    super.key,
    required this.user,
    this.embeddedInShell = true,
  });

  final User user;
  final bool embeddedInShell;

  @override
  State<TreasuryPage> createState() => _TreasuryPageState();
}

class _TreasuryPageState extends State<TreasuryPage> {
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
      final session = await repo.getOpenSessionForCashier(widget.user.id);
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

    final operation = request.type == CashMovementType.payIn
        ? SecurityOperations.cashPayIn
        : SecurityOperations.cashPayOut;

    final manager = await SecurityGuard.authorize(
      context,
      operation,
      currentUser: widget.user,
    );
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

  Future<void> _closeZ() async {
    if (_report == null) {
      return;
    }

    final authorized = await SecurityGuard.authorize(
      context,
      SecurityOperations.closeSession,
      currentUser: widget.user,
    );
    if (authorized == null || !mounted) {
      return;
    }

    final router = GoRouter.of(context);
    final embedded = widget.embeddedInShell;
    final closed = await router.push<bool>(
      embedded ? '/backoffice/treasury/z-close' : '/z-close',
      extra: ZCloseRouteArgs(user: widget.user, report: _report!),
    );
    if (!mounted) {
      return;
    }
    if (closed == true) {
      if (embedded) {
        await _load();
      } else {
        router.pop(true);
      }
    } else {
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (_loading) {
      return const Padding(
        padding: EdgeInsets.all(AppSpacing.l),
        child: LoadingSkeletonList(itemCount: 4, itemHeight: 120),
      );
    }
    if (_error != null) {
      return Center(child: Text(_error!));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.embeddedInShell)
            BackofficePageHeader(
              title: 'Trésorerie',
              subtitle: 'Session de caisse et mouvements',
              trailing: IconButton(
                tooltip: 'Actualiser',
                onPressed: _load,
                icon: const Icon(Icons.refresh),
              ),
            )
          else
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => context.pop(true),
                ),
                Text('Trésorerie', style: theme.textTheme.headlineLarge),
                const Spacer(),
                IconButton(
                  tooltip: 'Actualiser',
                  onPressed: _load,
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
          if (!widget.embeddedInShell) ...[
            _LinkCard(
              icon: Icons.insights_outlined,
              label: 'Dashboard analytique',
              onTap: () => context.go('/backoffice/analytics'),
            ),
            const SizedBox(height: AppSpacing.s),
          ],
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text('Session active', style: theme.textTheme.titleLarge),
                  const SizedBox(height: AppSpacing.m),
                  if (_session == null) ...[
                    Text(
                      'Aucune session ouverte pour ${widget.user.name}.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    PosButton(
                      label: 'OUVRIR LA CAISSE',
                      icon: Icons.lock_open,
                      expand: true,
                      onPressed: _openSession,
                    ),
                  ] else if (_report != null) ...[
                    SessionReportPanel(report: _report!),
                  ],
                ],
              ),
            ),
          ),
          if (_session != null) ...[
            const SizedBox(height: AppSpacing.m),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Mouvements', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.m),
                    PosButton(
                      label: 'PAY-IN (entrée)',
                      icon: Icons.add_circle_outline,
                      variant: PosButtonVariant.tonal,
                      expand: true,
                      onPressed: () => _cashMovement(CashMovementType.payIn),
                    ),
                    const SizedBox(height: AppSpacing.s),
                    PosButton(
                      label: 'PAY-OUT (sortie)',
                      icon: Icons.remove_circle_outline,
                      variant: PosButtonVariant.outlined,
                      expand: true,
                      onPressed: () => _cashMovement(CashMovementType.payOut),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.m),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text('Actions', style: theme.textTheme.titleLarge),
                    const SizedBox(height: AppSpacing.m),
                    PosButton(
                      label: 'CLÔTURE Z',
                      icon: Icons.receipt_long,
                      expand: true,
                      onPressed: _report == null ? null : _closeZ,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _LinkCard extends StatelessWidget {
  const _LinkCard({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
