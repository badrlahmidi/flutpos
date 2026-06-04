import '../database/app_database.dart';

/// Groupe de modificateurs avec ses options actives (catalogue).
class ModifierGroupWithOptions {
  const ModifierGroupWithOptions({
    required this.group,
    required this.options,
  });

  final ModifierGroup group;
  final List<ModifierOption> options;
}
