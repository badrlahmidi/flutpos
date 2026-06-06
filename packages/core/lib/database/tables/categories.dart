import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'print_stations.dart';

class Categories extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get image => text().nullable()();
  TextColumn get colorHex => text().nullable()();
  TextColumn get printStationId =>
      text().nullable().references(PrintStations, #id)();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();
  TextColumn get scheduledStartTime => text().nullable()();
  TextColumn get scheduledEndTime => text().nullable()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
