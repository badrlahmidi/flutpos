import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('regroupe 4 cafés identiques', () {
    const product = Product(
      id: 'p1',
      categoryId: 'c1',
      name: 'Café',
      priceDineIn: 15,
      taxRate: 20,
      sortOrder: 0,
      isActive: true,
      trackStock: false,
      currentStock: 0,
      productType: 'standard',
    );

    OrderItem _item(String id, double qty) => OrderItem(
          id: id,
          orderId: 'o1',
          productId: 'p1',
          quantity: qty,
          unitPrice: 15,
          taxRate: 20,
          courseNumber: 1,
          isFired: true,
          status: 'PENDING',
          createdAt: DateTime.utc(2026, 1, 1),
        );

    final lines = [
      OrderItemWithProduct(
        orderItem: _item('i1', 1),
        product: product,
        modifiers: const [],
      ),
      OrderItemWithProduct(
        orderItem: _item('i2', 1),
        product: product,
        modifiers: const [],
      ),
      OrderItemWithProduct(
        orderItem: _item('i3', 1),
        product: product,
        modifiers: const [],
      ),
      OrderItemWithProduct(
        orderItem: _item('i4', 1),
        product: product,
        modifiers: const [],
      ),
    ];

    final grouped = KitchenTicketLineGrouper.group(lines);
    expect(grouped.length, 1);
    expect(grouped.first.quantity, 4);
    expect(grouped.first.sourceItemIds.length, 4);
  });

  test('ne regroupe pas si modificateurs différents', () {
    const product = Product(
      id: 'p1',
      categoryId: 'c1',
      name: 'Burger',
      priceDineIn: 75,
      taxRate: 20,
      sortOrder: 0,
      isActive: true,
      trackStock: false,
      currentStock: 0,
      productType: 'standard',
    );

    final base = OrderItem(
      id: 'i1',
      orderId: 'o1',
      productId: 'p1',
      quantity: 1,
      unitPrice: 75,
      taxRate: 20,
      courseNumber: 1,
      isFired: true,
      status: 'PENDING',
      createdAt: DateTime.utc(2026, 1, 1),
    );

    final lines = [
      OrderItemWithProduct(
        orderItem: base,
        product: product,
        modifiers: [
          OrderItemModifier(
            id: 'm1',
            orderItemId: 'i1',
            modifierOptionId: 'opt-a',
            priceExtra: 0,
          ),
        ],
        modifierOptions: [
          ModifierOption(
            id: 'opt-a',
            modifierGroupId: 'g1',
            name: 'Sans oignon',
            priceExtra: 0,
            sortOrder: 0,
            isActive: true,
          ),
        ],
      ),
      OrderItemWithProduct(
        orderItem: base.copyWith(id: 'i2'),
        product: product,
        modifiers: [
          OrderItemModifier(
            id: 'm2',
            orderItemId: 'i2',
            modifierOptionId: 'opt-b',
            priceExtra: 10,
          ),
        ],
        modifierOptions: [
          ModifierOption(
            id: 'opt-b',
            modifierGroupId: 'g1',
            name: 'Fromage',
            priceExtra: 10,
            sortOrder: 1,
            isActive: true,
          ),
        ],
      ),
    ];

    expect(KitchenTicketLineGrouper.group(lines).length, 2);
  });
}
