import '../entities/daily_analytics_snapshot.dart';

/// Agrégations analytiques (CA, tickets, food cost).
abstract class AnalyticsRepository {
  /// Tableau de bord du jour civil local ([day] = date calendaire).
  Future<DailyAnalyticsSnapshot> loadDailyDashboard({DateTime? day});
}
