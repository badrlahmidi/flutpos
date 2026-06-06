import '../database/app_database.dart';
import '../entities/modifier_group_with_options.dart';

/// Données formulaire catégorie (backoffice).
class CategoryFormData {
  const CategoryFormData({
    required this.name,
    this.nameAr,
    this.colorHex,
    this.printStationId,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String name;
  final String? nameAr;
  final String? colorHex;
  final String? printStationId;
  final int sortOrder;
  final bool isActive;
}

/// Données formulaire produit (backoffice).
class ProductFormData {
  const ProductFormData({
    required this.categoryId,
    required this.name,
    this.nameAr,
    required this.priceDineIn,
    this.priceDelivery,
    this.taxRate = 20,
    this.trackStock = false,
    this.currentStock = 0,
    this.productType = 'standard',
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String categoryId;
  final String name;
  final String? nameAr;
  final double priceDineIn;
  final double? priceDelivery;
  final double taxRate;
  final bool trackStock;
  final double currentStock;
  final String productType;
  final int sortOrder;
  final bool isActive;
}

/// Données formulaire groupe modificateur.
class ModifierGroupFormData {
  const ModifierGroupFormData({
    required this.name,
    this.nameAr,
    this.isMultipleChoice = true,
    this.isRequired = false,
  });

  final String name;
  final String? nameAr;
  final bool isMultipleChoice;
  final bool isRequired;
}

/// Données formulaire option modificateur.
class ModifierOptionFormData {
  const ModifierOptionFormData({
    required this.modifierGroupId,
    required this.name,
    this.nameAr,
    this.priceExtra = 0,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String modifierGroupId;
  final String name;
  final String? nameAr;
  final double priceExtra;
  final int sortOrder;
  final bool isActive;
}

/// Données formulaire note cuisine.
class KitchenNoteFormData {
  const KitchenNoteFormData({
    required this.name,
    this.nameAr,
    this.sortOrder = 0,
    this.isActive = true,
  });

  final String name;
  final String? nameAr;
  final int sortOrder;
  final bool isActive;
}

/// Accès au catalogue (catégories, produits, modificateurs).
abstract class ProductRepository {
  Future<List<Category>> getActiveCategories();

  Future<List<Product>> getProductsByCategory(String categoryId);

  /// Stream réactif — silent update quand le catalogue cloud/local change.
  Stream<List<Category>> watchActiveCategories();

  /// Stream réactif des produits actifs d'une catégorie.
  Stream<List<Product>> watchProductsByCategory(String categoryId);

  Future<Product?> getProductById(String productId);

  Future<bool> hasModifiers(String productId);

  Future<List<ModifierGroupWithOptions>> getModifierGroupsForProduct(
    String productId,
  );

  /// Tous les produits actifs (admin catalogue).
  Future<List<Product>> listAllActiveProducts();

  /// Met à jour le libellé arabe d'un produit.
  Future<void> updateProductNameAr({
    required String productId,
    String? nameAr,
  });

  /// Toutes les options de modificateurs actives.
  Future<List<ModifierOption>> listAllModifierOptions();

  /// Met à jour le libellé arabe d'une option modificateur.
  Future<void> updateModifierOptionNameAr({
    required String optionId,
    String? nameAr,
  });

  // ─── Backoffice CRUD ───

  Future<List<Category>> listAllCategories();

  Future<int> countProductsInCategory(String categoryId);

  Future<Category> createCategory(CategoryFormData data);

  Future<void> updateCategory(String id, CategoryFormData data);

  Future<void> deleteCategory(String id);

  Future<List<Product>> listAllProducts({
    String? categoryId,
    String? searchQuery,
    bool includeInactive = true,
  });

  Future<Product> createProduct(ProductFormData data);

  Future<void> updateProduct(String id, ProductFormData data);

  Future<void> setProductActive(String id, {required bool isActive});

  Future<void> deleteProduct(String id);

  Future<List<ModifierGroupWithOptions>> listAllModifierGroupsWithOptions();

  Future<ModifierGroup> createModifierGroup(ModifierGroupFormData data);

  Future<void> updateModifierGroup(String id, ModifierGroupFormData data);

  Future<void> deleteModifierGroup(String id);

  Future<ModifierOption> createModifierOption(ModifierOptionFormData data);

  Future<void> updateModifierOption(String id, ModifierOptionFormData data);

  Future<void> deleteModifierOption(String id);

  Future<List<KitchenNote>> listKitchenNotes();

  Future<KitchenNote> createKitchenNote(KitchenNoteFormData data);

  Future<void> updateKitchenNote(String id, KitchenNoteFormData data);

  Future<void> deleteKitchenNote(String id);

  // ─── Ingredients & Recipe Items ───
  Future<List<Ingredient>> listAllIngredients();

  Future<List<RecipeItem>> getRecipeForProduct(String productId);

  Future<void> updateRecipe(String productId, List<RecipeItem> recipeItems);
}
