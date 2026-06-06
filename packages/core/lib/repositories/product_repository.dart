import '../database/app_database.dart';
import '../entities/modifier_group_with_options.dart';

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
}
