import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';

/// Tuile table du plan de salle — statut dynamique avec glow premium.
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
    final isDark = theme.brightness == Brightness.dark;

    final _TableStyle style = _resolveStyle(snapshot.tileStatus, isDark, scheme);

    final timer = snapshot.occupiedDurationLabel;
    final total = snapshot.currentGrandTotal;
    final reservation = snapshot.upcomingReservation;
    final guestCount = snapshot.activeOrder?.guestCount;
    final elapsedMinutes = snapshot.occupiedDurationLabel != null
        ? _parseElapsedMinutes(snapshot.occupiedDurationLabel!)
        : null;
    final isLate = elapsedMinutes != null && elapsedMinutes >= 60;

    Widget tile = Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          decoration: BoxDecoration(
            color: style.background,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: style.borderColor,
              width: snapshot.tileStatus == FloorPlanTileStatus.occupied ? 2.5 : 1.5,
            ),
            boxShadow: [
              if (snapshot.tileStatus == FloorPlanTileStatus.occupied)
                BoxShadow(
                  color: style.borderColor.withValues(alpha: isLate ? 0.40 : 0.22),
                  blurRadius: isLate ? 18 : 10,
                  spreadRadius: isLate ? 2 : 0,
                ),
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Status badge
                  _StatusDot(status: snapshot.tileStatus, color: style.borderColor),
                  const SizedBox(height: 4),
                  // Table name
                  Text(
                    snapshot.table.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: style.foreground,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  // Capacity / guests
                  const SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.people_outline_rounded,
                        size: 12,
                        color: style.foreground.withValues(alpha: 0.6),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        guestCount != null
                            ? '$guestCount / ${snapshot.table.capacity}'
                            : '${snapshot.table.capacity} pl.',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: style.foreground.withValues(alpha: 0.65),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  // Timer badge
                  if (timer != null) ...[
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: style.borderColor.withValues(alpha: isLate ? 0.22 : 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isLate
                                ? Icons.warning_amber_rounded
                                : Icons.schedule_rounded,
                            size: 11,
                            color: style.borderColor,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            timer,
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: style.borderColor,
                              fontWeight: FontWeight.w800,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  // Reservation info
                  if (reservation != null && snapshot.activeOrder == null) ...[
                    const SizedBox(height: 4),
                    _ReservationBadge(
                      name: reservation.customerName,
                      time: _formatReservationTime(reservation.reservedAt),
                      foreground: style.foreground,
                    ),
                  ],
                  // Total
                  if (total != null && total > 0) ...[
                    const SizedBox(height: 4),
                    Text(
                      '${total.toStringAsFixed(0)} DH',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: style.foreground,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );

    // Pulsing glow animation for occupied tables
    if (snapshot.tileStatus == FloorPlanTileStatus.occupied && isLate) {
      tile = tile
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .boxShadow(
            duration: 1200.ms,
            begin: BoxShadow(
              color: style.borderColor.withValues(alpha: 0.18),
              blurRadius: 8,
            ),
            end: BoxShadow(
              color: style.borderColor.withValues(alpha: 0.45),
              blurRadius: 22,
              spreadRadius: 2,
            ),
          );
    }

    return tile;
  }

  _TableStyle _resolveStyle(
    FloorPlanTileStatus status,
    bool isDark,
    ColorScheme scheme,
  ) {
    switch (status) {
      case FloorPlanTileStatus.free:
        return _TableStyle(
          borderColor: isDark ? AppColors.accentGreen : const Color(0xFF16A34A),
          background: isDark
              ? const Color(0xFF1A2820)
              : const Color(0xFFF0FDF4),
          foreground: scheme.onSurface,
        );
      case FloorPlanTileStatus.occupied:
        return _TableStyle(
          borderColor: isDark ? AppColors.accentOrange : const Color(0xFFEA580C),
          background: isDark
              ? const Color(0xFF231A10)
              : const Color(0xFFFFF7ED),
          foreground: scheme.onSurface,
        );
      case FloorPlanTileStatus.reservedOrProforma:
        return _TableStyle(
          borderColor: isDark ? AppColors.accentPurple : const Color(0xFF6D28D9),
          background: isDark
              ? const Color(0xFF1D1630)
              : const Color(0xFFF5F3FF),
          foreground: scheme.onSurface,
        );
    }
  }

  static int _parseElapsedMinutes(String label) {
    // Expects format like "1h30" or "45min"
    final hourMatch = RegExp(r'(\d+)h').firstMatch(label);
    final minMatch = RegExp(r'(\d+)m').firstMatch(label);
    final hours = int.tryParse(hourMatch?.group(1) ?? '0') ?? 0;
    final mins = int.tryParse(minMatch?.group(1) ?? '0') ?? 0;
    return hours * 60 + mins;
  }

  static String _formatReservationTime(DateTime utc) {
    final local = utc.toLocal();
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }
}

class _TableStyle {
  const _TableStyle({
    required this.borderColor,
    required this.background,
    required this.foreground,
  });
  final Color borderColor;
  final Color background;
  final Color foreground;
}

/// Small pulsing dot indicating table availability.
class _StatusDot extends StatelessWidget {
  const _StatusDot({required this.status, required this.color});
  final FloorPlanTileStatus status;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final isPulsing = status == FloorPlanTileStatus.occupied;
    Widget dot = Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 5),
        ],
      ),
    );
    if (isPulsing) {
      dot = dot
          .animate(onPlay: (c) => c.repeat(reverse: true))
          .scale(
            begin: const Offset(0.85, 0.85),
            end: const Offset(1.3, 1.3),
            duration: 900.ms,
            curve: Curves.easeInOut,
          );
    }
    return dot;
  }
}

class _ReservationBadge extends StatelessWidget {
  const _ReservationBadge({
    required this.name,
    required this.time,
    required this.foreground,
  });
  final String name;
  final String time;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          name,
          style: theme.textTheme.labelSmall?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
        Text(
          '⏰ $time',
          style: theme.textTheme.labelSmall?.copyWith(
            color: foreground.withValues(alpha: 0.8),
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
