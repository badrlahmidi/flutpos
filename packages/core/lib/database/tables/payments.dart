import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'orders.dart';

class Payments extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get paymentMethod => text()();
  RealColumn get amount => real()();
  TextColumn get reference => text().nullable()();
  DateTimeColumn get paidAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
