import 'base_validator.dart';

/// Validates APPLY_DISCOUNT WebSocket payloads (security fix [HAUTE-N03]).
///
/// Expected payload shape:
/// ```json
/// {
///   "orderId": "uuid",
///   "discountType": "PERCENT" | "FIXED",
///   "discountValue": 10.0,
///   "discountReason": "string?"
/// }
/// ```
class ApplyDiscountValidator implements WsPayloadValidator {
  const ApplyDiscountValidator({this.orderTotal});

  /// Optional order total — when provided, percentage / fixed value
  /// ceilings are validated against it.
  final double? orderTotal;

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

    final discountType = payload['discountType'];
    if (discountType is! String ||
        (discountType != 'PERCENT' && discountType != 'FIXED')) {
      errors.add(const ValidationError(
        field: 'discountType',
        code: 'INVALID_VALUE',
        message: 'discountType doit être PERCENT ou FIXED',
      ));
    }

    final discountValue = payload['discountValue'];
    if (!ValidationRules.isNonNegativeNumber(discountValue)) {
      errors.add(const ValidationError(
        field: 'discountValue',
        code: 'INVALID_VALUE',
        message: 'discountValue doit être un nombre >= 0',
      ));
    } else if (discountType == 'PERCENT' && discountValue > 100) {
      errors.add(const ValidationError(
        field: 'discountValue',
        code: 'OUT_OF_RANGE',
        message: 'discountValue (PERCENT) ne peut pas dépasser 100',
      ));
    } else if (discountType == 'FIXED' &&
        orderTotal != null &&
        discountValue > orderTotal!) {
      errors.add(ValidationError(
        field: 'discountValue',
        code: 'OUT_OF_RANGE',
        message:
            'discountValue (FIXED) ne peut pas dépasser le total ($orderTotal)',
      ));
    }

    final reason = payload['discountReason'];
    if (reason != null && reason is! String) {
      errors.add(const ValidationError(
        field: 'discountReason',
        code: 'INVALID_TYPE',
        message: 'discountReason doit être une chaîne',
      ));
    }

    return errors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}