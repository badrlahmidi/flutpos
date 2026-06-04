/// Type de remise globale sur commande (`Orders.discountType`).
enum DiscountType {
  percentage('PERCENTAGE'),
  fixedAmount('FIXED_AMOUNT');

  const DiscountType(this.dbValue);

  final String dbValue;

  static DiscountType? fromDb(String? value) {
    if (value == null) {
      return null;
    }
    for (final type in DiscountType.values) {
      if (type.dbValue == value) {
        return type;
      }
    }
    return null;
  }
}
