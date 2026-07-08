import 'package:drift/drift.dart';

import '../utils/uuid_generator.dart';

import 'tables/audit_trail.dart';
import 'tables/cash_movements.dart';
import 'tables/cash_sessions.dart';
import 'tables/categories.dart';
import 'tables/discounts.dart';
import 'tables/ingredients.dart';
import 'tables/kitchen_notes.dart';
import 'tables/modifier_groups.dart';
import 'tables/modifier_options.dart';
import 'tables/order_item_modifiers.dart';
import 'tables/order_items.dart';
import 'tables/orders.dart';
import 'tables/payments.dart';
import 'tables/print_stations.dart';
import 'tables/product_modifiers.dart';
import 'tables/products.dart';
import 'tables/recipe_items.dart';
import 'tables/reservations.dart';
import 'tables/restaurant_config.dart';
import 'tables/restaurant_tables.dart';
import 'tables/sync_queue.dart';
import 'tables/time_attendance.dart';
import 'tables/security_rules.dart';
import 'tables/users.dart';
import 'tables/zones.dart';
import 'tables/vouchers.dart';
import 'tables/customers.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    RestaurantConfig,
    Users,
    SecurityRules,
    Zones,
    RestaurantTables,
    Reservations,
    TimeAttendance,
    PrintStations,
    Categories,
    Products,
    ModifierGroups,
    ModifierOptions,
    ProductModifiers,
    Ingredients,
    RecipeItems,
    CashSessions,
    CashMovements,
    Orders,
    OrderItems,
    OrderItemModifiers,
    Discounts,
    Payments,
    SyncQueue,
    AuditTrail,
    Vouchers,
    KitchenNotes,
    Customers,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {this.powerSyncManaged = false});

  /// `true` quand la base est ouverte via PowerSync (schéma géré côté sync).
  final bool powerSyncManaged;

  @override
  int get schemaVersion => 9;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          if (powerSyncManaged) {
            // PowerSync crée les vues ; Drift gère la table lien composite.
            await m.createTable(productModifiers);
          } else {
            await m.createAll();
          }
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 3) {
            await m.addColumn(orders, orders.companyName);
            await m.addColumn(orders, orders.companyIce);
            await m.addColumn(orders, orders.invoiceNumber);
          }
          if (from < 4) {
            await m.createTable(vouchers);
          }
          if (from < 5) {
            await m.addColumn(orders, orders.notes);
          }
          if (from < 6) {
            await m.addColumn(categories, categories.colorHex);
            await m.createTable(kitchenNotes);
          }
          if (from < 7) {
            await m.addColumn(products, products.productType);
          }
          if (from < 8) {
            await m.addColumn(users, users.accessLevel);
            await m.createTable(securityRules);
            await customStatement('''
              UPDATE users SET access_level = CASE
                WHEN role = 'ADMIN' THEN 9
                WHEN role = 'MANAGER' THEN 7
                WHEN role = 'CASHIER' THEN 3
                ELSE 0
              END
            ''');
          }
          if (from < 9) {
            await m.createTable(customers);
            await m.addColumn(orders, orders.customerId);
          }
        },
      );
}
