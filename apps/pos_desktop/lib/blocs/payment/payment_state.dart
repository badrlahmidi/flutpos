import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class PaymentState extends Equatable {
  const PaymentState();

  @override
  List<Object?> get props => [];
}

final class PaymentInitial extends PaymentState {
  const PaymentInitial();
}

final class PaymentLoading extends PaymentState {
  const PaymentLoading();
}

final class PaymentReady extends PaymentState {
  const PaymentReady({
    required this.order,
    required this.totals,
    required this.amountDue,
    required this.totalPaid,
    required this.remainingToPay,
    required this.entryAmount,
    required this.isSplitMode,
    required this.changePreview,
    this.isProcessing = false,
    this.errorMessage,
    this.pendingCashDrawer = false,
  });

  final CompleteOrder order;
  final OrderTotalResult totals;
  final double amountDue;
  final double totalPaid;
  final double remainingToPay;
  final String entryAmount;
  final bool isSplitMode;
  final ChangeResult? changePreview;
  final bool isProcessing;
  final String? errorMessage;
  final bool pendingCashDrawer;

  @override
  List<Object?> get props => [
        order.order.id,
        amountDue,
        totalPaid,
        remainingToPay,
        entryAmount,
        isSplitMode,
        changePreview?.changeAmount,
        isProcessing,
        errorMessage,
        pendingCashDrawer,
        order.payments.length,
      ];
}

final class PaymentSuccess extends PaymentState {
  const PaymentSuccess(this.order, {this.openCashDrawer = false});

  final CompleteOrder order;
  final bool openCashDrawer;

  @override
  List<Object?> get props => [order.order.id, openCashDrawer];
}

final class PaymentFailure extends PaymentState {
  const PaymentFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
