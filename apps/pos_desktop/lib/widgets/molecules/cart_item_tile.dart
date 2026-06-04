import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';

/// Ligne de panier avec contrôles quantité et suppression.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required     this.onRemove,
    this.isLocked = false,
  });

  final OrderItemWithProduct line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onRemove;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final qty = line.orderItem.quantity;
    final modifierLabels = line.modifierSummary;
    final sentToKitchen = line.orderItem.isFired;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      child: Material(
        color: scheme.surface,
        borderRadius: BorderRadius.circular(AppSpacing.s),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.s),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.product.name,
                          style: theme.textTheme.titleMedium,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (sentToKitchen) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              'Envoyé cuisine',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: scheme.tertiary,
                              ),
                            ),
                          ),
                        ],
                        if (modifierLabels.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(top: AppSpacing.xs),
                            child: Text(
                              modifierLabels,
                              style: theme.textTheme.labelSmall,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Text(
                    PriceFormatter.format(line.lineSubtotal),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              Row(
                children: [
                  _QtyButton(
                    icon: Icons.remove,
                    onPressed: isLocked ? null : onDecrement,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.m,
                    ),
                    child: Text(
                      qty == qty.roundToDouble()
                          ? '${qty.toInt()}'
                          : qty.toStringAsFixed(1),
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  _QtyButton(
                    icon: Icons.add,
                    onPressed: isLocked ? null : onIncrement,
                  ),
                  const Spacer(),
                  IconButton(
                    tooltip: sentToKitchen
                        ? 'Annuler (void cuisine)'
                        : 'Supprimer la ligne',
                    onPressed: isLocked || onRemove == null ? null : onRemove,
                    icon: Icon(
                      sentToKitchen
                          ? Icons.block
                          : Icons.delete_outline,
                      color: scheme.error,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _QtyButton extends StatelessWidget {
  const _QtyButton({required this.icon, this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppSpacing.minTouchTarget,
      height: AppSpacing.minTouchTarget,
      child: Material(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSpacing.s),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onPressed,
          child: Icon(icon),
        ),
      ),
    );
  }
}
