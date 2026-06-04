import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class PrintStations extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get ipAddress => text().nullable()();
  TextColumn get type =>
      text().withDefault(const Constant('THERMAL_PRINTER'))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
