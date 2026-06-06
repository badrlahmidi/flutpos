import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../blocs/reporting/reporting_state.dart';
import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';
import 'report_dashboard_panel.dart';

/// Aperçu tabulaire style feuille A4 avec barre d'outils.
class ReportPrintPreview extends StatefulWidget {
  const ReportPrintPreview({
    super.key,
    required this.tab,
    this.onPrint,
    this.onExportCsv,
    this.onExportPdf,
  });

  final OpenReportTab tab;
  final VoidCallback? onPrint;
  final VoidCallback? onExportCsv;
  final VoidCallback? onExportPdf;

  @override
  State<ReportPrintPreview> createState() => _ReportPrintPreviewState();
}

class _ReportPrintPreviewState extends State<ReportPrintPreview> {
  double _zoom = 1.0;

  static final _periodFmt = DateFormat('d MMM yyyy', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final tab = widget.tab;

    if (tab.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (tab.errorMessage != null) {
      return Center(child: Text(tab.errorMessage!));
    }

    if (tab.type == ReportType.dashboard && tab.dashboardSnapshot != null) {
      return ReportDashboardPanel(snapshot: tab.dashboardSnapshot!);
    }

    final header = tab.header;
    if (header == null) {
      return const Center(child: Text('Aucune donnée'));
    }

    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.l, AppSpacing.m, AppSpacing.l, 0),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Zoom −',
                onPressed: _zoom > 0.75
                    ? () => setState(() => _zoom -= 0.1)
                    : null,
                icon: const Icon(Icons.zoom_out),
              ),
              Text('${(_zoom * 100).round()} %'),
              IconButton(
                tooltip: 'Zoom +',
                onPressed: _zoom < 1.25
                    ? () => setState(() => _zoom += 0.1)
                    : null,
                icon: const Icon(Icons.zoom_in),
              ),
              const Spacer(),
              if (widget.onPrint != null)
                OutlinedButton.icon(
                  onPressed: widget.onPrint,
                  icon: const Icon(Icons.print_outlined, size: 18),
                  label: const Text('Imprimer'),
                ),
              if (widget.onExportCsv != null) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: widget.onExportCsv,
                  icon: const Icon(Icons.table_view_outlined, size: 18),
                  label: const Text('Excel'),
                ),
              ],
              if (widget.onExportPdf != null) ...[
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: widget.onExportPdf,
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text('PDF'),
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Center(
              child: Transform.scale(
                scale: _zoom,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 794),
                  child: Card(
                    elevation: 3,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      header.title,
                                      style: theme.textTheme.headlineSmall?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '${_periodFmt.format(header.filters.startDate)}  →  ${_periodFmt.format(header.filters.endDate)}',
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              _KpiChip(
                                label: 'Total TTC',
                                value: PriceFormatter.format(header.totalTTC),
                                color: scheme.primary,
                              ),
                              const SizedBox(width: 8),
                              _KpiChip(
                                label: 'Tickets',
                                value: '${header.ticketCount}',
                                color: scheme.secondary,
                              ),
                            ],
                          ),
                          const Divider(height: 32, color: Colors.black26),
                          _ReportTable(type: tab.type, rows: tab.rows),
                          if (header.totalHT > 0) ...[
                            const Divider(height: 24, color: Colors.black26),
                            _TotalsRow(header: header),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _KpiChip extends StatelessWidget {
  const _KpiChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: color,
            ),
          ),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        ],
      ),
    );
  }
}

class _ReportTable extends StatelessWidget {
  const _ReportTable({required this.type, required this.rows});

  final ReportType type;
  final List<dynamic> rows;

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case ReportType.productSales:
        return _DataTable<ProductSalesReportLine>(
          columns: const [
            'Code',
            'Produit',
            'Catégorie',
            'Qté',
            'HT',
            'TVA',
            'TTC',
          ],
          rows: rows.cast<ProductSalesReportLine>(),
          cellBuilder: (row) => [
            row.productCode,
            row.productName,
            row.categoryName,
            row.quantitySold.toStringAsFixed(0),
            PriceFormatter.format(row.totalHT),
            PriceFormatter.format(row.totalTax),
            PriceFormatter.format(row.totalTTC),
          ],
        );
      case ReportType.categorySales:
        return _DataTable<CategorySalesReportLine>(
          columns: const ['Catégorie', 'Qté', 'HT', 'TVA', 'TTC'],
          rows: rows.cast<CategorySalesReportLine>(),
          cellBuilder: (row) => [
            row.categoryName,
            row.quantitySold.toStringAsFixed(0),
            PriceFormatter.format(row.totalHT),
            PriceFormatter.format(row.totalTax),
            PriceFormatter.format(row.totalTTC),
          ],
        );
      case ReportType.paymentMethods:
        return _DataTable<PaymentMethodReportLine>(
          columns: const ['Mode de règlement', 'Transactions', 'Total'],
          rows: rows.cast<PaymentMethodReportLine>(),
          cellBuilder: (row) => [
            row.method,
            '${row.transactionCount}',
            PriceFormatter.format(row.totalAmount),
          ],
        );
      case ReportType.userSales:
        return _DataTable<UserSalesReportLine>(
          columns: const ['Serveur', 'Tickets', 'Total TTC', 'Panier moy.'],
          rows: rows.cast<UserSalesReportLine>(),
          cellBuilder: (row) => [
            row.userName,
            '${row.ticketCount}',
            PriceFormatter.format(row.totalTTC),
            PriceFormatter.format(row.averageBasket),
          ],
        );
      case ReportType.dashboard:
        return const SizedBox.shrink();
    }
  }
}

class _DataTable<T> extends StatelessWidget {
  const _DataTable({
    required this.columns,
    required this.rows,
    required this.cellBuilder,
  });

  final List<String> columns;
  final List<T> rows;
  final List<String> Function(T row) cellBuilder;

  @override
  Widget build(BuildContext context) {
    if (rows.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(48),
        alignment: Alignment.center,
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.black38),
            SizedBox(height: 12),
            Text(
              'Aucune donnée pour cette période',
              style: TextStyle(color: Colors.black54),
            ),
          ],
        ),
      );
    }

    return Table(
      border: TableBorder.all(color: Colors.black26, width: 0.5),
      columnWidths: const {0: IntrinsicColumnWidth()},
      children: [
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: columns
              .map(
                (col) => TableCell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    child: Text(
                      col,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
        ...rows.asMap().entries.map((entry) {
          final isEven = entry.key.isEven;
          final cells = cellBuilder(entry.value);
          return TableRow(
            decoration: BoxDecoration(
              color: isEven ? null : Colors.grey.shade50,
            ),
            children: cells
                .map(
                  (cell) => TableCell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 9,
                      ),
                      child: Text(
                        cell,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ],
    );
  }
}

class _TotalsRow extends StatelessWidget {
  const _TotalsRow({required this.header});

  final ReportHeader header;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _TotalCell(label: 'Total HT', value: PriceFormatter.format(header.totalHT)),
        const SizedBox(width: 16),
        _TotalCell(label: 'Total TVA', value: PriceFormatter.format(header.totalTax)),
        const SizedBox(width: 16),
        _TotalCell(
          label: 'Total TTC',
          value: PriceFormatter.format(header.totalTTC),
          accent: true,
        ),
      ],
    );
  }
}

class _TotalCell extends StatelessWidget {
  const _TotalCell({
    required this.label,
    required this.value,
    this.accent = false,
  });

  final String label;
  final String value;
  final bool accent;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.black54)),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 16,
            color: accent ? Theme.of(context).colorScheme.primary : Colors.black87,
          ),
        ),
      ],
    );
  }
}
