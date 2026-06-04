import '../database/app_database.dart';
import '../enums/order_type.dart';

/// Règles de calcul des prix catalogue (avant figage dans [OrderItem.unitPrice]).
abstract final class OrderPricing {
  OrderPricing._();

  /// Règle #5 : fallback `priceTakeaway ?? priceDineIn` pour l'emporter.
  static double resolveUnitPrice(Product product, OrderType orderType) {
    switch (orderType) {
      case OrderType.takeaway:
        return product.priceTakeaway ?? product.priceDineIn;
      case OrderType.delivery:
        return product.priceDelivery ??
            product.priceTakeaway ??
            product.priceDineIn;
      case OrderType.dineIn:
        return product.priceDineIn;
    }
  }
}
