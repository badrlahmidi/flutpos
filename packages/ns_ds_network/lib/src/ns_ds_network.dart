import 'dart:io';

import 'package:mdns_dart/mdns_dart.dart';

import 'discovered_service.dart';
import 'ns_ds_network_constants.dart';

/// Façade mDNS pour Ritagestion (PC caisse + apps serveurs).
///
/// API documentée dans `03_network_protocol.md` :
/// - [registerService] — annonce la caisse sur le LAN
/// - [discoverServices] — scan `_ritajpos._tcp`
class NsDsNetwork {
  NsDsNetwork._();

  static final NsDsNetwork instance = NsDsNetwork._();

  MDNSServer? _server;

  bool get isAdvertising => _server?.isRunning ?? false;

  /// Annonce un service mDNS sur le réseau local (côté PC caisse).
  Future<void> registerService({
    String name = NsDsNetworkConstants.defaultServiceName,
    String type = NsDsNetworkConstants.serviceType,
    int port = NsDsNetworkConstants.defaultPort,
    List<String> txt = const [],
  }) async {
    await unregisterService();

    final localIp = await _resolveLocalIpv4();
    final mdnsService = await MDNSService.create(
      instance: name,
      service: type,
      port: port,
      ips: [localIp],
      txt: txt,
    );

    _server = MDNSServer(MDNSServerConfig(zone: mdnsService));
    await _server!.start();
  }

  /// Arrête l'annonce mDNS en cours.
  Future<void> unregisterService() async {
    final server = _server;
    _server = null;
    if (server != null && server.isRunning) {
      await server.stop();
    }
  }

  /// Découvre les caisses `_ritajpos._tcp` sur le LAN (côté mobile).
  Future<List<DiscoveredService>> discoverServices({
    String type = NsDsNetworkConstants.serviceType,
    Duration timeout = NsDsNetworkConstants.defaultDiscoveryTimeout,
  }) async {
    final entries = await MDNSClient.discover(type, timeout: timeout);

    return entries
        .where((entry) => entry.isComplete && entry.primaryAddress != null)
        .map(
          (entry) => DiscoveredService(
            name: entry.name,
            host: entry.host,
            ipAddress: entry.primaryAddress!.address,
            port: entry.port,
            txtRecords: List.unmodifiable(entry.infoFields),
          ),
        )
        .toList(growable: false);
  }

  Future<InternetAddress> _resolveLocalIpv4() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLinkLocal: false,
    );

    for (final interface in interfaces) {
      for (final address in interface.addresses) {
        if (!address.isLoopback) {
          return address;
        }
      }
    }

    throw StateError(
      'Aucune interface IPv4 locale disponible pour l\'annonce mDNS.',
    );
  }
}

/// Raccourci — annonce la caisse principale.
Future<void> registerService({
  String name = NsDsNetworkConstants.defaultServiceName,
  String type = NsDsNetworkConstants.serviceType,
  int port = NsDsNetworkConstants.defaultPort,
  List<String> txt = const [],
}) =>
    NsDsNetwork.instance.registerService(
      name: name,
      type: type,
      port: port,
      txt: txt,
    );

/// Raccourci — scan des services RitajPOS sur le LAN.
Future<List<DiscoveredService>> discoverServices({
  String type = NsDsNetworkConstants.serviceType,
  Duration timeout = NsDsNetworkConstants.defaultDiscoveryTimeout,
}) =>
    NsDsNetwork.instance.discoverServices(type: type, timeout: timeout);
