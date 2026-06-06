import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

/// En-tête standard des pages backoffice (titre + actions).
class BackofficePageHeader extends StatelessWidget {
  const BackofficePageHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.searchHint,
    this.onSearchChanged,
    this.actions = const [],
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final String? searchHint;
  final ValueChanged<String>? onSearchChanged;
  final List<Widget> actions;
  final Widget? trailing;

  /// Style compact pour [FilledButton] dans une [Row] (évite w=Infinity).
  static ButtonStyle get compactFilledButtonStyle => FilledButton.styleFrom(
        minimumSize: const Size(0, 48),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasActions = actions.isNotEmpty || trailing != null;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.l,
        AppSpacing.m,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: theme.textTheme.headlineLarge),
                    if (subtitle != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (hasActions)
                Theme(
                  data: theme.copyWith(
                    filledButtonTheme: FilledButtonThemeData(
                      style: compactFilledButtonStyle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < actions.length; i++) ...[
                        if (i > 0) const SizedBox(width: AppSpacing.s),
                        actions[i],
                      ],
                      if (trailing != null) ...[
                        if (actions.isNotEmpty)
                          const SizedBox(width: AppSpacing.s),
                        trailing!,
                      ],
                    ],
                  ),
                ),
            ],
          ),
          if (onSearchChanged != null) ...[
            const SizedBox(height: AppSpacing.m),
            TextField(
              decoration: InputDecoration(
                hintText: searchHint ?? 'Rechercher…',
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: onSearchChanged,
            ),
          ],
        ],
      ),
    );
  }
}

Future<bool> confirmDelete(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Annuler'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Supprimer'),
        ),
      ],
    ),
  );
  return result == true;
}

Color? parseColorHex(String? hex) {
  if (hex == null || hex.isEmpty) {
    return null;
  }
  final value = hex.replaceFirst('#', '');
  if (value.length == 6) {
    return Color(int.parse('FF$value', radix: 16));
  }
  return null;
}

String colorToHex(Color color) {
  return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

const categoryColorPresets = <Color>[
  Color(0xFF6C8EFF),
  Color(0xFF4ADE80),
  Color(0xFFFB923C),
  Color(0xFFA78BFA),
  Color(0xFFEC4899),
  Color(0xFFEAB308),
];
