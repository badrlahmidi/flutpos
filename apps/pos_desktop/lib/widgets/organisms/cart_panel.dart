import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';
import '../../utils/price_formatter.dart';
import '../atoms/auto_direction_text_field.dart';
import '../molecules/cart_item_tile.dart';

/// Panneau panier droit — maquette Ritaj POS.
class CartPanel extends StatefulWidget {
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
    this.tableLabel,
    this.isLoading = false,
    this.onSendToKitchen,
    this.onClaimNextCourse,
    this.onProforma,
    this.onDiscount,
    this.onPay,
    this.isOrderLocked = false,
    this.isProforma = false,
    this.discountAmount = 0,
    this.deliveryLabel,
    this.isDeliveryOrder = false,
    this.activeCourseNumber = 1,
    this.onActiveCourseSelected,
    this.onItemCourseChanged,
    this.canClaimNextCourse = false,
  });

  final User user;
  final String? tableLabel;
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
  final VoidCallback? onClaimNextCourse;
  final VoidCallback? onProforma;
  final VoidCallback? onDiscount;
  final VoidCallback? onPay;
  final bool isOrderLocked;
  final bool isProforma;
  final double discountAmount;
  final String? deliveryLabel;
  final bool isDeliveryOrder;
  final int activeCourseNumber;
  final ValueChanged<int>? onActiveCourseSelected;
  final void Function(OrderItemWithProduct line, int course)? onItemCourseChanged;
  final bool canClaimNextCourse;

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  final _orderNotesController = TextEditingController();

  @override
  void dispose() {
    _orderNotesController.dispose();
    super.dispose();
  }

  double get _taxRateLabel {
    if (widget.subtotal <= 0) return 0;
    return (widget.taxAmount / widget.subtotal * 100).roundToDouble();
  }

  @override
  Widget build(BuildContext context) {
    final hasItems = widget.items.isNotEmpty;
    final table = widget.tableLabel ?? 'Comptoir';

    return Container(
      color: PosDesignTokens.cardBackground,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            userName: widget.user.name,
            tableLabel: table,
            onLock: widget.onLock,
          ),
          if (widget.deliveryLabel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.deliveryLabel!,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: PosDesignTokens.primaryBlue,
                ),
              ),
            ),
          if (!widget.isDeliveryOrder)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _OrderTypeTabs(
                orderType: widget.orderType,
                onChanged: widget.onOrderTypeChanged,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: null,
                    icon: const Icon(Icons.person_add_outlined, size: 18),
                    label: const Text('Client (optionnel)'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      side: const BorderSide(color: PosDesignTokens.borderLight),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: AutoDirectionTextField(
              controller: _orderNotesController,
              decoration: const InputDecoration(
                labelText: 'Note de commande',
                hintText: 'Instructions spéciales...',
                border: OutlineInputBorder(),
                isDense: true,
              ),
              maxLines: 2,
            ),
          ),
          if (widget.isProforma)
            const Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'Proforma — ajout bloqué',
                style: TextStyle(color: PosDesignTokens.payOrange),
              ),
            ),
          if (!widget.isDeliveryOrder && !widget.isOrderLocked) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Wrap(
                spacing: 6,
                children: [
                  for (var c = CourseHelpers.minCourse;
                      c <= CourseHelpers.maxCourse;
                      c++)
                    ChoiceChip(
                      label: Text(CourseHelpers.labelForCourse(c)),
                      selected: widget.activeCourseNumber == c,
                      onSelected: widget.onActiveCourseSelected == null
                          ? null
                          : (_) => widget.onActiveCourseSelected!(c),
                    ),
                ],
              ),
            ),
          ],
          Expanded(
            child: widget.isLoading && !hasItems
                ? const Center(child: CircularProgressIndicator())
                : !hasItems
                    ? const _EmptyCart()
                    : ListView.builder(
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final line = widget.items[index];
                          return CartItemTile(
                            line: line,
                            isLocked: widget.isOrderLocked,
                            onIncrement: () => widget.onIncrement(line),
                            onDecrement: () => widget.onDecrement(line),
                            onRemove: widget.onRemove == null
                                ? null
                                : () => widget.onRemove!(line),
                            onCourseChanged: widget.onItemCourseChanged == null ||
                                    widget.isOrderLocked
                                ? null
                                : (c) => widget.onItemCourseChanged!(line, c),
                          );
                        },
                      ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                _TotalLine('Sous-total', PriceFormatter.format(widget.subtotal)),
                const SizedBox(height: 6),
                _TotalLine(
                  'TVA (${_taxRateLabel.toStringAsFixed(0)} %)',
                  PriceFormatter.format(widget.taxAmount),
                ),
                if (widget.discountAmount > 0) ...[
                  const SizedBox(height: 6),
                  _TotalLine(
                    'Remise',
                    '- ${PriceFormatter.format(widget.discountAmount)}',
                    editable: true,
                    onEdit: widget.onDiscount,
                  ),
                ],
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'TOTAL',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.5,
                        color: PosDesignTokens.textMuted,
                      ),
                    ),
                    Text(
                      PriceFormatter.format(widget.total),
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: PosDesignTokens.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _SecondaryAction(
                    label: 'REMISE',
                    onPressed: hasItems && !widget.isOrderLocked
                        ? widget.onDiscount
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SecondaryAction(
                    label: 'PROFORMA',
                    onPressed: hasItems && !widget.isProforma && !widget.isOrderLocked
                        ? widget.onProforma
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _SecondaryAction(
                    label: 'EN ATTENTE',
                    onPressed: null,
                  ),
                ),
              ],
            ),
          ),
          if (widget.canClaimNextCourse)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _PrimaryAction(
                label: 'RÉCLAMER LA SUITE',
                icon: Icons.restaurant_menu,
                color: PosDesignTokens.primaryBlueDark,
                onPressed: hasItems ? widget.onClaimNextCourse : null,
              ),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: _PrimaryAction(
              label: 'ENVOYER EN CUISINE',
              icon: Icons.restaurant,
              color: PosDesignTokens.primaryBlue,
              onPressed: hasItems ? widget.onSendToKitchen : null,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: _PrimaryAction(
              label: 'PAYER ${PriceFormatter.format(widget.total)}',
              icon: Icons.account_balance_wallet_outlined,
              color: PosDesignTokens.payOrange,
              onPressed: hasItems ? widget.onPay : null,
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.userName,
    required this.tableLabel,
    required this.onLock,
  });

  final String userName;
  final String tableLabel;
  final VoidCallback onLock;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: PosDesignTokens.primaryBlue.withValues(alpha: 0.12),
            child: Text(
              userName.isNotEmpty ? userName[0].toUpperCase() : '?',
              style: const TextStyle(
                color: PosDesignTokens.primaryBlue,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      tableLabel,
                      style: const TextStyle(
                        color: PosDesignTokens.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const Icon(Icons.expand_more, size: 16, color: PosDesignTokens.textMuted),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: 'Verrouiller',
            onPressed: onLock,
            icon: const Icon(Icons.lock_outline, size: 20),
          ),
        ],
      ),
    );
  }
}

class _OrderTypeTabs extends StatelessWidget {
  const _OrderTypeTabs({
    required this.orderType,
    required this.onChanged,
  });

  final OrderType orderType;
  final ValueChanged<OrderType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: PosDesignTokens.shellBackground,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _Tab(
            label: 'Sur place',
            selected: orderType == OrderType.dineIn,
            onTap: () => onChanged(OrderType.dineIn),
          ),
          _Tab(
            label: 'Emporter',
            selected: orderType == OrderType.takeaway,
            onTap: () => onChanged(OrderType.takeaway),
          ),
          _Tab(
            label: 'Livraison',
            selected: orderType == OrderType.delivery,
            onTap: () => onChanged(OrderType.delivery),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: selected ? PosDesignTokens.payOrange : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: selected ? Colors.white : PosDesignTokens.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  const _TotalLine(this.label, this.value, {this.editable = false, this.onEdit});

  final String label;
  final String value;
  final bool editable;
  final VoidCallback? onEdit;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: PosDesignTokens.textMuted)),
        Row(
          children: [
            Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (editable && onEdit != null)
              IconButton(
                icon: const Icon(Icons.edit_outlined, size: 16),
                onPressed: onEdit,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
      ],
    );
  }
}

class _SecondaryAction extends StatelessWidget {
  const _SecondaryAction({required this.label, this.onPressed});

  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        side: const BorderSide(color: PosDesignTokens.borderLight),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _PrimaryAction extends StatelessWidget {
  const _PrimaryAction({
    required this.label,
    required this.icon,
    required this.color,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
      style: FilledButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        minimumSize: const Size(double.infinity, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.shopping_cart_outlined, size: 48, color: PosDesignTokens.textMuted),
          SizedBox(height: 12),
          Text('Panier vide', style: TextStyle(color: PosDesignTokens.textMuted)),
        ],
      ),
    );
  }
}
