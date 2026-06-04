import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// Barre verticale des catégories (pas de scroll horizontal).
class CategoryBar extends StatelessWidget {
  const CategoryBar({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onCategorySelected,
  });

  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<Category> onCategorySelected;

  @override
  Widget build(BuildContext context) {
    if (categories.isEmpty) {
      return const _CategoryEmptyState();
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      itemCount: categories.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.s),
      itemBuilder: (context, index) {
        final category = categories[index];
        final selected = category.id == selectedCategoryId;
        return _CategoryTile(
          label: category.name,
          selected: selected,
          onTap: () => onCategorySelected(category),
        );
      },
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final background = selected ? scheme.primaryContainer : scheme.surface;
    final foreground =
        selected ? scheme.onPrimaryContainer : scheme.onSurface;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.s),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: SizedBox(
            width: double.infinity,
            height: AppSpacing.minTouchTarget,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Row(
                children: [
                  Icon(
                    Icons.category_outlined,
                    color: foreground,
                    size: AppSpacing.m,
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    child: Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: foreground,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryEmptyState extends StatelessWidget {
  const _CategoryEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Text(
          'Aucune catégorie',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
