import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('KitchenBilingualLabel concatène FR et AR', () {
    expect(
      KitchenBilingualLabel.productLine(
        name: 'Poulet Rôti',
        nameAr: 'دجاج محمر',
      ),
      'Poulet Rôti / دجاج محمر',
    );
  });

  test('KitchenBilingualLabel sans nameAr retourne le nom FR', () {
    expect(
      KitchenBilingualLabel.productLine(name: 'Café', nameAr: null),
      'Café',
    );
  });
}
