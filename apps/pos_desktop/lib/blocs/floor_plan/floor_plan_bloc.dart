import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'floor_plan_event.dart';
import 'floor_plan_state.dart';

class FloorPlanBloc extends Bloc<FloorPlanEvent, FloorPlanState> {
  FloorPlanBloc({
    required FloorPlanRepository floorPlanRepository,
    required OrderRepository orderRepository,
    required CashSessionRepository cashSessionRepository,
    required ReservationRepository reservationRepository,
  })  : _floorPlan = floorPlanRepository,
        _orders = orderRepository,
        _sessions = cashSessionRepository,
        _reservations = reservationRepository,
        super(const FloorPlanInitial()) {
    on<FloorPlanStarted>(_onStarted);
    on<FloorPlanRefreshRequested>(_onRefresh);
    on<FloorPlanZoneSelected>(_onZoneSelected);
    on<FloorPlanOpenTableRequested>(_onOpenTable);
    on<FloorPlanResumeTableRequested>(_onResume);
    on<FloorPlanTransferRequested>(_onTransfer);
    on<FloorPlanMergeRequested>(_onMerge);
    on<FloorPlanNavigationHandled>(_onNavigationHandled);
  }

  final FloorPlanRepository _floorPlan;
  final OrderRepository _orders;
  final CashSessionRepository _sessions;
  final ReservationRepository _reservations;

  StreamSubscription<List<FloorPlanZoneSnapshot>>? _watchSub;
  Timer? _syncTimer;
  String? _userId;

  Future<void> _onStarted(
    FloorPlanStarted event,
    Emitter<FloorPlanState> emit,
  ) async {
    _userId = event.user.id;
    emit(const FloorPlanLoading());

    final session = await _sessions.getOpenSessionForCashier(event.user.id);
    if (session == null) {
      emit(const FloorPlanError(
        'Ouvrez la caisse (Trésorerie) avant le service à table',
      ));
      return;
    }

    await _watchSub?.cancel();
    _watchSub = _floorPlan.watchFloorPlan().listen(
      (_) => add(const FloorPlanRefreshRequested()),
      onError: (Object e) => add(const FloorPlanRefreshRequested()),
    );

    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(
      const Duration(minutes: 1),
      (_) => add(const FloorPlanRefreshRequested()),
    );

    try {
      final zones = await _floorPlan.loadFloorPlan();
      if (zones.isEmpty) {
        emit(const FloorPlanError('Aucune zone configurée'));
        return;
      }
      emit(FloorPlanReady(zones: zones, selectedZoneIndex: 0));
    } catch (e) {
      emit(FloorPlanError('Chargement plan de salle : $e'));
    }
  }

  Future<void> _onRefresh(
    FloorPlanRefreshRequested event,
    Emitter<FloorPlanState> emit,
  ) async {
    final current = state;
    if (current is! FloorPlanReady && current is! FloorPlanLoading) {
      return;
    }

    final index = current is FloorPlanReady ? current.selectedZoneIndex : 0;

    try {
      final zones = await _floorPlan.loadFloorPlan();
      if (zones.isEmpty) {
        emit(const FloorPlanError('Aucune zone configurée'));
        return;
      }
      emit(
        FloorPlanReady(
          zones: zones,
          selectedZoneIndex: index.clamp(0, zones.length - 1),
        ),
      );
    } catch (e) {
      if (current is FloorPlanReady) {
        emit(current);
      } else {
        emit(FloorPlanError('Actualisation : $e'));
      }
    }
  }

  void _onZoneSelected(
    FloorPlanZoneSelected event,
    Emitter<FloorPlanState> emit,
  ) {
    final current = state;
    if (current is! FloorPlanReady) {
      return;
    }
    emit(current.copyWith(selectedZoneIndex: event.zoneIndex));
  }

  Future<void> _onOpenTable(
    FloorPlanOpenTableRequested event,
    Emitter<FloorPlanState> emit,
  ) async {
    final userId = _userId;
    final current = state;
    if (userId == null || current is! FloorPlanReady) {
      return;
    }

    try {
      final session = await _sessions.getOpenSessionForCashier(userId);
      if (session == null) {
        emit(const FloorPlanError('Session caisse fermée'));
        return;
      }

      final tableName = _tableName(current, event.tableId);
      final order = await _orders.openTableOrder(
        sessionId: session.id,
        waiterId: userId,
        tableId: event.tableId,
        guestCount: event.guestCount,
      );
      await _reservations.markSeatedForTable(event.tableId);

      final zones = await _floorPlan.loadFloorPlan();
      emit(
        current.copyWith(
          zones: zones,
          navigateToPos: FloorPlanPosNavigation(
            orderId: order.id,
            tableName: tableName,
          ),
        ),
      );
    } catch (e) {
      emit(FloorPlanError('Ouverture table : $e'));
      final zones = await _floorPlan.loadFloorPlan();
      if (zones.isNotEmpty) {
        emit(
          FloorPlanReady(
            zones: zones,
            selectedZoneIndex: current.selectedZoneIndex,
          ),
        );
      }
    }
  }

  void _onResume(
    FloorPlanResumeTableRequested event,
    Emitter<FloorPlanState> emit,
  ) {
    final current = state;
    if (current is! FloorPlanReady) {
      return;
    }
    emit(
      current.copyWith(
        navigateToPos: FloorPlanPosNavigation(
          orderId: event.orderId,
          tableName: event.tableName,
        ),
      ),
    );
  }

  Future<void> _onTransfer(
    FloorPlanTransferRequested event,
    Emitter<FloorPlanState> emit,
  ) async {
    final current = state;
    if (current is! FloorPlanReady) {
      return;
    }

    try {
      await _orders.transferTableOrder(
        orderId: event.orderId,
        targetTableId: event.targetTableId,
      );
      final zones = await _floorPlan.loadFloorPlan();
      emit(current.copyWith(zones: zones));
    } catch (e) {
      emit(FloorPlanError('Transfert : $e'));
      final zones = await _floorPlan.loadFloorPlan();
      emit(
        FloorPlanReady(
          zones: zones,
          selectedZoneIndex: current.selectedZoneIndex,
        ),
      );
    }
  }

  Future<void> _onMerge(
    FloorPlanMergeRequested event,
    Emitter<FloorPlanState> emit,
  ) async {
    final current = state;
    if (current is! FloorPlanReady) {
      return;
    }

    try {
      await _orders.mergeTableOrders(
        targetOrderId: event.targetOrderId,
        sourceOrderId: event.sourceOrderId,
      );
      final zones = await _floorPlan.loadFloorPlan();
      emit(current.copyWith(zones: zones));
    } catch (e) {
      emit(FloorPlanError('Fusion : $e'));
      final zones = await _floorPlan.loadFloorPlan();
      emit(
        FloorPlanReady(
          zones: zones,
          selectedZoneIndex: current.selectedZoneIndex,
        ),
      );
    }
  }

  void _onNavigationHandled(
    FloorPlanNavigationHandled event,
    Emitter<FloorPlanState> emit,
  ) {
    final current = state;
    if (current is FloorPlanReady) {
      emit(current.copyWith(clearNavigation: true));
    }
  }

  String _tableName(FloorPlanReady state, String tableId) {
    for (final zone in state.zones) {
      for (final snap in zone.tables) {
        if (snap.table.id == tableId) {
          return snap.table.name;
        }
      }
    }
    return 'Table';
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    _syncTimer?.cancel();
    return super.close();
  }
}
