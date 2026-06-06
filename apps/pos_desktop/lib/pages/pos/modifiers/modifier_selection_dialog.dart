import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../../theme/app_spacing.dart';
import '../../../utils/price_formatter.dart';
import '../../../widgets/atoms/auto_direction_text_field.dart';
import '../../../widgets/widgets.dart';

/// Résultat du modal modificateurs (options + note libre cuisine).
class ModifierSelectionResult {
  const ModifierSelectionResult({
    required this.options,
    this.customNotes,
  });

  final List<ModifierOption> options;
  final String? customNotes;
}

/// Affiche le modal de sélection des modificateurs.
Future<ModifierSelectionResult?> showModifierSelectionDialog({
  required BuildContext context,
  required Product product,
  required List<ModifierGroupWithOptions> groups,
}) {
  return showDialog<ModifierSelectionResult>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _ModifierSelectionDialog(
      product: product,
      groups: groups,
    ),
  );
}

class _ModifierSelectionDialog extends StatefulWidget {
  const _ModifierSelectionDialog({
    required this.product,
    required this.groups,
  });

  final Product product;
  final List<ModifierGroupWithOptions> groups;

  @override
  State<_ModifierSelectionDialog> createState() =>
      _ModifierSelectionDialogState();
}

class _ModifierSelectionDialogState extends State<_ModifierSelectionDialog> {
  final Map<String, Set<String>> _selectedByGroup = {};
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _isValid {
    for (final group in widget.groups) {
      if (!group.group.isRequired) {
        continue;
      }
      final selected = _selectedByGroup[group.group.id];
      if (selected == null || selected.isEmpty) {
        return false;
      }
    }
    return true;
  }

  List<ModifierOption> get _selectedOptions {
    final options = <ModifierOption>[];
    for (final group in widget.groups) {
      final ids = _selectedByGroup[group.group.id] ?? {};
      for (final option in group.options) {
        if (ids.contains(option.id)) {
          options.add(option);
        }
      }
    }
    return options;
  }

  void _toggleOption(ModifierGroupWithOptions group, ModifierOption option) {
    setState(() {
      final groupId = group.group.id;
      final current = _selectedByGroup.putIfAbsent(groupId, () => {});

      if (group.group.isMultipleChoice) {
        if (current.contains(option.id)) {
          current.remove(option.id);
        } else {
          current.add(option.id);
        }
      } else {
        _selectedByGroup[groupId] = {option.id};
      }
    });
  }

  bool _isOptionSelected(String groupId, String optionId) {
    return _selectedByGroup[groupId]?.contains(optionId) ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.l),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 720,
          maxHeight: size.height * 0.9,
        ),
        child: Material(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(AppSpacing.m),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: AppSpacing.minTouchTarget + AppSpacing.s,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.m,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.product.name,
                          style: theme.textTheme.headlineLarge?.copyWith(
                            fontSize: 24,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Annuler',
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(AppSpacing.m),
                  itemCount: widget.groups.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.l),
                  itemBuilder: (context, index) {
                    return _ModifierGroupSection(
                      groupWithOptions: widget.groups[index],
                      isSelected: _isOptionSelected,
                      onOptionTap: _toggleOption,
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: AutoDirectionTextField(
                  controller: _notesController,
                  decoration: const InputDecoration(
                    labelText: 'Note cuisine (FR / AR)',
                    hintText: 'Ex: بدون بصل',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.m),
                child: Row(
                  children: [
                    Expanded(
                      child: PosButton(
                        label: 'Annuler',
                        variant: PosButtonVariant.outlined,
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.m),
                    Expanded(
                      flex: 2,
                      child: PosButton(
                        label: 'Ajouter au panier',
                        icon: Icons.add_shopping_cart,
                        expand: true,
                        onPressed: _isValid
                            ? () {
                                final notes = _notesController.text.trim();
                                Navigator.of(context).pop(
                                  ModifierSelectionResult(
                                    options: _selectedOptions,
                                    customNotes:
                                        notes.isEmpty ? null : notes,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModifierGroupSection extends StatelessWidget {
  const _ModifierGroupSection({
    required this.groupWithOptions,
    required this.isSelected,
    required this.onOptionTap,
  });

  final ModifierGroupWithOptions groupWithOptions;
  final bool Function(String groupId, String optionId) isSelected;
  final void Function(ModifierGroupWithOptions group, ModifierOption option)
      onOptionTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final group = groupWithOptions.group;
    final requiredLabel = group.isRequired ? 'Obligatoire' : 'Optionnel';
    final choiceLabel =
        group.isMultipleChoice ? 'Plusieurs choix' : 'Un seul choix';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                group.name,
                style: theme.textTheme.titleMedium,
              ),
            ),
            Text(
              '$requiredLabel · $choiceLabel',
              style: theme.textTheme.labelSmall,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.m),
        Wrap(
          spacing: AppSpacing.s,
          runSpacing: AppSpacing.s,
          children: [
            for (final option in groupWithOptions.options)
              _ModifierOptionTile(
                option: option,
                selected: isSelected(group.id, option.id),
                onTap: () => onOptionTap(groupWithOptions, option),
              ),
          ],
        ),
      ],
    );
  }
}

class _ModifierOptionTile extends StatelessWidget {
  const _ModifierOptionTile({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final ModifierOption option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasExtra = option.priceExtra > 0;

    final background =
        selected ? scheme.primaryContainer : scheme.surfaceContainerHighest;
    final foreground =
        selected ? scheme.onPrimaryContainer : scheme.onSurface;

    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppSpacing.s),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            minWidth: 140,
            minHeight: AppSpacing.minTouchTarget,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.m,
              vertical: AppSpacing.s,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  option.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: foreground,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (hasExtra) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '+${PriceFormatter.format(option.priceExtra)}',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: foreground,
                      fontWeight: FontWeight.w700,
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
}
