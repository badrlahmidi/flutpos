import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class Discounts extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get type => text()();
  RealColumn get value => real()();
  TextColumn get code => text().nullable()();
  IntColumn get maxUses => integer().nullable()();
  IntColumn get currentUses =>
      integer().withDefault(const Constant(0))();
  DateTimeColumn get validFrom => dateTime().nullable()();
  DateTimeColumn get validUntil => dateTime().nullable()();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
