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

/// Répartition par mode de paiement.
class PaymentMethodBreakdown {
  const PaymentMethodBreakdown({
    required this.method,
    required this.label,
    required this.amount,
    required this.count,
  });

  final String method;
  final String label;
  final double amount;
  final int count;
}

/// Répartition par catégorie.
class CategoryBreakdown {
  const CategoryBreakdown({
    required this.categoryId,
    required this.categoryName,
    required this.revenue,
    required this.quantity,
  });

  final String categoryId;
  final String categoryName;
  final double revenue;
  final double quantity;
}

/// Performance serveur (classement).
class WaiterPerformance {
  const WaiterPerformance({
    required this.userId,
    required this.userName,
    required this.ticketCount,
    required this.totalRevenue,
    required this.averageBasket,
  });

  final String userId;
  final String userName;
  final int ticketCount;
  final double totalRevenue;
  final double averageBasket;
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
    this.paymentBreakdown = const [],
    this.categoryBreakdown = const [],
    this.waiterPerformance = const [],
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

  /// Répartition par mode de paiement.
  final List<PaymentMethodBreakdown> paymentBreakdown;

  /// Répartition par catégorie.
  final List<CategoryBreakdown> categoryBreakdown;

  /// Performance des serveurs.
  final List<WaiterPerformance> waiterPerformance;
}
