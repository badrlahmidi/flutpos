import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({
    required OrderRepository orderRepository,
    required CashSessionRepository cashSessionRepository,
  })  : _orderRepository = orderRepository,
        _cashSessionRepository = cashSessionRepository,
        super(const CartInitial()) {
    on<CartStarted>(_onStarted);
    on<CartOrderTypeChanged>(_onOrderTypeChanged);
    on<CartItemAdded>(_onItemAdded);
    on<CartItemAddedWithModifiers>(_onItemAddedWithModifiers);
    on<CartItemRemoved>(_onItemRemoved);
    on<CartItemQuantityUpdated>(_onQuantityUpdated);
    on<CartItemModifierAdded>(_onModifierAdded);
    on<CartReloadRequested>(_onReloadRequested);
    on<CartProformaRequested>(_onProformaRequested);
        on<CartDiscountApplied>(_onDiscountApplied);
    on<CartItemVoided>(_onItemVoided);
    on<CartActiveCourseSelected>(_onActiveCourseSelected);
    on<CartItemCourseChanged>(_onItemCourseChanged);
    on<CartCourseFireRequested>(_onCourseFireRequested);
    on<CartOrderNotesChanged>(_onOrderNotesChanged);
  }

  final OrderRepository _orderRepository;
  final CashSessionRepository _cashSessionRepository;
  String? _orderId;
  String? _cashierId;
  int _activeCourseNumber = 1;

  Future<void> _onStarted(CartStarted event, Emitter<CartState> emit) async {
    emit(const CartLoading());
    try {
      final session =
          await _cashSessionRepository.getOpenSessionForCashier(event.user.id);
      if (session == null) {
        emit(const CartError(
          'Aucune session ouverte — ouvrez la caisse (menu Trésorerie)',
        ));
        return;
      }

      _cashierId = event.user.id;

      if (event.existingOrderId != null) {
        final existing =
            await _orderRepository.getCompleteOrder(event.existingOrderId!);
        if (existing == null) {
          emit(const CartError('Ticket introuvable'));
          return;
        }
        _orderId = existing.order.id;
      } else if (event.deliverySource != null) {
        final order = await _orderRepository.createDeliveryOrder(
          sessionId: session.id,
          waiterId: event.user.id,
          source: event.deliverySource!,
          externalRef: event.externalRef,
        );
        _orderId = order.id;
      } else if (event.tableId != null) {
        final order = await _orderRepository.openTableOrder(
          sessionId: session.id,
          waiterId: event.user.id,
          tableId: event.tableId!,
          guestCount: event.guestCount ?? 1,
        );
        _orderId = order.id;
      } else {
        final order = await _orderRepository.createOrder(
          sessionId: session.id,
          waiterId: event.user.id,
          orderType: OrderType.dineIn,
        );
        _orderId = order.id;
      }

      await _emitOrder(emit);
    } catch (e) {
      emit(CartError('Impossible d\'ouvrir la commande : $e'));
    }
  }

  Future<void> _recoverOrEmitError(
    Emitter<CartState> emit,
    Object error,
    String context,
  ) async {
    try {
      await _emitOrder(emit);
    } catch (_) {
      emit(CartError('$context : $error'));
    }
  }

  Future<void> _onOrderTypeChanged(
    CartOrderTypeChanged event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }

    final current = state.orderOrNull;
    if (current != null &&
        OrderSource.fromDb(current.order.source) != OrderSource.manual) {
      return;
    }

    try {
      await _orderRepository.updateOrderType(
        orderId: orderId,
        orderType: event.orderType,
      );
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Type de commande');
    }
  }

  Future<void> _onOrderNotesChanged(
    CartOrderNotesChanged event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }

    final current = state.orderOrNull;
    final normalized = event.notes.trim().isEmpty ? null : event.notes.trim();
    if (current == null || current.order.notes == normalized) {
      return;
    }

    try {
      await _orderRepository.updateOrderNotes(
        orderId: orderId,
        notes: normalized,
      );
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Note de commande');
    }
  }

  Future<void> _onItemAdded(
    CartItemAdded event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }

    final current = state.orderOrNull;
    if (current == null) {
      return;
    }

    emit(const CartLoading());

    try {
      final orderType = current.orderType;
      final course = event.courseNumber ?? _activeCourseNumber;
      final mergeTarget = _findMergeableLine(current, event.product.id, course);

      if (mergeTarget != null) {
        await _orderRepository.updateOrderItemQuantity(
          orderItemId: mergeTarget.orderItem.id,
          quantity: mergeTarget.orderItem.quantity + 1,
        );
      } else {
        await _orderRepository.addOrderItem(
          orderId: orderId,
          product: event.product,
          orderType: orderType,
          courseNumber: course,
        );
      }
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Ajout article');
    }
  }

  Future<void> _onItemAddedWithModifiers(
    CartItemAddedWithModifiers event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    final current = state.orderOrNull;
    if (orderId == null || current == null) {
      return;
    }

    emit(const CartLoading());

    try {
      final item = await _orderRepository.addOrderItem(
        orderId: orderId,
        product: event.product,
        orderType: current.orderType,
        courseNumber: event.courseNumber ?? _activeCourseNumber,
        customNotes: event.customNotes,
      );
      for (final option in event.options) {
        await _orderRepository.addOrderItemModifier(
          orderItemId: item.id,
          option: option,
        );
      }
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Ajout avec modificateurs');
    }
  }

  Future<void> _onItemRemoved(
    CartItemRemoved event,
    Emitter<CartState> emit,
  ) async {
    if (_orderId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      final graceful =
          await _orderRepository.removeOrderItem(event.orderItemId);
      await _emitOrder(
        emit,
        feedbackMessage: graceful
            ? 'Annulation discrète (grâce 30 s)'
            : null,
      );
    } on OrderItemVoidRequired catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Suppression');
    }
  }

  Future<void> _onQuantityUpdated(
    CartItemQuantityUpdated event,
    Emitter<CartState> emit,
  ) async {
    if (_orderId == null) {
      return;
    }

    emit(const CartLoading());

    try {
      if (event.quantity <= 0) {
        final graceful =
            await _orderRepository.removeOrderItem(event.orderItemId);
        await _emitOrder(
          emit,
          feedbackMessage: graceful
              ? 'Annulation discrète (grâce 30 s)'
              : null,
        );
      } else {
        await _orderRepository.updateOrderItemQuantity(
          orderItemId: event.orderItemId,
          quantity: event.quantity,
        );
        await _emitOrder(emit);
      }
    } on OrderItemVoidRequired catch (e) {
      emit(CartError(e.message));
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Quantité');
    }
  }

  Future<void> _onDiscountApplied(
    CartDiscountApplied event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      await _orderRepository.applyDiscount(
        userId: event.managerUserId,
        orderId: orderId,
        discountType: event.discountType,
        discountValue: event.discountValue,
        reason: event.reason,
        authorizedByUserId: event.managerUserId,
      );
      await _emitOrder(emit);
    } catch (e) {
      emit(CartError('Remise : $e'));
    }
  }

  Future<void> _onItemVoided(
    CartItemVoided event,
    Emitter<CartState> emit,
  ) async {
    if (_orderId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      await _orderRepository.voidOrderItem(
        userId: event.managerUserId,
        orderItemId: event.orderItemId,
        reason: event.reason,
        authorizedByUserId: event.managerUserId,
      );
      await _emitOrder(emit);
    } catch (e) {
      emit(CartError('Annulation : $e'));
    }
  }

  Future<void> _onProformaRequested(
    CartProformaRequested event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      await _orderRepository.markOrderProforma(orderId);
      await _emitOrder(emit);
    } catch (e) {
      emit(CartError('Proforma : $e'));
    }
  }

  Future<void> _onReloadRequested(
    CartReloadRequested event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    final cashierId = _cashierId;
    if (orderId == null || cashierId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      final current = await _orderRepository.getCompleteOrder(orderId);
      if (current != null && current.order.status == 'PAID') {
        final session =
            await _cashSessionRepository.getOpenSessionForCashier(cashierId);
        if (session == null) {
          emit(const CartError('Session caisse fermée — rouvrez la caisse'));
          return;
        }
        final order = await _orderRepository.createOrder(
          sessionId: session.id,
          waiterId: cashierId,
          orderType: OrderType.dineIn,
        );
        _orderId = order.id;
      }
      await _emitOrder(emit);
    } catch (e) {
      emit(CartError('Rechargement panier : $e'));
    }
  }

  Future<void> _onActiveCourseSelected(
    CartActiveCourseSelected event,
    Emitter<CartState> emit,
  ) async {
    if (event.courseNumber < CourseHelpers.minCourse ||
        event.courseNumber > CourseHelpers.maxCourse) {
      return;
    }
    _activeCourseNumber = event.courseNumber;
    final current = state.orderOrNull;
    if (current == null) {
      return;
    }
    emit(CartReady(current, activeCourseNumber: _activeCourseNumber));
  }

  Future<void> _onItemCourseChanged(
    CartItemCourseChanged event,
    Emitter<CartState> emit,
  ) async {
    if (_orderId == null) {
      return;
    }
    emit(const CartLoading());
    try {
      await _orderRepository.updateOrderItemCourse(
        orderItemId: event.orderItemId,
        courseNumber: event.courseNumber,
      );
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Course');
    }
  }

  Future<void> _onCourseFireRequested(
    CartCourseFireRequested event,
    Emitter<CartState> emit,
  ) async {
    final orderId = _orderId;
    if (orderId == null) {
      return;
    }
    emit(const CartLoading());
    try {
      final result = await _orderRepository.fireNextPendingCourse(orderId);
      if (result == null) {
        await _emitOrder(
          emit,
          feedbackMessage: 'Aucune course en attente à envoyer',
        );
        return;
      }
      await _emitOrder(
        emit,
        fireCourseResult: result,
        feedbackMessage:
            'Course ${result.courseNumber} envoyée (${result.firedItems.length} ligne(s))',
      );
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Envoi cuisine');
    }
  }

  Future<void> _onModifierAdded(
    CartItemModifierAdded event,
    Emitter<CartState> emit,
  ) async {
    if (_orderId == null) {
      return;
    }

    emit(const CartLoading());
    try {
      await _orderRepository.addOrderItemModifier(
        orderItemId: event.orderItemId,
        option: event.option,
      );
      await _emitOrder(emit);
    } catch (e) {
      await _recoverOrEmitError(emit, e, 'Modificateur');
    }
  }

  OrderItemWithProduct? _findMergeableLine(
    CompleteOrder order,
    String productId,
    int courseNumber,
  ) {
    for (final line in order.items) {
      if (line.product.id == productId &&
          line.modifiers.isEmpty &&
          line.orderItem.status != 'VOIDED' &&
          !line.orderItem.isFired &&
          line.orderItem.courseNumber == courseNumber) {
        return line;
      }
    }
    return null;
  }

  Future<void> _emitOrder(
    Emitter<CartState> emit, {
    String? feedbackMessage,
    FireCourseResult? fireCourseResult,
  }) async {
    final orderId = _orderId;
    if (orderId == null) {
      emit(const CartError('Commande non initialisée'));
      return;
    }

    final complete = await _orderRepository.getCompleteOrder(orderId);
    if (complete == null) {
      emit(const CartError('Commande introuvable'));
      return;
    }
    emit(CartReady(
      complete,
      feedbackMessage: feedbackMessage,
      fireCourseResult: fireCourseResult,
      activeCourseNumber: _activeCourseNumber,
    ));
  }
}
