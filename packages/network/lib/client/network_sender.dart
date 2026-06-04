import '../protocol/event_envelope.dart';

/// Contrat minimal pour l'envoi direct de messages réseau (évite import circulaire).
abstract interface class NetworkSender {
  /// Indique si le canal WebSocket est opérationnel.
  bool get isConnected;

  /// Envoie un message sur le fil sans passer par la SyncQueue.
  Future<void> sendDirect(EventEnvelope envelope);
}
