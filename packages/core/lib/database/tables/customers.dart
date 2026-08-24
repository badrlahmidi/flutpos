import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class Customers extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get phone => text().nullable()();
  TextColumn get email => text().nullable()();
  TextColumn get address => text().nullable()();
  TextColumn get taxId => text().nullable()(); // ICE
  RealColumn get accountBalance => real().withDefault(const Constant(0.0))();
  RealColumn get creditLimit => real().withDefault(const Constant(5000.0))();
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// Soft-delete (audit trail) — security fix [MOY-D04].
  DateTimeColumn get deletedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
