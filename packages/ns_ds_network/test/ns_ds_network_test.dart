import 'package:ns_ds_network/ns_ds_network.dart';
import 'package:test/test.dart';

void main() {
  group('NsDsNetworkConstants', () {
    test('aligne le protocole RitajPOS', () {
      expect(NsDsNetworkConstants.serviceType, '_ritajpos._tcp');
      expect(NsDsNetworkConstants.defaultServiceName, 'Caisse Principale');
      expect(NsDsNetworkConstants.defaultPort, 8085);
    });
  });

  group('DiscoveredService', () {
    test('toString contient IP et port', () {
      const service = DiscoveredService(
        name: 'Caisse Principale',
        host: 'pc-caisse.local',
        ipAddress: '192.168.1.50',
        port: 8080,
      );

      expect(
        service.toString(),
        contains('192.168.1.50:8080'),
      );
    });
  });
}
