/// Clés d'opérations pour le moteur RBAC niveaux 0-9.
abstract final class SecurityOperations {
  SecurityOperations._();

  // Général
  static const backofficeAccess = 'backoffice_access';
  static const settingsAccess = 'settings_access';
  static const closeSession = 'close_session';
  static const floorPlanEdit = 'floor_plan_edit';

  // Ventes (caisse)
  static const voidItem = 'void_item';
  static const voidOrder = 'void_order';
  static const applyDiscount = 'apply_discount';
  static const cashPayIn = 'cash_pay_in';
  static const cashPayOut = 'cash_pay_out';
  static const reprintReceipt = 'reprint_receipt';
  static const openCashDrawer = 'open_cash_drawer';
  static const sellOutOfStock = 'sell_out_of_stock';

  // Backoffice
  static const analyticsAccess = 'analytics_access';
  static const productsManage = 'products_manage';
  static const stockManage = 'stock_manage';
  static const clientsManage = 'clients_manage';
  static const promotionsManage = 'promotions_manage';
  static const securityManage = 'security_manage';

  // Stock
  static const quickInventory = 'quick_inventory';
  static const viewCostPrices = 'view_cost_prices';

  static const all = [
    backofficeAccess,
    settingsAccess,
    closeSession,
    floorPlanEdit,
    voidItem,
    voidOrder,
    applyDiscount,
    cashPayIn,
    cashPayOut,
    reprintReceipt,
    openCashDrawer,
    sellOutOfStock,
    analyticsAccess,
    productsManage,
    stockManage,
    clientsManage,
    promotionsManage,
    securityManage,
    quickInventory,
    viewCostPrices,
  ];
}

/// Définition statique d'une règle (seed & UI).
class SecurityRuleDefinition {
  const SecurityRuleDefinition({
    required this.operationKey,
    required this.category,
    required this.label,
    required this.defaultLevel,
    this.description,
  });

  final String operationKey;
  final String category;
  final String label;
  final int defaultLevel;
  final String? description;
}

/// Règles par défaut alignées sur la matrice RBAC existante.
abstract final class DefaultSecurityRules {
  DefaultSecurityRules._();

  static const definitions = [
    SecurityRuleDefinition(
      operationKey: SecurityOperations.backofficeAccess,
      category: 'general',
      label: 'Accès au backoffice',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.settingsAccess,
      category: 'general',
      label: 'Paramètres application',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.closeSession,
      category: 'general',
      label: 'Clôture de caisse (Z)',
      defaultLevel: 3,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.floorPlanEdit,
      category: 'general',
      label: 'Modification plan de salle',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.voidItem,
      category: 'sales',
      label: 'Annuler un article (envoyé cuisine)',
      defaultLevel: 9,
      description: 'Requiert PIN manager si niveau insuffisant.',
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.voidOrder,
      category: 'sales',
      label: 'Annuler une commande',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.applyDiscount,
      category: 'sales',
      label: 'Appliquer une remise',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.cashPayIn,
      category: 'sales',
      label: 'Entrée de caisse (Pay-in)',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.cashPayOut,
      category: 'sales',
      label: 'Sortie de caisse (Pay-out)',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.reprintReceipt,
      category: 'sales',
      label: 'Réimpression ticket',
      defaultLevel: 3,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.openCashDrawer,
      category: 'sales',
      label: 'Ouverture manuelle tiroir-caisse',
      defaultLevel: 3,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.sellOutOfStock,
      category: 'sales',
      label: 'Vente hors-stock',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.analyticsAccess,
      category: 'backoffice',
      label: 'Statistiques & rapports',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.productsManage,
      category: 'backoffice',
      label: 'Gestion produits & menu',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.stockManage,
      category: 'backoffice',
      label: 'Gestion stocks',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.clientsManage,
      category: 'backoffice',
      label: 'Gestion clients',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.promotionsManage,
      category: 'backoffice',
      label: 'Gestion promotions',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.securityManage,
      category: 'backoffice',
      label: 'Gestion utilisateurs & sécurité',
      defaultLevel: 9,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.quickInventory,
      category: 'stock',
      label: 'Inventaire rapide',
      defaultLevel: 7,
    ),
    SecurityRuleDefinition(
      operationKey: SecurityOperations.viewCostPrices,
      category: 'stock',
      label: 'Affichage prix d\'achat',
      defaultLevel: 9,
    ),
  ];
}
