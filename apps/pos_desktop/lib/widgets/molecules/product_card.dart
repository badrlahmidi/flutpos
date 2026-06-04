import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../atoms/price_tag.dart';

/// Tuile produit : icône/image + nom + [PriceTag].
class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.name,
    required this.price,
    required this.onTap,
    this.imageUrl,
    this.subtitle,
  });

  final String name;
  final double price;
  final VoidCallback onTap;
  final String? imageUrl;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Material(
      color: scheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(AppSpacing.s),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: _ProductVisual(
                    imageUrl: imageUrl,
                    color: scheme.primaryContainer,
                    iconColor: scheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(height: AppSpacing.s),
                Text(
                  name,
                  style: theme.textTheme.titleMedium,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    subtitle!,
                    style: theme.textTheme.labelSmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                PriceTag(amount: price, align: TextAlign.start),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductVisual extends StatelessWidget {
  const _ProductVisual({
    required this.imageUrl,
    required this.color,
    required this.iconColor,
  });

  final String? imageUrl;
  final Color color;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(AppSpacing.s),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _placeholder(iconColor, color),
        ),
      );
    }
    return _placeholder(iconColor, color);
  }

  Widget _placeholder(Color iconColor, Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppSpacing.s),
      ),
      child: Center(
        child: Icon(
          Icons.restaurant,
          size: AppSpacing.l,
          color: iconColor,
        ),
      ),
    );
  }
}
