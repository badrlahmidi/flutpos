import 'models/split_bill_result.dart';
import 'money_math.dart';

/// Divise un montant en parts égales ou montants personnalisés.
abstract final class SplitBillCalculator {
  SplitBillCalculator._();

  static SplitBillResult call({
    required double totalAmount,
    int? equalParts,
    List<double>? customAmounts,
  }) {
    final total = roundMoney(totalAmount);

    if (customAmounts != null && customAmounts.isNotEmpty) {
      return _splitCustom(total, customAmounts);
    }

    final parts = equalParts ?? 1;
    if (parts < 1) {
      throw ArgumentError.value(equalParts, 'equalParts', 'Doit être ≥ 1');
    }

    return _splitEqual(total, parts);
  }

  static SplitBillResult _splitEqual(double total, int parts) {
    final totalCents = toCents(total);
    final baseCents = totalCents ~/ parts;
    final extraCents = totalCents % parts;

    final portions = List<double>.generate(parts, (index) {
      final cents = baseCents + (index < extraCents ? 1 : 0);
      return fromCents(cents);
    });

    return SplitBillResult(
      mode: SplitBillMode.equalParts,
      totalAmount: total,
      portions: portions,
      allocatedAmount: total,
      remainingAmount: 0,
    );
  }

  static SplitBillResult _splitCustom(
    double total,
    List<double> customAmounts,
  ) {
    final portions = customAmounts.map(roundMoney).toList();
    final allocated = roundMoney(
      portions.fold<double>(0, (sum, value) => sum + value),
    );

    if (allocated > total) {
      throw ArgumentError(
        'La somme des parts ($allocated DH) dépasse le total ($total DH).',
      );
    }

    return SplitBillResult(
      mode: SplitBillMode.customAmounts,
      totalAmount: total,
      portions: portions,
      allocatedAmount: allocated,
      remainingAmount: roundMoney(total - allocated),
    );
  }
}
