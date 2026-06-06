import '../database/app_database.dart';

/// Stations d'impression et configuration restaurant.
abstract class PrintRepository {
  Future<RestaurantConfigData?> getRestaurantConfig();

  Future<void> updateDefaultServiceMode(String modeDbValue);

  Future<List<PrintStation>> getActivePrintStations();

  Future<PrintStation?> getPrintStationById(String stationId);

  /// Station liée à la catégorie du produit (routage cuisine/bar).
  Future<PrintStation?> resolveStationForCategory(String categoryId);
  Future<void> updateRestaurantConfig({
    required String name,
    String? address,
    String? phone,
    String? ice,
    String? rc,
    String? identifiantFiscal,
  });

  Future<List<PrintStation>> getAllPrintStations();
  Future<void> savePrintStation(PrintStation station);
  Future<void> deletePrintStation(String id);
}
