import 'package:intl/intl.dart';

/// Formatage devise MAD — convention marocaine : `1 250,50 DH`.
abstract final class PriceFormatter {
  PriceFormatter._();

  static final NumberFormat _amount = NumberFormat('#,##0.00', 'fr_FR');

  static String format(double amount) => '${_amount.format(amount)} DH';
}
