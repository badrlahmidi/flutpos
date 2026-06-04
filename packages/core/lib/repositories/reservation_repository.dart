import '../database/app_database.dart';

/// Gestion des réservations et synchronisation statut table `RESERVED`.
abstract class ReservationRepository {
  /// Délai avant l'heure prévue pour bloquer la table.
  static const Duration reserveLeadTime = Duration(minutes: 30);

  Future<Reservation> createReservation({
    required String tableId,
    required String customerName,
    String? customerPhone,
    required int guestCount,
    required DateTime reservedAt,
    String? notes,
  });

  Future<Reservation> cancelReservation(String reservationId);

  Future<List<Reservation>> listUpcomingReservations({
    DateTime? from,
    DateTime? to,
  });

  Future<Reservation?> getConfirmedReservationForTable(String tableId);

  /// Passe les tables en `RESERVED` / libère / marque `NO_SHOW`.
  Future<int> syncReservationTableStatuses();

  /// À l'installation client : table passée en service.
  Future<void> markSeatedForTable(String tableId);

  Future<List<RestaurantTable>> listAllTables();

  Future<List<Zone>> listAllZones();
}
