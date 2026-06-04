import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('CalculateChange', () {
    test('monnaie à rendre 47 DH = 2×20 + 1×5 + 1×2', () {
      final result = CalculateChange.call(
        amountDue: 320,
        amountReceived: 367,
      );

      expect(result.isFullyPaid, isTrue);
      expect(result.changeAmount, 47);

      final byValue = {
        for (final e in result.breakdown) e.denomination.valueDh: e.count,
      };
      expect(byValue[20], 2);
      expect(byValue[5], 1);
      expect(byValue[2], 1);
      expect(
        result.breakdown.fold<double>(0, (s, e) => s + e.subtotal),
        47,
      );
    });

    test('paiement mixte : reçu supérieur au dû', () {
      final result = CalculateChange.call(
        amountDue: 320,
        amountReceived: 500,
      );

      expect(result.changeAmount, 180);
      expect(result.isFullyPaid, isTrue);
    });

    test('paiement insuffisant : pas de monnaie', () {
      final result = CalculateChange.call(
        amountDue: 320,
        amountReceived: 300,
      );

      expect(result.isFullyPaid, isFalse);
      expect(result.changeAmount, 0);
      expect(result.breakdown, isEmpty);
    });

    test('paiement exact : monnaie nulle', () {
      final result = CalculateChange.call(
        amountDue: 125.5,
        amountReceived: 125.5,
      );

      expect(result.changeAmount, 0);
      expect(result.breakdown, isEmpty);
    });

    test('décomposition avec pièces 0,50 et 0,10', () {
      final result = CalculateChange.call(
        amountDue: 10,
        amountReceived: 10.8,
      );

      expect(result.changeAmount, 0.8);
      final total = result.breakdown.fold<double>(
        0,
        (sum, entry) => sum + entry.subtotal,
      );
      expect(total, closeTo(0.8, 0.001));
    });

    test('arrondi au dixième de dirham (pièce 0,10)', () {
      final result = CalculateChange.call(
        amountDue: 33.33,
        amountReceived: 50,
      );

      expect(result.changeAmount, 16.7);
      expect(
        result.breakdown.fold<double>(0, (s, e) => s + e.subtotal),
        closeTo(16.7, 0.001),
      );
    });
  });
}
