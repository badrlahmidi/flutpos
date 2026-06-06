import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../di/service_locator.dart';
import '../../../services/accounting_export_service.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/atoms/pos_button.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';

/// Export comptable mensuel (CSV → Bureau Windows).
class AccountingExportPage extends StatefulWidget {
  const AccountingExportPage({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  State<AccountingExportPage> createState() => _AccountingExportPageState();
}

class _AccountingExportPageState extends State<AccountingExportPage> {
  static final DateFormat _monthLabel =
      DateFormat('MMMM yyyy', 'fr_FR');

  DateTime _selectedMonth = DateTime(DateTime.now().year, DateTime.now().month);
  MonthlyAccountingReport? _preview;
  bool _loading = false;
  bool _exporting = false;
  String? _error;
  String? _lastExportPath;

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final report =
          await sl<AccountingExportRepository>().loadMonthlyReport(_selectedMonth);
      if (!mounted) {
        return;
      }
      setState(() {
        _preview = report;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _error = '$e';
        _loading = false;
      });
    }
  }

  void _shiftMonth(int delta) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + delta,
      );
    });
    _loadPreview();
  }

  Future<void> _export() async {
    setState(() {
      _exporting = true;
      _error = null;
    });

    try {
      final path = await sl<AccountingExportService>().exportMonthlyToDesktop(
        _selectedMonth,
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _exporting = false;
        _lastExportPath = path;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Export enregistré — $path'),
          duration: const Duration(seconds: 4),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _exporting = false;
        _error = '$e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final preview = _preview;

    return Scaffold(
      appBar: widget.embeddedInShell
          ? null
          : AppBar(
              title: const Text('Export comptable'),
            ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: const EdgeInsets.all(AppSpacing.l),
              children: [
                if (widget.embeddedInShell)
                  BackofficePageHeader(
                    title: 'Export comptable',
                    subtitle: 'CSV mensuel vers le Bureau',
                  ),
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Mois précédent',
                      onPressed: () => _shiftMonth(-1),
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Expanded(
                      child: Text(
                        _monthLabel.format(_selectedMonth),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Mois suivant',
                      onPressed: () => _shiftMonth(1),
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
                if (_error != null) ...[
                  Text(
                    _error!,
                    style: TextStyle(color: scheme.error),
                  ),
                  const SizedBox(height: AppSpacing.m),
                ],
                if (preview != null) ...[
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(AppSpacing.m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            preview.restaurantName,
                            style: theme.textTheme.titleMedium,
                          ),
                          const SizedBox(height: AppSpacing.s),
                          _PreviewRow(
                            label: 'CA total TTC',
                            value: PriceFormatter.format(preview.totalRevenue),
                          ),
                          _PreviewRow(
                            label: 'Tickets payés',
                            value: '${preview.paidOrdersCount}',
                          ),
                          _PreviewRow(
                            label: 'Sessions Z clôturées',
                            value: '${preview.closedSessions.length}',
                          ),
                          const Divider(height: AppSpacing.l),
                          Text('TVA', style: theme.textTheme.titleSmall),
                          const SizedBox(height: AppSpacing.s),
                          for (final row in preview.taxByRate)
                            if (row.taxableBase > 0 || row.taxAmount > 0)
                              _PreviewRow(
                                label: 'TVA ${row.taxRate.toStringAsFixed(0)} %',
                                value:
                                    'HT ${PriceFormatter.format(row.taxableBase)} · '
                                    'TVA ${PriceFormatter.format(row.taxAmount)}',
                              ),
                          const Divider(height: AppSpacing.l),
                          Text(
                            'Modes de règlement',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.s),
                          for (final entry
                              in preview.salesByPaymentMethod.entries)
                            _PreviewRow(
                              label: accountingPaymentMethodLabel(entry.key),
                              value: PriceFormatter.format(entry.value),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.l),
                PosButton(
                  label: _exporting ? 'EXPORT…' : 'EXPORTER CSV (BUREAU)',
                  icon: Icons.download,
                  expand: true,
                  onPressed: _exporting || preview == null ? null : _export,
                ),
                if (_lastExportPath != null) ...[
                  const SizedBox(height: AppSpacing.m),
                  Text(
                    'Dernier fichier : $_lastExportPath',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.m),
                Text(
                  'Format CSV (séparateur point-virgule) compatible Excel — '
                  'TVA 7 / 10 / 20 % et modes Espèces, Carte, TPE.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
    );
  }
}

class _PreviewRow extends StatelessWidget {
  const _PreviewRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Expanded(child: Text(label)),
          Text(value, style: Theme.of(context).textTheme.titleSmall),
        ],
      ),
    );
  }
}
