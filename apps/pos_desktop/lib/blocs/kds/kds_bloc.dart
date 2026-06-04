import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:network/network.dart';

import '../../di/app_bootstrap.dart';
import 'kds_event.dart';
import 'kds_state.dart';

class KdsBloc extends Bloc<KdsEvent, KdsState> {
  KdsBloc({required KdsRepository kdsRepository})
      : _kds = kdsRepository,
        super(const KdsInitial()) {
    on<KdsStarted>(_onStarted);
    on<KdsRefreshRequested>(_onRefresh);
    on<KdsItemReadyPressed>(_onItemReady);
  }

  final KdsRepository _kds;
  StreamSubscription<List<KdsOrderTicket>>? _watchSub;

  Future<void> _onStarted(KdsStarted event, Emitter<KdsState> emit) async {
    emit(const KdsLoading());
    await _watchSub?.cancel();
    _watchSub = _kds.watchPendingTickets().listen(
      (_) => add(const KdsRefreshRequested()),
    );
    await _load(emit);
  }

  Future<void> _onRefresh(
    KdsRefreshRequested event,
    Emitter<KdsState> emit,
  ) async {
    final current = state;
    if (current is! KdsReady && current is! KdsLoading) {
      return;
    }
    if (current is! KdsLoading) {
      emit(const KdsLoading());
    }
    await _load(emit, keepLastReady: current is KdsReady);
  }

  Future<void> _onItemReady(
    KdsItemReadyPressed event,
    Emitter<KdsState> emit,
  ) async {
    try {
      await _kds.markOrderItemReady(event.orderItemId);

      final server = AppBootstrap.instance.networkServer;
      if (server.isRunning) {
        server.broadcast(
          EventEnvelope.create(
            action: WsAction.orderStatusChanged,
            deviceId: 'kds-desktop',
            payload: {
              'orderId': event.orderId,
              'orderItemId': event.orderItemId,
              'status': 'PREPARING',
              'productName': event.productName,
            },
          ),
        );
      }

      final tickets = await _kds.loadPendingTickets();
      emit(
        KdsReady(
          tickets: tickets,
          lastReadyProductName: event.productName,
        ),
      );
    } catch (e) {
      emit(KdsError('Prêt : $e'));
      await _load(emit);
    }
  }

  Future<void> _load(
    Emitter<KdsState> emit, {
    bool keepLastReady = false,
  }) async {
    try {
      final tickets = await _kds.loadPendingTickets();
      final lastReady = keepLastReady && state is KdsReady
          ? (state as KdsReady).lastReadyProductName
          : null;
      emit(KdsReady(tickets: tickets, lastReadyProductName: lastReady));
    } catch (e) {
      emit(KdsError('Chargement KDS : $e'));
    }
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }
}
