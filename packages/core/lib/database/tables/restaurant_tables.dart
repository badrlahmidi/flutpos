import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'zones.dart';

class RestaurantTables extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get zoneId => text().references(Zones, #id)();
  TextColumn get name => text()();
  IntColumn get capacity => integer()();
  TextColumn get status =>
      text().withDefault(const Constant('FREE'))();
  RealColumn get posX => real().nullable()();
  RealColumn get posY => real().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
