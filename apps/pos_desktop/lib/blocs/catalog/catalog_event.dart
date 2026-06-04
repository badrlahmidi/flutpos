import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CatalogEvent extends Equatable {
  const CatalogEvent();

  @override
  List<Object?> get props => [];
}

/// Démarre l'écoute réactive du catalogue (catégories + produits).
final class CatalogStarted extends CatalogEvent {
  const CatalogStarted();
}

/// Changement de catégorie active dans la grille produits.
final class CatalogCategorySelected extends CatalogEvent {
  const CatalogCategorySelected(this.categoryId);

  final String categoryId;

  @override
  List<Object?> get props => [categoryId];
}

/// Émis par le BLoC quand [ProductRepository.watchActiveCategories] notifie.
final class CatalogCategoriesUpdated extends CatalogEvent {
  const CatalogCategoriesUpdated(this.categories);

  final List<Category> categories;

  @override
  List<Object?> get props => [categories];
}

/// Émis par le BLoC quand [ProductRepository.watchProductsByCategory] notifie.
final class CatalogProductsUpdated extends CatalogEvent {
  const CatalogProductsUpdated(this.products);

  final List<Product> products;

  @override
  List<Object?> get props => [products];
}

final class CatalogFailed extends CatalogEvent {
  const CatalogFailed(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
