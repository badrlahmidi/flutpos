import '../database/app_database.dart';

/// Ligne de commande enrichie (article + produit + modificateurs figés).
class OrderItemWithProduct {
  const OrderItemWithProduct({
    required this.orderItem,
    required this.product,
    required this.modifiers,
    this.modifierOptions = const [],
  });

  final OrderItem orderItem;
  final Product product;
  final List<OrderItemModifier> modifiers;
  final List<ModifierOption> modifierOptions;

  double get modifiersExtraTotal =>
      modifiers.fold<double>(0, (sum, m) => sum + m.priceExtra);

  String get modifierSummary =>
      modifierOptions.map((o) => o.name).join(' · ');

  /// Sous-total ligne : quantité × (prix unitaire figé + extras modificateurs).
  double get lineSubtotal =>
      orderItem.quantity * (orderItem.unitPrice + modifiersExtraTotal);
}
