import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('SplitBillCalculator', () {
    test('division égale en 3 sur 100 DH', () {
      final result = SplitBillCalculator.call(
        totalAmount: 100,
        equalParts: 3,
      );

      expect(result.mode, SplitBillMode.equalParts);
      expect(result.portions, [33.34, 33.33, 33.33]);
      expect(
        result.portions.fold<double>(0, (a, b) => a + b),
        closeTo(100, 0.001),
      );
      expect(result.isFullyAllocated, isTrue);
    });

    test('division égale en 3 sur 333.33 DH (scénario doc)', () {
      final result = SplitBillCalculator.call(
        totalAmount: 333.33,
        equalParts: 3,
      );

      expect(
        result.portions.fold<double>(0, (a, b) => a + b),
        closeTo(333.33, 0.001),
      );
      expect(result.portions.length, 3);
    });

    test('division en 1 part = total entier', () {
      final result = SplitBillCalculator.call(
        totalAmount: 47.5,
        equalParts: 1,
      );

      expect(result.portions, [47.5]);
      expect(result.remainingAmount, 0);
    });

    test('montants personnalisés partiels', () {
      final result = SplitBillCalculator.call(
        totalAmount: 320,
        customAmounts: [200, 100],
      );

      expect(result.mode, SplitBillMode.customAmounts);
      expect(result.allocatedAmount, 300);
      expect(result.remainingAmount, 20);
      expect(result.isFullyAllocated, isFalse);
    });

    test('montants personnalisés couvrant le total', () {
      final result = SplitBillCalculator.call(
        totalAmount: 320,
        customAmounts: [200, 120],
      );

      expect(result.allocatedAmount, 320);
      expect(result.remainingAmount, 0);
      expect(result.isFullyAllocated, isTrue);
    });

    test('rejette une somme de parts supérieure au total', () {
      expect(
        () => SplitBillCalculator.call(
          totalAmount: 100,
          customAmounts: [60, 50],
        ),
        throwsArgumentError,
      );
    });

    test('rejette equalParts < 1', () {
      expect(
        () => SplitBillCalculator.call(totalAmount: 100, equalParts: 0),
        throwsArgumentError,
      );
    });
  });
}
