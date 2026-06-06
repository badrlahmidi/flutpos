/// Préparation minimaliste du texte arabe pour imprimantes ESC/POS LTR.
///
/// Les imprimantes thermiques n'appliquent pas le BiDi natif : on inverse
/// l'ordre des mots pour une lecture RTL approximative en attendant le mode raster.
abstract final class EscPosArabicText {
  EscPosArabicText._();

  static final _arabic = RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]');

  static bool containsArabic(String text) => _arabic.hasMatch(text);

  /// Prépare une ligne pour impression ESC/POS (inversion visuelle RTL).
  static String prepareLine(String line) {
    if (!containsArabic(line)) {
      return line;
    }
    return line.split(' ').reversed.join(' ');
  }

  static List<String> prepareLines(Iterable<String> lines) {
    return [for (final line in lines) prepareLine(line)];
  }
}
