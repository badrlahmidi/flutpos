import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'orders.dart';

class Vouchers extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get code => text().unique()();
  RealColumn get amount => real()();
  TextColumn get status => text().withDefault(const Constant('ACTIVE'))();
  TextColumn get orderId => text().nullable().references(Orders, #id)();
  DateTimeColumn get usedAt => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
