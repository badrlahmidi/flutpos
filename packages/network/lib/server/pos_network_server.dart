import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:ns_ds_network/ns_ds_network.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../protocol/event_envelope.dart';
import '../protocol/event_serializer.dart';
import '../protocol/ws_action.dart';
import 'ws_client_registry.dart';
import 'ws_message_handler.dart';

/// Serveur HTTP + WebSocket de la caisse PC (Shelf).
class PosNetworkServer {
  PosNetworkServer({
    required AppDatabase database,
    WsClientRegistry? clientRegistry,
    WsMessageHandler? messageHandler,
    this.version = '1.0.0',
    this.port = NsDsNetworkConstants.defaultPort,
  })  : _database = database,
        _clientRegistry = clientRegistry ?? WsClientRegistry(),
        _messageHandler = messageHandler ?? WsMessageHandler();

  final AppDatabase _database;
  final WsClientRegistry _clientRegistry;
  final WsMessageHandler _messageHandler;

  /// Version exposée sur `GET /ping`.
  final String version;

  /// Port d'écoute HTTP/WebSocket.
  final int port;

  HttpServer? _httpServer;
  Timer? _heartbeatTimer;

  /// Compteur de PING sans PONG par terminal (déconnexion après 3).
  final Map<String, int> _missedPongs = {};

  /// Association canal → deviceId pour les connexions en attente d'identification.
  final Map<WebSocketChannel, String> _channelDeviceIds = {};

  /// Registre des clients connectés (lecture seule).
  WsClientRegistry get clientRegistry => _clientRegistry;

  /// Indique si le serveur est démarré.
  bool get isRunning => _httpServer != null;

  /// Démarre le serveur Shelf, le WebSocket et l'annonce mDNS.
  Future<void> start() async {
    if (isRunning) {
      return;
    }

    final router = Router()
      ..get('/ping', _handlePing)
      ..get('/ws', webSocketHandler(_handleWebSocket));

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _httpServer = await shelf_io.serve(
      handler,
      InternetAddress.anyIPv4,
      port,
    );

    await NsDsNetwork.instance.registerService(port: port);

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _sendHeartbeat(),
    );

    print(
      '[PosNetworkServer] Démarré sur ${_httpServer!.address.address}:$port',
    );
  }

  /// Arrête le serveur, ferme les WebSockets et désenregistre mDNS.
  Future<void> stop() async {
    _heartbeatTimer?.cancel();
    _heartbeatTimer = null;

    for (final channel in _clientRegistry.all) {
      await channel.sink.close();
    }
    _clientRegistry.clear();
    _channelDeviceIds.clear();
    _missedPongs.clear();

    final server = _httpServer;
    _httpServer = null;
    if (server != null) {
      await server.close(force: true);
    }

    await NsDsNetwork.instance.unregisterService();
    print('[PosNetworkServer] Arrêté.');
  }

  /// Envoie un message à tous les terminaux connectés.
  void broadcast(EventEnvelope envelope) {
    final encoded = EventSerializer.encode(envelope);
    for (final channel in _clientRegistry.all) {
      _safeSend(channel, encoded);
    }
    print(
      '[PosNetworkServer] Broadcast ${envelope.action} → ${_clientRegistry.count} clients',
    );
  }

  /// Envoie un message à un terminal spécifique.
  void sendTo(String deviceId, EventEnvelope envelope) {
    final channel = _clientRegistry.get(deviceId);
    if (channel == null) {
      print('[PosNetworkServer] Client introuvable: $deviceId');
      return;
    }
    _safeSend(channel, EventSerializer.encode(envelope));
  }

  Response _handlePing(Request request) {
    final body = jsonEncode({
      'status': 'online',
      'version': version,
      'activeSessions': _clientRegistry.count,
    });
    return Response.ok(
      body,
      headers: {'Content-Type': 'application/json'},
    );
  }

  void _handleWebSocket(WebSocketChannel webSocket) {
    print('[PosNetworkServer] Nouvelle connexion WebSocket');

    webSocket.stream.listen(
      (dynamic data) => _onMessage(webSocket, data),
      onDone: () => _onDisconnect(webSocket),
      onError: (Object error, StackTrace stackTrace) {
        print('[PosNetworkServer] Erreur WebSocket: $error');
        _onDisconnect(webSocket);
      },
      cancelOnError: true,
    );
  }

  void _onMessage(WebSocketChannel webSocket, dynamic data) {
    if (data is! String) {
      print('[PosNetworkServer] Message binaire ignoré.');
      return;
    }

    final envelope = EventSerializer.decode(data);
    if (envelope == null) {
      return;
    }

    _registerClient(webSocket, envelope.deviceId);

    if (envelope.action == WsAction.pong) {
      _missedPongs[envelope.deviceId] = 0;
      return;
    }

    final response = _messageHandler.handle(envelope);
    if (response.action == WsAction.pong) {
      _safeSend(webSocket, EventSerializer.encode(response));
      return;
    }

    sendTo(envelope.deviceId, response);
  }

  void _registerClient(WebSocketChannel webSocket, String deviceId) {
    final previousId = _channelDeviceIds[webSocket];
    if (previousId == deviceId && _clientRegistry.isConnected(deviceId)) {
      return;
    }

    if (previousId != null && previousId != deviceId) {
      _clientRegistry.remove(previousId);
      _missedPongs.remove(previousId);
    }

    _channelDeviceIds[webSocket] = deviceId;
    _clientRegistry.add(deviceId, webSocket);
    _missedPongs.putIfAbsent(deviceId, () => 0);
  }

  void _onDisconnect(WebSocketChannel webSocket) {
    final deviceId = _channelDeviceIds.remove(webSocket);
    if (deviceId != null) {
      _clientRegistry.remove(deviceId);
      _missedPongs.remove(deviceId);
    }
    print('[PosNetworkServer] Déconnexion WebSocket${deviceId != null ? ' ($deviceId)' : ''}');
  }

  void _sendHeartbeat() {
    for (final deviceId in _clientRegistry.deviceIds.toList()) {
      final missed = _missedPongs[deviceId] ?? 0;
      if (missed >= 3) {
        print('[PosNetworkServer] Client $deviceId déconnecté (3 PING sans PONG)');
        _disconnectClient(deviceId);
        continue;
      }

      final ping = EventEnvelope.create(
        action: WsAction.ping,
        deviceId: 'pos-server',
        payload: const {},
      );
      sendTo(deviceId, ping);
      _missedPongs[deviceId] = missed + 1;
    }
  }

  void _disconnectClient(String deviceId) {
    final channel = _clientRegistry.get(deviceId);
    _clientRegistry.remove(deviceId);
    _missedPongs.remove(deviceId);
    channel?.sink.close();
  }

  void _safeSend(WebSocketChannel channel, String message) {
    try {
      channel.sink.add(message);
    } catch (error) {
      print('[PosNetworkServer] Envoi impossible: $error');
    }
  }

  /// Exposé pour les tests — accès BDD (SyncQueue future).
  AppDatabase get database => _database;
}
