import '../database/app_database.dart';
import 'print_repository.dart';

class PrintRepositoryImpl implements PrintRepository {
  PrintRepositoryImpl(this._db);

  final AppDatabase _db;

  @override
  Future<RestaurantConfigData?> getRestaurantConfig() {
    return _db.select(_db.restaurantConfig).getSingleOrNull();
  }

  @override
  Future<List<PrintStation>> getActivePrintStations() {
    return (_db.select(_db.printStations)
          ..where((s) => s.isActive.equals(true)))
        .get();
  }

  @override
  Future<PrintStation?> getPrintStationById(String stationId) {
    return (_db.select(_db.printStations)..where((s) => s.id.equals(stationId)))
        .getSingleOrNull();
  }

  @override
  Future<PrintStation?> resolveStationForCategory(String categoryId) async {
    final category = await (_db.select(_db.categories)
          ..where((c) => c.id.equals(categoryId)))
        .getSingleOrNull();
    final stationId = category?.printStationId;
    if (stationId == null) {
      final stations = await getActivePrintStations();
      return stations.isNotEmpty ? stations.first : null;
    }
    return getPrintStationById(stationId);
  }
}
