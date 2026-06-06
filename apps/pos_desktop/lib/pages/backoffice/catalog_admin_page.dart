import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';

/// Édition des libellés arabes (produits et modificateurs).
class CatalogAdminPage extends StatefulWidget {
  const CatalogAdminPage({super.key});

  @override
  State<CatalogAdminPage> createState() => _CatalogAdminPageState();
}

class _CatalogAdminPageState extends State<CatalogAdminPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;
  List<Product> _products = const [];
  List<ModifierOption> _modifiers = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    _load();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final repo = sl<ProductRepository>();
    final products = await repo.listAllActiveProducts();
    final modifiers = await repo.listAllModifierOptions();
    if (mounted) {
      setState(() {
        _products = products;
        _modifiers = modifiers;
        _loading = false;
      });
    }
  }

  Future<void> _editProduct(Product product) async {
    final controller = TextEditingController(text: product.nameAr ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(product.name),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nom arabe (nameAr)',
            hintText: 'Ex: شاورما',
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (saved != true || !mounted) {
      controller.dispose();
      return;
    }
    final nameAr = controller.text.trim();
    controller.dispose();
    await sl<ProductRepository>().updateProductNameAr(
      productId: product.id,
      nameAr: nameAr.isEmpty ? null : nameAr,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produit mis à jour')),
      );
      await _load();
    }
  }

  Future<void> _editModifier(ModifierOption option) async {
    final controller = TextEditingController(text: option.nameAr ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(option.name),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nom arabe (nameAr)',
            border: OutlineInputBorder(),
          ),
          textDirection: TextDirection.rtl,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Enregistrer'),
          ),
        ],
      ),
    );
    if (saved != true || !mounted) {
      controller.dispose();
      return;
    }
    final nameAr = controller.text.trim();
    controller.dispose();
    await sl<ProductRepository>().updateModifierOptionNameAr(
      optionId: option.id,
      nameAr: nameAr.isEmpty ? null : nameAr,
    );
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Modificateur mis à jour')),
      );
      await _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogue — libellés AR'),
        bottom: TabBar(
          controller: _tabs,
          tabs: const [
            Tab(text: 'Produits'),
            Tab(text: 'Modificateurs'),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Actualiser',
            onPressed: _loading ? null : _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabs,
              children: [
                ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: _products.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.s),
                  itemBuilder: (context, index) {
                    final p = _products[index];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                        p.nameAr?.isNotEmpty == true
                            ? p.nameAr!
                            : '— pas de libellé AR —',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: p.nameAr?.isNotEmpty == true
                              ? null
                              : theme.colorScheme.outline,
                        ),
                        textDirection: TextDirection.rtl,
                      ),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () => _editProduct(p),
                    );
                  },
                ),
                ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: _modifiers.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.s),
                  itemBuilder: (context, index) {
                    final m = _modifiers[index];
                    return ListTile(
                      title: Text(m.name),
                      subtitle: Text(
                        m.nameAr?.isNotEmpty == true
                            ? m.nameAr!
                            : '— pas de libellé AR —',
                        textDirection: TextDirection.rtl,
                      ),
                      trailing: const Icon(Icons.edit_outlined),
                      onTap: () => _editModifier(m),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
