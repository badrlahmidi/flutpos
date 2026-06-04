import 'package:drift/drift.dart';

import 'modifier_groups.dart';
import 'products.dart';

class ProductModifiers extends Table {
  TextColumn get productId =>
      text().references(Products, #id)();
  TextColumn get modifierGroupId =>
      text().references(ModifierGroups, #id)();

  @override
  Set<Column<Object>> get primaryKey => {productId, modifierGroupId};
}
