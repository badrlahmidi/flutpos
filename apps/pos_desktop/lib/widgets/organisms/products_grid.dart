import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../theme/app_spacing.dart';
import '../../theme/pos_design_tokens.dart';
import '../molecules/product_card.dart';

/// Grille produits responsive ([SliverGrid], scroll vertical uniquement).
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.priceFor,
    required this.onProductTap,
    this.onProductLongPress,
    this.scrollController,
    this.isCompactMode = false,
  });

  final List<Product> products;
  final double Function(Product product) priceFor;
  final ValueChanged<Product> onProductTap;
  final ValueChanged<Product>? onProductLongPress;
  final ScrollController? scrollController;
  final bool isCompactMode;

  /// [SliverGrid] à intégrer dans un [CustomScrollView] parent.
  static Widget sliver({
    required List<Product> products,
    required double Function(Product product) priceFor,
    required ValueChanged<Product> onProductTap,
    required ValueChanged<Product>? onProductLongPress,
    required double availableWidth,
    required bool isCompactMode,
  }) {
    final hasImages = !isCompactMode && products.any((p) => p.image != null && p.image!.isNotEmpty);
    final crossAxisCount = _crossAxisCount(availableWidth, hasImages);
    final childAspectRatio = hasImages ? 0.78 : 1.35;

    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.m,
        crossAxisSpacing: AppSpacing.m,
        childAspectRatio: childAspectRatio,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          final accentColor = PosDesignTokens.categoryAccent(product.categoryId.hashCode);
          return ProductCard(
            name: product.name,
            price: priceFor(product),
            imageUrl: isCompactMode ? null : product.image,
            subtitle: product.nameAr,
            inStock: !product.trackStock || product.currentStock > 0,
            productType: product.productType,
            onTap: () => onProductTap(product),
            onLongPress: () => onProductLongPress?.call(product),
            accentColor: accentColor,
          )
              .animate(delay: Duration(milliseconds: index * 50))
              .fadeIn(duration: 300.ms)
              .slideY(begin: 0.1, end: 0);
        },
        childCount: products.length,
      ),
    );
  }

  static int _crossAxisCount(double width, bool hasImages) {
    if (hasImages) {
      if (width >= 960) {
        return 4;
      }
      if (width >= 640) {
        return 3;
      }
      return 2;
    } else {
      // Mode compact sans images : afficher plus de colonnes
      if (width >= 1200) {
        return 6;
      }
      if (width >= 900) {
        return 5;
      }
      if (width >= 600) {
        return 4;
      }
      return 3;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _ProductsEmptyState();
    }

    final hasImages = !isCompactMode && products.any((p) => p.image != null && p.image!.isNotEmpty);
    final childAspectRatio = hasImages ? 0.78 : 1.35;

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCount(constraints.maxWidth, hasImages);

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.m),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: childAspectRatio,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            final accentColor = PosDesignTokens.categoryAccent(product.categoryId.hashCode);
            return ProductCard(
              name: product.name,
              price: priceFor(product),
              imageUrl: isCompactMode ? null : product.image,
              subtitle: product.nameAr,
              inStock: !product.trackStock || product.currentStock > 0,
              productType: product.productType,
              onTap: () => onProductTap(product),
              onLongPress: () => onProductLongPress?.call(product),
              accentColor: accentColor,
            )
                .animate(delay: Duration(milliseconds: index * 50))
                .fadeIn(duration: 300.ms)
                .slideY(begin: 0.1, end: 0);
          },
        );
      },
    );
  }
}

class _ProductsEmptyState extends StatelessWidget {
  const _ProductsEmptyState();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: AppSpacing.minTouchTarget,
            color: theme.colorScheme.onSurfaceVariant,
          ),
          const SizedBox(height: AppSpacing.m),
          Text(
            'Aucun produit dans cette catégorie',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
