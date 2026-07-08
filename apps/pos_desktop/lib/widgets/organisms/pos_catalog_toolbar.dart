import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';

enum PosProductFilter { all, available, popular, favorites }

/// Barre recherche + filtres (zone centrale maquette).
class PosCatalogToolbar extends StatelessWidget {
  const PosCatalogToolbar({
    super.key,
    required this.searchController,
    required this.filter,
    required this.onFilterChanged,
    required this.isCompactMode,
    required this.onCompactModeChanged,
    this.onSort,
  });

  final TextEditingController searchController;
  final PosProductFilter filter;
  final ValueChanged<PosProductFilter> onFilterChanged;
  final bool isCompactMode;
  final ValueChanged<bool> onCompactModeChanged;
  final VoidCallback? onSort;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher un produit...',
                    hintStyle: TextStyle(color: PosDesignTokens.textMuted),
                    prefixIcon: Icon(Icons.search, color: PosDesignTokens.textMuted),
                    filled: true,
                    fillColor: PosDesignTokens.cardBackground,
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
                      borderSide: BorderSide(color: PosDesignTokens.borderLight),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
                      borderSide: BorderSide(color: PosDesignTokens.borderLight),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onSort,
                icon: const Icon(Icons.sort, size: 18),
                label: const Text('Trier'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
                  ),
                  side: BorderSide(color: PosDesignTokens.borderLight),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'Tous',
                        selected: filter == PosProductFilter.all,
                        onTap: () => onFilterChanged(PosProductFilter.all),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Disponibles',
                        selected: filter == PosProductFilter.available,
                        onTap: () => onFilterChanged(PosProductFilter.available),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Populaires',
                        selected: filter == PosProductFilter.popular,
                        onTap: () => onFilterChanged(PosProductFilter.popular),
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: 'Favoris',
                        icon: Icons.favorite_border,
                        selected: filter == PosProductFilter.favorites,
                        onTap: () => onFilterChanged(PosProductFilter.favorites),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  color: PosDesignTokens.cardBackground,
                  borderRadius: BorderRadius.circular(PosDesignTokens.radiusMd),
                  border: Border.all(color: PosDesignTokens.borderLight),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.grid_view_rounded,
                        size: 18,
                        color: !isCompactMode ? PosDesignTokens.primaryBlue : PosDesignTokens.textMuted,
                      ),
                      onPressed: () => onCompactModeChanged(false),
                      tooltip: 'Mode Grille Standard',
                      splashRadius: 16,
                    ),
                    Container(
                      width: 1,
                      height: 20,
                      color: PosDesignTokens.borderLight,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.view_headline_rounded,
                        size: 18,
                        color: isCompactMode ? PosDesignTokens.primaryBlue : PosDesignTokens.textMuted,
                      ),
                      onPressed: () => onCompactModeChanged(true),
                      tooltip: 'Mode Boutons Compacts',
                      splashRadius: 16,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.icon,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? PosDesignTokens.primaryBlue : PosDesignTokens.cardBackground,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? PosDesignTokens.primaryBlue : PosDesignTokens.borderLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: selected ? Colors.white : PosDesignTokens.textMuted,
                ),
                const SizedBox(width: 6),
              ],
              Text(
                label,
                style: TextStyle(
                  color: selected ? Colors.white : PosDesignTokens.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
