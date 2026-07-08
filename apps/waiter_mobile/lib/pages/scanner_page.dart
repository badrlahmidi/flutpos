import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import 'order_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final MobileScannerController _controller = MobileScannerController();
  final _floorPlanRepo = GetIt.instance<FloorPlanRepository>();
  bool _isProcessing = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing) return;
    
    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final code = barcodes.first.rawValue;
    if (code == null) return;

    setState(() => _isProcessing = true);
    
    // On suppose que le code QR a le format "table:TABLE_ID"
    final tableId = code.startsWith('table:') ? code.substring(6) : code;

    try {
      final snapshotList = await _floorPlanRepo.watchFloorPlan().first;
      RestaurantTable? foundTable;
      for (final zoneSnap in snapshotList) {
        for (final tableSnap in zoneSnap.tables) {
          if (tableSnap.table.id == tableId) {
            foundTable = tableSnap.table;
            break;
          }
        }
        if (foundTable != null) break;
      }

      if (foundTable != null && mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => OrderPage(table: foundTable!),
          ),
        );
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Table introuvable ($code)')),
        );
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _isProcessing = false);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scanner une table')),
      body: Stack(
        children: [
          MobileScanner(
            controller: _controller,
            onDetect: _onDetect,
          ),
          if (_isProcessing)
            const Center(
              child: CircularProgressIndicator(),
            ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, state, child) {
                      switch (state.torchState) {
                        case TorchState.off:
                          return const Icon(Icons.flash_off, color: Colors.grey);
                        case TorchState.on:
                          return const Icon(Icons.flash_on, color: Colors.yellow);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => _controller.toggleTorch(),
                ),
                const SizedBox(width: 32),
                IconButton(
                  color: Colors.white,
                  icon: ValueListenableBuilder(
                    valueListenable: _controller,
                    builder: (context, state, child) {
                      switch (state.cameraDirection) {
                        case CameraFacing.front:
                          return const Icon(Icons.camera_front);
                        case CameraFacing.back:
                          return const Icon(Icons.camera_rear);
                      }
                    },
                  ),
                  iconSize: 32.0,
                  onPressed: () => _controller.switchCamera(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
