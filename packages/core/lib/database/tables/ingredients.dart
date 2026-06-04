import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class Ingredients extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get unit => text()();
  RealColumn get costPerUnit => real()();
  RealColumn get currentStock =>
      real().withDefault(const Constant(0))();
  RealColumn get minimumStock =>
      real().withDefault(const Constant(0))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
