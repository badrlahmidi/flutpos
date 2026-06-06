import 'package:drift/drift.dart';

/// Niveau d'accès requis (0-9) par opération sensible.
class SecurityRules extends Table {
  TextColumn get operationKey => text()();
  TextColumn get category => text()();
  TextColumn get label => text()();
  IntColumn get requiredLevel =>
      integer().withDefault(const Constant(0))();
  TextColumn get description => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {operationKey};
}
