import 'package:drift/drift.dart';

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
  Future<void> updateDefaultServiceMode(String modeDbValue) async {
    final config = await getRestaurantConfig();
    if (config == null) {
      return;
    }
    await (_db.update(_db.restaurantConfig)
          ..where((c) => c.id.equals(config.id)))
        .write(
      RestaurantConfigCompanion(
        defaultServiceMode: Value(modeDbValue),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
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

  @override
  Future<void> updateRestaurantConfig({
    required String name,
    String? address,
    String? phone,
    String? ice,
    String? rc,
    String? identifiantFiscal,
  }) async {
    final config = await getRestaurantConfig();
    if (config == null) {
      return;
    }
    await (_db.update(_db.restaurantConfig)
          ..where((c) => c.id.equals(config.id)))
        .write(
      RestaurantConfigCompanion(
        name: Value(name),
        address: Value(address),
        phone: Value(phone),
        ice: Value(ice),
        rc: Value(rc),
        identifiantFiscal: Value(identifiantFiscal),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  @override
  Future<List<PrintStation>> getAllPrintStations() {
    return _db.select(_db.printStations).get();
  }

  @override
  Future<void> savePrintStation(PrintStation station) async {
    await _db.into(_db.printStations).insertOnConflictUpdate(
          PrintStationsCompanion(
            id: Value(station.id),
            name: Value(station.name),
            ipAddress: Value(station.ipAddress),
            type: Value(station.type),
            isActive: Value(station.isActive),
          ),
        );
  }

  @override
  Future<void> deletePrintStation(String id) async {
    await (_db.delete(_db.printStations)..where((s) => s.id.equals(id))).go();
  }
}
