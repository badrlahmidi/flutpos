import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import 'categories_page.dart';

/// Gestion CRUD des produits.
class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  List<Category> _categories = const [];
  List<Product> _products = const [];
  String? _categoryFilter;
  String _search = '';
  bool _loading = true;
  Product? _selectedProduct;
  bool _showEditor = false;
  Product? _editingProduct;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = sl<ProductRepository>();
    final categories = await repo.listAllCategories();
    final products = await repo.listAllProducts(
      categoryId: _categoryFilter,
      searchQuery: _search.isEmpty ? null : _search,
    );
    if (mounted) {
      setState(() {
        _categories = categories.where((c) => c.isActive).toList();
        _products = products;
        _selectedProduct = null;
        if (_editingProduct != null && !products.any((p) => p.id == _editingProduct!.id)) {
          _showEditor = false;
          _editingProduct = null;
        }
        _loading = false;
      });
    }
  }

  String _categoryName(String categoryId) {
    return _categories
            .where((c) => c.id == categoryId)
            .map((c) => c.name)
            .firstOrNull ??
        '—';
  }

  void _openEditor({Product? product}) {
    setState(() {
      _editingProduct = product;
      _showEditor = true;
    });
  }

  Future<void> _openCategoryEditor({Category? category}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => CategoryEditorDialog(category: category),
    );
    if (saved == true && mounted) {
      await _load();
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final repo = sl<ProductRepository>();
    final count = await repo.countProductsInCategory(category.id);
    if (!mounted) return;
    final ok = await confirmDelete(
      context,
      title: 'Supprimer la catégorie',
      message: count > 0
          ? 'Cette catégorie contient $count produit(s). Elle sera désactivée.'
          : 'Confirmer la suppression de « ${category.name} » ?',
    );
    if (!ok || !mounted) {
      return;
    }
    await repo.deleteCategory(category.id);
    setState(() {
      _categoryFilter = null;
    });
    await _load();
  }

  Future<void> _toggleActive(Product product) async {
    await sl<ProductRepository>().setProductActive(
      product.id,
      isActive: !product.isActive,
    );
    await _load();
  }

  Future<void> _deleteProduct(Product product) async {
    final ok = await confirmDelete(
      context,
      title: 'Désactiver le produit',
      message: 'Désactiver « ${product.name} » ?',
    );
    if (!ok || !mounted) {
      return;
    }
    await sl<ProductRepository>().deleteProduct(product.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const BackofficePageHeader(
          title: 'Produits',
          subtitle: 'Catalogue et tarifs',
        ),
        // Toolbar
        Container(
          color: theme.colorScheme.surfaceContainerLow,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
          child: Row(
            children: [
              TextButton.icon(
                icon: const Icon(Icons.add_circle_outline, color: AppColors.accentGreen),
                label: const Text('Nouveau'),
                onPressed: _loading || _categories.isEmpty ? null : () => _openEditor(),
              ),
              const SizedBox(width: AppSpacing.m),
              TextButton.icon(
                icon: const Icon(Icons.edit_outlined, color: AppColors.accentBlue),
                label: const Text('Modifier'),
                onPressed: _selectedProduct == null ? null : () => _openEditor(product: _selectedProduct),
              ),
              const SizedBox(width: AppSpacing.m),
              TextButton.icon(
                icon: const Icon(Icons.block_outlined, color: Colors.amberAccent),
                label: const Text('Activer/Désactiver'),
                onPressed: _selectedProduct == null ? null : () => _toggleActive(_selectedProduct!),
              ),
              const SizedBox(width: AppSpacing.m),
              TextButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: const Text('Supprimer'),
                onPressed: _selectedProduct == null ? null : () => _deleteProduct(_selectedProduct!),
              ),
              const SizedBox(width: AppSpacing.m),
              IconButton(
                tooltip: 'Actualiser',
                icon: const Icon(Icons.refresh),
                onPressed: _load,
              ),
              const Spacer(),
              // Search input
              SizedBox(
                width: 280,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher par nom...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() {
                      _search = v;
                    });
                    _load();
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.m),
              Text(
                'Produits: ${_products.length}',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left Panel: Categories Explorer
              Container(
                width: 240,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: theme.colorScheme.outlineVariant),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m, vertical: AppSpacing.s),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'GROUPES',
                              style: theme.textTheme.labelSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          IconButton(
                            constraints: const BoxConstraints(),
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.create_new_folder_outlined, size: 18, color: AppColors.accentGreen),
                            tooltip: 'Nouveau groupe',
                            onPressed: () => _openCategoryEditor(),
                          ),
                          if (_categoryFilter != null) ...[
                            const SizedBox(width: AppSpacing.s),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.folder_open_outlined, size: 18, color: AppColors.accentBlue),
                              tooltip: 'Modifier le groupe',
                              onPressed: () {
                                final cat = _categories.firstWhere((c) => c.id == _categoryFilter);
                                _openCategoryEditor(category: cat);
                              },
                            ),
                            const SizedBox(width: AppSpacing.s),
                            IconButton(
                              constraints: const BoxConstraints(),
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.folder_delete_outlined, size: 18, color: Colors.redAccent),
                              tooltip: 'Supprimer le groupe',
                              onPressed: () {
                                final cat = _categories.firstWhere((c) => c.id == _categoryFilter);
                                _deleteCategory(cat);
                              },
                            ),
                          ],
                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            leading: Icon(
                              Icons.grid_view_rounded,
                              color: _categoryFilter == null
                                  ? theme.colorScheme.primary
                                  : theme.colorScheme.onSurfaceVariant,
                            ),
                            title: const Text('Tous les produits'),
                            selected: _categoryFilter == null,
                            selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                            onTap: () {
                              setState(() {
                                _categoryFilter = null;
                                _selectedProduct = null;
                              });
                              _load();
                            },
                          ),
                          const Divider(height: 1),
                          for (final cat in _categories)
                            ListTile(
                              leading: Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: parseColorHex(cat.colorHex) ?? Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              title: Text(cat.name),
                              selected: _categoryFilter == cat.id,
                              selectedTileColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                              onTap: () {
                                setState(() {
                                  _categoryFilter = cat.id;
                                  _selectedProduct = null;
                                });
                                _load();
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Right Panel: Products Table
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : _products.isEmpty
                        ? Center(
                            child: Text(
                              'Aucun produit trouvé',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.all(AppSpacing.m),
                            child: DataTable2(
                              columnSpacing: AppSpacing.m,
                              horizontalMargin: AppSpacing.m,
                              minWidth: 900,
                              headingRowColor: WidgetStateProperty.all(
                                theme.colorScheme.surfaceContainerHighest,
                              ),
                              showCheckboxColumn: true,
                              columns: const [
                                DataColumn2(label: Text('Nom FR'), size: ColumnSize.L),
                                DataColumn2(label: Text('Nom AR'), size: ColumnSize.M),
                                DataColumn2(label: Text('Catégorie'), size: ColumnSize.M),
                                DataColumn2(label: Text('Type'), size: ColumnSize.S),
                                DataColumn2(label: Text('Prix'), size: ColumnSize.S),
                                DataColumn2(label: Text('Livraison'), size: ColumnSize.S),
                                DataColumn2(label: Text('TVA'), size: ColumnSize.S),
                                DataColumn2(label: Text('Stock'), size: ColumnSize.S),
                                DataColumn2(label: Text('Actif'), size: ColumnSize.S),
                              ],
                              rows: [
                                for (final product in _products)
                                  DataRow(
                                    selected: _selectedProduct?.id == product.id,
                                    onSelectChanged: (selected) {
                                      setState(() {
                                        _selectedProduct = selected == true ? product : null;
                                      });
                                    },
                                    cells: [
                                      DataCell(Text(product.name)),
                                      DataCell(Text(product.nameAr ?? '—')),
                                      DataCell(Text(_categoryName(product.categoryId))),
                                      DataCell(Text(
                                        product.productType == 'composed'
                                            ? 'Composé'
                                            : 'Standard',
                                      )),
                                      DataCell(Text(PriceFormatter.format(product.priceDineIn))),
                                      DataCell(Text(
                                        product.priceDelivery != null
                                            ? PriceFormatter.format(product.priceDelivery!)
                                            : '—',
                                      )),
                                      DataCell(Text('${product.taxRate.toStringAsFixed(0)} %')),
                                      DataCell(Text(
                                        product.trackStock
                                            ? product.currentStock.toStringAsFixed(0)
                                            : '—',
                                      )),
                                      DataCell(
                                        Icon(
                                          product.isActive ? Icons.check_circle : Icons.cancel,
                                          color: product.isActive ? AppColors.accentGreen : Colors.redAccent,
                                          size: 20,
                                        ),
                                      ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
              ),
              if (_showEditor)
                Container(
                  width: 480,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    border: Border(
                      left: BorderSide(color: theme.colorScheme.outlineVariant),
                    ),
                  ),
                  child: _ProductEditorPanel(
                    product: _editingProduct,
                    categories: _categories,
                    onCancel: () {
                      setState(() {
                        _showEditor = false;
                        _editingProduct = null;
                      });
                    },
                    onSaved: () {
                      setState(() {
                        _showEditor = false;
                        _editingProduct = null;
                      });
                      _load();
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProductEditorPanel extends StatefulWidget {
  const _ProductEditorPanel({
    this.product,
    required this.categories,
    required this.onCancel,
    required this.onSaved,
  });

  final Product? product;
  final List<Category> categories;
  final VoidCallback onCancel;
  final VoidCallback onSaved;

  @override
  State<_ProductEditorPanel> createState() => _ProductEditorPanelState();
}

class _ProductEditorPanelState extends State<_ProductEditorPanel> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _deliveryCtrl;
  late final TextEditingController _taxCtrl;
  late final TextEditingController _stockCtrl;
  late final TextEditingController _orderCtrl;
  late String _categoryId;
  late bool _trackStock;
  late bool _isActive;
  late String _productType;

  List<Ingredient> _allIngredients = [];
  List<RecipeItem> _recipeItems = [];
  bool _loadingRecipe = false;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _nameArCtrl = TextEditingController(text: p?.nameAr ?? '');
    _priceCtrl = TextEditingController(text: p != null ? '${p.priceDineIn}' : '');
    _deliveryCtrl = TextEditingController(
      text: p?.priceDelivery != null ? '${p!.priceDelivery}' : '',
    );
    _taxCtrl = TextEditingController(text: '${p?.taxRate ?? 20}');
    _stockCtrl = TextEditingController(
      text: p != null ? '${p.currentStock}' : '0',
    );
    _orderCtrl = TextEditingController(text: '${p?.sortOrder ?? 0}');
    _categoryId = p?.categoryId ?? widget.categories.first.id;
    _trackStock = p?.trackStock ?? false;
    _isActive = p?.isActive ?? true;
    _productType = p?.productType ?? 'standard';

    _loadIngredientsAndRecipe();
  }

  Future<void> _loadIngredientsAndRecipe() async {
    setState(() => _loadingRecipe = true);
    try {
      final repo = sl<ProductRepository>();
      final ingredients = await repo.listAllIngredients();
      List<RecipeItem> recipeItems = [];
      if (widget.product != null) {
        recipeItems = await repo.getRecipeForProduct(widget.product!.id);
      }
      if (mounted) {
        setState(() {
          _allIngredients = ingredients;
          _recipeItems = recipeItems;
        });
      }
    } catch (_) {
    } finally {
      if (mounted) {
        setState(() => _loadingRecipe = false);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _priceCtrl.dispose();
    _deliveryCtrl.dispose();
    _taxCtrl.dispose();
    _stockCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    final price = double.tryParse(_priceCtrl.text.replaceAll(',', '.'));
    if (name.isEmpty || price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez remplir le nom et le prix valide.')),
      );
      return;
    }
    setState(() => _saving = true);
    final deliveryRaw = _deliveryCtrl.text.trim();
    final data = ProductFormData(
      categoryId: _categoryId,
      name: name,
      nameAr: _nameArCtrl.text.trim().isEmpty ? null : _nameArCtrl.text.trim(),
      priceDineIn: price,
      priceDelivery: deliveryRaw.isEmpty
          ? null
          : double.tryParse(deliveryRaw.replaceAll(',', '.')),
      taxRate: double.tryParse(_taxCtrl.text.replaceAll(',', '.')) ?? 20,
      trackStock: _trackStock,
      currentStock: double.tryParse(_stockCtrl.text.replaceAll(',', '.')) ?? 0,
      productType: _productType,
      sortOrder: int.tryParse(_orderCtrl.text.trim()) ?? 0,
      isActive: _isActive,
    );
    final repo = sl<ProductRepository>();
    if (widget.product == null) {
      final created = await repo.createProduct(data);
      if (_productType == 'composed') {
        final newRecipe = _recipeItems.map((r) => RecipeItem(
          id: '',
          productId: created.id,
          ingredientId: r.ingredientId,
          quantityUsed: r.quantityUsed,
        )).toList();
        await repo.updateRecipe(created.id, newRecipe);
      }
    } else {
      final id = widget.product!.id;
      await repo.updateProduct(id, data);
      if (_productType == 'composed') {
        final newRecipe = _recipeItems.map((r) => RecipeItem(
          id: '',
          productId: id,
          ingredientId: r.ingredientId,
          quantityUsed: r.quantityUsed,
        )).toList();
        await repo.updateRecipe(id, newRecipe);
      }
    }
    setState(() => _saving = false);
    widget.onSaved();
  }

  void _addRecipeItem() {
    if (_allIngredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucun ingrédient configuré dans le stock.")),
      );
      return;
    }
    setState(() {
      _recipeItems.add(
        RecipeItem(
          id: '',
          productId: widget.product?.id ?? '',
          ingredientId: _allIngredients.first.id,
          quantityUsed: 0.1,
        ),
      );
    });
  }

  void _removeRecipeItem(int index) {
    setState(() {
      _recipeItems.removeAt(index);
    });
  }

  void _updateRecipeItemIngredient(int index, String ingredientId) {
    setState(() {
      final old = _recipeItems[index];
      _recipeItems[index] = RecipeItem(
        id: old.id,
        productId: old.productId,
        ingredientId: ingredientId,
        quantityUsed: old.quantityUsed,
      );
    });
  }

  void _updateRecipeItemQuantity(int index, double quantity) {
    setState(() {
      final old = _recipeItems[index];
      _recipeItems[index] = RecipeItem(
        id: old.id,
        productId: old.productId,
        ingredientId: old.ingredientId,
        quantityUsed: quantity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isComposed = _productType == 'composed';

    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    widget.product == null ? 'Nouveau produit' : 'Modifier produit',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: widget.onCancel,
                ),
              ],
            ),
          ),
          // Tab Bar
          TabBar(
            labelColor: scheme.primary,
            unselectedLabelColor: scheme.onSurfaceVariant,
            indicatorColor: scheme.primary,
            tabs: const [
              Tab(text: 'Détails'),
              Tab(text: 'Prix & Taxe'),
              Tab(text: 'Stock & Recette'),
            ],
          ),
          // Tab Content
          Expanded(
            child: _loadingRecipe
                ? const Center(child: CircularProgressIndicator())
                : TabBarView(
                    children: [
                      // Details Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            DropdownButtonFormField<String>(
                              value: _categoryId,
                              decoration: const InputDecoration(labelText: 'Catégorie / Groupe'),
                              items: [
                                for (final c in widget.categories)
                                  DropdownMenuItem(value: c.id, child: Text(c.name)),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() => _categoryId = v);
                                }
                              },
                            ),
                            const SizedBox(height: AppSpacing.m),
                            TextField(
                              controller: _nameCtrl,
                              decoration: const InputDecoration(labelText: 'Nom (FR)'),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            TextField(
                              controller: _nameArCtrl,
                              decoration: const InputDecoration(labelText: 'Nom (AR)'),
                              textDirection: TextDirection.rtl,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            DropdownButtonFormField<String>(
                              value: _productType,
                              decoration: const InputDecoration(labelText: 'Type de Produit'),
                              items: const [
                                DropdownMenuItem(
                                  value: 'standard',
                                  child: Text('Standard (Direct)'),
                                ),
                                DropdownMenuItem(
                                  value: 'composed',
                                  child: Text('Composé (Recette)'),
                                ),
                              ],
                              onChanged: (v) {
                                if (v != null) {
                                  setState(() {
                                    _productType = v;
                                    if (v == 'composed') {
                                      _trackStock = true;
                                    }
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: AppSpacing.m),
                            TextField(
                              controller: _orderCtrl,
                              decoration: const InputDecoration(labelText: 'Ordre de tri'),
                              keyboardType: TextInputType.number,
                            ),
                            const SizedBox(height: AppSpacing.m),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Produit Actif'),
                              subtitle: const Text('Rendre visible dans la caisse'),
                              value: _isActive,
                              onChanged: (v) => setState(() => _isActive = v),
                            ),
                          ],
                        ),
                      ),
                      // Price & Tax Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextField(
                              controller: _priceCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Prix sur place (DH)',
                                suffixText: 'DH',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            TextField(
                              controller: _deliveryCtrl,
                              decoration: const InputDecoration(
                                labelText: 'Prix livraison (DH) (Optionnel)',
                                suffixText: 'DH',
                              ),
                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            ),
                            const SizedBox(height: AppSpacing.m),
                            TextField(
                              controller: _taxCtrl,
                              decoration: const InputDecoration(
                                labelText: 'TVA (%)',
                                suffixText: '%',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      // Stock & Recipe Tab
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.m),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Suivre le stock'),
                              value: _trackStock,
                              onChanged: isComposed
                                  ? null
                                  : (v) => setState(() => _trackStock = v),
                              subtitle: isComposed
                                  ? const Text('Obligatoire pour produit composé')
                                  : null,
                            ),
                            if (_trackStock && !isComposed) ...[
                              const SizedBox(height: AppSpacing.s),
                              TextField(
                                controller: _stockCtrl,
                                decoration: const InputDecoration(labelText: 'Stock actuel'),
                                keyboardType: TextInputType.number,
                              ),
                            ],
                            if (isComposed) ...[
                              const SizedBox(height: AppSpacing.m),
                              Row(
                                children: [
                                  Icon(Icons.menu_book, color: scheme.primary, size: 20),
                                  const SizedBox(width: AppSpacing.s),
                                  Text(
                                    'RECETTE / FICHE TECHNIQUE',
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: scheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s),
                              Text(
                                'Les ingrédients seront déduits du stock à chaque vente de ce produit.',
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: AppSpacing.m),
                              if (_recipeItems.isEmpty)
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.l),
                                  child: Center(
                                    child: Text(
                                      'Aucun ingrédient configuré',
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        color: scheme.onSurfaceVariant,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: _recipeItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _recipeItems[index];
                                    final ing = _allIngredients.firstWhere(
                                      (i) => i.id == item.ingredientId,
                                      orElse: () => Ingredient(
                                        id: item.ingredientId,
                                        name: 'Inconnu',
                                        unit: 'unit',
                                        costPerUnit: 0,
                                        currentStock: 0,
                                        minimumStock: 0,
                                        updatedAt: DateTime.now(),
                                      ),
                                    );
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: AppSpacing.s),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 3,
                                            child: DropdownButtonFormField<String>(
                                              value: item.ingredientId,
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.s,
                                                  vertical: AppSpacing.xs,
                                                ),
                                              ),
                                              items: [
                                                for (final ingredient in _allIngredients)
                                                  DropdownMenuItem(
                                                    value: ingredient.id,
                                                    child: Text(
                                                      '${ingredient.name} (${ingredient.unit})',
                                                      style: const TextStyle(fontSize: 12),
                                                    ),
                                                  ),
                                              ],
                                              onChanged: (v) {
                                                if (v != null) {
                                                  _updateRecipeItemIngredient(index, v);
                                                }
                                              },
                                            ),
                                          ),
                                          const SizedBox(width: AppSpacing.s),
                                          Expanded(
                                            flex: 2,
                                            child: TextFormField(
                                              initialValue: '${item.quantityUsed}',
                                              decoration: InputDecoration(
                                                suffixText: ing.unit,
                                                contentPadding: const EdgeInsets.symmetric(
                                                  horizontal: AppSpacing.s,
                                                  vertical: AppSpacing.xs,
                                                ),
                                              ),
                                              keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                              style: const TextStyle(fontSize: 12),
                                              onChanged: (v) {
                                                final qty = double.tryParse(v.replaceAll(',', '.')) ?? 0;
                                                _updateRecipeItemQuantity(index, qty);
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                                            onPressed: () => _removeRecipeItem(index),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              const SizedBox(height: AppSpacing.s),
                              OutlinedButton.icon(
                                onPressed: _addRecipeItem,
                                icon: const Icon(Icons.add),
                                label: const Text('Ajouter ingrédient'),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
          ),
          // Footer
          Container(
            padding: const EdgeInsets.all(AppSpacing.m),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: scheme.outlineVariant)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: widget.onCancel,
                  child: const Text('Annuler'),
                ),
                const SizedBox(width: AppSpacing.s),
                FilledButton.icon(
                  icon: _saving
                      ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.save),
                  label: const Text('Enregistrer'),
                  onPressed: _saving ? null : _save,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}
