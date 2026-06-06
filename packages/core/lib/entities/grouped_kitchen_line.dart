/// Ligne synthétisée pour ticket cuisine/bar (articles identiques regroupés).
class GroupedKitchenLine {
  const GroupedKitchenLine({
    required this.productName,
    this.productNameAr,
    required this.quantity,
    required this.modifierSummary,
    this.customNotes,
    required this.sourceItemIds,
    this.courseNumber = 1,
  });

  final String productName;
  final String? productNameAr;
  final double quantity;
  final String modifierSummary;
  final String? customNotes;
  final List<String> sourceItemIds;
  final int courseNumber;
}
