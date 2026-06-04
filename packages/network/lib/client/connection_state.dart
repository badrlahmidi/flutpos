/// État de la connexion réseau du terminal serveur (mobile).
enum ConnectionState {
  /// Aucune connexion active.
  disconnected,

  /// Scan mDNS en cours.
  discovering,

  /// Handshake WebSocket en cours.
  connecting,

  /// Connexion opérationnelle.
  connected,

  /// Perte de connexion — retry backoff en cours.
  reconnecting,
}
