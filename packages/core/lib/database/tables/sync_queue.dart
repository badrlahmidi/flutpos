import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class SyncQueue extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get action => text()();
  TextColumn get payload => text()();
  TextColumn get status =>
      text().withDefault(const Constant('PENDING_SYNC'))();
  IntColumn get retryCount =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastAttemptAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
