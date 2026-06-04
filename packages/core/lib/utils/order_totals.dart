import '../entities/complete_order.dart';
import '../entities/order_item_with_product.dart';
import '../usecases/calculate_order_total.dart';
import '../usecases/models/order_total_result.dart';
import 'payment_order_mapper.dart';

/// Totaux panier / encaissement (lignes actives, remises, TVA).
extension CompleteOrderTotals on CompleteOrder {
  List<OrderItemWithProduct> get activeItems => items
      .where((line) => line.orderItem.status != 'VOIDED')
      .toList();

  OrderTotalResult get computedTotals => CalculateOrderTotal.call(
        lines: PaymentOrderMapper.toLineInputs(this),
        discount: PaymentOrderMapper.toDiscountInput(order),
      );

  double get displaySubtotal => computedTotals.subtotal;

  double get displayTaxAmount => computedTotals.taxAmount;

  double get displayDiscountAmount => computedTotals.discountAmount;

  double get displayGrandTotal => computedTotals.grandTotal;
}
