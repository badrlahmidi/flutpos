import '../database/app_database.dart';
import 'order_item_with_product.dart';

/// Ticket affiché sur l'écran cuisine (KDS).
class KdsOrderTicket {
  const KdsOrderTicket({
    required this.order,
    this.table,
    required this.pendingItems,
    this.headerLabel,
  });

  final Order order;
  final RestaurantTable? table;
  final List<OrderItemWithProduct> pendingItems;
  final String? headerLabel;

  DateTime get oldestItemAt {
    if (pendingItems.isEmpty) {
      return order.createdAt;
    }
    return pendingItems
        .map((i) => i.orderItem.createdAt)
        .reduce((a, b) => a.isBefore(b) ? a : b);
  }
}
