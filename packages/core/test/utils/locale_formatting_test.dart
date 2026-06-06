import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:test/test.dart';

void main() {
  test('ensureAppLocaleDateFormatting permet DateFormat fr_FR', () async {
    await ensureAppLocaleDateFormatting();

    final formatted = DateFormat('dd/MM/yyyy HH:mm', kAppLocale).format(
      DateTime(2026, 6, 5, 14, 30),
    );

    expect(formatted, '05/06/2026 14:30');
  });
}
