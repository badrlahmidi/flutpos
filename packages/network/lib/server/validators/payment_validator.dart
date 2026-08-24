import 'base_validator.dart';

/// Validates PAYMENT WebSocket payloads (security fix [HAUTE-N03]).
///
/// Expected payload shape:
/// ```json
/// {
///   "orderId": "uuid",
///   "paymentMethod": "CASH" | "CARD" | "TICKET_RESTO" | ...,
///   "amount": 120.0,
///   "reference": "string?"
/// }
/// ```
class PaymentValidator implements WsPayloadValidator {
  const PaymentValidator({this.remainingDue});

  /// Optional remaining amount due on the order — when provided, the
  /// payment amount is validated to not exceed it.
  final double? remainingDue;

  static const _validMethods = {
    'CASH',
    'CARD',
    'TICKET_RESTO',
    'VOUCHER',
    'MEAL_VOUCHER',
    'BANK_TRANSFER',
    'ONLINE',
    'CREDIT',
  };

  @override
  ValidationResult validate(Map<String, dynamic> payload) {
    final errors = <ValidationError>[];

    final orderId = payload['orderId'];
    if (!ValidationRules.isUuid(orderId)) {
      errors.add(const ValidationError(
        field: 'orderId',
        code: 'REQUIRED',
        message: 'orderId (UUID) est requis',
      ));
    }

    final method = payload['paymentMethod'];
    if (method is! String || !_validMethods.contains(method)) {
      errors.add(const ValidationError(
        field: 'paymentMethod',
        code: 'INVALID_VALUE',
        message: 'paymentMethod invalide',
      ));
    }

    final amount = payload['amount'];
    if (!ValidationRules.isPositiveNumber(amount)) {
      errors.add(const ValidationError(
        field: 'amount',
        code: 'INVALID_VALUE',
        message: 'amount doit être un nombre > 0',
      ));
    } else if (remainingDue != null && amount > remainingDue!) {
      errors.add(ValidationError(
        field: 'amount',
        code: 'OUT_OF_RANGE',
        message: 'amount ne peut pas dépasser le restant dû ($remainingDue)',
      ));
    }

    final reference = payload['reference'];
    if (reference != null && reference is! String) {
      errors.add(const ValidationError(
        field: 'reference',
        code: 'INVALID_TYPE',
        message: 'reference doit être une chaîne',
      ));
    }

    return errors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}