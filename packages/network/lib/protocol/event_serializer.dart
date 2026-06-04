import 'dart:convert';

import 'event_envelope.dart';

/// Utilitaire de sérialisation JSON pour [EventEnvelope].
///
/// Ne lève jamais d'exception — les erreurs sont loggées via [print].
abstract final class EventSerializer {
  /// Encode une [EventEnvelope] en chaîne JSON.
  static String encode(EventEnvelope envelope) {
    try {
      return jsonEncode(envelope.toJson());
    } catch (error, stackTrace) {
      print('[EventSerializer.encode] Erreur: $error\n$stackTrace');
      return '{}';
    }
  }

  /// Décode une chaîne JSON en [EventEnvelope].
  ///
  /// Retourne `null` si le JSON est malformé ou incomplet.
  static EventEnvelope? decode(String json) {
    try {
      final decoded = jsonDecode(json);
      if (decoded is! Map<String, dynamic>) {
        print('[EventSerializer.decode] JSON racine invalide (attendu Map).');
        return null;
      }
      return EventEnvelope.fromJson(decoded);
    } catch (error, stackTrace) {
      print('[EventSerializer.decode] Erreur: $error\n$stackTrace');
      return null;
    }
  }
}
