import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('TaxBreakdown', () {
    test('regroupe la TVA par taux', () {
      final lines = [
        const OrderLineInput(
          quantity: 1,
          unitPrice: 100,
          taxRate: 20,
        ),
        const OrderLineInput(
          quantity: 2,
          unitPrice: 50,
          taxRate: 10,
        ),
      ];

      final result = TaxBreakdown.fromLines(lines);

      expect(result.length, 2);
      expect(result.first.taxRate, 20);
      expect(result.first.taxableBase, 100);
      expect(result.first.taxAmount, 20);
      expect(result[1].taxRate, 10);
      expect(result[1].taxableBase, 100);
      expect(result[1].taxAmount, 10);
    });

    test('ignore les lignes annulées', () {
      final lines = [
        const OrderLineInput(
          quantity: 1,
          unitPrice: 80,
          taxRate: 20,
          status: 'VOIDED',
        ),
      ];

      expect(TaxBreakdown.fromLines(lines), isEmpty);
    });
  });
}
