/// Statut réservation (BDD : `CONFIRMED`, `SEATED`, `CANCELLED`, `NO_SHOW`).
enum ReservationStatus {
  confirmed('CONFIRMED'),
  seated('SEATED'),
  cancelled('CANCELLED'),
  noShow('NO_SHOW');

  const ReservationStatus(this.dbValue);

  final String dbValue;

  static ReservationStatus fromDb(String value) {
    return ReservationStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => ReservationStatus.confirmed,
    );
  }
}
