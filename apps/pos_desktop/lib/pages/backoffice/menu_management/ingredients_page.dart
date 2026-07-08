import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../../widgets/atoms/pos_button.dart';
import '../../../utils/price_formatter.dart';

class IngredientsPage extends StatefulWidget {
  const IngredientsPage({super.key});

  @override
  State<IngredientsPage> createState() => _IngredientsPageState();
}

class _IngredientsPageState extends State<IngredientsPage> {
  final _repo = sl<ProductRepository>();
  List<Ingredient> _ingredients = [];
  bool _isLoading = true;
  String _search = '';

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    try {
      final ingredients = await _repo.listAllIngredients();
      if (mounted) {
        setState(() {
          _ingredients = ingredients.where((i) => i.name.toLowerCase().contains(_search.toLowerCase())).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _createIngredient() async {
    final form = await _showIngredientForm();
    if (form != null) {
      await _repo.createIngredient(form);
      _loadData();
    }
  }

  Future<void> _editIngredient(Ingredient i) async {
    final form = await _showIngredientForm(existing: i);
    if (form != null) {
      await _repo.updateIngredient(i.id, form);
      _loadData();
    }
  }
  
  Future<void> _deleteIngredient(Ingredient i) async {
    final ok = await confirmDelete(
      context,
      title: 'Supprimer Ingrédient',
      message: 'Confirmer la suppression de « ${i.name} » ?',
    );
    if (!ok || !mounted) return;
    
    try {
      await _repo.deleteIngredient(i.id);
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Impossible de supprimer cet ingrédient (il est probablement utilisé dans une recette).')),
        );
      }
    }
  }

  Future<IngredientFormData?> _showIngredientForm({Ingredient? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name);
    final unitCtrl = TextEditingController(text: existing?.unit ?? 'kg');
    final costCtrl = TextEditingController(text: existing != null ? '${existing.costPerUnit}' : '');
    final stockCtrl = TextEditingController(text: existing != null ? '${existing.currentStock}' : '0');
    final minStockCtrl = TextEditingController(text: existing != null ? '${existing.minimumStock}' : '0');

    return showDialog<IngredientFormData>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Nouvel Ingrédient' : 'Modifier Ingrédient'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Nom de l\'ingrédient *', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: unitCtrl,
                decoration: const InputDecoration(labelText: 'Unité (ex: kg, L, pièce)', border: OutlineInputBorder()),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: costCtrl,
                decoration: const InputDecoration(labelText: 'Coût par unité (DH)', border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: stockCtrl,
                decoration: const InputDecoration(labelText: 'Stock Actuel', border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: minStockCtrl,
                decoration: const InputDecoration(labelText: 'Stock Minimum (Alerte)', border: OutlineInputBorder()),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              if (nameCtrl.text.trim().isEmpty) return;
              Navigator.pop(
                context,
                IngredientFormData(
                  name: nameCtrl.text.trim(),
                  unit: unitCtrl.text.trim().isEmpty ? 'unite' : unitCtrl.text.trim(),
                  costPerUnit: double.tryParse(costCtrl.text.replaceAll(',', '.')) ?? 0,
                  currentStock: double.tryParse(stockCtrl.text.replaceAll(',', '.')) ?? 0,
                  minimumStock: double.tryParse(minStockCtrl.text.replaceAll(',', '.')) ?? 0,
                ),
              );
            },
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BackofficePageHeader(
          title: 'Stock & Ingrédients',
          subtitle: 'Gérer la liste des ingrédients pour vos fiches techniques.',
          actions: [
            PosButton(
              label: 'Nouvel Ingrédient',
              icon: Icons.add_shopping_cart,
              onPressed: _createIngredient,
            ),
          ],
        ),
        Container(
          color: theme.colorScheme.surfaceContainerLow,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.s),
          child: Row(
            children: [
              SizedBox(
                width: 280,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un ingrédient...',
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
                    _loadData();
                  },
                ),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Actualiser',
                icon: const Icon(Icons.refresh),
                onPressed: _loadData,
              ),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Card(
                  margin: const EdgeInsets.all(AppSpacing.l),
                  child: ListView.separated(
                    itemCount: _ingredients.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final ing = _ingredients[index];
                      final isLowStock = ing.currentStock <= ing.minimumStock;
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isLowStock ? Colors.orange.shade100 : Colors.blue.shade100,
                          child: Icon(
                            Icons.inventory_2,
                            color: isLowStock ? Colors.orange : Colors.blue,
                          ),
                        ),
                        title: Text(ing.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Coût: ${PriceFormatter.format(ing.costPerUnit)} / ${ing.unit}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('Stock', style: TextStyle(fontSize: 12)),
                                Text(
                                  '${ing.currentStock.toStringAsFixed(2)} ${ing.unit}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isLowStock ? Colors.orange : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: AppSpacing.l),
                            IconButton(
                              icon: const Icon(Icons.edit_outlined),
                              onPressed: () => _editIngredient(ing),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                              onPressed: () => _deleteIngredient(ing),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}


