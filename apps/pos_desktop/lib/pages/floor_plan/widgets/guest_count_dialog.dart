import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';

/// Saisie du nombre de couverts — boutons rapides 1-6+ au lieu de +/-.
Future<int?> showGuestCountDialog(
  BuildContext context, {
  required String tableName,
  required int capacity,
  int? defaultGuests,
}) {
  return showDialog<int>(
    context: context,
    builder: (ctx) => _GuestCountDialog(
      tableName: tableName,
      capacity: capacity,
      defaultGuests: defaultGuests,
    ),
  );
}

class _GuestCountDialog extends StatefulWidget {
  const _GuestCountDialog({
    required this.tableName,
    required this.capacity,
    this.defaultGuests,
  });

  final String tableName;
  final int capacity;
  final int? defaultGuests;

  @override
  State<_GuestCountDialog> createState() => _GuestCountDialogState();
}

class _GuestCountDialogState extends State<_GuestCountDialog> {
  int _guests = 2;

  @override
  void initState() {
    super.initState();
    final suggested = widget.defaultGuests ?? 2;
    _guests = suggested.clamp(1, widget.capacity);
  }

  void _open() => Navigator.of(context).pop(_guests);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    // Quick presets: 1..min(6, capacity), then custom stepper for more
    final presets = List.generate(
      widget.capacity.clamp(1, 6),
      (i) => i + 1,
    );
    final hasMore = widget.capacity > 6;

    return Dialog(
      backgroundColor: isDark ? const Color(0xFF1A1F2E) : scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: SizedBox(
          width: 380,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Header ───────────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: scheme.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.table_restaurant_rounded,
                      color: scheme.primary,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Table ${widget.tableName}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Capacité max : ${widget.capacity} pers.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: scheme.surfaceContainerHighest
                          .withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),

              // ── Label ────────────────────────────────────────────────────
              Text(
                'Nombre de couverts',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.m),

              // ── Quick preset grid ─────────────────────────────────────────
              GridView.count(
                crossAxisCount: presets.length <= 3 ? presets.length : 3,
                shrinkWrap: true,
                mainAxisSpacing: AppSpacing.s,
                crossAxisSpacing: AppSpacing.s,
                childAspectRatio: 1.4,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  for (final n in presets)
                    _GuestPresetTile(
                      count: n,
                      isSelected: _guests == n,
                      onTap: () {
                        setState(() => _guests = n);
                        // Auto-confirm on single tap
                        Future.delayed(
                          const Duration(milliseconds: 120),
                          _open,
                        );
                      },
                      isDark: isDark,
                      scheme: scheme,
                    ),
                  if (hasMore)
                    _GuestCustomTile(
                      isSelected: _guests > 6,
                      current: _guests > 6 ? _guests : null,
                      isDark: isDark,
                      scheme: scheme,
                      capacity: widget.capacity,
                      onChanged: (v) => setState(() => _guests = v),
                    ),
                ],
              ),

              // ── Selected display ──────────────────────────────────────────
              const SizedBox(height: AppSpacing.m),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.m,
                  vertical: AppSpacing.s,
                ),
                decoration: BoxDecoration(
                  color: scheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: scheme.primary.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.people_rounded,
                      color: scheme.primary,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$_guests couvert${_guests > 1 ? 's' : ''}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: scheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.m),

              // ── Action Buttons ────────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Annuler'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.s),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _open,
                      icon: const Icon(Icons.table_restaurant_rounded, size: 18),
                      label: const Text(
                        'OUVRIR LA TABLE',
                        style: TextStyle(fontWeight: FontWeight.w800),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
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

/// A quick-tap preset tile for guest count 1–6.
class _GuestPresetTile extends StatelessWidget {
  const _GuestPresetTile({
    required this.count,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
    required this.scheme,
  });

  final int count;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;
  final ColorScheme scheme;

  static const List<String> _icons = [
    '🧑', // 1
    '👫', // 2
    '👨‍👩‍👦', // 3
    '👨‍👩‍👧‍👦', // 4
    '🪑', // 5
    '🪑', // 6
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: isSelected
          ? scheme.primary
          : (isDark
              ? const Color(0xFF232937)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.6)),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected
                  ? scheme.primary
                  : scheme.outlineVariant.withValues(alpha: 0.5),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                count <= _icons.length ? _icons[count - 1] : '👥',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 4),
              Text(
                '$count',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: isSelected ? Colors.white : scheme.onSurface,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom stepper tile for counts > 6.
class _GuestCustomTile extends StatelessWidget {
  const _GuestCustomTile({
    required this.isSelected,
    required this.current,
    required this.isDark,
    required this.scheme,
    required this.capacity,
    required this.onChanged,
  });

  final bool isSelected;
  final int? current;
  final bool isDark;
  final ColorScheme scheme;
  final int capacity;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final value = current ?? 7;
    return Material(
      color: isSelected
          ? scheme.primary.withValues(alpha: 0.15)
          : (isDark
              ? const Color(0xFF232937)
              : scheme.surfaceContainerHighest.withValues(alpha: 0.6)),
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected
                ? scheme.primary.withValues(alpha: 0.7)
                : scheme.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _MiniBtn(
                  icon: Icons.remove,
                  onTap: value > 7
                      ? () => onChanged(value - 1)
                      : null,
                  scheme: scheme,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    '$value',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: isSelected ? scheme.primary : scheme.onSurface,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                ),
                _MiniBtn(
                  icon: Icons.add,
                  onTap: value < capacity
                      ? () => onChanged(value + 1)
                      : null,
                  scheme: scheme,
                ),
              ],
            ),
            Text(
              'pers.',
              style: theme.textTheme.labelSmall?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniBtn extends StatelessWidget {
  const _MiniBtn({required this.icon, required this.onTap, required this.scheme});
  final IconData icon;
  final VoidCallback? onTap;
  final ColorScheme scheme;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: scheme.primary.withValues(alpha: onTap != null ? 0.15 : 0.05),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 14,
          color: onTap != null ? scheme.primary : scheme.onSurfaceVariant,
        ),
      ),
    );
  }
}
