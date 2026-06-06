import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../di/service_locator.dart';
import '../../../theme/app_spacing.dart';

/// Page des paramètres de l'application avec configuration de l'établissement
/// et des obligations fiscales marocaines (DGI / ICE / IF / RC).
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _formKey = GlobalKey<FormState>();

  bool _isLoading = true;
  bool _isSaving = false;

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _iceController = TextEditingController();
  final _rcController = TextEditingController();
  final _ifController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    try {
      final config = await sl<PrintRepository>().getRestaurantConfig();
      if (config != null) {
        _nameController.text = config.name;
        _addressController.text = config.address ?? '';
        _phoneController.text = config.phone ?? '';
        _iceController.text = config.ice ?? '';
        _rcController.text = config.rc ?? '';
        _ifController.text = config.identifiantFiscal ?? '';
      }
    } catch (_) {
      // Ignoré ou géré en silence
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _iceController.dispose();
    _rcController.dispose();
    _ifController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isSaving = true);

    try {
      await sl<PrintRepository>().updateRestaurantConfig(
        name: _nameController.text.trim(),
        address: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
        phone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
        ice: _iceController.text.trim().isEmpty ? null : _iceController.text.trim(),
        rc: _rcController.text.trim().isEmpty ? null : _rcController.text.trim(),
        identifiantFiscal: _ifController.text.trim().isEmpty ? null : _ifController.text.trim(),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Configuration de l\'établissement enregistrée avec succès'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'enregistrement : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.l),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.settings_outlined, size: 36, color: scheme.primary),
              const SizedBox(width: AppSpacing.s),
              Text(
                'Paramètres de l\'Application',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.l),
          Card(
            child: ListTile(
              leading: const Icon(Icons.shield_outlined),
              title: const Text('Utilisateurs & Sécurité'),
              subtitle: const Text(
                'Gérer les comptes, niveaux d\'accès 0-9 et permissions',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => context.go('/backoffice/security'),
            ),
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Colonne de Gauche : Paramètres Système & Infos
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    _buildSystemCard(theme, scheme),
                    const SizedBox(height: AppSpacing.m),
                    _buildVersionCard(theme, scheme),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.l),
              // Colonne de Droite : Formulaire d'Établissement & DGI
              Expanded(
                flex: 6,
                child: _buildFiscalFormCard(theme, scheme),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemCard(ThemeData theme, ColorScheme scheme) {
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Configuration Système',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(height: AppSpacing.l),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.dark_mode_outlined, color: scheme.primary),
              title: const Text('Thème sombre'),
              subtitle: const Text('Activé par défaut (Optimal pour la caisse)'),
              trailing: Switch(
                value: true,
                onChanged: null,
                activeColor: scheme.primary,
              ),
            ),
            const Divider(height: AppSpacing.s),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.print_outlined, color: scheme.primary),
              title: const Text('Réseau d\'impression'),
              subtitle: const Text('Routage automatique par station de cuisine'),
              trailing: Icon(Icons.chevron_right, color: scheme.onSurfaceVariant),
              onTap: () => _showPrintStationsManager(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVersionCard(ThemeData theme, ColorScheme scheme) {
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: scheme.primary, size: 28),
            const SizedBox(width: AppSpacing.m),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ritagestion POS Desktop',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Version 1.0.0 (Stable)',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiscalFormCard(ThemeData theme, ColorScheme scheme) {
    return Card(
      elevation: 0,
      color: scheme.surfaceContainerLow.withValues(alpha: 0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Obligations Fiscales & En-tête',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Conformité DGI (Direction Générale des Impôts)',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  Icon(Icons.gavel_outlined, color: scheme.primary),
                ],
              ),
              const Divider(height: AppSpacing.l),
              // Nom Établissement
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'établissement / Raison Sociale *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.storefront_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Le nom de l\'établissement est obligatoire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppSpacing.m),
              // Adresse
              TextFormField(
                controller: _addressController,
                maxLines: 2,
                decoration: const InputDecoration(
                  labelText: 'Adresse physique (imprimée sur le ticket)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.location_on_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              // Téléphone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Téléphone de contact',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              // ICE
              TextFormField(
                controller: _iceController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'[\d\s\-]')),
                ],
                decoration: const InputDecoration(
                  labelText: 'Identifiant Commun de l\'Entreprise (ICE) *',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.business_outlined),
                  helperText: 'Requis pour la conformité de facturation (15 chiffres)',
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'L\'ICE de l\'établissement est obligatoire';
                  }
                  final msg = MoroccanIce.validationMessage(val);
                  return msg;
                },
              ),
              const SizedBox(height: AppSpacing.m),
              Row(
                children: [
                  // Identifiant Fiscal (IF)
                  Expanded(
                    child: TextFormField(
                      controller: _ifController,
                      decoration: const InputDecoration(
                        labelText: 'N° Identifiant Fiscal (IF)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.m),
                  // Registre du commerce (RC)
                  Expanded(
                    child: TextFormField(
                      controller: _rcController,
                      decoration: const InputDecoration(
                        labelText: 'N° Registre de Commerce (RC)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.app_registration_outlined),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.l),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _isSaving ? null : _saveConfig,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: const Text(
                    'Enregistrer la Configuration',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showPrintStationsManager(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const _PrintStationsManagerDialog(),
    );
  }
}

class _PrintStationsManagerDialog extends StatefulWidget {
  const _PrintStationsManagerDialog();

  @override
  State<_PrintStationsManagerDialog> createState() => _PrintStationsManagerDialogState();
}

class _PrintStationsManagerDialogState extends State<_PrintStationsManagerDialog> {
  List<PrintStation> _stations = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStations();
  }

  Future<void> _loadStations() async {
    setState(() => _loading = true);
    try {
      final list = await sl<PrintRepository>().getAllPrintStations();
      setState(() {
        _stations = list;
        _loading = false;
      });
    } catch (_) {
      setState(() => _loading = false);
    }
  }

  Future<void> _onToggleActive(PrintStation station, bool value) async {
    final updated = PrintStation(
      id: station.id,
      name: station.name,
      ipAddress: station.ipAddress,
      type: station.type,
      isActive: value,
    );
    await sl<PrintRepository>().savePrintStation(updated);
    _loadStations();
  }

  Future<void> _onDelete(PrintStation station) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Supprimer la station ?'),
        content: Text('Voulez-vous vraiment supprimer la station "${station.name}" ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
            ),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await sl<PrintRepository>().deletePrintStation(station.id);
      _loadStations();
    }
  }

  Future<void> _onEdit(PrintStation? station) async {
    final saved = await showDialog<bool>(
      context: context,
      builder: (ctx) => _PrintStationEditorDialog(station: station),
    );
    if (saved == true) {
      _loadStations();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Container(
        width: 600,
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(Icons.print_outlined, size: 28, color: scheme.primary),
                const SizedBox(width: AppSpacing.m),
                Text(
                  'Stations d\'Impression Réseau',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const Divider(height: AppSpacing.l),
            if (_loading)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_stations.isEmpty)
              SizedBox(
                height: 200,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.print_disabled_outlined, size: 48, color: scheme.onSurfaceVariant),
                      const SizedBox(height: AppSpacing.s),
                      Text(
                        'Aucune station configurée',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 400),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _stations.length,
                  itemBuilder: (context, index) {
                    final s = _stations[index];
                    return Card(
                      elevation: 0,
                      color: scheme.surfaceContainerHigh,
                      margin: const EdgeInsets.only(bottom: AppSpacing.s),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: scheme.outlineVariant),
                      ),
                      child: ListTile(
                        title: Text(
                          s.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          s.ipAddress ?? 'Pas d\'adresse IP',
                          style: TextStyle(fontFamily: 'Courier', color: scheme.onSurfaceVariant),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Switch(
                              value: s.isActive,
                              onChanged: (val) => _onToggleActive(s, val),
                            ),
                            IconButton(
                              icon: Icon(Icons.edit_outlined, color: scheme.primary),
                              onPressed: () => _onEdit(s),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete_outline, color: scheme.error),
                              onPressed: () => _onDelete(s),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            const SizedBox(height: AppSpacing.m),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Fermer'),
                ),
                ElevatedButton.icon(
                  onPressed: () => _onEdit(null),
                  icon: const Icon(Icons.add),
                  label: const Text('Ajouter une station'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: scheme.primary,
                    foregroundColor: scheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PrintStationEditorDialog extends StatefulWidget {
  const _PrintStationEditorDialog({this.station});

  final PrintStation? station;

  @override
  State<_PrintStationEditorDialog> createState() => _PrintStationEditorDialogState();
}

class _PrintStationEditorDialogState extends State<_PrintStationEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _ipController = TextEditingController();
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.station != null) {
      _nameController.text = widget.station!.name;
      _ipController.text = widget.station!.ipAddress ?? '';
      _isActive = widget.station!.isActive;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ipController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final station = PrintStation(
      id: widget.station?.id ?? newUuid(),
      name: _nameController.text.trim(),
      ipAddress: _ipController.text.trim().isEmpty ? null : _ipController.text.trim(),
      type: widget.station?.type ?? 'THERMAL_PRINTER',
      isActive: _isActive,
    );

    try {
      await sl<PrintRepository>().savePrintStation(station);
      if (mounted) {
        Navigator.of(context).pop(true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.station == null ? 'Nouvelle Station' : 'Modifier la Station'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nom de la station *',
                border: OutlineInputBorder(),
              ),
              validator: (val) {
                if (val == null || val.trim().isEmpty) {
                  return 'Nom obligatoire';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.m),
            TextFormField(
              controller: _ipController,
              decoration: const InputDecoration(
                labelText: 'Adresse IP Réseau (ex: 192.168.1.100)',
                border: OutlineInputBorder(),
                helperText: 'Laisser vide pour tester en local/console',
              ),
              validator: (val) {
                if (val != null && val.trim().isNotEmpty) {
                  final ipPattern = RegExp(r'^(\d{1,3}\.){3}\d{1,3}$');
                  if (!ipPattern.hasMatch(val.trim())) {
                    return 'Adresse IP invalide';
                  }
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.m),
            SwitchListTile(
              title: const Text('Station active'),
              value: _isActive,
              onChanged: (val) => setState(() => _isActive = val),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: _onSave,
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}
