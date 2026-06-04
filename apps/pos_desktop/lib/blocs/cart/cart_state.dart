import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

final class CartInitial extends CartState {
  const CartInitial();
}

final class CartLoading extends CartState {
  const CartLoading();
}

final class CartReady extends CartState {
  const CartReady(this.order, {this.feedbackMessage});

  final CompleteOrder order;
  final String? feedbackMessage;

  int get itemCount => order.items.length;

  @override
  List<Object?> get props => [
        order.order.id,
        order.items.length,
        order.subtotalAmount,
        feedbackMessage,
      ];
}

final class CartError extends CartState {
  const CartError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

extension CartStateX on CartState {
  OrderType get orderTypeOrDefault {
    return switch (this) {
      CartReady(:final order) => order.orderType,
      _ => OrderType.dineIn,
    };
  }

  CompleteOrder? get orderOrNull {
    return switch (this) {
      CartReady(:final order) => order,
      _ => null,
    };
  }

  bool get isOrderLocked {
    final status = orderOrNull?.order.status;
    return status == 'PROFORMA' || status == 'PAID';
  }

  bool get isProforma => orderOrNull?.order.status == 'PROFORMA';

  bool get isDeliveryOrder =>
      orderOrNull?.orderType == OrderType.delivery;

  OrderSource get orderSourceOrDefault {
    final raw = orderOrNull?.order.source;
    if (raw == null) {
      return OrderSource.manual;
    }
    return OrderSource.fromDb(raw);
  }

  String? get deliveryDisplayLabel {
    final order = orderOrNull?.order;
    if (order == null) {
      return null;
    }
    return DeliveryTicketHeader.displayLabel(order);
  }
}
