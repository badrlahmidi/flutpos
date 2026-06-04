import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Tuile table du plan de salle (couleur selon statut).
class FloorPlanTableTile extends StatelessWidget {
  const FloorPlanTableTile({
    super.key,
    required this.snapshot,
    required this.onTap,
    this.onLongPress,
  });

  final FloorPlanTableSnapshot snapshot;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final Color background;
    final Color foreground;
    switch (snapshot.tileStatus) {
      case FloorPlanTileStatus.free:
        background = scheme.primaryContainer;
        foreground = scheme.onPrimaryContainer;
      case FloorPlanTileStatus.occupied:
        background = scheme.errorContainer;
        foreground = scheme.onErrorContainer;
      case FloorPlanTileStatus.reservedOrProforma:
        background = scheme.tertiaryContainer;
        foreground = scheme.onTertiaryContainer;
    }

    final timer = snapshot.occupiedDurationLabel;
    final total = snapshot.currentGrandTotal;
    final reservation = snapshot.upcomingReservation;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppSpacing.s),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSpacing.s),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: AppSpacing.minTouchTarget,
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.s),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  snapshot.table.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '${snapshot.table.capacity} pl.',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: foreground.withValues(alpha: 0.85),
                  ),
                ),
                if (timer != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    timer,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: foreground,
                    ),
                  ),
                ],
                if (reservation != null && snapshot.activeOrder == null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    reservation.customerName,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _formatReservationTime(reservation.reservedAt),
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: foreground.withValues(alpha: 0.9),
                    ),
                  ),
                ],
                if (total != null && total > 0) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${total.toStringAsFixed(0)} DH',
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  static String _formatReservationTime(DateTime utc) {
    final local = utc.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}
