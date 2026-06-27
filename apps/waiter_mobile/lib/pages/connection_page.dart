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
  final _ipController = TextEditingController();
  bool _discovering = false;
  bool _connectingManually = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _startDiscovery();
  }

  @override
  void dispose() {
    _ipController.dispose();
    super.dispose();
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

  Future<void> _connectManually() async {
    final ip = _ipController.text.trim();
    if (ip.isEmpty) {
      setState(() => _error = 'Veuillez saisir une adresse IP.');
      return;
    }
    setState(() {
      _connectingManually = true;
      _error = '';
    });
    try {
      await _client.connectManually(ip);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const TablesPage()),
      );
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Échec de la connexion directe à $ip : $e';
      });
    } finally {
      if (mounted) {
        setState(() => _connectingManually = false);
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
        child: SingleChildScrollView(
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
                  label: const Text('Réessayer la recherche'),
                ),
                const SizedBox(height: 32),
                const Divider(),
                const SizedBox(height: 16),
                const Text(
                  'Ou connexion manuelle :',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 320,
                  child: TextField(
                    controller: _ipController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse IP de la caisse',
                      hintText: 'ex: 192.168.1.100',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.computer),
                      isDense: true,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  onPressed: _connectingManually ? null : _connectManually,
                  icon: _connectingManually
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.link),
                  label: const Text('Connexion directe'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
