import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

/// Ouvre la session caisse et crée ou reprend une commande [OPEN].
final class CartStarted extends CartEvent {
  const CartStarted(
    this.user, {
    this.existingOrderId,
    this.tableId,
    this.guestCount,
    this.deliverySource,
    this.externalRef,
  });

  final User user;
  final String? existingOrderId;
  final String? tableId;
  final int? guestCount;
  final OrderSource? deliverySource;
  final String? externalRef;

  @override
  List<Object?> get props => [
        user.id,
        existingOrderId,
        tableId,
        guestCount,
        deliverySource,
        externalRef,
      ];
}

final class CartOrderTypeChanged extends CartEvent {
  const CartOrderTypeChanged(this.orderType);

  final OrderType orderType;

  @override
  List<Object?> get props => [orderType];
}

final class CartItemAdded extends CartEvent {
  const CartItemAdded(this.product, {this.courseNumber});

  final Product product;
  final int? courseNumber;

  @override
  List<Object?> get props => [product.id, courseNumber];
}

/// Ajout avec modificateurs (nouvelle ligne, pas de fusion).
final class CartItemAddedWithModifiers extends CartEvent {
  const CartItemAddedWithModifiers({
    required this.product,
    required this.options,
    this.courseNumber,
    this.customNotes,
  });

  final Product product;
  final List<ModifierOption> options;
  final int? courseNumber;
  final String? customNotes;

  @override
  List<Object?> get props => [
        product.id,
        options.map((o) => o.id).toList(),
        courseNumber,
        customNotes,
      ];
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

/// Course active pour les prochains ajouts (Entrée / Plat / Dessert).
final class CartActiveCourseSelected extends CartEvent {
  const CartActiveCourseSelected(this.courseNumber);

  final int courseNumber;

  @override
  List<Object?> get props => [courseNumber];
}

/// Change la course d'une ligne non envoyée en cuisine.
final class CartItemCourseChanged extends CartEvent {
  const CartItemCourseChanged({
    required this.orderItemId,
    required this.courseNumber,
  });

  final String orderItemId;
  final int courseNumber;

  @override
  List<Object?> get props => [orderItemId, courseNumber];
}

/// Envoie la prochaine course en attente en cuisine (`fireNextPendingCourse`).
final class CartCourseFireRequested extends CartEvent {
  const CartCourseFireRequested();
}
