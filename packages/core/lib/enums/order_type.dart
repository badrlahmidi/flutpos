/// Type de commande (valeurs stockées en BDD : `DINE_IN`, `TAKEAWAY`, `DELIVERY`).
enum OrderType {
  dineIn('DINE_IN'),
  takeaway('TAKEAWAY'),
  delivery('DELIVERY');

  const OrderType(this.dbValue);

  final String dbValue;

  static OrderType fromDb(String value) {
    return OrderType.values.firstWhere(
      (t) => t.dbValue == value,
      orElse: () => OrderType.dineIn,
    );
  }
}
