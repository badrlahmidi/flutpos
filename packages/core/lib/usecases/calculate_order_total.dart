import '../enums/discount_type.dart';
import 'models/order_discount_input.dart';
import 'models/order_line_input.dart';
import 'models/order_total_result.dart';
import 'money_math.dart';

/// Calcule sous-total, modificateurs, remise globale et TVA (logique pure).
abstract final class CalculateOrderTotal {
  CalculateOrderTotal._();

  static OrderTotalResult call({
    required List<OrderLineInput> lines,
    OrderDiscountInput? discount,
  }) {
    final activeLines = lines.where((l) => !l.isVoided).toList();

    var subtotal = 0.0;
    var modifiersTotal = 0.0;
    var taxAmount = 0.0;

    for (final line in activeLines) {
      subtotal += line.lineSubtotal;
      modifiersTotal += line.quantity * line.modifierExtrasTotal;
      taxAmount += line.lineSubtotal * (line.taxRate / 100);
    }

    subtotal = roundMoney(subtotal);
    modifiersTotal = roundMoney(modifiersTotal);
    taxAmount = roundMoney(taxAmount);

    final discountAmount = _computeDiscount(
      subtotal: subtotal,
      discount: discount,
    );

    final totalDue = roundMoney(subtotal - discountAmount);

    return OrderTotalResult(
      subtotal: subtotal,
      modifiersTotal: modifiersTotal,
      discountAmount: discountAmount,
      taxAmount: taxAmount,
      totalDue: totalDue,
    );
  }

  static double _computeDiscount({
    required double subtotal,
    OrderDiscountInput? discount,
  }) {
    if (discount == null || subtotal <= 0) {
      return 0;
    }

    final amount = switch (discount.type) {
      DiscountType.percentage => subtotal * (discount.value / 100),
      DiscountType.fixedAmount => discount.value,
    };

    return roundMoney(amount.clamp(0, subtotal));
  }
}
