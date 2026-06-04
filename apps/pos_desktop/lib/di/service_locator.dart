import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import '../services/print/pos_print_service.dart';
import '../services/accounting_export_service.dart';

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

  sl.registerLazySingleton<TimeAttendanceRepository>(
    () => TimeAttendanceRepositoryImpl(
      sl<AppDatabase>(),
      sl<AuthRepository>(),
    ),
  );

  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AnalyticsRepository>(
    () => AnalyticsRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<AccountingExportRepository>(
    () => AccountingExportRepositoryImpl(
      sl<AppDatabase>(),
      sl<OrderRepository>(),
      sl<CashSessionRepository>(),
    ),
  );

  sl.registerLazySingleton<AccountingExportService>(
    () => AccountingExportService(
      repository: sl<AccountingExportRepository>(),
    ),
  );

  sl.registerLazySingleton<AuditRepository>(
    () => AuditRepositoryImpl(sl<AppDatabase>()),
  );

  sl.registerLazySingleton<OrderRepository>(
    () => OrderRepositoryImpl(sl<AppDatabase>(), sl<AuditRepository>()),
  );

  sl.registerLazySingleton<KdsRepository>(
    () => KdsRepositoryImpl(
      sl<AppDatabase>(),
      sl<OrderRepository>(),
    ),
  );

  sl.registerLazySingleton<ReservationRepository>(
    () => ReservationRepositoryImpl(
      sl<AppDatabase>(),
      sl<OrderRepository>(),
    ),
  );

  sl.registerLazySingleton<FloorPlanRepository>(
    () => FloorPlanRepositoryImpl(
      sl<AppDatabase>(),
      sl<OrderRepository>(),
      sl<ReservationRepository>(),
    ),
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
