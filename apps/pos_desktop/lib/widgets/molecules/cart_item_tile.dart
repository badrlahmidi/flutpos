import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/pos_design_tokens.dart';
import '../../utils/price_formatter.dart';

/// Ligne panier compacte — maquette Ritaj POS.
class CartItemTile extends StatelessWidget {
  const CartItemTile({
    super.key,
    required this.line,
    required this.onIncrement,
    required this.onDecrement,
    required this.onRemove,
    this.isLocked = false,
    this.onCourseChanged,
  });

  final OrderItemWithProduct line;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onRemove;
  final bool isLocked;
  final ValueChanged<int>? onCourseChanged;

  @override
  Widget build(BuildContext context) {
    final qty = line.orderItem.quantity;
    final unit = line.orderItem.unitPrice;
    final sentToKitchen = line.orderItem.isFired;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: PosDesignTokens.cardBackground,
          borderRadius: BorderRadius.circular(PosDesignTokens.radiusMd),
          border: Border.all(color: PosDesignTokens.borderLight),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: _Thumb(imageUrl: line.product.image),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    line.product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${_formatQty(qty)} x ${PriceFormatter.format(unit)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: PosDesignTokens.textMuted,
                    ),
                  ),
                  if (line.modifierSummary.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      '- ${line.modifierSummary}',
                      style: TextStyle(
                        fontSize: 11,
                        color: PosDesignTokens.textMuted,
                      ),
                    ),
                  ],
                  if (line.orderItem.customNotes != null &&
                      line.orderItem.customNotes!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      line.orderItem.customNotes!,
                      style: TextStyle(
                        fontSize: 11,
                        color: PosDesignTokens.offlineRed,
                      ),
                    ),
                  ],
                  if (sentToKitchen)
                    Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Text(
                        'Envoyé cuisine',
                        style: TextStyle(
                          fontSize: 10,
                          color: PosDesignTokens.primaryBlue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: PosDesignTokens.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${CourseHelpers.emojiForCourse(line.orderItem.courseNumber)} ${CourseHelpers.labelForCourse(line.orderItem.courseNumber)}',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: PosDesignTokens.primaryBlue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _QtyBtn(icon: Icons.remove, onTap: isLocked ? null : onDecrement),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          _formatQty(qty),
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      _QtyBtn(icon: Icons.add, onTap: isLocked ? null : onIncrement),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  PriceFormatter.format(line.lineSubtotal),
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    color: PosDesignTokens.primaryBlue,
                  ),
                ),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20),
                  onSelected: (value) {
                    if (value == 'remove' && onRemove != null) {
                      onRemove!();
                    } else if (value.startsWith('course_') && onCourseChanged != null) {
                      final c = int.tryParse(value.substring(7));
                      if (c != null) {
                        onCourseChanged!(c);
                      }
                    }
                  },
                  itemBuilder: (_) => [
                    if (onRemove != null)
                      const PopupMenuItem(
                        value: 'remove',
                        child: Text('Supprimer'),
                      ),
                    if (onCourseChanged != null && !isLocked) ...[
                      const PopupMenuDivider(),
                      for (var c = CourseHelpers.minCourse; c <= CourseHelpers.maxCourse; c++)
                        PopupMenuItem(
                          value: 'course_$c',
                          child: Row(
                            children: [
                              Text(CourseHelpers.emojiForCourse(c)),
                              const SizedBox(width: 8),
                              Text(CourseHelpers.labelForCourse(c)),
                              if (line.orderItem.courseNumber == c) ...[
                                const Spacer(),
                                Icon(Icons.check, size: 16, color: PosDesignTokens.primaryBlue),
                              ],
                            ],
                          ),
                        ),
                    ],
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _formatQty(double q) =>
      q == q.roundToDouble() ? '${q.toInt()}' : q.toStringAsFixed(1);
}

class _Thumb extends StatelessWidget {
  const _Thumb({this.imageUrl});
  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url != null && url.isNotEmpty) {
      return Image.network(url, width: 52, height: 52, fit: BoxFit.cover);
    }
    return Container(
      width: 52,
      height: 52,
      color: PosDesignTokens.shellBackground,
      child: Icon(Icons.restaurant, size: 22, color: PosDesignTokens.textMuted),
    );
  }
}

class _QtyBtn extends StatelessWidget {
  const _QtyBtn({required this.icon, this.onTap});
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: PosDesignTokens.shellBackground,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          width: 28,
          height: 28,
          child: Icon(icon, size: 16),
        ),
      ),
    );
  }
}
