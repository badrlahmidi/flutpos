import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'restaurant_tables.dart';

class Reservations extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get tableId =>
      text().references(RestaurantTables, #id)();
  TextColumn get customerName => text()();
  TextColumn get customerPhone => text().nullable()();
  IntColumn get guestCount => integer()();
  DateTimeColumn get reservedAt => dateTime()();
  TextColumn get notes => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('CONFIRMED'))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
