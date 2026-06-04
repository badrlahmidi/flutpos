import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'users.dart';

class TimeAttendance extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get userId => text().references(Users, #id)();
  DateTimeColumn get clockIn => dateTime()();
  DateTimeColumn get clockOut => dateTime().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
