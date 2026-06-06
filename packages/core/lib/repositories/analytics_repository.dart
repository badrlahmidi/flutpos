import '../entities/daily_analytics_snapshot.dart';
import '../entities/report_entities.dart';

/// Agrégations analytiques (CA, tickets, food cost) et rapports multi-dimensions.
abstract class AnalyticsRepository {
  /// Tableau de bord du jour civil local ([day] = date calendaire).
  Future<DailyAnalyticsSnapshot> loadDailyDashboard({DateTime? day});

  /// Rapport des ventes agrégées par produit sur la période [filters].
  Future<({ReportHeader header, List<ProductSalesReportLine> lines})>
      getProductSalesReport(ReportFilters filters);

  /// Rapport des ventes agrégées par catégorie sur la période [filters].
  Future<({ReportHeader header, List<CategorySalesReportLine> lines})>
      getCategorySalesReport(ReportFilters filters);

  /// Rapport des ventes par mode de règlement.
  Future<({ReportHeader header, List<PaymentMethodReportLine> lines})>
      getPaymentMethodReport(ReportFilters filters);

  /// Rapport des ventes par utilisateur / serveur.
  Future<({ReportHeader header, List<UserSalesReportLine> lines})>
      getUserSalesReport(ReportFilters filters);

  /// Options pour les filtres (utilisateurs, catégories, sessions).
  Future<ReportingFilterOptions> loadReportingFilterOptions({
    DateTime? sessionPeriodStart,
    DateTime? sessionPeriodEnd,
  });
}
