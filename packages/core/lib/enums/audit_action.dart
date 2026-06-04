/// Actions journalisées dans [AuditTrail] (cf. `07_security_and_auth.md`).
enum AuditAction {
  voidItem('VOID_ITEM'),
  applyDiscount('APPLY_DISCOUNT'),
  reopenTicket('REOPEN_TICKET'),
  cashDrawerOpen('CASH_DRAWER_OPEN'),
  payOut('PAY_OUT'),
  payIn('PAY_IN'),
  closeSession('CLOSE_SESSION'),
  resetPin('RESET_PIN'),
  priceChange('PRICE_CHANGE'),
  loginFailed('LOGIN_FAILED');

  const AuditAction(this.dbValue);

  final String dbValue;

  static AuditAction? fromDb(String value) {
    for (final action in AuditAction.values) {
      if (action.dbValue == value) {
        return action;
      }
    }
    return null;
  }

  static bool isValid(String value) => fromDb(value) != null;
}
