import 'mad_denomination.dart';

/// Résultat du calcul de monnaie à rendre.
class ChangeResult {
  const ChangeResult({
    required this.amountDue,
    required this.amountReceived,
    required this.changeAmount,
    required this.isFullyPaid,
    required this.breakdown,
  });

  final double amountDue;
  final double amountReceived;
  final double changeAmount;
  final bool isFullyPaid;
  final List<MadBreakdownEntry> breakdown;
}
