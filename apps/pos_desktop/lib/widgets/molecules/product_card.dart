import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';
import '../../theme/pos_design_tokens.dart';
import '../../utils/price_formatter.dart';

/// Carte produit — maquette Ritaj POS (image, favori, prix, stock).
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
    this.imageUrl,
    this.subtitle,
    this.description,
    this.inStock = true,
    this.isFavorite = false,
    this.productType = 'standard',
    this.onFavoriteToggle,
  });

  final String name;
  final double price;
  final VoidCallback onTap;
  final String? imageUrl;
  final String? subtitle;
  final String? description;
  final bool inStock;
  final bool isFavorite;
  final String productType;
  final VoidCallback? onFavoriteToggle;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosDesignTokens.cardBackground,
      borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
      elevation: 0,
      shadowColor: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(PosDesignTokens.radiusLg),
            border: Border.all(color: PosDesignTokens.borderLight),
            boxShadow: PosDesignTokens.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(PosDesignTokens.radiusLg),
                      ),
                      child: _ProductImage(imageUrl: imageUrl),
                    ),
                    if (productType == 'composed')
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: PosDesignTokens.primaryBlue,
                            borderRadius: BorderRadius.circular(6.0),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.menu_book, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text(
                                'Recette',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Material(
                        color: Colors.white.withValues(alpha: 0.92),
                        shape: const CircleBorder(),
                        child: InkWell(
                          onTap: onFavoriteToggle,
                          customBorder: const CircleBorder(),
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Icon(
                              isFavorite ? Icons.favorite : Icons.favorite_border,
                              size: 18,
                              color: isFavorite
                                  ? Colors.redAccent
                                  : PosDesignTokens.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        description ?? subtitle ?? ' ',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: PosDesignTokens.textMuted,
                        ),
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Text(
                            PriceFormatter.format(price),
                            style: AppTypography.priceStyle(
                              Theme.of(context).colorScheme,
                            ).copyWith(fontSize: 15),
                          ),
                          const Spacer(),
                          if (inStock)
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: PosDesignTokens.stockGreenBg,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'En stock',
                                style: TextStyle(
                                  color: PosDesignTokens.stockGreen,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: PosDesignTokens.offlineRed
                                    .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Rupture',
                                style: TextStyle(
                                  color: PosDesignTokens.offlineRed,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({this.imageUrl});

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(
        url,
        width: double.infinity,
        height: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => const _PlaceholderImage(),
      );
    }
    return const _PlaceholderImage();
  }
}

class _PlaceholderImage extends StatelessWidget {
  const _PlaceholderImage();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            PosDesignTokens.primaryBlue.withValues(alpha: 0.08),
            PosDesignTokens.payOrange.withValues(alpha: 0.12),
          ],
        ),
      ),
      child: const Icon(
        Icons.restaurant,
        size: 40,
        color: PosDesignTokens.textMuted,
      ),
    );
  }
}
