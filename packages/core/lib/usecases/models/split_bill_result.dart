import '../money_math.dart';

/// Mode de division du ticket.
enum SplitBillMode {
  equalParts,
  customAmounts,
}

/// Résultat d'un partage de note.
class SplitBillResult {
  const SplitBillResult({
    required this.mode,
    required this.totalAmount,
    required this.portions,
    required this.allocatedAmount,
    required this.remainingAmount,
  });

  final SplitBillMode mode;
  final double totalAmount;
  final List<double> portions;
  final double allocatedAmount;
  final double remainingAmount;

  bool get isFullyAllocated => roundMoney(remainingAmount) <= 0;
}
