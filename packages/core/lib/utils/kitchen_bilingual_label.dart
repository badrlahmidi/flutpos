/// Format bilingue FR/AR pour tickets cuisine (doc `10_i18n_and_localization.md`).
abstract final class KitchenBilingualLabel {
  KitchenBilingualLabel._();

  static String productLine({
    required String name,
    String? nameAr,
  }) {
    final ar = nameAr?.trim();
    if (ar == null || ar.isEmpty) {
      return name;
    }
    return '$name / $ar';
  }

  static String modifierSegment({
    required String name,
    String? nameAr,
  }) {
    final ar = nameAr?.trim();
    if (ar == null || ar.isEmpty) {
      return name;
    }
    return '$name ($ar)';
  }

  static String modifierSummaryFromOptions(List<({String name, String? nameAr})> options) {
    if (options.isEmpty) {
      return '';
    }
    return options
        .map((o) => modifierSegment(name: o.name, nameAr: o.nameAr))
        .join(' · ');
  }
}
