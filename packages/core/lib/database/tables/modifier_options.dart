import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'modifier_groups.dart';

class ModifierOptions extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get modifierGroupId =>
      text().references(ModifierGroups, #id)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  RealColumn get priceExtra =>
      real().withDefault(const Constant(0.0))();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
