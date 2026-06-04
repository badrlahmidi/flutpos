import '../entities/floor_plan_zone_snapshot.dart';

/// Lecture du plan de salle (zones, tables, commandes actives).
abstract class FloorPlanRepository {
  Future<List<FloorPlanZoneSnapshot>> loadFloorPlan();

  Stream<List<FloorPlanZoneSnapshot>> watchFloorPlan();
}
