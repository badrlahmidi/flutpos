/// Point de vente horaire (CA encaissé).
class HourlySalesPoint {
  const HourlySalesPoint({
    required this.hour,
    required this.amount,
  });

  /// Heure locale 0–23.
  final int hour;
  final double amount;
}

/// Produit dans le classement des ventes.
class TopProductSale {
  const TopProductSale({
    required this.productId,
    required this.productName,
    required this.quantitySold,
    required this.revenue,
  });

  final String productId;
  final String productName;
  final double quantitySold;
  final double revenue;
}

/// Synthèse analytique journalière (dashboard backoffice).
class DailyAnalyticsSnapshot {
  const DailyAnalyticsSnapshot({
    required this.day,
    required this.revenueDineIn,
    required this.revenueDelivery,
    required this.totalRevenue,
    required this.ticketCount,
    required this.averageBasket,
    required this.salesByHour,
    required this.topProducts,
    required this.foodCostSalesRevenue,
    required this.foodCostTheoretical,
    required this.foodCostGap,
    required this.foodCostRatioPercent,
  });

  final DateTime day;
  final double revenueDineIn;
  final double revenueDelivery;
  final double totalRevenue;
  final int ticketCount;
  final double averageBasket;
  final List<HourlySalesPoint> salesByHour;
  final List<TopProductSale> topProducts;

  /// CA des lignes avec recette connue.
  final double foodCostSalesRevenue;

  /// Coût matière théorique (RecipeItems × Ingredients.costPerUnit).
  final double foodCostTheoretical;

  /// Écart CA − coût théorique (marge brute matière).
  final double foodCostGap;

  /// Coût / CA × 100 (0 si pas de recettes).
  final double foodCostRatioPercent;
}
