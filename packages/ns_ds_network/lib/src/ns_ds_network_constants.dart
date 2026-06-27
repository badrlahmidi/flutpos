/// Constantes réseau LAN — alignées sur `docs/architecture/03_network_protocol.md`.
abstract final class NsDsNetworkConstants {
  static const serviceType = '_ritajpos._tcp';
  static const defaultServiceName = 'Caisse Principale';
  static const defaultPort = 8085;
  static const defaultDiscoveryTimeout = Duration(seconds: 5);
}
