import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'catalog_event.dart';
import 'catalog_state.dart';

/// Catalogue POS réactif — silent updates quand PowerSync/Drift notifie un changement.
class CatalogBloc extends Bloc<CatalogEvent, CatalogState> {
  CatalogBloc({required ProductRepository productRepository})
      : _products = productRepository,
        super(const CatalogInitial()) {
    on<CatalogStarted>(_onStarted);
    on<CatalogCategorySelected>(_onCategorySelected);
    on<CatalogCategoriesUpdated>(_onCategoriesUpdated);
    on<CatalogProductsUpdated>(_onProductsUpdated);
    on<CatalogFailed>(_onFailed);
  }

  final ProductRepository _products;
  StreamSubscription<List<Category>>? _categoriesSub;
  StreamSubscription<List<Product>>? _productsSub;

  List<Category> _categories = [];
  String? _selectedCategoryId;
  bool _initialLoad = true;

  Future<void> _onStarted(CatalogStarted event, Emitter<CatalogState> emit) async {
    _initialLoad = true;
    emit(const CatalogLoading());

    await _categoriesSub?.cancel();
    _categoriesSub = _products.watchActiveCategories().listen(
      (categories) => add(CatalogCategoriesUpdated(categories)),
      onError: (Object e) => add(CatalogFailed('$e')),
    );
  }

  Future<void> _onCategorySelected(
    CatalogCategorySelected event,
    Emitter<CatalogState> emit,
  ) async {
    if (event.categoryId == _selectedCategoryId) {
      return;
    }

    _selectedCategoryId = event.categoryId;
    final current = state;
    if (current is CatalogReady) {
      emit(
        current.copyWith(
          selectedCategoryId: event.categoryId,
          isLoadingProducts: true,
        ),
      );
    }

    await _subscribeProducts(event.categoryId);
  }

  void _onCategoriesUpdated(
    CatalogCategoriesUpdated event,
    Emitter<CatalogState> emit,
  ) {
    _categories = event.categories;

    if (_categories.isEmpty) {
      _selectedCategoryId = null;
      _initialLoad = false;
      emit(
        const CatalogReady(
          categories: [],
          products: [],
          selectedCategoryId: null,
        ),
      );
      return;
    }

    final selectedExists = _selectedCategoryId != null &&
        _categories.any((c) => c.id == _selectedCategoryId);
    if (!selectedExists) {
      _selectedCategoryId = _categories.first.id;
      unawaited(_subscribeProducts(_selectedCategoryId!));
    }

    final current = state;
    if (current is CatalogReady) {
      emit(
        current.copyWith(
          categories: _categories,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
    }
  }

  void _onProductsUpdated(
    CatalogProductsUpdated event,
    Emitter<CatalogState> emit,
  ) {
    final wasLoadingProducts =
        state is CatalogReady && (state as CatalogReady).isLoadingProducts;

    if (_initialLoad) {
      _initialLoad = false;
      emit(
        CatalogReady(
          categories: _categories,
          products: event.products,
          selectedCategoryId: _selectedCategoryId,
        ),
      );
      return;
    }

    emit(
      CatalogReady(
        categories: _categories,
        products: event.products,
        selectedCategoryId: _selectedCategoryId,
        isLoadingProducts: false,
        silentRefresh: !wasLoadingProducts,
      ),
    );
  }

  void _onFailed(CatalogFailed event, Emitter<CatalogState> emit) {
    emit(CatalogError(event.message));
  }

  Future<void> _subscribeProducts(String categoryId) async {
    await _productsSub?.cancel();
    _productsSub = _products.watchProductsByCategory(categoryId).listen(
      (products) => add(CatalogProductsUpdated(products)),
      onError: (Object e) => add(CatalogFailed('$e')),
    );
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    await _productsSub?.cancel();
    return super.close();
  }
}
