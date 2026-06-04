import 'package:equatable/equatable.dart';

sealed class ReservationsEvent extends Equatable {
  const ReservationsEvent();

  @override
  List<Object?> get props => [];
}

final class ReservationsStarted extends ReservationsEvent {
  const ReservationsStarted();
}

final class ReservationsRefreshRequested extends ReservationsEvent {
  const ReservationsRefreshRequested();
}

final class ReservationCreateSubmitted extends ReservationsEvent {
  const ReservationCreateSubmitted({
    required this.tableId,
    required this.customerName,
    this.customerPhone,
    required this.guestCount,
    required this.reservedAt,
    this.notes,
  });

  final String tableId;
  final String customerName;
  final String? customerPhone;
  final int guestCount;
  final DateTime reservedAt;
  final String? notes;

  @override
  List<Object?> get props => [
        tableId,
        customerName,
        customerPhone,
        guestCount,
        reservedAt,
        notes,
      ];
}

final class ReservationCancelRequested extends ReservationsEvent {
  const ReservationCancelRequested(this.reservationId);

  final String reservationId;

  @override
  List<Object?> get props => [reservationId];
}
