import 'package:drift/drift.dart';

import '../../utils/uuid_generator.dart';

/// Notes cuisine prédéfinies (backoffice).
class KitchenNotes extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
