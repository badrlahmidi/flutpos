/// Mode de service caisse (`TABLE_SERVICE` = plan de salle, `QUICK_SERVICE` = comptoir).
enum ServiceMode {
  tableService('TABLE_SERVICE'),
  quickService('QUICK_SERVICE');

  const ServiceMode(this.dbValue);

  final String dbValue;

  static ServiceMode fromDb(String value) {
    return ServiceMode.values.firstWhere(
      (m) => m.dbValue == value,
      orElse: () => ServiceMode.tableService,
    );
  }

  String get label => switch (this) {
        ServiceMode.tableService => 'Service à table',
        ServiceMode.quickService => 'Service rapide',
      };

  ServiceMode get toggled => switch (this) {
        ServiceMode.tableService => ServiceMode.quickService,
        ServiceMode.quickService => ServiceMode.tableService,
      };
}
