import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

class RestaurantConfig extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get name => text()();
  TextColumn get address => text().nullable()();
  TextColumn get phone => text().nullable()();
  TextColumn get ice => text().nullable()();
  TextColumn get rc => text().nullable()();
  TextColumn get identifiantFiscal => text().nullable()();
  TextColumn get currency =>
      text().withDefault(const Constant('MAD'))();
  TextColumn get logoPath => text().nullable()();
  TextColumn get defaultServiceMode =>
      text().withDefault(const Constant('TABLE_SERVICE'))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
