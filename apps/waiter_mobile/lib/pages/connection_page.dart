import 'package:flutter/material.dart';

import '../di/app_bootstrap.dart';
import 'tables_page.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final _client = AppBootstrap.instance.networkClient;
  bool _discovering = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  Future<void> _startDiscovery() async {
    if (!mounted) return;
    setState(() {
      _discovering = true;
      _error = '';
    });

    try {
      final success = await _client.discoverAndConnect();
      if (!mounted) return;
      
      if (success) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const TablesPage()),
        );
      } else {
        setState(() {
          _error = 'Aucune caisse trouvée sur le réseau local.';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Erreur de connexion : $e';
      });
    } finally {
      if (mounted) {
        setState(() {
          _discovering = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ritagestion Waiter'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.wifi, size: 64, color: Colors.blueGrey),
              const SizedBox(height: 24),
              if (_discovering) ...[
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                const Text('Recherche de la caisse principale...'),
              ] else ...[
                if (_error.isNotEmpty) ...[
                  Text(
                    _error,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                ],
                ElevatedButton.icon(
                  onPressed: _startDiscovery,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Réessayer'),
                ),
                // TODO: Ajouter un champ pour saisir l'IP manuellement
              ],
            ],
          ),
        ),
      ),
    );
  }
}
