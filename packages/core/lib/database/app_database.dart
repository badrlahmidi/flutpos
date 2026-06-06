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
import 'tables/users.dart';
import 'tables/zones.dart';
import 'tables/vouchers.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    RestaurantConfig,
    Users,
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
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor, {this.powerSyncManaged = false});

  /// `true` quand la base est ouverte via PowerSync (schéma géré côté sync).
  final bool powerSyncManaged;

  @override
  int get schemaVersion => 7;

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
        },
      );
}
