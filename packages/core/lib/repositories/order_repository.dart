import '../database/app_database.dart';
import '../entities/complete_order.dart';
import '../entities/fire_course_result.dart';
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
    String? orderId,
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
    int courseNumber = 1,
    String? orderItemId,
  });

  /// Réplique fidèle (mêmes IDs) d'une commande reçue du PC.
  Future<CompleteOrder?> mirrorOrderSnapshot({
    required String localSessionId,
    required Map<String, dynamic> snapshot,
  });

  /// Supprime le ticket local ouvert sur une table (PC sans commande).
  Future<void> clearLocalOpenOrderForTable(String tableId);

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

  /// Change la course d'une ligne non encore envoyée en cuisine.
  Future<OrderItem> updateOrderItemCourse({
    required String orderItemId,
    required int courseNumber,
  });

  /// Numéros de course ayant au moins une ligne non envoyée (`isFired == false`).
  Future<List<int>> listPendingCourseNumbers(String orderId);

  /// Envoie en cuisine toutes les lignes d'une course (`isFired = true`).
  Future<FireCourseResult> fireCourse({
    required String orderId,
    required int courseNumber,
  });

  /// Envoie la prochaine course en attente (numéro minimal non fired).
  Future<FireCourseResult?> fireNextPendingCourse(String orderId);

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

  /// Note globale sur le ticket (allergies, instructions service, etc.).
  Future<Order> updateOrderNotes({
    required String orderId,
    required String? notes,
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

  /// Assigne un client à la commande (pour le paiement en compte).
  Future<Order> setOrderCustomer(String orderId, String? customerId);

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
    String? orderId,
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
