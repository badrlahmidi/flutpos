import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(const PaymentInitial()) {
    on<PaymentStarted>(_onStarted);
    on<PaymentDigitEntered>(_onDigitEntered);
    on<PaymentBackspacePressed>(_onBackspace);
    on<PaymentClearEntryPressed>(_onClear);
    on<PaymentQuickBillPressed>(_onQuickBill);
    on<PaymentSetRemainingPressed>(_onSetRemaining);
    on<PaymentMethodPressed>(_onMethodPressed);
    on<PaymentSplitModeToggled>(_onSplitToggled);
    on<PaymentCashDrawerHandled>(_onCashDrawerHandled);
    on<PaymentDiscountApplied>(_onDiscountApplied);
  }

  final OrderRepository _orderRepository;

  Future<void> _onStarted(
    PaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(const PaymentLoading());
    await _reload(emit, event.orderId);
  }

  void _onDigitEntered(
    PaymentDigitEntered event,
    Emitter<PaymentState> emit,
  ) {
    final current = state;
    if (current is! PaymentReady || current.isProcessing) {
      return;
    }

    final digit = event.digit;
    if (digit == ',' || digit == '.') {
      if (current.entryAmount.contains('.')) {
        return;
      }
      final next = current.entryAmount.isEmpty ? '0.' : '${current.entryAmount}.';
      emit(_copyWithEntry(current, next));
      return;
    }

    if (!RegExp(r'^\d$').hasMatch(digit)) {
      return;
    }

    final next = current.entryAmount == '0'
        ? digit
        : '${current.entryAmount}$digit';
    emit(_copyWithEntry(current, next));
  }

  void _onBackspace(PaymentBackspacePressed event, Emitter<PaymentState> emit) {
    final current = state;
    if (current is! PaymentReady || current.entryAmount.isEmpty) {
      return;
    }
    final next = current.entryAmount.substring(0, current.entryAmount.length - 1);
    emit(_copyWithEntry(current, next));
  }

  void _onClear(PaymentClearEntryPressed event, Emitter<PaymentState> emit) {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }
    emit(_copyWithEntry(current, ''));
  }

  void _onQuickBill(
    PaymentQuickBillPressed event,
    Emitter<PaymentState> emit,
  ) {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }
    final existing = _parseEntry(current.entryAmount) ?? 0;
    final next = _formatEntry(existing + event.amountDh);
    emit(_copyWithEntry(current, next));
  }

  void _onSetRemaining(
    PaymentSetRemainingPressed event,
    Emitter<PaymentState> emit,
  ) {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }
    emit(_copyWithEntry(current, _formatEntry(current.remainingToPay)));
  }

  void _onSplitToggled(
    PaymentSplitModeToggled event,
    Emitter<PaymentState> emit,
  ) {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }
    emit(
      _copyWithEntry(
        current,
        current.entryAmount,
        isSplitMode: !current.isSplitMode,
      ),
    );
  }

  Future<void> _onMethodPressed(
    PaymentMethodPressed event,
    Emitter<PaymentState> emit,
  ) async {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }

    emit(current.copyWith(isProcessing: true, errorMessage: null));

    try {
      final paymentAmount = _resolvePaymentAmount(current);
      if (paymentAmount <= 0) {
        emit(
          current.copyWith(
            isProcessing: false,
            errorMessage: 'Montant invalide',
          ),
        );
        return;
      }

      var amountToRecord = paymentAmount;
      if (event.method == PaymentMethod.cash &&
          paymentAmount > current.remainingToPay + 0.009) {
        amountToRecord = current.remainingToPay;
      } else if (paymentAmount > current.remainingToPay + 0.009) {
        emit(
          current.copyWith(
            isProcessing: false,
            errorMessage: 'Montant supérieur au reste à payer',
          ),
        );
        return;
      }

      await _orderRepository.addPayment(
        orderId: current.order.order.id,
        method: event.method,
        amount: roundMoney(amountToRecord),
      );

      final wasCash = event.method == PaymentMethod.cash;

      await _orderRepository.finalizeOrderIfFullyPaid(current.order.order.id);
      await _reload(
        emit,
        current.order.order.id,
        clearEntry: true,
        cashDrawerOnCash: wasCash,
      );
    } catch (e) {
      final ready = state;
      if (ready is PaymentReady) {
        emit(
          ready.copyWith(
            isProcessing: false,
            errorMessage: e.toString(),
          ),
        );
      }
    }
  }

  double _resolvePaymentAmount(PaymentReady state) {
    final parsed = _parseEntry(state.entryAmount);
    if (parsed != null && parsed > 0) {
      return parsed;
    }
    return state.remainingToPay;
  }

  PaymentReady _copyWithEntry(
    PaymentReady state,
    String entry, {
    bool? isSplitMode,
  }) {
    return state.copyWith(
      entryAmount: entry,
      isSplitMode: isSplitMode,
      changePreview: _changePreview(
        remaining: state.remainingToPay,
        entry: entry,
      ),
      errorMessage: null,
    );
  }

  ChangeResult? _changePreview({
    required double remaining,
    required String entry,
  }) {
    final received = _parseEntry(entry);
    if (received == null || received <= 0) {
      return null;
    }
    return CalculateChange.call(
      amountDue: remaining,
      amountReceived: received,
    );
  }

  Future<void> _onDiscountApplied(
    PaymentDiscountApplied event,
    Emitter<PaymentState> emit,
  ) async {
    final current = state;
    if (current is! PaymentReady) {
      return;
    }

    emit(current.copyWith(isProcessing: true, errorMessage: null));

    try {
      await _orderRepository.applyDiscount(
        userId: event.managerUserId,
        orderId: current.order.order.id,
        discountType: event.discountType,
        discountValue: event.discountValue,
        reason: event.reason,
        authorizedByUserId: event.managerUserId,
      );
      await _reload(emit, current.order.order.id);
    } catch (e) {
      final ready = state;
      if (ready is PaymentReady) {
        emit(
          ready.copyWith(
            isProcessing: false,
            errorMessage: 'Remise : $e',
          ),
        );
      }
    }
  }

  void _onCashDrawerHandled(
    PaymentCashDrawerHandled event,
    Emitter<PaymentState> emit,
  ) {
    final current = state;
    if (current is! PaymentReady || !current.pendingCashDrawer) {
      return;
    }
    emit(current.copyWith(pendingCashDrawer: false));
  }

  Future<void> _reload(
    Emitter<PaymentState> emit,
    String orderId, {
    bool clearEntry = false,
    bool cashDrawerOnCash = false,
  }) async {
    final previous = state;
    try {
      final order = await _orderRepository.getCompleteOrder(orderId);
      if (order == null) {
        emit(const PaymentFailure('Commande introuvable'));
        return;
      }

      if (order.items.isEmpty) {
        emit(const PaymentFailure('Panier vide'));
        return;
      }

      final totals = CalculateOrderTotal.call(
        lines: PaymentOrderMapper.toLineInputs(order),
        discount: PaymentOrderMapper.toDiscountInput(order.order),
      );
      final amountDue = totals.grandTotal;
      final totalPaid = roundMoney(
        order.payments.fold<double>(0, (s, p) => s + p.amount),
      );
      final remaining = roundMoney((amountDue - totalPaid).clamp(0, double.infinity));

      if (order.order.status == 'PAID' || remaining <= 0.009) {
        emit(PaymentSuccess(order, openCashDrawer: cashDrawerOnCash));
        return;
      }

      final entry = clearEntry
          ? ''
          : (previous is PaymentReady ? previous.entryAmount : '');
      final splitMode =
          previous is PaymentReady ? previous.isSplitMode : false;
      emit(
        PaymentReady(
          order: order,
          totals: totals,
          amountDue: amountDue,
          totalPaid: totalPaid,
          remainingToPay: remaining,
          entryAmount: entry,
          isSplitMode: splitMode,
          changePreview: _changePreview(remaining: remaining, entry: entry),
          pendingCashDrawer: cashDrawerOnCash,
        ),
      );
    } catch (e) {
      emit(PaymentFailure('Erreur encaissement : $e'));
    }
  }

  double? _parseEntry(String raw) {
    if (raw.isEmpty) {
      return null;
    }
    return double.tryParse(raw.replaceAll(',', '.'));
  }

  String _formatEntry(double value) {
    final rounded = roundMoney(value);
    if (rounded == rounded.roundToDouble()) {
      return rounded.toInt().toString();
    }
    return rounded.toStringAsFixed(2);
  }
}

extension on PaymentReady {
  PaymentReady copyWith({
    String? entryAmount,
    bool? isSplitMode,
    ChangeResult? changePreview,
    bool? isProcessing,
    String? errorMessage,
    bool? pendingCashDrawer,
  }) {
    return PaymentReady(
      order: order,
      totals: totals,
      amountDue: amountDue,
      totalPaid: totalPaid,
      remainingToPay: remainingToPay,
      entryAmount: entryAmount ?? this.entryAmount,
      isSplitMode: isSplitMode ?? this.isSplitMode,
      changePreview: changePreview ?? this.changePreview,
      isProcessing: isProcessing ?? this.isProcessing,
      errorMessage: errorMessage,
      pendingCashDrawer: pendingCashDrawer ?? this.pendingCashDrawer,
    );
  }
}
