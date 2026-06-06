/// Statut HTTP de la caisse PC (`GET /ping`).
class PosServerStatus {
  const PosServerStatus({
    required this.online,
    required this.version,
    required this.hasOpenSession,
    this.cashSessionId,
    this.connectedClients = 0,
  });

  final bool online;
  final String version;
  final bool hasOpenSession;
  final String? cashSessionId;
  final int connectedClients;

  factory PosServerStatus.fromJson(Map<String, dynamic> json) {
    return PosServerStatus(
      online: json['status'] == 'online',
      version: json['version'] as String? ?? 'unknown',
      hasOpenSession: json['hasOpenSession'] as bool? ?? false,
      cashSessionId: json['cashSessionId'] as String?,
      connectedClients: json['connectedClients'] as int? ?? 0,
    );
  }
}
