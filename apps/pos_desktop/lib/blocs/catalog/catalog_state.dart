import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class CatalogState extends Equatable {
  const CatalogState();

  @override
  List<Object?> get props => [];
}

final class CatalogInitial extends CatalogState {
  const CatalogInitial();
}

final class CatalogLoading extends CatalogState {
  const CatalogLoading();
}

final class CatalogReady extends CatalogState {
  const CatalogReady({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    this.isLoadingProducts = false,
    this.silentRefresh = false,
  });

  final List<Category> categories;
  final List<Product> products;
  final String? selectedCategoryId;
  final bool isLoadingProducts;
  final bool silentRefresh;

  CatalogReady copyWith({
    List<Category>? categories,
    List<Product>? products,
    String? selectedCategoryId,
    bool? isLoadingProducts,
    bool? silentRefresh,
  }) {
    return CatalogReady(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      silentRefresh: silentRefresh ?? this.silentRefresh,
    );
  }

  @override
  List<Object?> get props => [
        categories,
        products,
        selectedCategoryId,
        isLoadingProducts,
        silentRefresh,
      ];
}

final class CatalogError extends CatalogState {
  const CatalogError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
