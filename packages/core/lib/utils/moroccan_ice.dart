/// Validation ICE marocain (Identifiant Commun de l'Entreprise).
abstract final class MoroccanIce {
  MoroccanIce._();

  static final RegExp _digitsOnly = RegExp(r'^\d{15}$');

  /// Normalise (espaces/tirets retirés).
  static String normalize(String raw) =>
      raw.replaceAll(RegExp(r'[\s\-]'), '');

  /// ICE valide : 15 chiffres (format courant Maroc).
  static bool isValid(String raw) {
    final normalized = normalize(raw);
    return _digitsOnly.hasMatch(normalized);
  }

  static String? validationMessage(String raw) {
    final normalized = normalize(raw);
    if (normalized.isEmpty) {
      return 'ICE obligatoire';
    }
    if (!_digitsOnly.hasMatch(normalized)) {
      return 'ICE invalide — 15 chiffres attendus';
    }
    return null;
  }
}
