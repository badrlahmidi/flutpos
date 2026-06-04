import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class ModifierGroups extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  BoolColumn get isMultipleChoice => boolean()();
  BoolColumn get isRequired => boolean()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
