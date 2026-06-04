import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../widgets/atoms/pos_button.dart';

/// Formulaire nouvelle réservation (nom, téléphone, couverts, date/heure).
Future<ReservationFormData?> showReservationFormDialog(
  BuildContext context, {
  required List<RestaurantTable> tables,
  required List<Zone> zones,
  String? preselectedTableId,
}) {
  return showDialog<ReservationFormData>(
    context: context,
    builder: (ctx) => _ReservationFormDialog(
      tables: tables,
      zones: zones,
      preselectedTableId: preselectedTableId,
    ),
  );
}

class ReservationFormData {
  const ReservationFormData({
    required this.tableId,
    required this.customerName,
    this.customerPhone,
    required this.guestCount,
    required this.reservedAt,
    this.notes,
  });

  final String tableId;
  final String customerName;
  final String? customerPhone;
  final int guestCount;
  final DateTime reservedAt;
  final String? notes;
}

class _ReservationFormDialog extends StatefulWidget {
  const _ReservationFormDialog({
    required this.tables,
    required this.zones,
    this.preselectedTableId,
  });

  final List<RestaurantTable> tables;
  final List<Zone> zones;
  final String? preselectedTableId;

  @override
  State<_ReservationFormDialog> createState() => _ReservationFormDialogState();
}

class _ReservationFormDialogState extends State<_ReservationFormDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  String? _tableId;
  int _guests = 2;
  late DateTime _reservedAt;

  @override
  void initState() {
    super.initState();
    _tableId = widget.preselectedTableId ?? widget.tables.firstOrNull?.id;
    final now = DateTime.now();
    _reservedAt = DateTime(
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute + 30 - (now.minute % 15),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String _tableLabel(RestaurantTable table) {
    final zone = widget.zones.where((z) => z.id == table.zoneId).firstOrNull;
    return zone != null ? '${zone.name} · ${table.name}' : table.name;
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _reservedAt,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (date == null || !mounted) {
      return;
    }

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_reservedAt),
    );
    if (time == null || !mounted) {
      return;
    }

    setState(() {
      _reservedAt = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  void _submit() {
    final name = _nameController.text.trim();
    final tableId = _tableId;
    if (tableId == null || name.length < 2) {
      return;
    }

    Navigator.of(context).pop(
      ReservationFormData(
        tableId: tableId,
        customerName: name,
        customerPhone: _phoneController.text.trim().isEmpty
            ? null
            : _phoneController.text.trim(),
        guestCount: _guests,
        reservedAt: _reservedAt,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final selectedTable = widget.tables
        .where((t) => t.id == _tableId)
        .firstOrNull;
    final capacity = selectedTable?.capacity ?? 8;

    return AlertDialog(
      title: const Text('Nouvelle réservation'),
      content: SizedBox(
        width: 420,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _tableId,
                decoration: const InputDecoration(labelText: 'Table'),
                items: [
                  for (final table in widget.tables)
                    DropdownMenuItem(
                      value: table.id,
                      child: Text(_tableLabel(table)),
                    ),
                ],
                onChanged: (v) => setState(() => _tableId = v),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nom *'),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: AppSpacing.s),
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Téléphone',
                  hintText: '+212 6…',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  Text('Couverts', style: theme.textTheme.titleSmall),
                  const Spacer(),
                  IconButton(
                    onPressed:
                        _guests > 1 ? () => setState(() => _guests--) : null,
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Text('$_guests', style: theme.textTheme.titleLarge),
                  IconButton(
                    onPressed: _guests < capacity
                        ? () => setState(() => _guests++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.s),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Date et heure'),
                subtitle: Text(
                  _formatDateTime(_reservedAt),
                  style: theme.textTheme.titleMedium,
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.calendar_month),
                  onPressed: _pickDateTime,
                ),
              ),
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
                maxLines: 2,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'La table passera en orange 30 min avant l\'heure prévue.',
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        PosButton(
          label: 'RÉSERVER',
          onPressed: _submit,
        ),
      ],
    );
  }

  static String _formatDateTime(DateTime local) {
    final d = '${local.day.toString().padLeft(2, '0')}/'
        '${local.month.toString().padLeft(2, '0')}';
    final h = local.hour.toString().padLeft(2, '0');
    final m = local.minute.toString().padLeft(2, '0');
    return '$d — $h:$m';
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}
