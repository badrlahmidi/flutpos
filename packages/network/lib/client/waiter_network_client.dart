import 'dart:async';

import 'package:core/core.dart';
import 'package:dio/dio.dart';
import 'package:ns_ds_network/ns_ds_network.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../protocol/event_envelope.dart';
import '../protocol/event_serializer.dart';
import '../protocol/pos_server_status.dart';
import '../protocol/ws_action.dart';
import '../sync/sync_queue_manager.dart';
import 'connection_state.dart';
import 'connection_state_notifier.dart';
import 'network_sender.dart';

/// Client WebSocket pour l'application serveur mobile (Waiter).
class WaiterNetworkClient implements NetworkSender {
  WaiterNetworkClient({
    required AppDatabase database,
    required this.deviceId,
    SyncQueueManager? syncQueueManager,
    NsDsNetwork? nsDsNetwork,
  })  : _syncQueueManager = syncQueueManager ?? SyncQueueManager(database),
        _nsDsNetwork = nsDsNetwork ?? NsDsNetwork.instance;

  final String deviceId;
  final SyncQueueManager _syncQueueManager;
  final NsDsNetwork _nsDsNetwork;

  WebSocketChannel? _channel;
  StreamSubscription<dynamic>? _subscription;
  Timer? _reconnectTimer;

  int _reconnectAttempt = 0;
  String? _lastIp;
  int? _lastPort;

  final _messagesController = StreamController<EventEnvelope>.broadcast();

  /// État de connexion observable par l'UI (indicateur vert/rouge).
  final ConnectionStateNotifier connectionState = ConnectionStateNotifier();

  /// Flux des messages entrants décodés.
  Stream<EventEnvelope> get messages => _messagesController.stream;

  /// Gestionnaire SyncQueue associé.
  SyncQueueManager get syncQueueManager => _syncQueueManager;

  @override
  bool get isConnected => connectionState.value == ConnectionState.connected;

  /// Dernière caisse découverte via mDNS.
  DiscoveredService? lastDiscoveredService;

  /// Scan mDNS — retourne la première caisse trouvée.
  Future<DiscoveredService?> discover() async {
    _setState(ConnectionState.discovering);
    try {
      final services = await _nsDsNetwork.discoverServices();
      if (services.isEmpty) {
        print('[WaiterNetworkClient] Aucune caisse trouvée sur le LAN.');
        _setState(ConnectionState.disconnected);
        return null;
      }
      lastDiscoveredService = services.first;
      print(
        '[WaiterNetworkClient] Caisse trouvée: '
        '${lastDiscoveredService!.ipAddress}:${lastDiscoveredService!.port}',
      );
      return lastDiscoveredService;
    } catch (error, stackTrace) {
      print('[WaiterNetworkClient] Erreur mDNS: $error\n$stackTrace');
      _setState(ConnectionState.disconnected);
      return null;
    }
  }

  /// Ouvre une connexion WebSocket vers `ws://ip:port/ws`.
  Future<void> connect(String ip, int port) async {
    _lastIp = ip;
    _lastPort = port;
    _cancelReconnectTimer();
    _setState(ConnectionState.connecting);

    await _subscription?.cancel();
    await _channel?.sink.close();
    _channel = null;

    try {
      final uri = Uri.parse('ws://$ip:$port/ws');
      _channel = WebSocketChannel.connect(uri);

      _subscription = _channel!.stream.listen(
        _onMessage,
        onDone: _onDisconnected,
        onError: (Object error, StackTrace stackTrace) {
          print('[WaiterNetworkClient] Erreur stream: $error');
          _onDisconnected();
        },
        cancelOnError: true,
      );

      _reconnectAttempt = 0;
      _setState(ConnectionState.connected);
      print('[WaiterNetworkClient] Connecté à $uri');

      await _syncQueueManager.retryFailed();
      await _syncQueueManager.flush(this);
    } catch (error, stackTrace) {
      print('[WaiterNetworkClient] Connexion échouée: $error\n$stackTrace');
      _setState(ConnectionState.disconnected);
      _scheduleReconnect();
      rethrow;
    }
  }

  /// Découverte mDNS automatique puis connexion à la première caisse.
  ///
  /// Retourne `false` si aucune caisse n'est trouvée (fallback IP manuelle).
  Future<bool> discoverAndConnect() async {
    final service = await discover();
    if (service == null) {
      return false;
    }
    await connect(service.ipAddress, service.port);
    return true;
  }

  /// Connexion manuelle (fallback saisie IP).
  Future<void> connectManually(String ip, {int port = NsDsNetworkConstants.defaultPort}) {
    return connect(ip, port);
  }

  /// Statut HTTP de la caisse (`GET /ping`) — session caisse incluse.
  Future<PosServerStatus?> fetchPosStatus() async {
    final ip = _lastIp;
    final port = _lastPort;
    if (ip == null || port == null) {
      return null;
    }
    try {
      final response = await Dio().get<Map<String, dynamic>>(
        'http://$ip:$port/ping',
        options: Options(responseType: ResponseType.json),
      );
      final data = response.data;
      if (data == null) {
        return null;
      }
      return PosServerStatus.fromJson(data);
    } catch (error) {
      print('[WaiterNetworkClient] Ping HTTP échoué: $error');
      return null;
    }
  }

  /// Envoie un message et attend l'ACK correspondant (connexion directe requise).
  Future<EventEnvelope> sendAndAwaitAck(
    EventEnvelope envelope, {
    Duration timeout = const Duration(seconds: 15),
  }) async {
    if (!isConnected) {
      throw StateError('WebSocket déconnecté — synchronisez d\'abord.');
    }

    final completer = Completer<EventEnvelope>();
    late StreamSubscription<EventEnvelope> subscription;
    subscription = messages.listen((message) {
      if (message.action != WsAction.ack) {
        return;
      }
      if (message.payload['originalMessageId'] == envelope.messageId) {
        subscription.cancel();
        if (!completer.isCompleted) {
          completer.complete(message);
        }
      }
    });

    try {
      await sendDirect(envelope);
      return await completer.future.timeout(
        timeout,
        onTimeout: () {
          subscription.cancel();
          throw TimeoutException(
            'Délai dépassé en attente ACK (${envelope.action})',
          );
        },
      );
    } catch (error) {
      await subscription.cancel();
      rethrow;
    }
  }

  /// Envoie un message — enqueue offline si déconnecté.
  Future<void> send(EventEnvelope envelope) async {
    if (isConnected) {
      await sendDirect(envelope);
    } else {
      await _syncQueueManager.enqueue(envelope);
    }
  }

  @override
  Future<void> sendDirect(EventEnvelope envelope) async {
    final channel = _channel;
    if (channel == null || !isConnected) {
      throw StateError('WebSocket non connecté — impossible d\'envoyer directement.');
    }
    try {
      channel.sink.add(EventSerializer.encode(envelope));
    } catch (error) {
      print('[WaiterNetworkClient] Envoi direct échoué: $error');
      await _syncQueueManager.enqueue(envelope);
      rethrow;
    }
  }

  /// Ferme proprement la connexion et annule la reconnexion auto.
  Future<void> disconnect() async {
    _cancelReconnectTimer();
    _reconnectAttempt = 0;
    await _subscription?.cancel();
    _subscription = null;
    await _channel?.sink.close();
    _channel = null;
    _setState(ConnectionState.disconnected);
    print('[WaiterNetworkClient] Déconnecté.');
  }

  void _onMessage(dynamic data) {
    if (data is! String) {
      return;
    }

    final envelope = EventSerializer.decode(data);
    if (envelope == null) {
      return;
    }

    if (envelope.action == WsAction.ping) {
      final pong = EventEnvelope.create(
        action: WsAction.pong,
        deviceId: deviceId,
        payload: {'originalMessageId': envelope.messageId},
      );
      unawaited(sendDirect(pong));
      return;
    }

    if (envelope.action == WsAction.ack) {
      final originalId = envelope.payload['originalMessageId'] as String?;
      if (originalId != null) {
        unawaited(_syncQueueManager.onAck(originalId));
      }
    }

    _messagesController.add(envelope);
  }

  void _onDisconnected() {
    if (connectionState.value == ConnectionState.disconnected) {
      return;
    }
    print('[WaiterNetworkClient] Connexion perdue — reconnexion planifiée.');
    _setState(ConnectionState.reconnecting);
    _scheduleReconnect();
  }

  void _scheduleReconnect() {
    _cancelReconnectTimer();

    final ip = _lastIp;
    final port = _lastPort;
    if (ip == null || port == null) {
      _setState(ConnectionState.disconnected);
      return;
    }

    final delaySeconds = _backoffSeconds(_reconnectAttempt);
    _reconnectAttempt++;

    print('[WaiterNetworkClient] Reconnexion dans ${delaySeconds}s (tentative $_reconnectAttempt)');

    _reconnectTimer = Timer(Duration(seconds: delaySeconds), () async {
      try {
        await connect(ip, port);
      } catch (_) {
        if (connectionState.value == ConnectionState.reconnecting) {
          _scheduleReconnect();
        }
      }
    });
  }

  int _backoffSeconds(int attempt) {
    final exponential = 1 << attempt.clamp(0, 4);
    return exponential.clamp(1, 30);
  }

  void _setState(ConnectionState state) {
    if (connectionState.value != state) {
      connectionState.value = state;
      print('[WaiterNetworkClient] État → $state');
    }
  }

  void _cancelReconnectTimer() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  /// Libère les ressources (streams, timers, WebSocket).
  Future<void> dispose() async {
    await disconnect();
    await _messagesController.close();
    connectionState.dispose();
  }
}
