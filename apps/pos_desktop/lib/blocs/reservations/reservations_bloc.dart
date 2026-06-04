import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'reservations_event.dart';
import 'reservations_state.dart';

class ReservationsBloc extends Bloc<ReservationsEvent, ReservationsState> {
  ReservationsBloc({required ReservationRepository reservationRepository})
      : _repo = reservationRepository,
        super(const ReservationsInitial()) {
    on<ReservationsStarted>(_onStarted);
    on<ReservationsRefreshRequested>(_onRefresh);
    on<ReservationCreateSubmitted>(_onCreate);
    on<ReservationCancelRequested>(_onCancel);
  }

  final ReservationRepository _repo;

  Future<void> _onStarted(
    ReservationsStarted event,
    Emitter<ReservationsState> emit,
  ) async {
    emit(const ReservationsLoading());
    await _load(emit);
  }

  Future<void> _onRefresh(
    ReservationsRefreshRequested event,
    Emitter<ReservationsState> emit,
  ) async {
    final current = state;
    if (current is! ReservationsReady) {
      emit(const ReservationsLoading());
    }
    await _load(emit);
  }

  Future<void> _onCreate(
    ReservationCreateSubmitted event,
    Emitter<ReservationsState> emit,
  ) async {
    try {
      await _repo.createReservation(
        tableId: event.tableId,
        customerName: event.customerName,
        customerPhone: event.customerPhone,
        guestCount: event.guestCount,
        reservedAt: event.reservedAt,
        notes: event.notes,
      );
      await _repo.syncReservationTableStatuses();
      await _load(emit);
    } catch (e) {
      emit(ReservationsError('$e'));
      await _load(emit);
    }
  }

  Future<void> _onCancel(
    ReservationCancelRequested event,
    Emitter<ReservationsState> emit,
  ) async {
    try {
      await _repo.cancelReservation(event.reservationId);
      await _repo.syncReservationTableStatuses();
      await _load(emit);
    } catch (e) {
      emit(ReservationsError('$e'));
      await _load(emit);
    }
  }

  Future<void> _load(Emitter<ReservationsState> emit) async {
    try {
      await _repo.syncReservationTableStatuses();
      final reservations = await _repo.listUpcomingReservations();
      final tables = await _repo.listAllTables();
      final zones = await _repo.listAllZones();
      emit(
        ReservationsReady(
          reservations: reservations,
          tables: tables,
          zones: zones,
        ),
      );
    } catch (e) {
      emit(ReservationsError('Chargement : $e'));
    }
  }
}
