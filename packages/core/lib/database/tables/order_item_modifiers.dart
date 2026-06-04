import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'modifier_options.dart';
import 'order_items.dart';

class OrderItemModifiers extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get orderItemId =>
      text().references(OrderItems, #id)();
  TextColumn get modifierOptionId =>
      text().references(ModifierOptions, #id)();
  RealColumn get priceExtra => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
