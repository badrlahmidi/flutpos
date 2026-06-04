import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../utils/price_formatter.dart';
import '../atoms/pos_button.dart';
import '../atoms/price_tag.dart';
import '../molecules/cart_item_tile.dart';

/// Panneau panier latéral (30 %) — alimenté par [CartBloc].
class CartPanel extends StatelessWidget {
  const CartPanel({
    super.key,
    required this.user,
    required this.orderType,
    required this.onOrderTypeChanged,
    required this.onLock,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.isLoading = false,
    this.onSendToKitchen,
    this.onProforma,
    this.onDiscount,
    this.onPay,
    this.isOrderLocked = false,
    this.isProforma = false,
    this.discountAmount = 0,
  });

  final User user;
  final OrderType orderType;
  final ValueChanged<OrderType> onOrderTypeChanged;
  final VoidCallback onLock;
  final List<OrderItemWithProduct> items;
  final double subtotal;
  final double taxAmount;
  final double total;
  final void Function(OrderItemWithProduct line) onIncrement;
  final void Function(OrderItemWithProduct line) onDecrement;
  final void Function(OrderItemWithProduct line)? onRemove;
  final bool isLoading;
  final VoidCallback? onSendToKitchen;
  final VoidCallback? onProforma;
  final VoidCallback? onDiscount;
  final VoidCallback? onPay;
  final bool isOrderLocked;
  final bool isProforma;
  final double discountAmount;

  int get itemCount => items.length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ColoredBox(
      color: scheme.surfaceContainerHighest,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _CartHeader(
            userName: user.name,
            onLock: onLock,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: _OrderTypeSelector(
              orderType: orderType,
              onChanged: onOrderTypeChanged,
            ),
          ),
          if (isProforma) ...[
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
              child: Material(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.s),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.s),
                  child: Row(
                    children: [
                      Icon(
                        Icons.lock_outline,
                        color: scheme.onTertiaryContainer,
                      ),
                      const SizedBox(width: AppSpacing.s),
                      Expanded(
                        child: Text(
                          'Proforma — ajout de plats bloqué',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onTertiaryContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.s),
          Expanded(
            child: isLoading && items.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : itemCount == 0
                    ? const _EmptyCart()
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: AppSpacing.s),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final line = items[index];
                          return CartItemTile(
                            line: line,
                            isLocked: isOrderLocked,
                            onIncrement: () => onIncrement(line),
                            onDecrement: () => onDecrement(line),
                            onRemove: onRemove == null
                                ? () {}
                                : () => onRemove!(line),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: PosButton(
              label: 'ENVOYER CUISINE',
              icon: Icons.restaurant,
              variant: PosButtonVariant.tonal,
              expand: true,
              onPressed:
                  itemCount > 0 && !isLoading ? onSendToKitchen : null,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: PosButton(
              label: 'REMISE',
              icon: Icons.discount_outlined,
              variant: PosButtonVariant.outlined,
              expand: true,
              onPressed: itemCount > 0 &&
                      !isLoading &&
                      !isOrderLocked
                  ? onDiscount
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: PosButton(
              label: 'PROFORMA',
              icon: Icons.receipt_long_outlined,
              variant: PosButtonVariant.outlined,
              expand: true,
              onPressed: itemCount > 0 &&
                      !isLoading &&
                      !isOrderLocked &&
                      !isProforma
                  ? onProforma
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TotalRow(
                  label: 'Sous-total',
                  value: PriceFormatter.format(subtotal),
                ),
                const SizedBox(height: AppSpacing.s),
                _TotalRow(
                  label: 'TVA',
                  value: PriceFormatter.format(taxAmount),
                ),
                if (discountAmount > 0) ...[
                  const SizedBox(height: AppSpacing.s),
                  _TotalRow(
                    label: 'Remise',
                    value: '- ${PriceFormatter.format(discountAmount)}',
                  ),
                ],
                const SizedBox(height: AppSpacing.m),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total', style: theme.textTheme.titleMedium),
                    PriceTag(amount: total, emphasized: true),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                PosButton(
                  label: 'PAYER',
                  icon: Icons.payments_outlined,
                  expand: true,
                  onPressed: itemCount > 0 && !isLoading ? onPay : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CartHeader extends StatelessWidget {
  const _CartHeader({
    required this.userName,
    required this.onLock,
  });

  final String userName;
  final VoidCallback onLock;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.s),
        child: Row(
          children: [
            Expanded(
              child: Text(
                userName,
                style: theme.textTheme.titleMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Verrouiller la caisse',
              onPressed: onLock,
              icon: const Icon(Icons.lock_outline),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderTypeSelector extends StatelessWidget {
  const _OrderTypeSelector({
    required this.orderType,
    required this.onChanged,
  });

  final OrderType orderType;
  final ValueChanged<OrderType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppSpacing.minTouchTarget,
      child: SegmentedButton<OrderType>(
        segments: const [
          ButtonSegment(
            value: OrderType.dineIn,
            label: Text('Sur place'),
            icon: Icon(Icons.restaurant),
          ),
          ButtonSegment(
            value: OrderType.takeaway,
            label: Text('Emporter'),
            icon: Icon(Icons.takeout_dining),
          ),
        ],
        selected: {orderType},
        onSelectionChanged: (set) {
          if (set.isNotEmpty) {
            onChanged(set.first);
          }
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: AppSpacing.minTouchTarget,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Panier vide',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              'Sélectionnez des produits',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
