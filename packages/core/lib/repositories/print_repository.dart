import '../database/app_database.dart';

/// Stations d'impression et configuration restaurant.
abstract class PrintRepository {
  Future<RestaurantConfigData?> getRestaurantConfig();

  Future<List<PrintStation>> getActivePrintStations();

  Future<PrintStation?> getPrintStationById(String stationId);

  /// Station liée à la catégorie du produit (routage cuisine/bar).
  Future<PrintStation?> resolveStationForCategory(String categoryId);
}
