import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart';

final sl = GetIt.instance;

void configureDependencies(AppDatabase database, WaiterNetworkClient networkClient) {
  if (sl.isRegistered<AppDatabase>()) {
    return;
  }

  // Database
  sl.registerSingleton<AppDatabase>(database);

  // Network Client
  sl.registerSingleton<WaiterNetworkClient>(networkClient);

  // Repositories
  sl.registerLazySingleton<AuditRepository>(
    () => AuditRepositoryImpl(database),
  );
  sl.registerLazySingleton<CashSessionRepository>(
    () => CashSessionRepositoryImpl(database, sl<AuditRepository>()),
  );
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(database),
  );
  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(database, sl<AuditRepository>()),
  );
  sl.registerLazySingleton<ReservationRepository>(
    () => ReservationRepositoryImpl(database, sl<OrderRepository>()),
  );
  sl.registerLazySingleton<FloorPlanRepository>(
    () => FloorPlanRepositoryImpl(
      database,
      sl<OrderRepository>(),
      sl<ReservationRepository>(),
    ),
  );
}

Future<void> resetDependencies() async {
  await sl.reset();
}
