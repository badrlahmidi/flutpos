import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  group('CalculateOrderTotal', () {
    test('sous-total avec modificateurs payants', () {
      final result = CalculateOrderTotal.call(
        lines: const [
          OrderLineInput(
            quantity: 2,
            unitPrice: 50,
            modifierExtrasTotal: 10,
            taxRate: 20,
          ),
        ],
      );

      expect(result.subtotal, 120);
      expect(result.modifiersTotal, 20);
      expect(result.discountAmount, 0);
      expect(result.taxAmount, 24);
      expect(result.totalDue, 120);
      expect(result.grandTotal, 144);
    });

    test('exclut les lignes VOIDED du sous-total', () {
      final result = CalculateOrderTotal.call(
        lines: const [
          OrderLineInput(quantity: 1, unitPrice: 100),
          OrderLineInput(
            quantity: 1,
            unitPrice: 50,
            status: 'VOIDED',
          ),
        ],
      );

      expect(result.subtotal, 100);
      expect(result.totalDue, 100);
    });

    test('remise pourcentage sur ticket multi-TVA', () {
      final result = CalculateOrderTotal.call(
        lines: const [
          OrderLineInput(quantity: 1, unitPrice: 100, taxRate: 20),
          OrderLineInput(quantity: 1, unitPrice: 200, taxRate: 10),
        ],
        discount: const OrderDiscountInput(
          type: DiscountType.percentage,
          value: 10,
        ),
      );

      expect(result.subtotal, 300);
      expect(result.discountAmount, 30);
      expect(result.taxAmount, 40);
      expect(result.totalDue, 270);
      expect(result.grandTotal, 310);
    });

    test('remise montant fixe plafonnée au sous-total', () {
      final result = CalculateOrderTotal.call(
        lines: const [
          OrderLineInput(quantity: 1, unitPrice: 80),
        ],
        discount: const OrderDiscountInput(
          type: DiscountType.fixedAmount,
          value: 150,
        ),
      );

      expect(result.discountAmount, 80);
      expect(result.totalDue, 0);
    });

    test('panier vide retourne des totaux à zéro', () {
      final result = CalculateOrderTotal.call(lines: const []);

      expect(result.subtotal, 0);
      expect(result.modifiersTotal, 0);
      expect(result.discountAmount, 0);
      expect(result.taxAmount, 0);
      expect(result.totalDue, 0);
    });

    test('sans remise quand discount null', () {
      final result = CalculateOrderTotal.call(
        lines: const [OrderLineInput(quantity: 3, unitPrice: 10)],
      );

      expect(result.subtotal, 30);
      expect(result.discountAmount, 0);
      expect(result.totalDue, 30);
    });
  });
}
