import '../database/app_database.dart';
import '../enums/order_source.dart';
import '../enums/order_type.dart';

/// En-tête ticket cuisine pour commandes livreur (impression en gros).
abstract final class DeliveryTicketHeader {
  DeliveryTicketHeader._();

  /// Ligne centrée `*** … ***` pour déclencher le style ESC/POS large.
  static String? kitchenBannerLine(Order order) {
    if (OrderType.fromDb(order.orderType) != OrderType.delivery) {
      return null;
    }

    final source = OrderSource.fromDb(order.source);
    if (source == OrderSource.manual) {
      return null;
    }

    final ref = order.externalRef?.trim();
    final refPart = ref != null && ref.isNotEmpty ? ' #$ref' : '';
    return '*** ${source.emoji} ${source.label.toUpperCase()}$refPart ***';
  }

  /// Libellé compact pour l'UI caisse.
  static String? displayLabel(Order order) {
    final source = OrderSource.fromDb(order.source);
    if (source == OrderSource.manual &&
        OrderType.fromDb(order.orderType) != OrderType.delivery) {
      return null;
    }
    if (source == OrderSource.manual) {
      return 'Livraison';
    }
    final ref = order.externalRef?.trim();
    if (ref != null && ref.isNotEmpty) {
      return '${source.emoji} ${source.label} #$ref';
    }
    return '${source.emoji} ${source.label}';
  }
}
