import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/modifier_group_with_options.dart';
import '../utils/uuid_generator.dart';
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
  Stream<List<Category>> watchActiveCategories() {
    return (_db.select(_db.categories)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .watch();
  }

  @override
  Stream<List<Product>> watchProductsByCategory(String categoryId) {
    return (_db.select(_db.products)
          ..where(
            (p) =>
                p.categoryId.equals(categoryId) & p.isActive.equals(true),
          )
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .watch();
  }

  @override
  Future<Product?> getProductById(String productId) {
    return (_db.select(_db.products)..where((p) => p.id.equals(productId)))
        .getSingleOrNull();
  }

  @override
  Future<Product?> getProductByBarcode(String barcode) {
    return (_db.select(_db.products)..where((p) => p.barcode.equals(barcode)))
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

  @override
  Future<List<Product>> listAllActiveProducts() {
    return (_db.select(_db.products)
          ..where((p) => p.isActive.equals(true))
          ..orderBy([(p) => OrderingTerm.asc(p.sortOrder)]))
        .get();
  }

  @override
  Future<void> updateProductNameAr({
    required String productId,
    String? nameAr,
  }) async {
    await (_db.update(_db.products)..where((p) => p.id.equals(productId)))
        .write(ProductsCompanion(nameAr: Value(nameAr)));
  }

  @override
  Future<List<ModifierOption>> listAllModifierOptions() {
    return (_db.select(_db.modifierOptions)
          ..where((o) => o.isActive.equals(true))
          ..orderBy([(o) => OrderingTerm.asc(o.sortOrder)]))
        .get();
  }

  @override
  Future<void> updateModifierOptionNameAr({
    required String optionId,
    String? nameAr,
  }) async {
    await (_db.update(_db.modifierOptions)
          ..where((o) => o.id.equals(optionId)))
        .write(ModifierOptionsCompanion(nameAr: Value(nameAr)));
  }

  @override
  Future<List<Category>> listAllCategories() {
    return (_db.select(_db.categories)
          ..orderBy([(c) => OrderingTerm.asc(c.sortOrder)]))
        .get();
  }

  @override
  Future<int> countProductsInCategory(String categoryId) async {
    final count = _db.products.id.count();
    final query = _db.selectOnly(_db.products)
      ..addColumns([count])
      ..where(_db.products.categoryId.equals(categoryId));
    final row = await query.getSingle();
    return row.read(count) ?? 0;
  }

  @override
  Future<Category> createCategory(CategoryFormData data) async {
    final id = newUuid();
    await _db.into(_db.categories).insert(
          CategoriesCompanion.insert(
            id: Value(id),
            name: data.name,
            nameAr: Value(data.nameAr),
            colorHex: Value(data.colorHex),
            printStationId: Value(data.printStationId),
            sortOrder: Value(data.sortOrder),
            isActive: Value(data.isActive),
          ),
        );
    return (_db.select(_db.categories)..where((c) => c.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateCategory(String id, CategoryFormData data) async {
    await (_db.update(_db.categories)..where((c) => c.id.equals(id))).write(
      CategoriesCompanion(
        name: Value(data.name),
        nameAr: Value(data.nameAr),
        colorHex: Value(data.colorHex),
        printStationId: Value(data.printStationId),
        sortOrder: Value(data.sortOrder),
        isActive: Value(data.isActive),
      ),
    );
  }

  @override
  Future<void> deleteCategory(String id) async {
    final count = await countProductsInCategory(id);
    if (count > 0) {
      await (_db.update(_db.categories)..where((c) => c.id.equals(id)))
          .write(const CategoriesCompanion(isActive: Value(false)));
      return;
    }
    await (_db.delete(_db.categories)..where((c) => c.id.equals(id))).go();
  }

  @override
  Future<List<Product>> listAllProducts({
    String? categoryId,
    String? searchQuery,
    bool includeInactive = true,
  }) {
    final query = _db.select(_db.products);
    if (categoryId != null) {
      query.where((p) => p.categoryId.equals(categoryId));
    }
    if (!includeInactive) {
      query.where((p) => p.isActive.equals(true));
    }
    final q = searchQuery?.trim().toLowerCase();
    if (q != null && q.isNotEmpty) {
      query.where(
        (p) => p.name.lower().like('%$q%') | p.nameAr.lower().like('%$q%'),
      );
    }
    query.orderBy([(p) => OrderingTerm.asc(p.sortOrder)]);
    return query.get();
  }

  @override
  Future<Product> createProduct(ProductFormData data) async {
    final id = newUuid();
    await _db.into(_db.products).insert(
          ProductsCompanion.insert(
            id: Value(id),
            categoryId: data.categoryId,
            name: data.name,
            nameAr: Value(data.nameAr),
            priceDineIn: data.priceDineIn,
            priceDelivery: Value(data.priceDelivery),
            taxRate: Value(data.taxRate),
            trackStock: Value(data.trackStock),
            currentStock: Value(data.currentStock),
            productType: Value(data.productType),
            sortOrder: Value(data.sortOrder),
            isActive: Value(data.isActive),
          ),
        );
    return (_db.select(_db.products)..where((p) => p.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateProduct(String id, ProductFormData data) async {
    await (_db.update(_db.products)..where((p) => p.id.equals(id))).write(
      ProductsCompanion(
        categoryId: Value(data.categoryId),
        name: Value(data.name),
        nameAr: Value(data.nameAr),
        priceDineIn: Value(data.priceDineIn),
        priceDelivery: Value(data.priceDelivery),
        taxRate: Value(data.taxRate),
        trackStock: Value(data.trackStock),
        currentStock: Value(data.currentStock),
        productType: Value(data.productType),
        sortOrder: Value(data.sortOrder),
        isActive: Value(data.isActive),
      ),
    );
  }

  @override
  Future<void> setProductActive(String id, {required bool isActive}) async {
    await (_db.update(_db.products)..where((p) => p.id.equals(id)))
        .write(ProductsCompanion(isActive: Value(isActive)));
  }

  @override
  Future<void> deleteProduct(String id) async {
    await (_db.update(_db.products)..where((p) => p.id.equals(id)))
        .write(const ProductsCompanion(isActive: Value(false)));
  }

  @override
  Future<List<ModifierGroupWithOptions>> listAllModifierGroupsWithOptions() async {
    final groups = await (_db.select(_db.modifierGroups)
          ..orderBy([(g) => OrderingTerm.asc(g.name)]))
        .get();
    final result = <ModifierGroupWithOptions>[];
    for (final group in groups) {
      final options = await (_db.select(_db.modifierOptions)
            ..where((o) => o.modifierGroupId.equals(group.id))
            ..orderBy([(o) => OrderingTerm.asc(o.sortOrder)]))
          .get();
      result.add(ModifierGroupWithOptions(group: group, options: options));
    }
    return result;
  }

  @override
  Future<ModifierGroup> createModifierGroup(ModifierGroupFormData data) async {
    final id = newUuid();
    await _db.into(_db.modifierGroups).insert(
          ModifierGroupsCompanion.insert(
            id: Value(id),
            name: data.name,
            nameAr: Value(data.nameAr),
            isMultipleChoice: data.isMultipleChoice,
            isRequired: data.isRequired,
          ),
        );
    return (_db.select(_db.modifierGroups)..where((g) => g.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateModifierGroup(String id, ModifierGroupFormData data) async {
    await (_db.update(_db.modifierGroups)..where((g) => g.id.equals(id))).write(
      ModifierGroupsCompanion(
        name: Value(data.name),
        nameAr: Value(data.nameAr),
        isMultipleChoice: Value(data.isMultipleChoice),
        isRequired: Value(data.isRequired),
      ),
    );
  }

  @override
  Future<void> deleteModifierGroup(String id) async {
    await (_db.delete(_db.modifierOptions)
          ..where((o) => o.modifierGroupId.equals(id)))
        .go();
    await (_db.delete(_db.modifierGroups)..where((g) => g.id.equals(id))).go();
  }

  @override
  Future<ModifierOption> createModifierOption(
    ModifierOptionFormData data,
  ) async {
    final id = newUuid();
    await _db.into(_db.modifierOptions).insert(
          ModifierOptionsCompanion.insert(
            id: Value(id),
            modifierGroupId: data.modifierGroupId,
            name: data.name,
            nameAr: Value(data.nameAr),
            priceExtra: Value(data.priceExtra),
            sortOrder: Value(data.sortOrder),
            isActive: Value(data.isActive),
          ),
        );
    return (_db.select(_db.modifierOptions)..where((o) => o.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateModifierOption(
    String id,
    ModifierOptionFormData data,
  ) async {
    await (_db.update(_db.modifierOptions)..where((o) => o.id.equals(id)))
        .write(
      ModifierOptionsCompanion(
        modifierGroupId: Value(data.modifierGroupId),
        name: Value(data.name),
        nameAr: Value(data.nameAr),
        priceExtra: Value(data.priceExtra),
        sortOrder: Value(data.sortOrder),
        isActive: Value(data.isActive),
      ),
    );
  }

  @override
  Future<void> deleteModifierOption(String id) async {
    await (_db.update(_db.modifierOptions)..where((o) => o.id.equals(id)))
        .write(const ModifierOptionsCompanion(isActive: Value(false)));
  }

  @override
  Future<List<KitchenNote>> listKitchenNotes() {
    return (_db.select(_db.kitchenNotes)
          ..where((n) => n.isActive.equals(true))
          ..orderBy([(n) => OrderingTerm.asc(n.sortOrder)]))
        .get();
  }

  @override
  Future<KitchenNote> createKitchenNote(KitchenNoteFormData data) async {
    final id = newUuid();
    await _db.into(_db.kitchenNotes).insert(
          KitchenNotesCompanion.insert(
            id: Value(id),
            name: data.name,
            nameAr: Value(data.nameAr),
            sortOrder: Value(data.sortOrder),
            isActive: Value(data.isActive),
          ),
        );
    return (_db.select(_db.kitchenNotes)..where((n) => n.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateKitchenNote(String id, KitchenNoteFormData data) async {
    await (_db.update(_db.kitchenNotes)..where((n) => n.id.equals(id))).write(
      KitchenNotesCompanion(
        name: Value(data.name),
        nameAr: Value(data.nameAr),
        sortOrder: Value(data.sortOrder),
        isActive: Value(data.isActive),
      ),
    );
  }

  @override
  Future<void> deleteKitchenNote(String id) async {
    await (_db.update(_db.kitchenNotes)..where((n) => n.id.equals(id)))
        .write(const KitchenNotesCompanion(isActive: Value(false)));
  }

  @override
  Future<List<Ingredient>> listAllIngredients() {
    return _db.select(_db.ingredients).get();
  }

  @override
  Future<Ingredient> createIngredient(IngredientFormData data) async {
    final id = newUuid();
    await _db.into(_db.ingredients).insert(
          IngredientsCompanion.insert(
            id: Value(id),
            name: data.name,
            unit: data.unit,
            costPerUnit: data.costPerUnit,
            currentStock: Value(data.currentStock),
            minimumStock: Value(data.minimumStock),
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    return (_db.select(_db.ingredients)..where((i) => i.id.equals(id)))
        .getSingle();
  }

  @override
  Future<void> updateIngredient(String id, IngredientFormData data) async {
    await (_db.update(_db.ingredients)..where((i) => i.id.equals(id))).write(
      IngredientsCompanion(
        name: Value(data.name),
        unit: Value(data.unit),
        costPerUnit: Value(data.costPerUnit),
        currentStock: Value(data.currentStock),
        minimumStock: Value(data.minimumStock),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<void> deleteIngredient(String id) async {
    // Check if ingredient is used in recipes
    final uses = await (_db.select(_db.recipeItems)..where((r) => r.ingredientId.equals(id))).get();
    if (uses.isNotEmpty) {
      throw StateError('Cannot delete ingredient used in recipes.');
    }
    await (_db.delete(_db.ingredients)..where((i) => i.id.equals(id))).go();
  }

  @override
  Future<List<RecipeItem>> getRecipeForProduct(String productId) {
    return (_db.select(_db.recipeItems)
          ..where((ri) => ri.productId.equals(productId)))
        .get();
  }

  @override
  Future<void> updateRecipe(String productId, List<RecipeItem> recipeItems) async {
    await _db.transaction(() async {
      await (_db.delete(_db.recipeItems)
            ..where((ri) => ri.productId.equals(productId)))
          .go();

      for (final item in recipeItems) {
        await _db.into(_db.recipeItems).insert(
              RecipeItemsCompanion.insert(
                productId: productId,
                ingredientId: item.ingredientId,
                quantityUsed: item.quantityUsed,
              ),
            );
      }
    });
  }
}
