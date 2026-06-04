import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../../services/pos_service_mode.dart';
import '../../theme/app_spacing.dart';

/// Bascule service à table ↔ service rapide (top bar).
class ServiceModeToggle extends StatelessWidget {
  const ServiceModeToggle({
    super.key,
    this.onModeChanged,
  });

  final ValueChanged<ServiceMode>? onModeChanged;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: PosServiceMode.instance,
      builder: (context, _) {
        final mode = PosServiceMode.instance.mode;
        final isQuick = mode == ServiceMode.quickService;

        return Tooltip(
          message: isQuick
              ? 'Mode comptoir — passer au service à table'
              : 'Service à table — passer au comptoir rapide',
          child: FilledButton.tonalIcon(
            onPressed: () async {
              await PosServiceMode.instance.toggle();
              onModeChanged?.call(PosServiceMode.instance.mode);
            },
            icon: Icon(
              isQuick ? Icons.fastfood : Icons.table_restaurant_outlined,
            ),
            label: Text(
              isQuick ? 'RAPIDE' : 'TABLE',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            style: FilledButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.minTouchTarget,
                AppSpacing.minTouchTarget,
              ),
            ),
          ),
        );
      },
    );
  }
}
