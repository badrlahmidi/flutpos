import 'package:web_socket_channel/web_socket_channel.dart';

/// Registre des terminaux WebSocket connectés à la caisse PC.
class WsClientRegistry {
  final Map<String, WebSocketChannel> _clients = {};

  /// Nombre de clients actuellement connectés.
  int get count => _clients.length;

  /// Liste de tous les canaux WebSocket actifs.
  List<WebSocketChannel> get all => _clients.values.toList(growable: false);

  /// Identifiants des terminaux connectés.
  Iterable<String> get deviceIds => _clients.keys;

  /// Enregistre ou remplace un client pour [deviceId].
  void add(String deviceId, WebSocketChannel channel) {
    _clients[deviceId] = channel;
    print('[WsClientRegistry] Client ajouté: $deviceId (total: $count)');
  }

  /// Retire un client du registre.
  void remove(String deviceId) {
    final removed = _clients.remove(deviceId);
    if (removed != null) {
      print('[WsClientRegistry] Client retiré: $deviceId (total: $count)');
    }
  }

  /// Retourne le canal WebSocket d'un terminal, ou `null`.
  WebSocketChannel? get(String deviceId) => _clients[deviceId];

  /// Indique si un terminal est connecté.
  bool isConnected(String deviceId) => _clients.containsKey(deviceId);

  /// Vide le registre (fermeture serveur).
  void clear() => _clients.clear();
}
