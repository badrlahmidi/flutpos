import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'ingredients.dart';
import 'products.dart';

class RecipeItems extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get productId =>
      text().references(Products, #id)();
  TextColumn get ingredientId =>
      text().references(Ingredients, #id)();
  RealColumn get quantityUsed => real()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
