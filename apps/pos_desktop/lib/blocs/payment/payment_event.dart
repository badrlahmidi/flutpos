import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

final class PaymentStarted extends PaymentEvent {
  const PaymentStarted(this.orderId);

  final String orderId;

  @override
  List<Object?> get props => [orderId];
}

final class PaymentDigitEntered extends PaymentEvent {
  const PaymentDigitEntered(this.digit);

  final String digit;

  @override
  List<Object?> get props => [digit];
}

final class PaymentBackspacePressed extends PaymentEvent {
  const PaymentBackspacePressed();
}

final class PaymentClearEntryPressed extends PaymentEvent {
  const PaymentClearEntryPressed();
}

final class PaymentQuickBillPressed extends PaymentEvent {
  const PaymentQuickBillPressed(this.amountDh);

  final double amountDh;

  @override
  List<Object?> get props => [amountDh];
}

final class PaymentSetRemainingPressed extends PaymentEvent {
  const PaymentSetRemainingPressed();
}

final class PaymentMethodPressed extends PaymentEvent {
  const PaymentMethodPressed(this.method);

  final PaymentMethod method;

  @override
  List<Object?> get props => [method];
}

final class PaymentSplitModeToggled extends PaymentEvent {
  const PaymentSplitModeToggled();
}

final class PaymentCashDrawerHandled extends PaymentEvent {
  const PaymentCashDrawerHandled();
}

final class PaymentDiscountApplied extends PaymentEvent {
  const PaymentDiscountApplied({
    required this.managerUserId,
    required this.discountType,
    required this.discountValue,
    required this.reason,
  });

  final String managerUserId;
  final DiscountType discountType;
  final double discountValue;
  final String reason;

  @override
  List<Object?> get props => [
        managerUserId,
        discountType,
        discountValue,
        reason,
      ];
}
