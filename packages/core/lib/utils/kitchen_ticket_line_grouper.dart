import '../entities/grouped_kitchen_line.dart';
import '../entities/order_item_with_product.dart';

/// Regroupe les lignes ticket (même produit + modificateurs + notes).
abstract final class KitchenTicketLineGrouper {
  KitchenTicketLineGrouper._();

  static List<GroupedKitchenLine> group(List<OrderItemWithProduct> lines) {
    if (lines.isEmpty) {
      return [];
    }

    final buckets = <String, GroupedKitchenLine>{};

    for (final line in lines) {
      final key = _mergeKey(line);
      final existing = buckets[key];
      if (existing == null) {
        buckets[key] = GroupedKitchenLine(
          productName: line.product.name,
          quantity: line.orderItem.quantity,
          modifierSummary: line.modifierSummary,
          customNotes: line.orderItem.customNotes,
          sourceItemIds: [line.orderItem.id],
        );
      } else {
        buckets[key] = GroupedKitchenLine(
          productName: existing.productName,
          quantity: existing.quantity + line.orderItem.quantity,
          modifierSummary: existing.modifierSummary,
          customNotes: existing.customNotes,
          sourceItemIds: [...existing.sourceItemIds, line.orderItem.id],
        );
      }
    }

    return buckets.values.toList();
  }

  static String _mergeKey(OrderItemWithProduct line) {
    final modIds = line.modifiers
        .map((m) => m.modifierOptionId)
        .toList()
      ..sort();
    final notes = line.orderItem.customNotes ?? '';
    return '${line.product.id}|${modIds.join(',')}|$notes';
  }
}
