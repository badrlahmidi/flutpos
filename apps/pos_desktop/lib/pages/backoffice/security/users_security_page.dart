import 'package:core/core.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../navigation/app_session.dart';
import '../../../di/service_locator.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/access_level_stepper.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';

/// Module admin Utilisateurs & Sécurité RBAC (style Aronium).
class UsersSecurityPage extends StatefulWidget {
  const UsersSecurityPage({super.key});

  @override
  State<UsersSecurityPage> createState() => _UsersSecurityPageState();
}

class _UsersSecurityPageState extends State<UsersSecurityPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    sl<SecurityRepository>().ensureDefaultRules();
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: AppColors.scaffoldDark,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.l,
              AppSpacing.l,
              0,
            ),
            child: const BackofficePageHeader(
              title: 'Utilisateurs & Sécurité',
              subtitle: 'Niveaux d\'accès 0-9 et permissions opérationnelles',
            ),
          ),
          Material(
            color: scheme.surface,
            child: TabBar(
              controller: _tabs,
              tabs: const [
                Tab(icon: Icon(Icons.people_outline), text: 'Utilisateurs'),
                Tab(icon: Icon(Icons.shield_outlined), text: 'Sécurité'),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: TabBarView(
              controller: _tabs,
              children: const [
                _UsersTab(),
                _SecurityRulesTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UsersTab extends StatefulWidget {
  const _UsersTab();

  @override
  State<_UsersTab> createState() => _UsersTabState();
}

class _UsersTabState extends State<_UsersTab> {
  List<User> _users = [];
  bool _loading = true;
  bool _showInactive = false;
  User? _selected;
  bool _drawerOpen = false;
  User? _editing;

  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  String _role = 'WAITER';
  int _accessLevel = 0;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final users =
        await sl<UserRepository>().listUsers(includeInactive: _showInactive);
    if (mounted) {
      setState(() {
        _users = users;
        _loading = false;
        if (_selected != null &&
            !users.any((u) => u.id == _selected!.id)) {
          _selected = null;
        }
      });
    }
  }

  void _openEditor({User? user}) {
    setState(() {
      _editing = user;
      _drawerOpen = true;
      _nameController.text = user?.name ?? '';
      _pinController.clear();
      _role = user?.role ?? 'WAITER';
      _accessLevel = user?.accessLevel ?? 0;
      _isActive = user?.isActive ?? true;
    });
  }

  Future<void> _save() async {
    final actorId = AppSession.instance.user?.id;
    if (actorId == null) return;

    final repo = sl<UserRepository>();
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    if (_editing == null) {
      final pin = _pinController.text;
      if (pin.length < 4) {
        _toast('PIN minimum 4 chiffres');
        return;
      }
      await repo.createUser(
        actorUserId: actorId,
        name: name,
        role: _role,
        pin: pin,
        accessLevel: _accessLevel,
      );
    } else {
      await repo.updateUser(
        actorUserId: actorId,
        id: _editing!.id,
        name: name,
        role: _role,
        accessLevel: _accessLevel,
        isActive: _isActive,
      );
      if (_pinController.text.length >= 4) {
        await repo.resetPin(
          actorUserId: actorId,
          userId: _editing!.id,
          newPin: _pinController.text,
        );
      }
    }

    if (mounted) {
      setState(() => _drawerOpen = false);
      await _load();
    }
  }

  Future<void> _deleteSelected() async {
    if (_selected == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Désactiver l\'utilisateur'),
        content: Text('Désactiver « ${_selected!.name} » ?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Annuler')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Désactiver')),
        ],
      ),
    );
    if (ok != true || !mounted) return;
    final actorId = AppSession.instance.user?.id;
    if (actorId == null) return;
    await sl<UserRepository>().deleteUser(
      actorUserId: actorId,
      userId: _selected!.id,
    );
    await _load();
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    FilledButton.icon(
                      onPressed: () => _openEditor(),
                      icon: const Icon(Icons.person_add_outlined, size: 18),
                      label: const Text('Ajouter'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _selected == null
                          ? null
                          : () => _openEditor(user: _selected),
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('Modifier'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _selected == null ? null : _deleteSelected,
                      icon: const Icon(Icons.person_off_outlined, size: 18),
                      label: const Text('Désactiver'),
                    ),
                    OutlinedButton.icon(
                      onPressed: _load,
                      icon: const Icon(Icons.refresh, size: 18),
                      label: const Text('Actualiser'),
                    ),
                    FilterChip(
                      label: const Text('Afficher inactifs'),
                      selected: _showInactive,
                      onSelected: (v) {
                        setState(() => _showInactive = v);
                        _load();
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.m,
                        ),
                        child: DataTable2(
                          columnSpacing: 12,
                          horizontalMargin: 12,
                          minWidth: 700,
                          headingRowHeight: 44,
                          dataRowHeight: 48,
                          columns: const [
                            DataColumn2(label: Text('Nom'), size: ColumnSize.L),
                            DataColumn2(label: Text('Rôle'), size: ColumnSize.S),
                            DataColumn2(label: Text('Niveau'), size: ColumnSize.S),
                            DataColumn2(label: Text('Statut'), size: ColumnSize.S),
                          ],
                          rows: _users.map((u) {
                            final selected = _selected?.id == u.id;
                            return DataRow2(
                              selected: selected,
                              onTap: () => setState(() => _selected = u),
                              cells: [
                                DataCell(Text(u.name)),
                                DataCell(Text(u.role)),
                                DataCell(Text('${u.accessLevel}')),
                                DataCell(
                                  Icon(
                                    u.isActive
                                        ? Icons.check_circle
                                        : Icons.cancel_outlined,
                                    size: 18,
                                    color: u.isActive
                                        ? Colors.green
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ],
          ),
        ),
        if (_drawerOpen)
          SizedBox(
            width: 360,
            child: Material(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      _editing == null ? 'Nouvel utilisateur' : 'Modifier utilisateur',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nom affiché',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    DropdownButtonFormField<String>(
                      initialValue: _role,
                      decoration: const InputDecoration(
                        labelText: 'Rôle',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'ADMIN', child: Text('ADMIN')),
                        DropdownMenuItem(value: 'MANAGER', child: Text('MANAGER')),
                        DropdownMenuItem(value: 'CASHIER', child: Text('CASHIER')),
                        DropdownMenuItem(value: 'WAITER', child: Text('WAITER')),
                      ],
                      onChanged: (v) => setState(() => _role = v ?? 'WAITER'),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Niveau d\'accès (divise les permissions)',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    AccessLevelStepper(
                      value: _accessLevel,
                      onChanged: (v) => setState(() => _accessLevel = v),
                    ),
                    const SizedBox(height: AppSpacing.m),
                    TextField(
                      controller: _pinController,
                      decoration: InputDecoration(
                        labelText: _editing == null
                            ? 'Code PIN (4 chiffres)'
                            : 'Nouveau PIN (optionnel)',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: true,
                    ),
                    if (_editing != null) ...[
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Compte actif'),
                        value: _isActive,
                        onChanged: (v) => setState(() => _isActive = v),
                      ),
                    ],
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => setState(() => _drawerOpen = false),
                            child: const Text('Annuler'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: FilledButton(
                            onPressed: _save,
                            child: const Text('Enregistrer'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SecurityRulesTab extends StatefulWidget {
  const _SecurityRulesTab();

  @override
  State<_SecurityRulesTab> createState() => _SecurityRulesTabState();
}

class _SecurityRulesTabState extends State<_SecurityRulesTab> {
  List<SecurityRule> _rules = [];
  final Map<String, int> _draft = {};
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final rules = await sl<SecurityRepository>().listRules();
    if (mounted) {
      setState(() {
        _rules = rules;
        _draft
          ..clear()
          ..addEntries(
            rules.map((r) => MapEntry(r.operationKey, r.requiredLevel)),
          );
        _loading = false;
      });
    }
  }

  Future<void> _save() async {
    final actorId = AppSession.instance.user?.id;
    if (actorId == null) return;

    setState(() => _saving = true);
    await sl<SecurityRepository>().saveRules(
      _draft,
      actorUserId: actorId,
    );
    if (mounted) {
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Permissions enregistrées')),
      );
      await _load();
    }
  }

  Map<String, List<SecurityRule>> get _grouped {
    final map = <String, List<SecurityRule>>{};
    for (final rule in _rules) {
      map.putIfAbsent(rule.category, () => []).add(rule);
    }
    return map;
  }

  String _categoryLabel(String key) => switch (key) {
        'general' => 'Général',
        'sales' => 'Ventes (Caisse)',
        'backoffice' => 'Gestion Backoffice',
        'stock' => 'Stock',
        _ => key,
      };

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.m),
          child: Row(
            children: [
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save_outlined, size: 18),
                label: const Text('Enregistrer'),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: _load,
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text('Actualiser'),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.m),
            children: [
              for (final entry in _grouped.entries) ...[
                Text(
                  _categoryLabel(entry.key).toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        letterSpacing: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 8),
                Card(
                  child: Column(
                    children: entry.value.map((rule) {
                      final level = _draft[rule.operationKey] ?? rule.requiredLevel;
                      return ListTile(
                        title: Text(rule.label),
                        subtitle: rule.description != null
                            ? Text(rule.description!)
                            : null,
                        trailing: AccessLevelStepper(
                          compact: true,
                          value: level,
                          onChanged: (v) =>
                              setState(() => _draft[rule.operationKey] = v),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
