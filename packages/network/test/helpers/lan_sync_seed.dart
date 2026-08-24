import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:network/server/ws_message_handler.dart';

/// Données communes pour les tests sync mobile ↔ PC.
abstract final class LanSyncSeed {
  LanSyncSeed._();

  static const waiterId = kDefaultWaiterId;
  static const cashierId = 'd1b6a3f2-7c4e-4a9b-9f0d-2e5c8a1b3c7e';
  static const tableId = 'a1b2c3d4-e5f6-4a7b-8c9d-0e1f2a3b4c5d';
  static const zoneId = 'b2c3d4e5-f6a7-4b8c-9d0e-1f2a3b4c5d6e';
  static const categoryId = 'c3d4e5f6-a7b8-4c9d-8e0f-2a3b4c5d6e7f';
  static const productId = 'c9bf9e57-1685-4c89-bafb-ff5af830be8a';
  static const orderId = 'd4e5f6a7-b8c9-4d0e-9f1a-3b4c5d6e7f80';
  static const orderItemId = 'e5f6a7b8-c9d0-4e1f-a0b2-4c5d6e7f8091';

  static Future<void> seedPosCatalog(AppDatabase db) async {
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: const Value(waiterId),
            name: 'Serveur E2E',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: const Value(cashierId),
            name: 'Caissier E2E',
            pinHash: 'hash',
            role: 'CASHIER',
          ),
        );

    final cashRepo = CashSessionRepositoryImpl(
      db,
      AuditRepositoryImpl(db),
    );
    await cashRepo.openSession(userId: cashierId, openingBalance: 500);

    await db.into(db.zones).insert(
          ZonesCompanion.insert(
            id: const Value(zoneId),
            name: 'Salle E2E',
          ),
        );
    await db.into(db.restaurantTables).insert(
          RestaurantTablesCompanion.insert(
            id: const Value(tableId),
            zoneId: zoneId,
            name: 'T-E2E',
            capacity: 4,
          ),
        );
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: const Value(categoryId),
            name: 'Plats',
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(productId),
            categoryId: categoryId,
            name: 'Pastilla',
            priceDineIn: 75,
            nameAr: const Value('بسطيلة'),
          ),
        );
  }

  /// Catalogue minimal pour que [OrderRepository.getCompleteOrder] résolve les lignes.
  static Future<void> seedMobileCatalog(AppDatabase db) async {
    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: const Value(waiterId),
            name: 'Serveur E2E',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );

    final cashRepo = CashSessionRepositoryImpl(
      db,
      AuditRepositoryImpl(db),
    );
    await cashRepo.openSession(userId: waiterId, openingBalance: 0);

    await db.into(db.zones).insert(
          ZonesCompanion.insert(
            id: const Value(zoneId),
            name: 'Salle E2E',
          ),
        );
    await db.into(db.restaurantTables).insert(
          RestaurantTablesCompanion.insert(
            id: const Value(tableId),
            zoneId: zoneId,
            name: 'T-E2E',
            capacity: 4,
          ),
        );
    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: const Value(categoryId),
            name: 'Plats',
          ),
        );
    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value(productId),
            categoryId: categoryId,
            name: 'Pastilla',
            priceDineIn: 75,
          ),
        );
  }
}
