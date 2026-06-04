import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('money_math', () {
    test('roundMoney arrondit à 2 décimales', () {
      expect(roundMoney(10.005), 10.01);
      expect(roundMoney(10.004), 10.0);
    });

    test('toCents / fromCents', () {
      expect(toCents(47), 4700);
      expect(fromCents(4700), 47);
    });
  });
}
