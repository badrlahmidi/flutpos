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
import '../utils/app_logger.dart';
import 'ws_client_registry.dart';
import 'ws_message_handler.dart';
import 'ws_rate_limiter.dart';

/// Serveur HTTP + WebSocket de la caisse PC (Shelf).
///
/// Security fixes intégrés :
/// * [HAUTE-N02] Validation du pairing token à la connexion.
/// * [HAUTE-A04] Validation du sessionToken à chaque message.
/// * [MOY-N04]  Logging structuré (remplace `print()`).
/// * [MOY-N05]  Rate limiting par deviceId.
class PosNetworkServer {
  PosNetworkServer({
    required AppDatabase database,
    OrderRepository? orderRepository,
    CashSessionRepository? cashSessionRepository,
    ProductRepository? productRepository,
    WsClientRegistry? clientRegistry,
    WsMessageHandler? messageHandler,
    WsRateLimiter? rateLimiter,
    this.version = '1.0.0',
    this.port = NsDsNetworkConstants.defaultPort,
    InternetAddress? bindAddress,
    this.announceMdns = true,
    this.pairingRequired = false,
  })  : bindAddress = bindAddress ?? InternetAddress.anyIPv4,
        _database = database,
        _cashSessionRepository = cashSessionRepository ??
            CashSessionRepositoryImpl(
              database,
              AuditRepositoryImpl(database),
            ),
        _clientRegistry = clientRegistry ?? WsClientRegistry(),
        _messageHandler = messageHandler ??
            _createMessageHandler(
              database: database,
              orderRepository: orderRepository,
              cashSessionRepository: cashSessionRepository,
              productRepository: productRepository,
            ),
        _rateLimiter = rateLimiter ?? WsRateLimiter();

  static WsMessageHandler _createMessageHandler({
    required AppDatabase database,
    OrderRepository? orderRepository,
    CashSessionRepository? cashSessionRepository,
    ProductRepository? productRepository,
  }) {
    final audit = AuditRepositoryImpl(database);
    final sessions =
        cashSessionRepository ?? CashSessionRepositoryImpl(database, audit);
    return WsMessageHandler(
      orderRepository:
          orderRepository ?? OrderRepositoryImpl(database, audit),
      cashSessionRepository: sessions,
      productRepository: productRepository ?? ProductRepositoryImpl(database),
      devicePairingRepository: DevicePairingRepository(database),
    );
  }

  final AppDatabase _database;
  final CashSessionRepository _cashSessionRepository;
  final WsClientRegistry _clientRegistry;
  final WsMessageHandler _messageHandler;
  final WsRateLimiter _rateLimiter;

  /// Version exposée sur `GET /ping`.
  final String version;

  /// Port d'écoute HTTP/WebSocket.
  final int port;

  /// Interface d'écoute. Par défaut toutes les interfaces (LAN) —
  /// le serveur doit être joignable par les terminaux serveurs.
  late final InternetAddress bindAddress;

  /// Annonce mDNS au démarrage (désactivé en tests d'intégration).
  final bool announceMdns;

  /// Lorsque `true`, refuse les connexions WebSocket sans pairing token valide.
  /// (security fix [HAUTE-N02]) — activé en production, désactivé en tests.
  final bool pairingRequired;

  HttpServer? _httpServer;
  Timer? _heartbeatTimer;

  /// Compteur de PING sans PONG par terminal (déconnexion après 3).
  final Map<String, int> _missedPongs = {};

  /// Association canal → deviceId pour les connexions en attente d'identification.
  final Map<WebSocketChannel, String> _channelDeviceIds = {};

  /// Devices déjà pairés (cache en mémoire, security fix [HAUTE-N02]).
  final Set<String> _pairedDevices = {};

  /// Registre des clients connectés (lecture seule).
  WsClientRegistry get clientRegistry => _clientRegistry;

  /// Indique si le serveur est démarré.
  bool get isRunning => _httpServer != null;

  /// Port effectif après [start] (utile quand [port] vaut `0`).
  int? get boundPort => _httpServer?.port;

  /// Démarre le serveur Shelf, le WebSocket et l'annonce mDNS.
  Future<void> start() async {
    if (isRunning) {
      return;
    }

    // Initialize logger (security fix [MOY-N04]).
    AppLogger.instance.init();

    final router = Router()
      ..get('/ping', handlePingAsync)
      ..get('/ws', webSocketHandler(_handleWebSocket));

    final handler = Pipeline()
        .addMiddleware(logRequests())
        .addHandler(router.call);

    _httpServer = await shelf_io.serve(
      handler,
      bindAddress,
      port,
    );

    if (announceMdns) {
      await NsDsNetwork.instance.registerService(port: boundPort ?? port);
    }

    // [HAUTE-N02] Recharge les couplages actifs — survit au redémarrage.
    await _reloadPairedDevices();

    _heartbeatTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _sendHeartbeat(),
    );

    AppLogger.instance.info(
      'Server started on ${_httpServer!.address.address}:$port',
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
    _rateLimiter.clear();

    final server = _httpServer;
    _httpServer = null;
    if (server != null) {
      await server.close(force: true);
    }

    if (announceMdns) {
      await NsDsNetwork.instance.unregisterService();
    }
    AppLogger.instance.info('Server stopped.');
  }

  /// Envoie un message à tous les terminaux connectés.
  void broadcast(EventEnvelope envelope) {
    final encoded = EventSerializer.encode(envelope);
    for (final channel in _clientRegistry.all) {
      _safeSend(channel, encoded);
    }
    AppLogger.instance.info(
      'Broadcast ${envelope.action} → ${_clientRegistry.count} clients',
    );
  }

  /// Envoie un message à un terminal spécifique.
  void sendTo(String deviceId, EventEnvelope envelope) {
    final channel = _clientRegistry.get(deviceId);
    if (channel == null) {
      AppLogger.instance.warning(
        'Client not found: ${AppLogger.maskDeviceId(deviceId)}',
      );
      return;
    }
    _safeSend(channel, EventSerializer.encode(envelope));
  }

  /// Ajoute un device à la liste des terminaux pairés (security fix [HAUTE-N02]).
  void registerPairedDevice(String deviceId) {
    _pairedDevices.add(deviceId);
    AppLogger.instance.info(
      'Paired device registered: ${AppLogger.maskDeviceId(deviceId)}',
    );
  }

  /// Retire un device de la liste des terminaux pairés.
  void revokePairedDevice(String deviceId) {
    _pairedDevices.remove(deviceId);
    AppLogger.instance.warning(
      'Paired device revoked: ${AppLogger.maskDeviceId(deviceId)}',
    );
  }

  /// Ping enrichi — indique si une session caisse est ouverte sur le PC.
  Future<Response> handlePingAsync(Request request) async {
    final session = await _cashSessionRepository.getAnyOpenSession();
    final body = jsonEncode({
      'status': 'online',
      'version': version,
      'connectedClients': _clientRegistry.count,
      'hasOpenSession': session != null,
      if (session != null) 'cashSessionId': session.id,
    });
    return Response.ok(
      body,
      headers: {'Content-Type': 'application/json'},
    );
  }

  void _handleWebSocket(WebSocketChannel webSocket) {
    AppLogger.instance.info('New WebSocket connection');

    webSocket.stream.listen(
      (dynamic data) => _onMessage(webSocket, data),
      onDone: () => _onDisconnect(webSocket),
      onError: (Object error, StackTrace stackTrace) {
        AppLogger.instance.severe(
          'WebSocket error',
          error: error,
          stackTrace: stackTrace,
        );
        _onDisconnect(webSocket);
      },
      cancelOnError: true,
    );
  }

  void _onMessage(WebSocketChannel webSocket, dynamic data) async {
    if (data is! String) {
      AppLogger.instance.warning('Binary message ignored.');
      return;
    }

    final envelope = EventSerializer.decode(data);
    if (envelope == null) {
      return;
    }

    // [HAUTE-N02] Pairing check (when enabled).
    if (pairingRequired &&
        envelope.action != WsAction.pairingRequest &&
        !await _isPairedDevice(envelope.deviceId)) {
      AppLogger.instance.warning(
        'Pairing required: rejecting ${envelope.action} '
        'from ${AppLogger.maskDeviceId(envelope.deviceId)}',
      );
      _safeSend(
        webSocket,
        EventSerializer.encode(EventEnvelope.create(
          action: WsAction.error,
          deviceId: 'pos-server',
          payload: {
            'code': 'PAIRING_REQUIRED',
            'message': 'Terminal non couplé. Veuillez scanner le QR code.',
          },
        )),
      );
      return;
    }

    // [MOY-N05] Rate limiting (per deviceId).
    if (!_rateLimiter.tryConsume(envelope.deviceId,
        action: envelope.action)) {
      AppLogger.instance.warning(
        'Rate limited: ${AppLogger.maskDeviceId(envelope.deviceId)} '
        '(${envelope.action})',
      );
      _safeSend(
        webSocket,
        EventSerializer.encode(EventEnvelope.create(
          action: WsAction.error,
          deviceId: 'pos-server',
          payload: {
            'code': 'RATE_LIMITED',
            'message': 'Trop de messages. Veuillez ralentir.',
          },
        )),
      );

      // Disconnect after repeated violations.
      if (_rateLimiter.shouldDisconnect(envelope.deviceId)) {
        AppLogger.instance.severe(
          'Disconnecting rate-limit abuser: '
          '${AppLogger.maskDeviceId(envelope.deviceId)}',
        );
        _disconnectClient(envelope.deviceId);
      }
      return;
    }

    _registerClient(webSocket, envelope.deviceId);

    if (envelope.action == WsAction.pong) {
      _missedPongs[envelope.deviceId] = 0;
      return;
    }

    final response = await _messageHandler.handle(envelope);
    if (response.action == WsAction.pong) {
      _safeSend(webSocket, EventSerializer.encode(response));
      return;
    }

    sendTo(envelope.deviceId, response);
  }

  /// Recharge les terminaux pairés actifs depuis la base.
  Future<void> _reloadPairedDevices() async {
    final pairings = _messageHandler.devicePairingRepository;
    if (pairings == null) {
      return;
    }
    try {
      final active = await pairings.getActivePairings();
      _pairedDevices
        ..clear()
        ..addAll(active.map((p) => p.deviceId));
    } catch (e, st) {
      AppLogger.instance.severe('Failed to load paired devices',
          error: e, stackTrace: st);
    }
  }

  /// Vérifie le couplage : cache mémoire, sinon base (fallback restart).
  Future<bool> _isPairedDevice(String deviceId) async {
    if (_pairedDevices.contains(deviceId)) {
      return true;
    }
    final pairings = _messageHandler.devicePairingRepository;
    if (pairings == null) {
      return false;
    }
    final active = await pairings.isDeviceActive(deviceId);
    if (active) {
      _pairedDevices.add(deviceId);
    }
    return active;
  }

  void _registerClient(WebSocketChannel webSocket, String deviceId) {    final previousId = _channelDeviceIds[webSocket];
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
      _rateLimiter.removeDevice(deviceId);
    }
    AppLogger.instance.info(
      'WebSocket disconnected'
      '${deviceId != null ? ' (${AppLogger.maskDeviceId(deviceId)})' : ''}',
    );
  }

  void _sendHeartbeat() {
    for (final deviceId in _clientRegistry.deviceIds.toList()) {
      final missed = _missedPongs[deviceId] ?? 0;
      if (missed >= 3) {
        AppLogger.instance.warning(
          'Client disconnected (3 PING without PONG): '
          '${AppLogger.maskDeviceId(deviceId)}',
        );
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
    _rateLimiter.removeDevice(deviceId);
    channel?.sink.close();
  }

  void _safeSend(WebSocketChannel channel, String message) {
    try {
      channel.sink.add(message);
    } catch (error, st) {
      AppLogger.instance.severe('Send failed', error: error, stackTrace: st);
    }
  }

  /// Exposé pour les tests — accès BDD (SyncQueue future).
  AppDatabase get database => _database;
}