import '../money_math.dart';

/// Résultat du calcul financier d'une commande.
class OrderTotalResult {
  const OrderTotalResult({
    required this.subtotal,
    required this.modifiersTotal,
    required this.discountAmount,
    required this.taxAmount,
    required this.totalDue,
  });

  /// Σ lignes actives (HT/TTC catalogue, prix figés + modificateurs).
  final double subtotal;

  /// Part modificateurs : Σ (qty × extras modificateurs).
  final double modifiersTotal;

  final double discountAmount;
  final double taxAmount;

  /// Montant à encaisser : sous-total − remise (règle schéma #280).
  final double totalDue;

  /// Total affichage avec TVA détaillée : sous-total + TVA − remise.
  double get grandTotal => roundMoney(subtotal + taxAmount - discountAmount);
}
