import 'base_validator.dart';

/// Validates CREATE_ORDER WebSocket payloads (security fix [HAUTE-N03]).
///
/// Expected payload shape:
/// ```json
/// {
///   "tableId": "uuid",
///   "waiterId": "uuid",
///   "guestCount": 2,
///   "orderType": "DINE_IN",
///   "orderId": "uuid?"  // optional client-generated id
/// }
/// ```
class CreateOrderValidator implements WsPayloadValidator {
  const CreateOrderValidator();

  static const _validOrderTypes = {
    'DINE_IN',
    'TAKEAWAY',
    'DELIVERY',
  };

  @override
  ValidationResult validate(Map<String, dynamic> payload) {
    final errors = <ValidationError>[];

    final tableId = payload['tableId'];
    if (!ValidationRules.isNonEmptyString(tableId)) {
      errors.add(const ValidationError(
        field: 'tableId',
        code: 'REQUIRED',
        message: 'tableId est requis',
      ));
    } else if (!ValidationRules.isUuid(tableId) && tableId != 'TAKEAWAY' && tableId != 'BAR') {
      // Table IDs can be UUIDs or special string keys for non-table orders.
      errors.add(const ValidationError(
        field: 'tableId',
        code: 'INVALID_FORMAT',
        message: 'tableId doit être un UUID valide',
      ));
    }

    final waiterId = payload['waiterId'];
    if (waiterId != null && !ValidationRules.isUuid(waiterId)) {
      errors.add(const ValidationError(
        field: 'waiterId',
        code: 'INVALID_FORMAT',
        message: 'waiterId doit être un UUID valide',
      ));
    }

    final guestCount = payload['guestCount'];
    if (guestCount != null && !ValidationRules.isPositiveInt(guestCount)) {
      errors.add(const ValidationError(
        field: 'guestCount',
        code: 'INVALID_VALUE',
        message: 'guestCount doit être un entier positif',
      ));
    }

    final orderType = payload['orderType'];
    if (orderType != null &&
        (orderType is! String || !_validOrderTypes.contains(orderType))) {
      errors.add(const ValidationError(
        field: 'orderType',
        code: 'INVALID_VALUE',
        message: 'orderType invalide (DINE_IN, TAKEAWAY, DELIVERY)',
      ));
    }

    final orderId = payload['orderId'];
    if (orderId != null && !ValidationRules.isUuid(orderId)) {
      errors.add(const ValidationError(
        field: 'orderId',
        code: 'INVALID_FORMAT',
        message: 'orderId doit être un UUID valide',
      ));
    }

    return errors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}