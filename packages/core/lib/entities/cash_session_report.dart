import '../database/app_database.dart';

/// Brouillard / clôture Z d'une session de caisse.
class CashSessionReport {
  const CashSessionReport({
    required this.session,
    required this.cashierName,
    required this.openingBalance,
    required this.cashSales,
    required this.cardSales,
    required this.otherSales,
    required this.totalSales,
    required this.payInTotal,
    required this.payOutTotal,
    required this.expectedCashBalance,
    required this.paidOrdersCount,
    required this.openOrdersCount,
    required this.movements,
    required this.salesByMethod,
  });

  final CashSession session;
  final String cashierName;
  final double openingBalance;
  final double cashSales;
  final double cardSales;
  final double otherSales;
  final double totalSales;
  final double payInTotal;
  final double payOutTotal;

  /// Fond + espèces encaissées + entrées − sorties.
  final double expectedCashBalance;

  final int paidOrdersCount;
  final int openOrdersCount;
  final List<CashMovement> movements;
  final Map<String, double> salesByMethod;
}
