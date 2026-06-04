import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import '../services/print/pos_print_service.dart';

/// Conteneur DI global de l'application caisse.
final GetIt sl = GetIt.instance;

/// Enregistre [AppDatabase] et les repositories métier.
void configureDependencies(AppDatabase database) {
  if (sl.isRegistered<AppDatabase>()) {
    return;
  }

  sl.registerSingleton<AppDatabase>(database);

  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AuditRepository>(
    () => AuditRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<AppDatabase>(), sl<AuditRepository>()),
  );

  sl.registerLazySingleton<CashSessionRepository>(
    () => CashSessionRepositoryImpl(sl<AppDatabase>(), sl<AuditRepository>()),
  );

  sl.registerLazySingleton<PrintRepository>(
    () => PrintRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<PosPrintService>(
    () => PosPrintService(
      printRepository: sl<PrintRepository>(),
      auditRepository: sl<AuditRepository>(),
    ),
  );
}

/// Réinitialise le conteneur (tests ou redémarrage).
Future<void> resetDependencies() async {
  if (sl.isRegistered<PosPrintService>()) {
    sl<PosPrintService>().dispose();
  }
  await sl.reset();
}
