import 'base_validator.dart';

/// Validates ADD_ITEMS WebSocket payloads (security fix [HAUTE-N03]).
///
/// Expected payload shape:
/// ```json
/// {
///   "orderId": "uuid",
///   "productId": "uuid",
///   "quantity": 2.0,
///   "courseNumber": 1,
///   "customNotes": "string?"
/// }
/// ```
class AddItemsValidator implements WsPayloadValidator {
  const AddItemsValidator();

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

    final productId = payload['productId'];
    if (!ValidationRules.isUuid(productId)) {
      errors.add(const ValidationError(
        field: 'productId',
        code: 'REQUIRED',
        message: 'productId (UUID) est requis',
      ));
    }

    final quantity = payload['quantity'];
    if (!ValidationRules.isPositiveNumber(quantity)) {
      errors.add(const ValidationError(
        field: 'quantity',
        code: 'INVALID_VALUE',
        message: 'quantity doit être un nombre > 0',
      ));
    }

    final courseNumber = payload['courseNumber'];
    if (courseNumber != null && !ValidationRules.isPositiveInt(courseNumber)) {
      errors.add(const ValidationError(
        field: 'courseNumber',
        code: 'INVALID_VALUE',
        message: 'courseNumber doit être un entier positif',
      ));
    }

    final customNotes = payload['customNotes'];
    if (customNotes != null && customNotes is! String) {
      errors.add(const ValidationError(
        field: 'customNotes',
        code: 'INVALID_TYPE',
        message: 'customNotes doit être une chaîne',
      ));
    }

    final orderItemId = payload['orderItemId'];
    if (orderItemId != null && !ValidationRules.isUuid(orderItemId)) {
      errors.add(const ValidationError(
        field: 'orderItemId',
        code: 'INVALID_FORMAT',
        message: 'orderItemId doit être un UUID valide',
      ));
    }

    return errors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.invalid(errors);
  }
}