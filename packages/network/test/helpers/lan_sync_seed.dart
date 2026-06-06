import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:network/server/ws_message_handler.dart';

/// Données communes pour les tests sync mobile ↔ PC.
abstract final class LanSyncSeed {
  LanSyncSeed._();

  static const waiterId = kDefaultWaiterId;
  static const cashierId = 'cashier-e2e-001';
  static const tableId = 'table-e2e-001';
  static const zoneId = 'zone-e2e-001';
  static const categoryId = 'cat-e2e-001';
  static const productId = 'prod-e2e-001';
  static const orderId = 'order-e2e-001';
  static const orderItemId = 'item-e2e-001';

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
