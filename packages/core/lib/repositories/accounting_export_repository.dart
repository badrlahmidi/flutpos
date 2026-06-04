import '../entities/monthly_accounting_report.dart';

/// Chargement des agrégats comptables mensuels.
abstract class AccountingExportRepository {
  /// [month] = n'importe quel jour du mois cible.
  Future<MonthlyAccountingReport> loadMonthlyReport(DateTime month);
}
