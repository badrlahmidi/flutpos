import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'users.dart';

class CashSessions extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get cashierId => text().references(Users, #id)();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  RealColumn get openingBalance => real()();
  RealColumn get closingBalance => real().nullable()();
  RealColumn get expectedBalance => real().nullable()();
  TextColumn get closingNote => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('OPEN'))();

  /// Soft-delete (audit trail) — security fix [MOY-D04].
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
