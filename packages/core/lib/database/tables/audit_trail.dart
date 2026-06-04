import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'users.dart';

class AuditTrail extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get action => text()();
  TextColumn get targetType => text()();
  TextColumn get targetId => text()();
  TextColumn get details => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
