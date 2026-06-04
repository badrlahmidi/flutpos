/// Ligne synthétisée pour ticket cuisine/bar (articles identiques regroupés).
class GroupedKitchenLine {
  const GroupedKitchenLine({
    required this.productName,
    required this.quantity,
    required this.modifierSummary,
    this.customNotes,
    required this.sourceItemIds,
  });

  final String productName;
  final double quantity;
  final String modifierSummary;
  final String? customNotes;
  final List<String> sourceItemIds;
}
