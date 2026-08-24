/// Standardised validation result for WebSocket payloads (security fix [HAUTE-N03]).
class ValidationResult {
  const ValidationResult.valid()
      : isValid = true,
        errors = const [];

  const ValidationResult.invalid(this.errors) : isValid = false;

  final bool isValid;
  final List<ValidationError> errors;

  /// Aggregates multiple validation results.
  factory ValidationResult.merge(List<ValidationResult> results) {
    final allErrors = [
      for (final r in results) ...r.errors,
    ];
    return allErrors.isEmpty
        ? const ValidationResult.valid()
        : ValidationResult.invalid(allErrors);
  }
}

/// A single field-level validation error.
class ValidationError {
  const ValidationError({
    required this.field,
    required this.message,
    this.code = 'INVALID',
  });

  /// Machine-readable error code (e.g. `REQUIRED`, `INVALID_FORMAT`).
  final String code;

  /// Human-readable message (FR).
  final String message;

  /// JSON path of the offending field (e.g. `items[0].quantity`).
  final String field;

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'field': field,
      };

  @override
  String toString() => 'ValidationError($field: $message)';
}

/// Strategy interface — one validator per WebSocket command type.
abstract class WsPayloadValidator {
  /// Validates a raw payload map and returns the result.
  ValidationResult validate(Map<String, dynamic> payload);
}

/// Shared validation primitives used by concrete validators.
final class ValidationRules {
  ValidationRules._();

  static final _uuidRegExp = RegExp(
    r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}'
    r'-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
  );

  static bool isUuid(String? value) =>
      value != null && _uuidRegExp.hasMatch(value);

  static bool isPositiveNumber(dynamic value) =>
      value is num && value > 0;

  static bool isNonNegativeNumber(dynamic value) =>
      value is num && value >= 0;

  static bool isNonEmptyString(dynamic value) =>
      value is String && value.trim().isNotEmpty;

  static bool isPositiveInt(dynamic value) =>
      value is int && value > 0;

  static bool isPositiveIntAllowZero(dynamic value) =>
      value is int && value >= 0;
}