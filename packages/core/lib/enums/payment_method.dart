/// Mode de paiement (`Payments.paymentMethod`).
enum PaymentMethod {
  cash('CASH'),
  card('CARD'),
  tpe('TPE'),
  cheque('CHEQUE'),
  voucher('VOUCHER'),
  employeeMeal('EMPLOYEE_MEAL'),
  account('ACCOUNT');

  const PaymentMethod(this.dbValue);

  final String dbValue;

  String get label => switch (this) {
        PaymentMethod.cash => 'Espèces',
        PaymentMethod.card => 'Carte',
        PaymentMethod.tpe => 'TPE',
        PaymentMethod.cheque => 'Chèque',
        PaymentMethod.voucher => 'Voucher',
        PaymentMethod.employeeMeal => 'Repas employé',
        PaymentMethod.account => 'En compte',
      };

  static PaymentMethod? fromDb(String? value) {
    if (value == null) {
      return null;
    }
    for (final method in PaymentMethod.values) {
      if (method.dbValue == value) {
        return method;
      }
    }
    return null;
  }
}
