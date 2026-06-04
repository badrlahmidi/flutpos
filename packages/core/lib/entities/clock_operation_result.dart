/// Résultat d'une opération de pointage (entrée / sortie).
final class ClockOperationResult {
  const ClockOperationResult({
    required this.userName,
    required this.isClockIn,
    required this.recordedAt,
    this.openSince,
  });

  final String userName;
  final bool isClockIn;
  final DateTime recordedAt;

  /// Heure d'entrée si sortie enregistrée.
  final DateTime? openSince;
}
