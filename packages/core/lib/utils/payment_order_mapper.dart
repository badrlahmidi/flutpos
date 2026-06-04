import '../database/app_database.dart';
import '../entities/complete_order.dart';
import '../enums/discount_type.dart';
import '../usecases/models/order_discount_input.dart';
import '../usecases/models/order_line_input.dart';

/// Convertit une [CompleteOrder] en entrées des usecases financiers.
abstract final class PaymentOrderMapper {
  PaymentOrderMapper._();

  static List<OrderLineInput> toLineInputs(CompleteOrder order) {
    return order.items
        .map(
          (line) => OrderLineInput(
            quantity: line.orderItem.quantity,
            unitPrice: line.orderItem.unitPrice,
            modifierExtrasTotal: line.modifiersExtraTotal,
            taxRate: line.orderItem.taxRate,
            status: line.orderItem.status,
          ),
        )
        .toList();
  }

  static OrderDiscountInput? toDiscountInput(Order order) {
    final type = DiscountType.fromDb(order.discountType);
    final value = order.discountValue;
    if (type == null || value == null) {
      return null;
    }
    return OrderDiscountInput(type: type, value: value);
  }
}
