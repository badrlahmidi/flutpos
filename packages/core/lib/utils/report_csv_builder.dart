import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../entities/report_entities.dart';
import '../usecases/money_math.dart';

/// Génère un CSV tabulaire pour les rapports de vente (séparateur `;`).
abstract final class ReportCsvBuilder {
  ReportCsvBuilder._();

  static final DateFormat _date = DateFormat('dd/MM/yyyy', 'fr_FR');
  static final NumberFormat _amount = NumberFormat('#,##0.00', 'fr_FR');

  static String build({
    required String title,
    required ReportType reportType,
    required ReportHeader header,
    required List<dynamic> rows,
  }) {
    final period =
        '${_date.format(header.filters.startDate)} — ${_date.format(header.filters.endDate)}';
    final tableRows = <List<dynamic>>[
      ['Ritagestion — Rapport'],
      ['Titre', title],
      ['Période', period],
      ['Tickets', header.ticketCount],
      [],
    ];

    switch (reportType) {
      case ReportType.productSales:
        tableRows.add([
          'Code',
          'Produit',
          'Catégorie',
          'Qté',
          'HT (MAD)',
          'TVA (MAD)',
          'TTC (MAD)',
        ]);
        for (final row in rows.cast<ProductSalesReportLine>()) {
          tableRows.add([
            row.productCode,
            row.productName,
            row.categoryName,
            row.quantitySold,
            _amount.format(row.totalHT),
            _amount.format(row.totalTax),
            _amount.format(row.totalTTC),
          ]);
        }
      case ReportType.categorySales:
        tableRows.add([
          'Catégorie',
          'Qté',
          'HT (MAD)',
          'TVA (MAD)',
          'TTC (MAD)',
        ]);
        for (final row in rows.cast<CategorySalesReportLine>()) {
          tableRows.add([
            row.categoryName,
            row.quantitySold,
            _amount.format(row.totalHT),
            _amount.format(row.totalTax),
            _amount.format(row.totalTTC),
          ]);
        }
      case ReportType.paymentMethods:
        tableRows.add(['Mode de règlement', 'Transactions', 'Total (MAD)']);
        for (final row in rows.cast<PaymentMethodReportLine>()) {
          tableRows.add([
            row.method,
            row.transactionCount,
            _amount.format(row.totalAmount),
          ]);
        }
      case ReportType.userSales:
        tableRows.add([
          'Serveur',
          'Tickets',
          'Total TTC (MAD)',
          'Panier moy. (MAD)',
        ]);
        for (final row in rows.cast<UserSalesReportLine>()) {
          tableRows.add([
            row.userName,
            row.ticketCount,
            _amount.format(row.totalTTC),
            _amount.format(row.averageBasket),
          ]);
        }
      case ReportType.dashboard:
        tableRows.add(['Indicateur', 'Valeur']);
    }

    if (header.totalHT > 0) {
      tableRows.addAll([
        [],
        ['Total HT (MAD)', _amount.format(header.totalHT)],
        ['Total TVA (MAD)', _amount.format(header.totalTax)],
        ['Total TTC (MAD)', _amount.format(header.totalTTC)],
      ]);
    } else if (header.totalTTC > 0) {
      tableRows.addAll([
        [],
        ['Total TTC (MAD)', _amount.format(roundMoney(header.totalTTC))],
      ]);
    }

    return Csv(fieldDelimiter: ';').encode(tableRows);
  }
}

/// Types de rapports disponibles (miroir UI).
enum ReportType {
  productSales('Ventes par Produit'),
  categorySales('Ventes par Catégorie'),
  paymentMethods('Modes de Règlement'),
  userSales('Ventes par Serveur'),
  dashboard('Tableau de Bord');

  const ReportType(this.label);
  final String label;
}
