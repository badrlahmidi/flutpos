import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class Users extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get pinHash => text()();
  TextColumn get role => text()();
  IntColumn get accessLevel =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  /// Nombre de tentatives PIN échouées consécutives (persisté, cf. CRIT-A02).
  IntColumn get failedAttempts =>
      integer().withDefault(const Constant(0))();

  /// Date/heure jusqu'à laquelle le compte est verrouillé (null = non verrouillé).
  DateTimeColumn get lockedUntil => dateTime().nullable()();

  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
