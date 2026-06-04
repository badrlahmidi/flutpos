import '../database/app_database.dart';
import '../enums/order_type.dart';
import 'order_item_with_product.dart';

/// Commande agrégée avec lignes, paiements et totaux calculés.
class CompleteOrder {
  const CompleteOrder({
    required this.order,
    required this.waiter,
    required this.items,
    required this.payments,
    this.table,
  });

  final Order order;
  final RestaurantTable? table;
  final User waiter;
  final List<OrderItemWithProduct> items;
  final List<Payment> payments;

  OrderType get orderType => OrderType.fromDb(order.orderType);

  double get subtotalAmount =>
      items.fold<double>(0, (sum, item) => sum + item.lineSubtotal);

  double get discountAmount {
    final type = order.discountType;
    final value = order.discountValue;
    if (type == null || value == null) {
      return 0;
    }
    if (type == 'PERCENTAGE') {
      return subtotalAmount * (value / 100);
    }
    if (type == 'FIXED_AMOUNT') {
      return value.clamp(0, subtotalAmount);
    }
    return 0;
  }

  double get totalAmount => subtotalAmount - discountAmount;

  /// Total affiché caisse : sous-total + TVA − remises.
  double get grandTotal => subtotalAmount + taxAmount - discountAmount;

  double get totalPaid =>
      payments.fold<double>(0, (sum, payment) => sum + payment.amount);

  double get remainingToPay =>
      (totalAmount - totalPaid).clamp(0, double.infinity);

  double get changeToReturn {
    final change = totalPaid - totalAmount;
    return change > 0 ? change : 0;
  }

  /// TVA estimée à partir des taux figés sur chaque ligne (prix HT implicites).
  double get taxAmount => items.fold<double>(0, (sum, item) {
        final lineHt = item.lineSubtotal;
        return sum + lineHt * (item.orderItem.taxRate / 100);
      });
}
