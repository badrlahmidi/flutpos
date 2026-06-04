import '../usecases/tax_breakdown.dart';

/// Synthèse d'une session clôturée dans le mois.
class MonthlySessionSummary {
  const MonthlySessionSummary({
    required this.sessionId,
    required this.openedAt,
    required this.closedAt,
    required this.cashierName,
    required this.totalSales,
    required this.paidOrdersCount,
  });

  final String sessionId;
  final DateTime openedAt;
  final DateTime closedAt;
  final String cashierName;
  final double totalSales;
  final int paidOrdersCount;
}

/// Rapport comptable mensuel (export expert-comptable).
class MonthlyAccountingReport {
  const MonthlyAccountingReport({
    required this.restaurantName,
    required this.periodStart,
    required this.periodEnd,
    required this.taxByRate,
    required this.salesByPaymentMethod,
    required this.totalRevenue,
    required this.paidOrdersCount,
    required this.closedSessions,
  });

  final String restaurantName;
  final DateTime periodStart;
  final DateTime periodEnd;
  final List<TaxRateSummary> taxByRate;
  final Map<String, double> salesByPaymentMethod;
  final double totalRevenue;
  final int paidOrdersCount;
  final List<MonthlySessionSummary> closedSessions;
}
