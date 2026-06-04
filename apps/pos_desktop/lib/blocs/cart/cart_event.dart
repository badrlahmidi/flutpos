import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Ouvre la session caisse et crée une commande [OPEN].
final class CartStarted extends CartEvent {
  const CartStarted(this.user);

  final User user;

  @override
  List<Object?> get props => [user.id];
}

final class CartOrderTypeChanged extends CartEvent {
  const CartOrderTypeChanged(this.orderType);

  final OrderType orderType;

  @override
  List<Object?> get props => [orderType];
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product);

  final Product product;

  @override
  List<Object?> get props => [product.id];
}

/// Ajout avec modificateurs (nouvelle ligne, pas de fusion).
final class CartItemAddedWithModifiers extends CartEvent {
  const CartItemAddedWithModifiers({
    required this.product,
    required this.options,
  });

  final Product product;
  final List<ModifierOption> options;

  @override
  List<Object?> get props => [product.id, options.map((o) => o.id).toList()];
}

final class CartItemRemoved extends CartEvent {
  const CartItemRemoved(this.orderItemId);

  final String orderItemId;

  @override
  List<Object?> get props => [orderItemId];
}

final class CartItemQuantityUpdated extends CartEvent {
  const CartItemQuantityUpdated({
    required this.orderItemId,
    required this.quantity,
  });

  final String orderItemId;
  final double quantity;

  @override
  List<Object?> get props => [orderItemId, quantity];
}

final class CartReloadRequested extends CartEvent {
  const CartReloadRequested();
}

/// Imprime une proforma et verrouille la commande ([PROFORMA]).
final class CartProformaRequested extends CartEvent {
  const CartProformaRequested();
}

/// Remise globale (audit `APPLY_DISCOUNT` côté repository).
final class CartDiscountApplied extends CartEvent {
  const CartDiscountApplied({
    required this.managerUserId,
    required this.discountType,
    required this.discountValue,
    required this.reason,
    this.requestedByUserId,
  });

  final String managerUserId;
  final DiscountType discountType;
  final double discountValue;
  final String reason;
  final String? requestedByUserId;

  @override
  List<Object?> get props => [
        managerUserId,
        discountType,
        discountValue,
        reason,
        requestedByUserId,
      ];
}

/// Annulation article cuisine (`VOID_ITEM` + statut [VOIDED]).
final class CartItemVoided extends CartEvent {
  const CartItemVoided({
    required this.orderItemId,
    required this.managerUserId,
    required this.reason,
    this.requestedByUserId,
  });

  final String orderItemId;
  final String managerUserId;
  final String reason;
  final String? requestedByUserId;

  @override
  List<Object?> get props => [
        orderItemId,
        managerUserId,
        reason,
        requestedByUserId,
      ];
}

final class CartItemModifierAdded extends CartEvent {
  const CartItemModifierAdded({
    required this.orderItemId,
    required this.option,
  });

  final String orderItemId;
  final ModifierOption option;

  @override
  List<Object?> get props => [orderItemId, option.id];
}
