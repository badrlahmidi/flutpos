import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';

/// Gestion CRUD des modificateurs (groupes + options).
class ModifiersPage extends StatefulWidget {
  const ModifiersPage({super.key});

  @override
  State<ModifiersPage> createState() => _ModifiersPageState();
}

class _ModifiersPageState extends State<ModifiersPage> {
  List<ModifierGroupWithOptions> _groups = const [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final groups = await sl<ProductRepository>().listAllModifierGroupsWithOptions();
    if (mounted) {
      setState(() {
        _groups = groups;
        _loading = false;
      });
    }
  }

  Future<void> _editGroup({ModifierGroup? group}) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ModifierGroupDialog(group: group),
    );
    if (saved == true && mounted) {
      await _load();
    }
  }

  Future<void> _editOption({
    required String groupId,
    ModifierOption? option,
  }) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ModifierOptionDialog(
        groupId: groupId,
        option: option,
      ),
    );
    if (saved == true && mounted) {
      await _load();
    }
  }

  Future<void> _deleteGroup(ModifierGroup group) async {
    final ok = await confirmDelete(
      context,
      title: 'Supprimer le groupe',
      message: 'Supprimer « ${group.name} » et toutes ses options ?',
    );
    if (!ok || !mounted) {
      return;
    }
    await sl<ProductRepository>().deleteModifierGroup(group.id);
    await _load();
  }

  Future<void> _deleteOption(ModifierOption option) async {
    final ok = await confirmDelete(
      context,
      title: 'Désactiver l\'option',
      message: 'Désactiver « ${option.name} » ?',
    );
    if (!ok || !mounted) {
      return;
    }
    await sl<ProductRepository>().deleteModifierOption(option.id);
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BackofficePageHeader(
          title: 'Modificateurs',
          subtitle: 'Groupes et options',
          trailing: FilledButton.icon(
            style: BackofficePageHeader.compactFilledButtonStyle,
            onPressed: _loading ? null : () => _editGroup(),
            icon: const Icon(Icons.add),
            label: const Text('Groupe'),
          ),
        ),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.l),
                  children: [
                    for (final entry in _groups) ...[
                      Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.surface.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: theme.colorScheme.outlineVariant),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(AppSpacing.m),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      entry.group.name,
                                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: 'Modifier groupe',
                                    icon: const Icon(Icons.edit_outlined),
                                    color: theme.colorScheme.primary,
                                    onPressed: () =>
                                        _editGroup(group: entry.group),
                                  ),
                                  IconButton(
                                    tooltip: 'Supprimer groupe',
                                    icon: const Icon(Icons.delete_outline),
                                    color: theme.colorScheme.error,
                                    onPressed: () =>
                                        _deleteGroup(entry.group),
                                  ),
                                  const SizedBox(width: AppSpacing.s),
                                  FilledButton.tonalIcon(
                                    onPressed: () => _editOption(
                                      groupId: entry.group.id,
                                    ),
                                    icon: const Icon(Icons.add, size: 18),
                                    label: const Text('Option'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.s),
                              DataTable2(
                                columnSpacing: AppSpacing.m,
                                horizontalMargin: AppSpacing.s,
                                minWidth: 600,
                                headingRowHeight: 40,
                                dataRowHeight: 48,
                                headingRowColor: WidgetStateProperty.all(
                                  theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                                ),
                                columns: const [
                                  DataColumn2(label: Text('Option')),
                                  DataColumn2(label: Text('Nom AR')),
                                  DataColumn2(label: Text('Extra')),
                                  DataColumn2(label: Text('Actif')),
                                  DataColumn2(label: Text('Actions')),
                                ],
                                rows: [
                                  for (final option in entry.options)
                                    DataRow(
                                      cells: [
                                        DataCell(Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                        DataCell(Text(option.nameAr ?? '—')),
                                        DataCell(Text(
                                          PriceFormatter.format(option.priceExtra),
                                          style: TextStyle(
                                            color: option.priceExtra > 0
                                                ? theme.colorScheme.secondary
                                                : theme.colorScheme.outline,
                                            fontWeight: option.priceExtra > 0
                                                ? FontWeight.bold
                                                : FontWeight.normal,
                                          ),
                                        )),
                                        DataCell(Icon(
                                          option.isActive
                                              ? Icons.check_circle
                                              : Icons.remove_circle_outline,
                                          size: 18,
                                          color: option.isActive
                                              ? theme.colorScheme.primary
                                              : theme.colorScheme.outline,
                                        )),
                                        DataCell(
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.edit_outlined),
                                                color: theme.colorScheme.primary,
                                                onPressed: () => _editOption(
                                                  groupId: entry.group.id,
                                                  option: option,
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.delete_outline),
                                                color: theme.colorScheme.error,
                                                onPressed: () =>
                                                    _deleteOption(option),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.m),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _ModifierGroupDialog extends StatefulWidget {
  const _ModifierGroupDialog({this.group});

  final ModifierGroup? group;

  @override
  State<_ModifierGroupDialog> createState() => _ModifierGroupDialogState();
}

class _ModifierGroupDialogState extends State<_ModifierGroupDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late bool _multiple;
  late bool _required;

  @override
  void initState() {
    super.initState();
    final g = widget.group;
    _nameCtrl = TextEditingController(text: g?.name ?? '');
    _nameArCtrl = TextEditingController(text: g?.nameAr ?? '');
    _multiple = g?.isMultipleChoice ?? true;
    _required = g?.isRequired ?? false;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      return;
    }
    final data = ModifierGroupFormData(
      name: name,
      nameAr: _nameArCtrl.text.trim().isEmpty ? null : _nameArCtrl.text.trim(),
      isMultipleChoice: _multiple,
      isRequired: _required,
    );
    final repo = sl<ProductRepository>();
    if (widget.group == null) {
      await repo.createModifierGroup(data);
    } else {
      await repo.updateModifierGroup(widget.group!.id, data);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.group == null ? 'Nouveau groupe' : 'Modifier groupe'),
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
                  labelText: 'Nom du groupe (FR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tune),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _nameArCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom du groupe (AR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSpacing.m),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Choix multiple'),
                subtitle: const Text('Permet de cocher plusieurs options'),
                value: _multiple,
                onChanged: (v) => setState(() => _multiple = v),
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Sélection obligatoire'),
                subtitle: const Text('Le serveur doit choisir au moins une option'),
                value: _required,
                onChanged: (v) => setState(() => _required = v),
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

class _ModifierOptionDialog extends StatefulWidget {
  const _ModifierOptionDialog({
    required this.groupId,
    this.option,
  });

  final String groupId;
  final ModifierOption? option;

  @override
  State<_ModifierOptionDialog> createState() => _ModifierOptionDialogState();
}

class _ModifierOptionDialogState extends State<_ModifierOptionDialog> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _nameArCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _orderCtrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    final o = widget.option;
    _nameCtrl = TextEditingController(text: o?.name ?? '');
    _nameArCtrl = TextEditingController(text: o?.nameAr ?? '');
    _priceCtrl = TextEditingController(text: o != null ? '${o.priceExtra}' : '0');
    _orderCtrl = TextEditingController(text: '${o?.sortOrder ?? 0}');
    _isActive = o?.isActive ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArCtrl.dispose();
    _priceCtrl.dispose();
    _orderCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final name = _nameCtrl.text.trim();
    if (name.isEmpty) {
      return;
    }
    final data = ModifierOptionFormData(
      modifierGroupId: widget.groupId,
      name: name,
      nameAr: _nameArCtrl.text.trim().isEmpty ? null : _nameArCtrl.text.trim(),
      priceExtra: double.tryParse(_priceCtrl.text.replaceAll(',', '.')) ?? 0,
      sortOrder: int.tryParse(_orderCtrl.text.trim()) ?? 0,
      isActive: _isActive,
    );
    final repo = sl<ProductRepository>();
    if (widget.option == null) {
      await repo.createModifierOption(data);
    } else {
      await repo.updateModifierOption(widget.option!.id, data);
    }
    if (mounted) {
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      title: Text(widget.option == null ? 'Nouvelle option' : 'Modifier option'),
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
                  labelText: 'Nom de l\'option (FR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tune),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _nameArCtrl,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'option (AR)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.translate),
                ),
                textDirection: TextDirection.rtl,
              ),
              const SizedBox(height: AppSpacing.m),
              TextField(
                controller: _priceCtrl,
                decoration: const InputDecoration(
                  labelText: 'Prix supplémentaire (DH)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
              const SizedBox(height: AppSpacing.m),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Option active'),
                subtitle: const Text('Afficher dans les modificateurs de produits'),
                value: _isActive,
                onChanged: (v) => setState(() => _isActive = v),
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
