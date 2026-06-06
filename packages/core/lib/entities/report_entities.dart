/// Filtres communs à tous les rapports.
class ReportFilters {
  const ReportFilters({
    required this.startDate,
    required this.endDate,
    this.userId,
    this.categoryId,
    this.paymentMethodId,
    this.sessionId,
  });

  final DateTime startDate;
  final DateTime endDate;
  final String? userId;
  final String? categoryId;
  final String? paymentMethodId;
  final String? sessionId;

  ReportFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    String? userId,
    String? categoryId,
    String? paymentMethodId,
    String? sessionId,
    bool clearUserId = false,
    bool clearCategoryId = false,
    bool clearPaymentMethodId = false,
    bool clearSessionId = false,
  }) {
    return ReportFilters(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      userId: clearUserId ? null : (userId ?? this.userId),
      categoryId: clearCategoryId ? null : (categoryId ?? this.categoryId),
      paymentMethodId: clearPaymentMethodId
          ? null
          : (paymentMethodId ?? this.paymentMethodId),
      sessionId: clearSessionId ? null : (sessionId ?? this.sessionId),
    );
  }
}

/// Option utilisateur pour les filtres de rapport.
class ReportFilterUser {
  const ReportFilterUser({required this.id, required this.name});

  final String id;
  final String name;
}

/// Option catégorie pour les filtres de rapport.
class ReportFilterCategory {
  const ReportFilterCategory({required this.id, required this.name});

  final String id;
  final String name;
}

/// Option session de caisse pour les filtres de rapport.
class ReportFilterSession {
  const ReportFilterSession({
    required this.id,
    required this.label,
    required this.openedAt,
    this.closedAt,
  });

  final String id;
  final String label;
  final DateTime openedAt;
  final DateTime? closedAt;
}

/// Listes déroulantes alimentant le panneau de filtres.
class ReportingFilterOptions {
  const ReportingFilterOptions({
    required this.users,
    required this.categories,
    required this.sessions,
  });

  final List<ReportFilterUser> users;
  final List<ReportFilterCategory> categories;
  final List<ReportFilterSession> sessions;
}

/// Ligne du rapport "Ventes par Produit".
class ProductSalesReportLine {
  const ProductSalesReportLine({
    required this.productId,
    required this.productCode,
    required this.productName,
    required this.categoryName,
    required this.quantitySold,
    required this.totalHT,
    required this.totalTax,
    required this.totalTTC,
  });

  final String productId;
  final String productCode;
  final String productName;
  final String categoryName;
  final double quantitySold;
  final double totalHT;
  final double totalTax;
  final double totalTTC;
}

/// Ligne du rapport "Ventes par Catégorie".
class CategorySalesReportLine {
  const CategorySalesReportLine({
    required this.categoryId,
    required this.categoryName,
    required this.quantitySold,
    required this.totalHT,
    required this.totalTax,
    required this.totalTTC,
  });

  final String categoryId;
  final String categoryName;
  final double quantitySold;
  final double totalHT;
  final double totalTax;
  final double totalTTC;
}

/// Ligne du rapport "Ventes par Mode de Règlement".
class PaymentMethodReportLine {
  const PaymentMethodReportLine({
    required this.method,
    required this.transactionCount,
    required this.totalAmount,
  });

  final String method;
  final int transactionCount;
  final double totalAmount;
}

/// Ligne du rapport "Ventes par Utilisateur / Serveur".
class UserSalesReportLine {
  const UserSalesReportLine({
    required this.userId,
    required this.userName,
    required this.ticketCount,
    required this.totalTTC,
    required this.averageBasket,
  });

  final String userId;
  final String userName;
  final int ticketCount;
  final double totalTTC;
  final double averageBasket;
}

/// Rapport résumé multi-métriques (en-tête commun).
class ReportHeader {
  const ReportHeader({
    required this.title,
    required this.generatedAt,
    required this.filters,
    required this.totalTTC,
    required this.totalHT,
    required this.totalTax,
    required this.ticketCount,
  });

  final String title;
  final DateTime generatedAt;
  final ReportFilters filters;
  final double totalTTC;
  final double totalHT;
  final double totalTax;
  final int ticketCount;
}
