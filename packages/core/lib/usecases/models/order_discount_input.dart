import '../../enums/discount_type.dart';

/// Remise globale appliquée au ticket.
class OrderDiscountInput {
  const OrderDiscountInput({
    required this.type,
    required this.value,
  });

  final DiscountType type;
  final double value;
}
