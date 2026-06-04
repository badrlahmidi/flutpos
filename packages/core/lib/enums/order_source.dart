/// Source de la commande (BDD : `MANUAL`, `GLOVO`, `DELIVEROO`, `WEBSITE`).
enum OrderSource {
  manual('MANUAL'),
  glovo('GLOVO'),
  deliveroo('DELIVEROO'),
  website('WEBSITE');

  const OrderSource(this.dbValue);

  final String dbValue;

  static OrderSource fromDb(String value) {
    return OrderSource.values.firstWhere(
      (s) => s.dbValue == value,
      orElse: () => OrderSource.manual,
    );
  }

  String get label => switch (this) {
        OrderSource.manual => 'Manuel',
        OrderSource.glovo => 'Glovo',
        OrderSource.deliveroo => 'Deliveroo',
        OrderSource.website => 'Site web',
      };

  String get emoji => switch (this) {
        OrderSource.glovo => '🛵',
        OrderSource.deliveroo => '🛵',
        OrderSource.website => '🌐',
        OrderSource.manual => '',
      };
}
