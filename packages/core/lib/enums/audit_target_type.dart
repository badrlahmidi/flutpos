/// Type d'entité ciblée par une entrée [AuditTrail].
enum AuditTargetType {
  order('ORDER'),
  orderItem('ORDER_ITEM'),
  cashSession('CASH_SESSION'),
  product('PRODUCT'),
  user('USER'),
  securityRule('SECURITY_RULE');

  const AuditTargetType(this.dbValue);

  final String dbValue;

  static AuditTargetType? fromDb(String value) {
    for (final type in AuditTargetType.values) {
      if (type.dbValue == value) {
        return type;
      }
    }
    return null;
  }

  static bool isValid(String value) => fromDb(value) != null;
}
