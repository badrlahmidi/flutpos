import 'package:intl/date_symbol_data_local.dart';

/// Locale applicative pour dates et montants (Maroc / FR).
const String kAppLocale = 'fr_FR';

/// Charge les symboles de date [intl] pour [kAppLocale].
///
/// À appeler une fois au démarrage avant tout `DateFormat(..., kAppLocale)`.
Future<void> ensureAppLocaleDateFormatting() {
  return initializeDateFormatting(kAppLocale);
}
