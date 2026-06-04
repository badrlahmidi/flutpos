import '../database/app_database.dart';
import '../enums/table_status.dart';

/// Statut d'affichage tuile plan de salle (couleur).
enum FloorPlanTileStatus {
  free,
  occupied,
  reservedOrProforma,
}

/// Table enrichie pour le plan de salle (commande active + totaux).
class FloorPlanTableSnapshot {
  const FloorPlanTableSnapshot({
    required this.table,
    this.activeOrder,
    this.currentGrandTotal,
    this.upcomingReservation,
  });

  final RestaurantTable table;
  final Order? activeOrder;
  final double? currentGrandTotal;
  final Reservation? upcomingReservation;

  TableStatus get tableStatus => TableStatus.fromDb(table.status);

  FloorPlanTileStatus get tileStatus {
    if (tableStatus == TableStatus.reserved ||
        (upcomingReservation != null && activeOrder == null)) {
      return FloorPlanTileStatus.reservedOrProforma;
    }
    final order = activeOrder;
    if (order == null) {
      return FloorPlanTileStatus.free;
    }
    if (order.status == 'PROFORMA') {
      return FloorPlanTileStatus.reservedOrProforma;
    }
    return FloorPlanTileStatus.occupied;
  }

  Duration? get occupiedDuration {
    final created = activeOrder?.createdAt;
    if (created == null) {
      return null;
    }
    return DateTime.now().toUtc().difference(created);
  }

  String? get occupiedDurationLabel {
    final duration = occupiedDuration;
    if (duration == null) {
      return null;
    }
    final minutes = duration.inMinutes;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    return rem == 0 ? '${hours}h' : '${hours}h ${rem}m';
  }
}
