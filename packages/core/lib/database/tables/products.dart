import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'categories.dart';

class Products extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get categoryId =>
      text().references(Categories, #id)();
  TextColumn get name => text()();
  TextColumn get nameAr => text().nullable()();
  TextColumn get barcode => text().nullable()();
  RealColumn get priceDineIn => real()();
  RealColumn get priceTakeaway => real().nullable()();
  RealColumn get priceDelivery => real().nullable()();
  RealColumn get cost => real().nullable()();
  RealColumn get taxRate =>
      real().withDefault(const Constant(20.0))();
  TextColumn get image => text().nullable()();
  TextColumn get defaultNotes => text().nullable()();
  BoolColumn get trackStock =>
      boolean().withDefault(const Constant(false))();
  RealColumn get currentStock =>
      real().withDefault(const Constant(0))();
  IntColumn get sortOrder =>
      integer().withDefault(const Constant(0))();
  BoolColumn get isActive =>
      boolean().withDefault(const Constant(true))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
