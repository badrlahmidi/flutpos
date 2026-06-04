import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'cash_sessions.dart';
import 'users.dart';

class CashMovements extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get sessionId =>
      text().references(CashSessions, #id)();
  TextColumn get userId => text().references(Users, #id)();
  TextColumn get type => text()();
  RealColumn get amount => real()();
  TextColumn get reason => text()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
