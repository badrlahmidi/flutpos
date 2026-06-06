import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Dialogue de sélection de période double-calendrier au style Aronium.
/// Retourne une [DateTimeRange] ou null si l'utilisateur annule.
class PeriodPickerDialog extends StatefulWidget {
  const PeriodPickerDialog({
    super.key,
    required this.initialStart,
    required this.initialEnd,
  });

  final DateTime initialStart;
  final DateTime initialEnd;

  static Future<DateTimeRange?> show(
    BuildContext context, {
    required DateTime initialStart,
    required DateTime initialEnd,
  }) {
    return showDialog<DateTimeRange>(
      context: context,
      barrierColor: Colors.black54,
      builder: (_) => PeriodPickerDialog(
        initialStart: initialStart,
        initialEnd: initialEnd,
      ),
    );
  }

  @override
  State<PeriodPickerDialog> createState() => _PeriodPickerDialogState();
}

class _PeriodPickerDialogState extends State<PeriodPickerDialog> {
  late DateTime _start;
  late DateTime _end;

  static final _fmt = DateFormat('EEE d MMM yyyy', 'fr_FR');

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  void _applyQuickFilter(_QuickPeriod period) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    setState(() {
      switch (period) {
        case _QuickPeriod.today:
          _start = today;
          _end = today;
        case _QuickPeriod.yesterday:
          _start = today.subtract(const Duration(days: 1));
          _end = today.subtract(const Duration(days: 1));
        case _QuickPeriod.thisWeek:
          final weekday = today.weekday; // Mon=1
          _start = today.subtract(Duration(days: weekday - 1));
          _end = today;
        case _QuickPeriod.lastWeek:
          final weekday = today.weekday;
          final startOfThisWeek = today.subtract(Duration(days: weekday - 1));
          _start = startOfThisWeek.subtract(const Duration(days: 7));
          _end = startOfThisWeek.subtract(const Duration(days: 1));
        case _QuickPeriod.thisMonth:
          _start = DateTime(now.year, now.month, 1);
          _end = today;
        case _QuickPeriod.lastMonth:
          final firstOfThisMonth = DateTime(now.year, now.month, 1);
          _end = firstOfThisMonth.subtract(const Duration(days: 1));
          _start = DateTime(_end.year, _end.month, 1);
        case _QuickPeriod.thisYear:
          _start = DateTime(now.year, 1, 1);
          _end = today;
        case _QuickPeriod.lastYear:
          _start = DateTime(now.year - 1, 1, 1);
          _end = DateTime(now.year - 1, 12, 31);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: SizedBox(
        width: 720,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.date_range_outlined,
                      color: scheme.onPrimaryContainer),
                  const SizedBox(width: 12),
                  Text(
                    'Sélectionner une période',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: scheme.onPrimaryContainer,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ── Body ────────────────────────────────────────────────────────
            Flexible(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Quick filters column
                      SizedBox(
                        width: 160,
                        child: _QuickFiltersColumn(
                          onSelected: _applyQuickFilter,
                        ),
                      ),
                      const SizedBox(width: 24),
                      // Calendars
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _CalendarPicker(
                                    label: 'Date de début',
                                    selectedDate: _start,
                                    onDateSelected: (d) =>
                                        setState(() => _start = d),
                                    firstDate: DateTime(2020),
                                    lastDate: _end,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: _CalendarPicker(
                                    label: 'Date de fin',
                                    selectedDate: _end,
                                    onDateSelected: (d) =>
                                        setState(() => _end = d),
                                    firstDate: _start,
                                    lastDate: DateTime.now(),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Selected range summary
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: scheme.surfaceContainerHighest,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.calendar_today_outlined,
                                      size: 16,
                                      color: scheme.onSurfaceVariant),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_fmt.format(_start)}  →  ${_fmt.format(_end)}',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ── Actions ─────────────────────────────────────────────────────
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: () => Navigator.of(context).pop(
                      DateTimeRange(start: _start, end: _end),
                    ),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Appliquer'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Quick Filters ────────────────────────────────────────────────────────────

enum _QuickPeriod {
  today('Aujourd\'hui'),
  yesterday('Hier'),
  thisWeek('Cette semaine'),
  lastWeek('Semaine dernière'),
  thisMonth('Ce mois-ci'),
  lastMonth('Mois dernier'),
  thisYear('Cette année'),
  lastYear('Année dernière');

  const _QuickPeriod(this.label);
  final String label;
}

class _QuickFiltersColumn extends StatelessWidget {
  const _QuickFiltersColumn({required this.onSelected});

  final void Function(_QuickPeriod) onSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Raccourcis',
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        ..._QuickPeriod.values.map(
          (p) => InkWell(
            onTap: () => onSelected(p),
            borderRadius: BorderRadius.circular(6),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: Text(p.label, style: theme.textTheme.bodySmall),
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Calendar Picker ──────────────────────────────────────────────────────────

class _CalendarPicker extends StatelessWidget {
  const _CalendarPicker({
    required this.label,
    required this.selectedDate,
    required this.onDateSelected,
    required this.firstDate,
    required this.lastDate,
  });

  final String label;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onDateSelected;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: scheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        CalendarDatePicker(
          initialDate: selectedDate,
          firstDate: firstDate,
          lastDate: lastDate,
          onDateChanged: onDateSelected,
        ),
      ],
    );
  }
}
