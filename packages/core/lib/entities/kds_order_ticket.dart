import '../database/app_database.dart';
import 'order_item_with_product.dart';

/// Ticket affiché sur l'écran cuisine (KDS).
class KdsOrderTicket {
  const KdsOrderTicket({
    required this.order,
    this.table,
    required this.pendingItems,
    this.heldItems = const [],
    this.headerLabel,
  });

  final Order order;
  final RestaurantTable? table;
  /// Lignes envoyées en cuisine, en attente de préparation.
  final List<OrderItemWithProduct> pendingItems;
  /// Lignes non encore réclamées (`isFired == false`) — affichées « À suivre ».
  final List<OrderItemWithProduct> heldItems;
  final String? headerLabel;

  DateTime get oldestItemAt {
    final timestamps = [
      ...pendingItems.map((i) => i.orderItem.createdAt),
      ...heldItems.map((i) => i.orderItem.createdAt),
    ];
    if (timestamps.isEmpty) {
      return order.createdAt;
    }
    return timestamps.reduce((a, b) => a.isBefore(b) ? a : b);
  }
}
