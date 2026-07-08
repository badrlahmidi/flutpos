import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/pos_design_tokens.dart';
import '../../utils/price_formatter.dart';

/// Ligne panier compacte — accent coloré par catégorie, indicateur cuisine premium.
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

  Color _accentColor(bool isDark) {
    final hash = line.product.name.codeUnits.fold(0, (a, b) => a + b);
    return PosDesignTokens.categoryAccent(hash);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final qty = line.orderItem.quantity;
    final sentToKitchen = line.orderItem.isFired;
    final accent = _accentColor(isDark);
    


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Material(
        color: PosDesignTokens.cardBackground,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: sentToKitchen
                  ? PosDesignTokens.primaryBlue.withValues(alpha: 0.3)
                  : PosDesignTokens.borderLight,
            ),
            gradient: LinearGradient(
              colors: [
                accent.withValues(alpha: isDark ? 0.08 : 0.04),
                Colors.transparent,
              ],
              stops: const [0.0, 0.15],
            ),
          ),
          child: Row(
            children: [
              // Left accent indicator
              Container(
                width: 3,
                height: 24,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              ),
              const SizedBox(width: 6),
              // Compact Stepper
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _QtyBtnCompact(
                    icon: Icons.remove,
                    onTap: isLocked ? null : onDecrement,
                    accent: accent,
                  ),
                  Container(
                    constraints: const BoxConstraints(minWidth: 20),
                    alignment: Alignment.center,
                    child: Text(
                      _formatQty(qty),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: accent,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  _QtyBtnCompact(
                    icon: Icons.add,
                    onTap: isLocked ? null : onIncrement,
                    accent: accent,
                  ),
                ],
              ),
              const SizedBox(width: 8),
              // Product details (Single Line)
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: RichText(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                          children: [
                            TextSpan(text: line.product.name),
                            if (line.product.nameAr != null && line.product.nameAr!.isNotEmpty)
                              TextSpan(
                                text: ' (${line.product.nameAr})',
                                style: TextStyle(
                                  color: PosDesignTokens.textMuted,
                                  fontSize: 9,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            if (line.modifierSummary.isNotEmpty)
                              TextSpan(
                                text: ' • ${line.modifierSummary}',
                                style: TextStyle(
                                  color: PosDesignTokens.textMuted,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            if (line.orderItem.customNotes != null && line.orderItem.customNotes!.isNotEmpty)
                              TextSpan(
                                text: ' • ⚠ ${line.orderItem.customNotes!}',
                                style: TextStyle(
                                  color: PosDesignTokens.offlineRed,
                                  fontSize: 10,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    _CourseChipCompact(
                      label: CourseHelpers.emojiForCourse(line.orderItem.courseNumber),
                      color: accent,
                      tooltip: CourseHelpers.labelForCourse(line.orderItem.courseNumber),
                    ),
                    if (sentToKitchen) ...[
                      const SizedBox(width: 3),
                      const _KitchenIconCompact(),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 6),
              // Price
              Text(
                PriceFormatter.format(line.lineSubtotal),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: accent,
                ),
              ),
              // Actions popup
              PopupMenuButton<String>(
                icon: Icon(
                  Icons.more_vert,
                  size: 16,
                  color: PosDesignTokens.textMuted,
                ),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onSelected: (value) {
                  if (value == 'remove' && onRemove != null) {
                    onRemove!();
                  } else if (value.startsWith('course_') &&
                      onCourseChanged != null) {
                    final c = int.tryParse(value.substring(7));
                    if (c != null) onCourseChanged!(c);
                  }
                },
                itemBuilder: (_) => [
                  if (onRemove != null)
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline,
                            size: 16,
                            color: PosDesignTokens.offlineRed,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Supprimer',
                            style: TextStyle(
                              color: PosDesignTokens.offlineRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (onCourseChanged != null && !isLocked) ...[
                    const PopupMenuDivider(),
                    for (var c = CourseHelpers.minCourse;
                        c <= CourseHelpers.maxCourse;
                        c++)
                      PopupMenuItem(
                        value: 'course_$c',
                        child: Row(
                          children: [
                            Text(CourseHelpers.emojiForCourse(c)),
                            const SizedBox(width: 8),
                            Text(CourseHelpers.labelForCourse(c)),
                            if (line.orderItem.courseNumber == c) ...[
                              const Spacer(),
                              Icon(
                                Icons.check,
                                size: 14,
                                color: PosDesignTokens.primaryBlue,
                              ),
                            ],
                          ],
                        ),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _formatQty(double q) =>
      q == q.roundToDouble() ? '${q.toInt()}' : q.toStringAsFixed(1);
}

// ── Course chip compact ────────────────────────────────────────────────────────
class _CourseChipCompact extends StatelessWidget {
  const _CourseChipCompact({required this.label, required this.color, required this.tooltip});
  final String label;
  final Color color;
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
          ),
        ),
      ),
    );
  }
}

// ── Kitchen sent icon compact ───────────────────────────────────────────────────
class _KitchenIconCompact extends StatelessWidget {
  const _KitchenIconCompact();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.accentBlue : const Color(0xFF1D4ED8);
    return Tooltip(
      message: 'Envoyé en cuisine',
      child: Icon(
        Icons.soup_kitchen_rounded,
        size: 13,
        color: color,
      ),
    );
  }
}

// ── Compact Qty button ──────────────────────────────────────────────────────────
class _QtyBtnCompact extends StatelessWidget {
  const _QtyBtnCompact({required this.icon, required this.accent, this.onTap});
  final IconData icon;
  final Color accent;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onTap != null;
    return Material(
      color: isEnabled
          ? accent.withValues(alpha: 0.1)
          : PosDesignTokens.shellBackground,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          width: 22,
          height: 22,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isEnabled
                  ? accent.withValues(alpha: 0.3)
                  : PosDesignTokens.borderLight,
            ),
          ),
          child: Icon(
            icon,
            size: 12,
            color: isEnabled ? accent : PosDesignTokens.textMuted,
          ),
        ),
      ),
    );
  }
}
