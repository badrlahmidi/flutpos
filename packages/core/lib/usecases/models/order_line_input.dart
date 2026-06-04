/// Ligne de commande pour calculs financiers (sans dépendance Drift).
class OrderLineInput {
  const OrderLineInput({
    required this.quantity,
    required this.unitPrice,
    this.modifierExtrasTotal = 0,
    this.taxRate = 20,
    this.status = 'PENDING',
  });

  final double quantity;
  final double unitPrice;
  final double modifierExtrasTotal;
  final double taxRate;
  final String status;

  bool get isVoided => status == 'VOIDED';

  double get lineSubtotal => quantity * (unitPrice + modifierExtrasTotal);
}
