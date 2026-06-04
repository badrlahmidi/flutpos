import 'models/change_result.dart';
import 'models/mad_denomination.dart';
import 'money_math.dart';

/// Calcule la monnaie à rendre et sa décomposition en coupes MAD.
abstract final class CalculateChange {
  CalculateChange._();

  static ChangeResult call({
    required double amountDue,
    required double amountReceived,
  }) {
    final due = roundMoney(amountDue);
    final received = roundMoney(amountReceived);
    final isFullyPaid = received >= due;
    final rawChange = isFullyPaid ? roundMoney(received - due) : 0.0;
    final changeAmount =
        isFullyPaid && rawChange > 0 ? roundToTenCentimes(rawChange) : rawChange;

    final breakdown = changeAmount > 0
        ? _decomposeChange(changeAmount)
        : <MadBreakdownEntry>[];

    return ChangeResult(
      amountDue: due,
      amountReceived: received,
      changeAmount: changeAmount,
      isFullyPaid: isFullyPaid,
      breakdown: breakdown,
    );
  }

  /// Décomposition gloutonne optimale (billets 200→0,10 DH).
  static List<MadBreakdownEntry> _decomposeChange(double changeAmount) {
    var remainingCents = toCents(changeAmount);
    final entries = <MadBreakdownEntry>[];

    for (final denomination in MadDenominations.all) {
      if (remainingCents <= 0) {
        break;
      }
      final count = remainingCents ~/ denomination.valueCents;
      if (count > 0) {
        entries.add(
          MadBreakdownEntry(denomination: denomination, count: count),
        );
        remainingCents -= count * denomination.valueCents;
      }
    }

    return entries;
  }
}
