import 'dart:convert';

/// Sérialise les métadonnées d'audit en JSON (champ `AuditTrail.details`).
abstract final class AuditDetailsCodec {
  AuditDetailsCodec._();

  static String encode(Map<String, Object?> details) {
    return jsonEncode(details);
  }

  static Map<String, dynamic> decode(String? json) {
    if (json == null || json.isEmpty) {
      return {};
    }
    final parsed = jsonDecode(json);
    if (parsed is Map<String, dynamic>) {
      return parsed;
    }
    return {};
  }
}
