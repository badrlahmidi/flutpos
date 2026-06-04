import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class ReservationsState extends Equatable {
  const ReservationsState();

  @override
  List<Object?> get props => [];
}

final class ReservationsInitial extends ReservationsState {
  const ReservationsInitial();
}

final class ReservationsLoading extends ReservationsState {
  const ReservationsLoading();
}

final class ReservationsReady extends ReservationsState {
  const ReservationsReady({
    required this.reservations,
    required this.tables,
    required this.zones,
  });

  final List<Reservation> reservations;
  final List<RestaurantTable> tables;
  final List<Zone> zones;

  String tableLabel(String tableId) {
    for (final table in tables) {
      if (table.id == tableId) {
        final zone = zones.where((z) => z.id == table.zoneId).firstOrNull;
        final zoneName = zone?.name ?? '';
        return zoneName.isEmpty ? table.name : '$zoneName · ${table.name}';
      }
    }
    return tableId;
  }

  @override
  List<Object?> get props => [reservations.length, tables.length];
}

final class ReservationsError extends ReservationsState {
  const ReservationsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}
