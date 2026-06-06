import 'package:core/core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_desktop/services/print/ticket_content_builder.dart';

import '../blocs/test_helpers.dart';

void main() {
  setUpAll(() async {
    await ensureAppLocaleDateFormatting();
  });

  test('buildKitchenTicket formate la date sans LocaleDataException', () {
    final order = testCompleteOrder();
    final orderWithLongId = CompleteOrder(
      order: testOrder(status: 'OPEN').copyWith(id: 'order-12345678'),
      waiter: order.waiter,
      items: order.items,
      payments: order.payments,
    );

    final lines = TicketContentBuilder.buildKitchenTicket(
      config: null,
      station: const PrintStation(
        id: 'kitchen',
        name: 'Cuisine',
        type: 'KITCHEN',
        isActive: true,
      ),
      order: orderWithLongId,
      lines: orderWithLongId.items,
    );

    expect(lines, isNotEmpty);
    expect(lines.any((line) => RegExp(r'\d{2}/\d{2}/\d{4} \d{2}:\d{2}').hasMatch(line)), isTrue);
  });
}
