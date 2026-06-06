import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';

/// Gestion CRUD des catégories menu.
class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  List<Category> _categories = const [];
  final Map<String, int> _productCounts = {};
  final Map<String, String> _stationNames = {};
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = sl<ProductRepository>();
    final printRepo = sl<PrintRepository>();
    final categories = await repo.listAllCategories();
    final stations = await printRepo.getAllPrintStations();
    final stationMap = {for (final s in stations) s.id: s.name};
    final counts = <String, int>{};
    for (final c in categories) {
      counts[c.id] = await repo.countProductsInCategory(c.id);
    }
    if (mounted) {
      setState(() {
        _categories = categories;
        _stationNames
          ..clear()
          ..addAll(stationMap);
        _productCounts
          ..clear()
          ..addAll(counts);
        _loading = false;
      });
    }
  }

  Future<void> _openEditor({Category? category}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => CategoryEditorDialog(category: category),
    );
    if (saved == true && mounted) {
      await _load();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(category == null ? 'Catégorie créée' : 'Catégorie mise à jour'),
          ),
        );
      }
    }
  }

  Future<void> _deleteCategory(Category category) async {
    final count = _productCounts[category.id] ?? 0;
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
    await sl<ProductRepository>().deleteCategory(category.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BackofficePageHeader(
          title: 'Catégories',
          subtitle: 'Organisation du menu',
          trailing: FilledButton.icon(
            style: BackofficePageHeader.compactFilledButtonStyle,
            onPressed: _loading ? null : () => _openEditor(),
            icon: const Icon(Icons.add),
            label: const Text('Catégorie'),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: DataTable2(
                      columnSpacing: AppSpacing.m,
                      horizontalMargin: AppSpacing.m,
                      minWidth: 700,
                      headingRowColor: WidgetStateProperty.all(
                        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                      ),
                      columns: const [
                        DataColumn2(label: Text('Nom'), size: ColumnSize.L),
                        DataColumn2(label: Text('Couleur'), size: ColumnSize.S),
                        DataColumn2(label: Text('Ordre'), size: ColumnSize.S),
                        DataColumn2(label: Text('Produits'), size: ColumnSize.S),
                        DataColumn2(label: Text('Station'), size: ColumnSize.M),
                        DataColumn2(label: Text('Statut'), size: ColumnSize.S),
                        DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                      ],
                      rows: [
                        for (final category in _categories)
                          DataRow(
                            cells: [
                              DataCell(Text(category.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(
                                _ColorSwatch(colorHex: category.colorHex),
                              ),
                              DataCell(Text('${category.sortOrder}')),
                              DataCell(
                                Text('${_productCounts[category.id] ?? 0}'),
                              ),
                              DataCell(
                                Text(
                                  category.printStationId != null
                                      ? (_stationNames[category.printStationId] ?? 'Inconnue')
                                      : 'Aucune',
                                ),
                              ),
                              DataCell(
                                Icon(
                                  category.isActive
                                      ? Icons.check_circle
                                      : Icons.remove_circle_outline,
                                  color: category.isActive
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.outline,
                                  size: 20,
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Modifier',
                                      icon: const Icon(Icons.edit_outlined),
                                      color: theme.colorScheme.primary,
                                      onPressed: () =>
                                          _openEditor(category: category),
                                    ),
                                    IconButton(
                                      tooltip: 'Supprimer',
                                      icon: const Icon(Icons.delete_outline),
                                      color: theme.colorScheme.error,
                                      onPressed: () => _deleteCategory(category),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _ColorSwatch extends StatelessWidget {
  const _ColorSwatch({this.colorHex});

  final String? colorHex;

  @override
  Widget build(BuildContext context) {
    final color = parseColorHex(colorHex) ?? Theme.of(context).colorScheme.outline;
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
    );
  }
}

class CategoryEditorDialog extends StatefulWidget {
  const CategoryEditorDialog({super.key, this.category});

  final Category? category;

  @override
  State<CategoryEditorDialog> createState() => CategoryEditorDialogState();
}

class CategoryEditorDialogState extends State<CategoryEditorDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _orderCtrl;
  late Color _selectedColor;
  late bool _isActive;
  String? _selectedStationId;
  List<PrintStation> _stations = [];
  bool _loadingStations = true;

  @override
  void initState() {
    super.initState();
    final c = widget.category;
    _nameCtrl = TextEditingController(text: c?.name ?? '');
    _nameArCtrl = TextEditingController(text: c?.nameAr ?? '');
    _orderCtrl = TextEditingController(text: '${c?.sortOrder ?? 0}');
    _selectedColor =
        parseColorHex(c?.colorHex) ?? categoryColorPresets.first;
    _isActive = c?.isActive ?? true;
    _selectedStationId = c?.printStationId;
    _loadStations();
  }

  Future<void> _loadStations() async {
    try {
      final list = await sl<PrintRepository>().getActivePrintStations();
      if (mounted) {
        setState(() {
          _stations = list;
          _loadingStations = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _loadingStations = false);
      }
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      return;
    }
    final order = int.tryParse(_orderCtrl.text.trim()) ?? 0;
    final data = CategoryFormData(
      name: name,
      nameAr: _nameArCtrl.text.trim().isEmpty ? null : _nameArCtrl.text.trim(),
      colorHex: colorToHex(_selectedColor),
      printStationId: _selectedStationId,
      sortOrder: order,
      isActive: _isActive,
    );
    final repo = sl<ProductRepository>();
    if (widget.category == null) {
      await repo.createCategory(data);
    } else {
      await repo.updateCategory(widget.category!.id, data);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.category == null ? 'Nouvelle catégorie' : 'Modifier catégorie'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.s),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom (FR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.label_outline),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _nameArCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom (AR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _orderCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ordre d\'affichage',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sort),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: AppSpacing.m),
              DropdownButtonFormField<String>(
                value: _selectedStationId,
                decoration: const InputDecoration(
                  labelText: 'Station d\'impression (Cuisine/Bar)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.print_outlined),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Aucune station (Test/Console)'),
                  ),
                  for (final station in _stations)
                    DropdownMenuItem<String>(
                      value: station.id,
                      child: Text(station.name),
                    ),
                ],
                onChanged: _loadingStations
                    ? null
                    : (val) => setState(() => _selectedStationId = val),
              ),
              const SizedBox(height: AppSpacing.l),
              Text(
                'Couleur thématique',
                style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: AppSpacing.s),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  for (final color in categoryColorPresets)
                    GestureDetector(
                      onTap: () => setState(() => _selectedColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedColor == color
                                ? Colors.white
                                : Colors.black12,
                            width: _selectedColor == color ? 3 : 1,
                          ),
                          boxShadow: _selectedColor == color
                              ? [
                                  BoxShadow(
                                    color: color.withValues(alpha: 0.5),
                                    blurRadius: 8,
                                    spreadRadius: 2,
                                  ),
                                ]
                              : null,
                        ),
                        child: _selectedColor == color
                            ? const Icon(Icons.check, color: Colors.white, size: 18)
                            : null,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: AppSpacing.m),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Catégorie active'),
                subtitle: const Text('Afficher dans le point de vente'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
          ),
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
