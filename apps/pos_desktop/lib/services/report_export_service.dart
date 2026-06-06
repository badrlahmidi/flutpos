import 'dart:io';

import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../blocs/reporting/reporting_state.dart';
import '../utils/price_formatter.dart';

/// Export CSV/PDF et impression des rapports tabulaires.
class ReportExportService {
  static final _fileStamp = DateFormat('yyyyMMdd_HHmmss', 'fr_FR');
  static final _periodFmt = DateFormat('dd/MM/yyyy', 'fr_FR');

  Future<String> exportCsv(OpenReportTab tab) async {
    if (tab.type == ReportType.dashboard) {
      throw UnsupportedError('Export CSV non disponible pour le tableau de bord');
    }
    final header = tab.header!;
    final csv = ReportCsvBuilder.build(
      title: tab.title,
      reportType: tab.type,
      header: header,
      rows: tab.rows,
    );
    final desktop = _resolveDesktopDirectory();
    final filename =
        'ritagestion_rapport_${_slug(tab.title)}_${_fileStamp.format(DateTime.now())}.csv';
    final file = File(p.join(desktop.path, filename));
    await file.writeAsString('\uFEFF$csv');
    return file.path;
  }

  Future<String> exportPdfToDesktop(OpenReportTab tab) async {
    final bytes = await _buildPdfBytes(tab);
    final desktop = _resolveDesktopDirectory();
    final filename =
        'ritagestion_rapport_${_slug(tab.title)}_${_fileStamp.format(DateTime.now())}.pdf';
    final file = File(p.join(desktop.path, filename));
    await file.writeAsBytes(bytes);
    return file.path;
  }

  Future<void> printReport(OpenReportTab tab) async {
    final bytes = await _buildPdfBytes(tab);
    await Printing.layoutPdf(onLayout: (_) async => bytes);
  }

  Future<Uint8List> _buildPdfBytes(OpenReportTab tab) async {
    if (tab.type == ReportType.dashboard) {
      return _buildDashboardPdf(tab.dashboardSnapshot!);
    }

    final header = tab.header!;
    final doc = pw.Document();
    final period =
        '${_periodFmt.format(header.filters.startDate)} — ${_periodFmt.format(header.filters.endDate)}';

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return [
            pw.Text(
              header.title,
              style: pw.TextStyle(
                fontSize: 18,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Text('Période : $period'),
            pw.Text('Tickets : ${header.ticketCount}'),
            pw.SizedBox(height: 16),
            pw.Table.fromTextArray(
              headers: _pdfHeaders(tab.type),
              data: _pdfRows(tab),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellAlignment: pw.Alignment.centerLeft,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              border: pw.TableBorder.all(color: PdfColors.grey400, width: 0.5),
            ),
            if (header.totalHT > 0) ...[
              pw.SizedBox(height: 16),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                  children: [
                    pw.Text('Total HT : ${PriceFormatter.format(header.totalHT)}'),
                    pw.Text('Total TVA : ${PriceFormatter.format(header.totalTax)}'),
                    pw.Text(
                      'Total TTC : ${PriceFormatter.format(header.totalTTC)}',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ] else if (header.totalTTC > 0) ...[
              pw.SizedBox(height: 16),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Total TTC : ${PriceFormatter.format(header.totalTTC)}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                ),
              ),
            ],
          ];
        },
      ),
    );

    return doc.save();
  }

  Future<Uint8List> _buildDashboardPdf(DailyAnalyticsSnapshot snapshot) async {
    final doc = pw.Document();
    final dayLabel = DateFormat('EEEE d MMMM yyyy', 'fr_FR').format(snapshot.day);

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Tableau de bord',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(dayLabel),
              pw.SizedBox(height: 16),
              pw.Text('CA total : ${PriceFormatter.format(snapshot.totalRevenue)}'),
              pw.Text('Sur place : ${PriceFormatter.format(snapshot.revenueDineIn)}'),
              pw.Text('Livraison : ${PriceFormatter.format(snapshot.revenueDelivery)}'),
              pw.Text('Tickets : ${snapshot.ticketCount}'),
              pw.Text(
                'Panier moyen : ${PriceFormatter.format(snapshot.averageBasket)}',
              ),
              pw.SizedBox(height: 12),
              pw.Text(
                'Food cost : ${snapshot.foodCostRatioPercent.toStringAsFixed(1)} %',
              ),
            ],
          );
        },
      ),
    );

    return doc.save();
  }

  List<String> _pdfHeaders(ReportType type) {
    switch (type) {
      case ReportType.productSales:
        return ['Code', 'Produit', 'Catégorie', 'Qté', 'HT', 'TVA', 'TTC'];
      case ReportType.categorySales:
        return ['Catégorie', 'Qté', 'HT', 'TVA', 'TTC'];
      case ReportType.paymentMethods:
        return ['Mode', 'Transactions', 'Total'];
      case ReportType.userSales:
        return ['Serveur', 'Tickets', 'Total TTC', 'Panier moy.'];
      case ReportType.dashboard:
        return [];
    }
  }

  List<List<String>> _pdfRows(OpenReportTab tab) {
    switch (tab.type) {
      case ReportType.productSales:
        return tab.rows.cast<ProductSalesReportLine>().map((row) {
          return [
            row.productCode,
            row.productName,
            row.categoryName,
            row.quantitySold.toStringAsFixed(0),
            PriceFormatter.format(row.totalHT),
            PriceFormatter.format(row.totalTax),
            PriceFormatter.format(row.totalTTC),
          ];
        }).toList();
      case ReportType.categorySales:
        return tab.rows.cast<CategorySalesReportLine>().map((row) {
          return [
            row.categoryName,
            row.quantitySold.toStringAsFixed(0),
            PriceFormatter.format(row.totalHT),
            PriceFormatter.format(row.totalTax),
            PriceFormatter.format(row.totalTTC),
          ];
        }).toList();
      case ReportType.paymentMethods:
        return tab.rows.cast<PaymentMethodReportLine>().map((row) {
          return [
            row.method,
            '${row.transactionCount}',
            PriceFormatter.format(row.totalAmount),
          ];
        }).toList();
      case ReportType.userSales:
        return tab.rows.cast<UserSalesReportLine>().map((row) {
          return [
            row.userName,
            '${row.ticketCount}',
            PriceFormatter.format(row.totalTTC),
            PriceFormatter.format(row.averageBasket),
          ];
        }).toList();
      case ReportType.dashboard:
        return [];
    }
  }

  String _slug(String value) {
    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  Directory _resolveDesktopDirectory() {
    final userProfile =
        Platform.environment['USERPROFILE'] ?? Platform.environment['HOME'];
    if (userProfile != null) {
      final desktop = Directory(p.join(userProfile, 'Desktop'));
      if (desktop.existsSync()) return desktop;
      final bureau = Directory(p.join(userProfile, 'Bureau'));
      if (bureau.existsSync()) return bureau;
    }
    return Directory.current;
  }
}
