import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_typography.dart';
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
    this.orderNotes,
    this.onOrderNotesChanged,
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
  final String? orderNotes;
  final ValueChanged<String>? onOrderNotesChanged;

  @override
  State<CartPanel> createState() => _CartPanelState();
}

class _CartPanelState extends State<CartPanel> {
  final _orderNotesController = TextEditingController();
  Timer? _notesDebounce;
  double _cartScale = 1;

  @override
  void initState() {
    super.initState();
    _orderNotesController.text = widget.orderNotes ?? '';
  }

  @override
  void didUpdateWidget(CartPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final incoming = widget.orderNotes ?? '';
    if (incoming != (oldWidget.orderNotes ?? '') &&
        incoming != _orderNotesController.text) {
      _orderNotesController.text = incoming;
    }
    if (widget.items.length > oldWidget.items.length) {
      _pulseCart();
    }
  }

  Future<void> _pulseCart() async {
    setState(() => _cartScale = 1.04);
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (mounted) {
      setState(() => _cartScale = 1);
    }
  }

  void _onOrderNotesEdited(String value) {
    _notesDebounce?.cancel();
    _notesDebounce = Timer(const Duration(milliseconds: 400), () {
      widget.onOrderNotesChanged?.call(value);
    });
  }

  @override
  void dispose() {
    _notesDebounce?.cancel();
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
    final orderTypeLabel = _orderTypeLabel(widget.orderType);

    return AnimatedScale(
      scale: _cartScale,
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutBack,
      alignment: Alignment.centerRight,
      child: Container(
      decoration: BoxDecoration(
        color: PosDesignTokens.cardBackground,
        border: Border(
          left: BorderSide(color: PosDesignTokens.borderLight),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _Header(
            userName: widget.user.name,
            tableLabel: table,
            orderTypeLabel: orderTypeLabel,
            onLock: widget.onLock,
          ),
          if (widget.deliveryLabel != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                widget.deliveryLabel!,
                style: TextStyle(
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
                      side: BorderSide(color: PosDesignTokens.borderLight),
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
              readOnly: widget.isOrderLocked,
              onChanged: widget.isOrderLocked ? null : _onOrderNotesEdited,
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
            Padding(
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
          _CartFooter(
            subtotal: widget.subtotal,
            taxAmount: widget.taxAmount,
            taxRateLabel: _taxRateLabel,
            discountAmount: widget.discountAmount,
            total: widget.total,
            hasItems: hasItems,
            isOrderLocked: widget.isOrderLocked,
            isProforma: widget.isProforma,
            canClaimNextCourse: widget.canClaimNextCourse,
            onDiscount: widget.onDiscount,
            onProforma: widget.onProforma,
            onClaimNextCourse: widget.onClaimNextCourse,
            onSendToKitchen: widget.onSendToKitchen,
            onPay: widget.onPay,
          ),
        ],
      ),
    ),
    );
  }

  static String _orderTypeLabel(OrderType type) {
    return switch (type) {
      OrderType.dineIn => 'Sur place',
      OrderType.takeaway => 'Emporter',
      OrderType.delivery => 'Livraison',
    };
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.userName,
    required this.tableLabel,
    required this.orderTypeLabel,
    required this.onLock,
  });

  final String userName;
  final String tableLabel;
  final String orderTypeLabel;
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
              style: TextStyle(
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: PosDesignTokens.primaryBlue.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        orderTypeLabel,
                        style: TextStyle(
                          color: PosDesignTokens.primaryBlue,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      tableLabel,
                      style: TextStyle(
                        color: PosDesignTokens.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Icon(Icons.expand_more, size: 16, color: PosDesignTokens.textMuted),
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

class _CartFooter extends StatelessWidget {
  const _CartFooter({
    required this.subtotal,
    required this.taxAmount,
    required this.taxRateLabel,
    required this.discountAmount,
    required this.total,
    required this.hasItems,
    required this.isOrderLocked,
    required this.isProforma,
    required this.canClaimNextCourse,
    this.onDiscount,
    this.onProforma,
    this.onClaimNextCourse,
    this.onSendToKitchen,
    this.onPay,
  });

  final double subtotal;
  final double taxAmount;
  final double taxRateLabel;
  final double discountAmount;
  final double total;
  final bool hasItems;
  final bool isOrderLocked;
  final bool isProforma;
  final bool canClaimNextCourse;
  final VoidCallback? onDiscount;
  final VoidCallback? onProforma;
  final VoidCallback? onClaimNextCourse;
  final VoidCallback? onSendToKitchen;
  final VoidCallback? onPay;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: PosDesignTokens.cardBackground,
        border: Border(top: BorderSide(color: PosDesignTokens.borderLight)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Totals ───────────────────────────────────────────────────
            _TotalLine('Sous-total', PriceFormatter.format(subtotal)),
            const SizedBox(height: 4),
            _TotalLine(
              'TVA (${taxRateLabel.toStringAsFixed(0)} %)',
              PriceFormatter.format(taxAmount),
            ),
            if (discountAmount > 0) ...[
              const SizedBox(height: 4),
              _TotalLine(
                'Remise',
                '- ${PriceFormatter.format(discountAmount)}',
                editable: true,
                onEdit: onDiscount,
              ),
            ],
            Divider(height: 18, color: PosDesignTokens.borderLight),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.8,
                    color: PosDesignTokens.textMuted,
                  ),
                ),
                Text(
                  PriceFormatter.format(total),
                  style: AppTypography.priceStyle(scheme).copyWith(fontSize: 26),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // ── Secondary Actions Row ─────────────────────────────────────
            Row(
              children: [
                Expanded(
                  child: _HudActionButton(
                    label: 'REMISE',
                    keyHint: 'F1',
                    icon: Icons.discount_outlined,
                    onPressed: hasItems && !isOrderLocked ? onDiscount : null,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _HudActionButton(
                    label: 'PROFORMA',
                    keyHint: 'F2',
                    icon: Icons.receipt_long_outlined,
                    onPressed: hasItems && !isProforma && !isOrderLocked
                        ? onProforma
                        : null,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: _HudActionButton(
                    label: 'ATTENTE',
                    keyHint: 'F3',
                    icon: Icons.pause_circle_outlined,
                    onPressed: null,
                    isDark: isDark,
                  ),
                ),
              ],
            ),
            if (canClaimNextCourse) ...[
              const SizedBox(height: 6),
              _KitchenButton(
                label: 'RÉCLAMER LA SUITE',
                icon: Icons.restaurant_menu,
                color: isDark
                    ? PosDesignTokens.primaryBlueDark
                    : const Color(0xFF1A237E),
                keyHint: null,
                onPressed: hasItems ? onClaimNextCourse : null,
              ),
            ],
            const SizedBox(height: 6),

            // ── Send to Kitchen ───────────────────────────────────────────
            _KitchenButton(
              label: 'ENVOYER EN CUISINE',
              icon: Icons.soup_kitchen_rounded,
              color: PosDesignTokens.primaryBlue,
              keyHint: 'F4',
              onPressed: hasItems && !isOrderLocked ? onSendToKitchen : null,
            ),
            const SizedBox(height: 6),

            // ── Pay Button ────────────────────────────────────────────────
            _PayButton(
              amount: total,
              onPressed: hasItems ? onPay : null,
              isDark: isDark,
            ),

            // ── Keyboard HUD strip ────────────────────────────────────────
            const SizedBox(height: 8),
            _KeyboardHud(isDark: isDark),
          ],
        ),
      ),
    );
  }
}

// ── New Premium Pay Button ────────────────────────────────────────────────────
class _PayButton extends StatelessWidget {
  const _PayButton({required this.amount, required this.isDark, this.onPressed});

  final double amount;
  final bool isDark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Material(
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Ink(
          height: 60,
          decoration: BoxDecoration(
            gradient: isEnabled
                ? LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF16A34A), const Color(0xFF22C55E)]
                        : [const Color(0xFF15803D), const Color(0xFF22C55E)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isEnabled ? null : PosDesignTokens.borderLight,
            borderRadius: BorderRadius.circular(14),
            boxShadow: isEnabled
                ? [
                    BoxShadow(
                      color: const Color(0xFF16A34A).withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_wallet_rounded,
                  color: isEnabled ? Colors.white : PosDesignTokens.textMuted,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'PAYER',
                        style: TextStyle(
                          color:
                              isEnabled ? Colors.white : PosDesignTokens.textMuted,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          letterSpacing: 0.8,
                        ),
                      ),
                      if (isEnabled)
                        Text(
                          PriceFormatter.format(amount),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: isEnabled ? 0.2 : 0.0),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: isEnabled ? 0.4 : 0.0),
                    ),
                  ),
                  child: Text(
                    'F5',
                    style: TextStyle(
                      color: isEnabled
                          ? Colors.white
                          : PosDesignTokens.textMuted,
                      fontWeight: FontWeight.w900,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── HUD secondary action button (icon + key badge) ────────────────────────────
class _HudActionButton extends StatelessWidget {
  const _HudActionButton({
    required this.label,
    required this.keyHint,
    required this.icon,
    required this.isDark,
    this.onPressed,
  });

  final String label;
  final String keyHint;
  final IconData icon;
  final bool isDark;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    final baseColor = isEnabled
        ? (isDark ? Colors.white70 : const Color(0xFF334155))
        : PosDesignTokens.textMuted;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: isEnabled
                  ? PosDesignTokens.borderLight
                  : PosDesignTokens.borderLight.withValues(alpha: 0.5),
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: baseColor),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: baseColor,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 3),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                decoration: BoxDecoration(
                  color: isEnabled
                      ? PosDesignTokens.primaryBlue.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: isEnabled
                        ? PosDesignTokens.primaryBlue.withValues(alpha: 0.3)
                        : Colors.transparent,
                  ),
                ),
                child: Text(
                  keyHint,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    color: isEnabled
                        ? PosDesignTokens.primaryBlue
                        : PosDesignTokens.textMuted,
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

// ── Kitchen action button (full-width pill with shortcut badge) ────────────────
class _KitchenButton extends StatelessWidget {
  const _KitchenButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.keyHint,
    this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final String? keyHint;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null;
    return Material(
      color: isEnabled ? color.withValues(alpha: 0.1) : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(11),
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            border: Border.all(
              color: isEnabled
                  ? color.withValues(alpha: 0.5)
                  : PosDesignTokens.borderLight,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 18,
                color: isEnabled ? color : PosDesignTokens.textMuted,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: isEnabled ? color : PosDesignTokens.textMuted,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
              if (keyHint != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: isEnabled
                        ? color.withValues(alpha: 0.15)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(
                      color: isEnabled
                          ? color.withValues(alpha: 0.4)
                          : Colors.transparent,
                    ),
                  ),
                  child: Text(
                    keyHint!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      color: isEnabled ? color : PosDesignTokens.textMuted,
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

// ── Keyboard HUD strip (bottom hints bar) ─────────────────────────────────────
class _KeyboardHud extends StatelessWidget {
  const _KeyboardHud({required this.isDark});
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = isDark
        ? Colors.white.withValues(alpha: 0.3)
        : const Color(0xFF94A3B8);
    final keyBg = isDark
        ? Colors.white.withValues(alpha: 0.06)
        : const Color(0xFFF1F5F9);
    final keyBorder = isDark
        ? Colors.white.withValues(alpha: 0.12)
        : const Color(0xFFCBD5E1);

    Widget key(String label) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
          decoration: BoxDecoration(
            color: keyBg,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: keyBorder),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.06),
                blurRadius: 1,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 9,
            ),
          ),
        );

    Widget hint(String keyLabel, String action) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            key(keyLabel),
            const SizedBox(width: 3),
            Text(
              action,
              style: theme.textTheme.labelSmall?.copyWith(
                color: textColor,
                fontSize: 9,
              ),
            ),
          ],
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        hint('F1', 'Remise'),
        hint('F2', 'Proforma'),
        hint('F4', 'Cuisine'),
        hint('F5', 'Payer'),
        hint('Esc', 'Retour'),
      ],
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
        Text(label, style: TextStyle(color: PosDesignTokens.textMuted)),
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



class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
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
