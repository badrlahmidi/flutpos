import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:network/client/connection_state.dart' as net;

import '../di/app_bootstrap.dart';
import 'order_page.dart';
import 'scanner_page.dart';

class TablesPage extends StatefulWidget {
  const TablesPage({super.key});

  @override
  State<TablesPage> createState() => _TablesPageState();
}

class _TablesPageState extends State<TablesPage> {
  final _floorPlanRepo = GetIt.instance<FloorPlanRepository>();
  final _client = AppBootstrap.instance.networkClient;
  bool? _posSessionOpen;

  @override
  void initState() {
    super.initState();
    _client.connectionState.addListener(_onConnectionStateChanged);
    _checkPosSession();
  }

  Future<void> _checkPosSession() async {
    final status = await _client.fetchPosStatus();
    if (mounted) {
      setState(() => _posSessionOpen = status?.hasOpenSession);
    }
  }

  void _onConnectionStateChanged() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _client.connectionState.removeListener(_onConnectionStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan de Salle'),
        actions: [
          Builder(
            builder: (context) {
              final state = _client.connectionState.value;
              final color = state == net.ConnectionState.connected
                  ? Colors.green
                  : Colors.red;
              return Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Icon(Icons.circle, color: color, size: 12),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<FloorPlanZoneSnapshot>>(
        stream: _floorPlanRepo.watchFloorPlan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Erreur: ${snapshot.error}'));
          }

          final zones = snapshot.data ?? [];
          if (zones.isEmpty) {
            return const Center(child: Text('Aucune zone configurée.'));
          }

          return DefaultTabController(
            length: zones.length,
            child: Column(
              children: [
                if (_posSessionOpen == false)
                  MaterialBanner(
                    content: const Text(
                      'Caisse PC fermée — ouvrez la session sur le poste caisse.',
                    ),
                    leading: const Icon(Icons.warning_amber),
                    backgroundColor: Colors.orange.shade100,
                    actions: [
                      TextButton(
                        onPressed: _checkPosSession,
                        child: const Text('Revérifier'),
                      ),
                    ],
                  ),
                TabBar(
                  isScrollable: true,
                  tabs: zones.map((z) => Tab(text: z.zone.name)).toList(),
                ),
                Expanded(
                  child: TabBarView(
                    children: zones.map((zone) {
                      return GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 1,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: zone.tables.length,
                        itemBuilder: (context, index) {
                          final tableSnap = zone.tables[index];
                          final table = tableSnap.table;
                          final isOccupied = tableSnap.tileStatus == FloorPlanTileStatus.occupied;
                          
                          return InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => OrderPage(table: table),
                                ),
                              );
                            },
                            child: Card(
                              color: isOccupied ? Colors.orange.shade100 : Colors.green.shade100,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    table.name,
                                    style: Theme.of(context).textTheme.titleLarge,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(isOccupied ? 'Occupée' : 'Libre'),
                                  if (isOccupied && tableSnap.currentGrandTotal != null)
                                    Text('${tableSnap.currentGrandTotal!.toStringAsFixed(2)} DH'),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const ScannerPage(),
            ),
          );
        },
        icon: const Icon(Icons.qr_code_scanner),
        label: const Text('Scanner'),
      ),
    );
  }
}
