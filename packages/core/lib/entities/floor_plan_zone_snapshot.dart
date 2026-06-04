import '../database/app_database.dart';
import 'floor_plan_table_snapshot.dart';

/// Zone du restaurant avec ses tables positionnées.
class FloorPlanZoneSnapshot {
  const FloorPlanZoneSnapshot({
    required this.zone,
    required this.tables,
  });

  final Zone zone;
  final List<FloorPlanTableSnapshot> tables;
}
