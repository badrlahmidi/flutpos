/// Service mDNS découvert sur le réseau local.
class DiscoveredService {
  const DiscoveredService({
    required this.name,
    required this.host,
    required this.ipAddress,
    required this.port,
    this.txtRecords = const [],
  });

  final String name;
  final String host;
  final String ipAddress;
  final int port;
  final List<String> txtRecords;

  @override
  String toString() =>
      'DiscoveredService(name: $name, $ipAddress:$port, host: $host)';
}
