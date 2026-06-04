import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../molecules/product_card.dart';

/// Grille produits responsive ([SliverGrid], scroll vertical uniquement).
class ProductsGrid extends StatelessWidget {
  const ProductsGrid({
    super.key,
    required this.products,
    required this.priceFor,
    required this.onProductTap,
    this.scrollController,
  });

  final List<Product> products;
  final double Function(Product product) priceFor;
  final ValueChanged<Product> onProductTap;
  final ScrollController? scrollController;

  /// [SliverGrid] à intégrer dans un [CustomScrollView] parent.
  static Widget sliver({
    required List<Product> products,
    required double Function(Product product) priceFor,
    required ValueChanged<Product> onProductTap,
    required double availableWidth,
  }) {
    final crossAxisCount = _crossAxisCount(availableWidth);
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: AppSpacing.m,
        crossAxisSpacing: AppSpacing.m,
        childAspectRatio: 0.82,
      ),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final product = products[index];
          return ProductCard(
            name: product.name,
            price: priceFor(product),
            imageUrl: product.image,
            subtitle: product.nameAr,
            onTap: () => onProductTap(product),
          );
        },
        childCount: products.length,
      ),
    );
  }

  static int _crossAxisCount(double width) {
    if (width >= 960) {
      return 4;
    }
    if (width >= 640) {
      return 3;
    }
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _ProductsEmptyState();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final crossAxisCount = _crossAxisCount(constraints.maxWidth);

        return GridView.builder(
          controller: scrollController,
          padding: const EdgeInsets.all(AppSpacing.m),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: AppSpacing.m,
            crossAxisSpacing: AppSpacing.m,
            childAspectRatio: 0.82,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductCard(
              name: product.name,
              price: priceFor(product),
              imageUrl: product.image,
              subtitle: product.nameAr,
              onTap: () => onProductTap(product),
            );
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
