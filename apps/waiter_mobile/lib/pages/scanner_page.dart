import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/permission_denied_dialog.dart';
import 'order_page.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> with WidgetsBindingObserver {
  final MobileScannerController _controller = MobileScannerController();
  final _floorPlanRepo = GetIt.instance<FloorPlanRepository>();
  bool _isProcessing = false;
  bool _hasPermission = false;
  bool _permissionChecked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _requestCameraPermission();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (!mounted) return;

    if (status.isGranted) {
      setState(() {
        _hasPermission = true;
        _permissionChecked = true;
      });
    } else if (status.isPermanentlyDenied) {
      setState(() => _permissionChecked = true);
      await PermissionDeniedDialog.show(context, permanentlyDenied: true);
    } else {
      setState(() => _permissionChecked = true);
      await PermissionDeniedDialog.show(context, permanentlyDenied: false);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Re-check permission when user returns from settings.
    if (state == AppLifecycleState.resumed && !_hasPermission) {
      _requestCameraPermission();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_permissionChecked) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_hasPermission) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.camera_alt_outlined, size: 64, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Permission caméra requise'),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _requestCameraPermission,
              child: const Text('Accorder la permission'),
            ),
          ],
        ),
      );
    }

    return Stack(
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
                      case _:
                        return const Icon(Icons.flash_auto, color: Colors.white);
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
                      case _:
                        return const Icon(Icons.camera);
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
    );
  }
}