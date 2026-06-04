/// Statut visuel d'une table sur le plan de salle (BDD : `FREE`, `OCCUPIED`, `RESERVED`).
enum TableStatus {
  free('FREE'),
  occupied('OCCUPIED'),
  reserved('RESERVED');

  const TableStatus(this.dbValue);

  final String dbValue;

  static TableStatus fromDb(String value) {
    return TableStatus.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => TableStatus.free,
    );
  }
}
