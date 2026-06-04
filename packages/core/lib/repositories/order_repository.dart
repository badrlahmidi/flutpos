import '../database/app_database.dart';
import '../entities/complete_order.dart';
import '../enums/discount_type.dart';
import '../enums/order_source.dart';
import '../enums/order_type.dart';
import '../enums/payment_method.dart';

/// Persistance et agrégation des commandes (prix figés à l'ajout).
abstract class OrderRepository {
  double resolveUnitPrice(Product product, OrderType orderType);

  Future<CashSession?> getOpenSessionForCashier(String cashierId);

  Future<CashSession> ensureOpenSession({
    required String cashierId,
    double openingBalance = 0,
  });

  Future<Order> createOrder({
    required String sessionId,
    required String waiterId,
    required OrderType orderType,
    String? tableId,
    int guestCount = 1,
    OrderSource source = OrderSource.manual,
    String? externalRef,
  });

  /// Commande livraison (sans table, type [DELIVERY], tarifs livraison).
  Future<Order> createDeliveryOrder({
    required String sessionId,
    required String waiterId,
    required OrderSource source,
    String? externalRef,
  });

  /// Tickets livraison ouverts de la session en cours.
  Future<List<Order>> listOpenDeliveryOrders(String sessionId);

  Future<OrderItem> addOrderItem({
    required String orderId,
    required Product product,
    required OrderType orderType,
    double quantity = 1,
    String? customNotes,
  });

  Future<OrderItemModifier> addOrderItemModifier({
    required String orderItemId,
    required ModifierOption option,
  });

  Future<void> updateOrderItemQuantity({
    required String orderItemId,
    required double quantity,
  });

  /// Supprime une ligne non envoyée en cuisine.
  /// Retourne `true` si annulation avec grâce (< 30 s, sans audit).
  Future<bool> removeOrderItem(String orderItemId);

  /// Marque des lignes comme envoyées en cuisine (`isFired`).
  Future<void> markOrderItemsFired(Iterable<String> orderItemIds);

  /// Remise globale — audit `APPLY_DISCOUNT` **avant** mise à jour.
  Future<Order> applyDiscount({
    required String userId,
    required String orderId,
    required DiscountType discountType,
    required double discountValue,
    required String reason,
    String? authorizedByUserId,
  });

  /// Annulation article (cuisine) — audit `VOID_ITEM` **avant** mise à jour.
  Future<OrderItem> voidOrderItem({
    required String userId,
    required String orderItemId,
    required String reason,
    String? authorizedByUserId,
  });

  Future<void> updateOrderType({
    required String orderId,
    required OrderType orderType,
  });

  /// Note provisoire — passe la commande en [PROFORMA] (plus d'ajout d'articles).
  Future<Order> markOrderProforma(String orderId);

  Future<CompleteOrder?> getCompleteOrder(String orderId);

  Future<Payment> addPayment({
    required String orderId,
    required PaymentMethod method,
    required double amount,
    String? reference,
  });

  /// Marque la commande [PAID] si le total encaissé couvre le dû.
  Future<Order> finalizeOrderIfFullyPaid(String orderId);

  /// Enregistre les données facture entreprise (avant encaissement).
  Future<Order> setEnterpriseInvoice({
    required String orderId,
    required String companyName,
    required String companyIce,
  });

  /// Retire la demande de facture entreprise.
  Future<Order> clearEnterpriseInvoice(String orderId);

  /// Prochain numéro de facture séquentiel.
  Future<int> peekNextInvoiceNumber();

  /// Attribue un numéro de facture si [companyIce] est renseigné.
  Future<Order> issueInvoiceNumberIfNeeded(String orderId);

  /// Commande ouverte sur une table (`OPEN`, `SENT`, `PROFORMA`).
  Future<Order?> getOpenOrderForTable(String tableId);

  /// Ouvre une commande sur table et passe la table en [OCCUPIED].
  Future<Order> openTableOrder({
    required String sessionId,
    required String waiterId,
    required String tableId,
    int guestCount = 1,
  });

  /// Transfère un ticket vers une autre table (libère l'ancienne).
  Future<Order> transferTableOrder({
    required String orderId,
    required String targetTableId,
  });

  /// Fusionne deux tickets ouverts (lignes → cible, source annulée).
  Future<Order> mergeTableOrders({
    required String targetOrderId,
    required String sourceOrderId,
  });

  /// Déplace une ligne (ou une partie) vers un sous-ticket pour split bill.
  Future<({Order subOrder, OrderItem movedItem})> splitOrderItemToSubOrder({
    required String sourceOrderId,
    required String orderItemId,
    String? targetSubOrderId,
    double quantityToMove = 1,
  });

  /// Sous-tickets ouverts liés à la même session (sans table).
  Future<List<Order>> getOpenSubOrdersForSession(String sessionId);
}
