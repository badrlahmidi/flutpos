import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';

/// Notes cuisine prédéfinies — CRUD simple.
class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<KitchenNote> _notes = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final notes = await sl<ProductRepository>().listKitchenNotes();
    if (mounted) {
      setState(() {
        _notes = notes;
        _loading = false;
      });
    }
  }

  Future<void> _openEditor({KitchenNote? note}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => _NoteEditorDialog(note: note),
    );
    if (saved == true && mounted) {
      await _load();
    }
  }

  Future<void> _deleteNote(KitchenNote note) async {
    final ok = await confirmDelete(
      context,
      title: 'Supprimer la note',
      message: 'Supprimer « ${note.name} » ?',
    );
    if (!ok || !mounted) {
      return;
    }
    await sl<ProductRepository>().deleteKitchenNote(note.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BackofficePageHeader(
          title: 'Notes cuisine',
          subtitle: 'Notes prédéfinies pour les commandes',
          trailing: FilledButton.icon(
            style: BackofficePageHeader.compactFilledButtonStyle,
            onPressed: _loading ? null : () => _openEditor(),
            icon: const Icon(Icons.add),
            label: const Text('Note'),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.fromLTRB(AppSpacing.l, 0, AppSpacing.l, AppSpacing.l),
                  child: Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.35),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.outlineVariant),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: SizedBox.expand(
                      child: DataTable2(
                      columnSpacing: AppSpacing.m,
                      horizontalMargin: AppSpacing.m,
                      minWidth: 600,
                      headingRowColor: WidgetStateProperty.all(
                        theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.7),
                      ),
                      columns: const [
                        DataColumn2(label: Text('Nom FR'), size: ColumnSize.L),
                        DataColumn2(label: Text('Nom AR'), size: ColumnSize.L),
                        DataColumn2(label: Text('Ordre'), size: ColumnSize.S),
                        DataColumn2(label: Text('Actions'), size: ColumnSize.M),
                      ],
                      rows: [
                        for (final note in _notes)
                          DataRow(
                            cells: [
                              DataCell(Text(note.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                              DataCell(Text(
                                note.nameAr ?? '—',
                                textDirection: TextDirection.rtl,
                              )),
                              DataCell(Text('${note.sortOrder}')),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      color: theme.colorScheme.primary,
                                      onPressed: () => _openEditor(note: note),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline),
                                      color: theme.colorScheme.error,
                                      onPressed: () => _deleteNote(note),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

class _NoteEditorDialog extends StatefulWidget {
  const _NoteEditorDialog({this.note});

  final KitchenNote? note;

  @override
  State<_NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<_NoteEditorDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _orderCtrl;

  @override
  void initState() {
    super.initState();
    final n = widget.note;
    _nameCtrl = TextEditingController(text: n?.name ?? '');
    _nameArCtrl = TextEditingController(text: n?.nameAr ?? '');
    _orderCtrl = TextEditingController(text: '${n?.sortOrder ?? 0}');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      return;
    }
    final data = KitchenNoteFormData(
      name: name,
      nameAr: _nameArCtrl.text.trim().isEmpty ? null : _nameArCtrl.text.trim(),
      sortOrder: int.tryParse(_orderCtrl.text.trim()) ?? 0,
    );
    final repo = sl<ProductRepository>();
    if (widget.note == null) {
      await repo.createKitchenNote(data);
    } else {
      await repo.updateKitchenNote(widget.note!.id, data);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.note == null ? 'Nouvelle note' : 'Modifier note'),
      content: SizedBox(
        width: 440,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppSpacing.s),
              TextField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note cuisine (FR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.note_alt_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _nameArCtrl,
                decoration: const InputDecoration(
                  labelText: 'Note cuisine (AR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _orderCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ordre d\'affichage',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.sort),
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l, vertical: AppSpacing.m),
          ),
          onPressed: _save,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
