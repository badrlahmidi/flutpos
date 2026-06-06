import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';

/// Sidebar catégories — maquette Ritaj POS.
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
    this.productCounts = const {},
    this.onShowAllCategories,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<Category> onCategorySelected;
  final Map<String, int> productCounts;
  final VoidCallback? onShowAllCategories;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: PosDesignTokens.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
            child: Text(
              'CATÉGORIES',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
                color: PosDesignTokens.textMuted,
              ),
            ),
          ),
          Expanded(
            child: categories.isEmpty
                ? const Center(child: Text('Aucune catégorie'))
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: categories.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _CategoryTile(
                        label: category.name,
                        count: productCounts[category.id] ?? 0,
                        accent: PosDesignTokens.categoryAccent(index),
                        selected: category.id == selectedCategoryId,
                        onTap: () => onCategorySelected(category),
                      );
                    },
                  ),
          ),
          if (onShowAllCategories != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: OutlinedButton.icon(
                onPressed: onShowAllCategories,
                icon: const Icon(Icons.grid_view_rounded, size: 18),
                label: const Text('Toutes les catégories'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PosDesignTokens.radiusMd),
                  ),
                  side: const BorderSide(color: PosDesignTokens.borderLight),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.count,
    required this.accent,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final int count;
  final Color accent;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final bg = selected ? accent.withValues(alpha: 0.12) : Colors.transparent;
    final border = selected ? accent.withValues(alpha: 0.35) : PosDesignTokens.borderLight;

    return Material(
      color: bg,
      borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(_iconFor(label), color: accent, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: selected ? accent : PosDesignTokens.shellBackground,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: selected ? Colors.white : PosDesignTokens.textMuted,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _iconFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('entr')) return Icons.eco_outlined;
    if (lower.contains('plat')) return Icons.restaurant_outlined;
    if (lower.contains('boisson')) return Icons.local_cafe_outlined;
    if (lower.contains('dessert')) return Icons.cake_outlined;
    if (lower.contains('sandwich')) return Icons.lunch_dining_outlined;
    if (lower.contains('tajine')) return Icons.ramen_dining_outlined;
    return Icons.restaurant_menu_outlined;
  }
}
