import 'models/order_line_input.dart';
import 'money_math.dart';

/// Ligne de décomposition TVA par taux (Maroc : 20 %, 10 %, 7 %…).
class TaxRateSummary {
  const TaxRateSummary({
    required this.taxRate,
    required this.taxableBase,
    required this.taxAmount,
  });

  final double taxRate;
  final double taxableBase;
  final double taxAmount;
}

/// Regroupe la TVA par taux figé sur les lignes actives.
abstract final class TaxBreakdown {
  TaxBreakdown._();

  static List<TaxRateSummary> fromLines(List<OrderLineInput> lines) {
    final active = lines.where((l) => !l.isVoided);
    final byRate = <double, _Accumulator>{};

    for (final line in active) {
      final rate = line.taxRate;
      final acc = byRate.putIfAbsent(rate, () => _Accumulator());
      acc.base += line.lineSubtotal;
      acc.tax += line.lineSubtotal * (rate / 100);
    }

    final rates = byRate.keys.toList()..sort((a, b) => b.compareTo(a));
    return [
      for (final rate in rates)
        TaxRateSummary(
          taxRate: rate,
          taxableBase: roundMoney(byRate[rate]!.base),
          taxAmount: roundMoney(byRate[rate]!.tax),
        ),
    ];
  }
}

class _Accumulator {
  double base = 0;
  double tax = 0;
}
