// Helpers partagés pour les tests BLoC — données factices conformes aux
// classes Drift générées (`app_database.g.dart`).
import 'package:core/core.dart';

final testUser = User(
  id: 'user-1',
  name: 'Test Caissier',
  pinHash: 'fakehash',
  role: 'CASHIER',
  isActive: true,
  createdAt: DateTime(2026),
);

final testSession = CashSession(
  id: 'session-1',
  cashierId: 'user-1',
  openedAt: DateTime(2026),
  openingBalance: 500,
  status: 'OPEN',
);

Order testOrder({String status = 'OPEN', String? tableId}) => Order(
      id: 'order-1',
      sessionId: 'session-1',
      waiterId: 'user-1',
      orderType: 'DINE_IN',
      source: 'MANUAL',
      status: status,
      guestCount: 1,
      createdAt: DateTime(2026),
      tableId: tableId,
    );

final testProduct = Product(
  id: 'prod-1',
  categoryId: 'cat-1',
  name: 'Café Noir',
  priceDineIn: 15.0,
  priceTakeaway: 12.0,
  priceDelivery: 18.0,
  cost: 5.0,
  taxRate: 20.0,
  trackStock: false,
  currentStock: 0,
  productType: 'standard',
  sortOrder: 0,
  isActive: true,
);

OrderItem testOrderItem({
  String status = 'ACTIVE',
  bool isFired = false,
  int courseNumber = 1,
}) =>
    OrderItem(
      id: 'item-1',
      orderId: 'order-1',
      productId: 'prod-1',
      quantity: 1,
      unitPrice: 15.0,
      taxRate: 20.0,
      courseNumber: courseNumber,
      isFired: isFired,
      status: status,
      createdAt: DateTime(2026),
    );

final testPayment = Payment(
  id: 'pay-1',
  orderId: 'order-1',
  paymentMethod: 'CASH',
  amount: 15.0,
  paidAt: DateTime(2026),
);

CompleteOrder testCompleteOrder({
  String orderStatus = 'OPEN',
  List<OrderItemWithProduct>? items,
  List<Payment>? payments,
}) =>
    CompleteOrder(
      order: testOrder(status: orderStatus),
      waiter: testUser,
      items: items ??
          [
            OrderItemWithProduct(
              orderItem: testOrderItem(),
              product: testProduct,
              modifiers: const [],
              modifierOptions: const [],
            ),
          ],
      payments: payments ?? const [],
    );

final testZone = Zone(id: 'z1', name: 'Salle', sortOrder: 0);

RestaurantTable testTable({String status = 'FREE'}) => RestaurantTable(
      id: 't1',
      zoneId: 'z1',
      name: 'Table 1',
      capacity: 4,
      status: status,
      posX: 0,
      posY: 0,
    );

List<FloorPlanZoneSnapshot> testFloorPlan() => [
      FloorPlanZoneSnapshot(
        zone: testZone,
        tables: [FloorPlanTableSnapshot(table: testTable())],
      ),
    ];
