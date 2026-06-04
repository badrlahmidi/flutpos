import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/modifier_group_with_options.dart';
import 'product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<List<Category>> getActiveCategories() {
    return (_db.select(_db.categories)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) {
    return (_db.select(_db.products)
          ..where(
            (p) =>
                p.categoryId.equals(categoryId) & p.isActive.equals(true),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .get();
  }

  @override
  Future<Product?> getProductById(String productId) {
    return (_db.select(_db.products)..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
  }

  @override
  Future<bool> hasModifiers(String productId) async {
    final links = await (_db.select(_db.productModifiers)
          ..where((pm) => pm.productId.equals(productId)))
        .get();
    return links.isNotEmpty;
  }

  @override
  Future<List<ModifierGroupWithOptions>> getModifierGroupsForProduct(
    String productId,
  ) async {
    final links = await (_db.select(_db.productModifiers)
          ..where((pm) => pm.productId.equals(productId)))
        .get();

    if (links.isEmpty) {
      return [];
    }

    final groupIds = links.map((l) => l.modifierGroupId).toList();
    final groups = await (_db.select(_db.modifierGroups)
          ..where((g) => g.id.isIn(groupIds)))
        .get();

    final result = <ModifierGroupWithOptions>[];
    for (final group in groups) {
      final options = await (_db.select(_db.modifierOptions)
            ..where(
              (o) =>
                  o.modifierGroupId.equals(group.id) &
                  o.isActive.equals(true),
            )
            ..orderBy([(o) => OrderingTerm.asc(o.sortOrder)]))
          .get();
      result.add(ModifierGroupWithOptions(group: group, options: options));
    }
    return result;
  }
}
