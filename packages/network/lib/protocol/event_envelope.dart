import 'package:uuid/uuid.dart';

const _uuid = Uuid();

/// Enveloppe JSON standard pour tous les messages WebSocket RitajPOS.
///
/// Structure conforme à `docs/architecture/03_network_protocol.md` §4.
class EventEnvelope {
  /// Crée une enveloppe avec [messageId] et [timestamp] auto-générés.
  factory EventEnvelope.create({
    required String action,
    required String deviceId,
    Map<String, dynamic>? payload,
  }) {
    return EventEnvelope(
      messageId: _uuid.v4(),
      action: action,
      timestamp: DateTime.now().toUtc().toIso8601String(),
      deviceId: deviceId,
      payload: payload ?? const {},
    );
  }

  /// Désérialise une enveloppe depuis un [Map] JSON.
  factory EventEnvelope.fromJson(Map<String, dynamic> json) {
    final rawPayload = json['payload'];
    return EventEnvelope(
      messageId: json['messageId'] as String,
      action: json['action'] as String,
      timestamp: json['timestamp'] as String,
      deviceId: json['deviceId'] as String,
      payload: rawPayload is Map<String, dynamic>
          ? rawPayload
          : rawPayload is Map
              ? Map<String, dynamic>.from(rawPayload)
              : const {},
    );
  }

  const EventEnvelope({
    required this.messageId,
    required this.action,
    required this.timestamp,
    required this.deviceId,
    required this.payload,
  });

  /// Identifiant unique du message (UUID v4) — idempotence réseau.
  final String messageId;

  /// Nom de l'action métier ([WsAction]).
  final String action;

  /// Horodatage ISO-8601 UTC.
  final String timestamp;

  /// Identifiant du terminal émetteur.
  final String deviceId;

  /// Données métier spécifiques à l'action.
  final Map<String, dynamic> payload;

  /// Sérialise l'enveloppe en [Map] JSON.
  Map<String, dynamic> toJson() => {
        'messageId': messageId,
        'action': action,
        'timestamp': timestamp,
        'deviceId': deviceId,
        'payload': payload,
      };

  EventEnvelope copyWith({
    String? messageId,
    String? action,
    String? timestamp,
    String? deviceId,
    Map<String, dynamic>? payload,
  }) {
    return EventEnvelope(
      messageId: messageId ?? this.messageId,
      action: action ?? this.action,
      timestamp: timestamp ?? this.timestamp,
      deviceId: deviceId ?? this.deviceId,
      payload: payload ?? this.payload,
    );
  }

  @override
  String toString() =>
      'EventEnvelope(messageId: $messageId, action: $action, deviceId: $deviceId)';
}
