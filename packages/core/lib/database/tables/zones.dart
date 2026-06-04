import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class Zones extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
