import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../../utils/pin_hasher.dart';
import '../app_database.dart';

const _uuid = Uuid();

/// IDs stables pour reproductibilité des tests et démos.
abstract final class SeedIds {
  static const config = '00000000-0000-4000-8000-000000000001';
  static const userAdmin = '00000000-0000-4000-8000-000000000010';
  static const userCashier = '00000000-0000-4000-8000-000000000011';
  static const userWaiter = '00000000-0000-4000-8000-000000000012';
  static const zoneSalle = '00000000-0000-4000-8000-000000000020';
  static const zoneTerrasse = '00000000-0000-4000-8000-000000000021';
  static const zoneVip = '00000000-0000-4000-8000-000000000022';
  static const stationCuisine = '00000000-0000-4000-8000-000000000030';
  static const stationBar = '00000000-0000-4000-8000-000000000031';
  static const catEntrees = '00000000-0000-4000-8000-000000000040';
  static const catPlats = '00000000-0000-4000-8000-000000000041';
  static const catBoissons = '00000000-0000-4000-8000-000000000042';
  static const catDesserts = '00000000-0000-4000-8000-000000000043';
  static const modCuisson = '00000000-0000-4000-8000-000000000050';
  static const modSupplements = '00000000-0000-4000-8000-000000000051';
  static const modSauces = '00000000-0000-4000-8000-000000000052';
  static const productSteak = '00000000-0000-4000-8000-000000000060';
  static const productBurger = '00000000-0000-4000-8000-000000000061';
}

/// Injection des données de démo (catalogue, utilisateurs PIN, tables).
abstract final class DatabaseSeeder {
  DatabaseSeeder._();

  /// Retourne `true` si la base était vide et a été peuplée.
  static Future<bool> seedIfEmpty(AppDatabase db) async {
    final existing = await db.select(db.restaurantConfig).getSingleOrNull();
    if (existing != null) {
      return false;
    }
    await seed(db);
    return true;
  }

  static Future<void> seed(AppDatabase db) async {
    await _seedAll(db, DateTime.now().toUtc());
  }
}

Future<void> _seedAll(AppDatabase db, DateTime now) async {
  await db.into(db.restaurantConfig).insert(
        RestaurantConfigCompanion.insert(
          id: Value(SeedIds.config),
          name: 'Chez Ritaj',
          ice: const Value('001234567000089'),
          rc: const Value('123456'),
          address: const Value('12 Avenue Mohammed V, Casablanca'),
          phone: const Value('+212 5 22 00 00 00'),
          updatedAt: now,
        ),
      );

  await db.batch((batch) {
    batch.insertAll(db.users, [
      UsersCompanion.insert(
        id: Value(SeedIds.userAdmin),
        name: 'Admin Ritaj',
        pinHash: PinHasher.hashPin('1234'),
        role: 'ADMIN',
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      UsersCompanion.insert(
        id: Value(SeedIds.userCashier),
        name: 'Caissier Principal',
        pinHash: PinHasher.hashPin('5678'),
        role: 'CASHIER',
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
      UsersCompanion.insert(
        id: Value(SeedIds.userWaiter),
        name: 'Serveur Terrasse',
        pinHash: PinHasher.hashPin('9012'),
        role: 'WAITER',
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    ]);
  });

  await db.batch((batch) {
    batch.insertAll(db.zones, [
      ZonesCompanion.insert(
        id: Value(SeedIds.zoneSalle),
        name: 'Salle',
        sortOrder: const Value(0),
      ),
      ZonesCompanion.insert(
        id: Value(SeedIds.zoneTerrasse),
        name: 'Terrasse',
        sortOrder: const Value(1),
      ),
      ZonesCompanion.insert(
        id: Value(SeedIds.zoneVip),
        name: 'VIP',
        sortOrder: const Value(2),
      ),
    ]);
  });

  final tables = <RestaurantTablesCompanion>[
    for (var i = 1; i <= 4; i++)
      RestaurantTablesCompanion.insert(
        zoneId: SeedIds.zoneSalle,
        name: 'S$i',
        capacity: 4,
        posX: Value((i - 1) * 120.0),
        posY: const Value(80.0),
      ),
    for (var i = 1; i <= 3; i++)
      RestaurantTablesCompanion.insert(
        zoneId: SeedIds.zoneTerrasse,
        name: 'T$i',
        capacity: 2,
        posX: Value((i - 1) * 100.0),
        posY: const Value(200.0),
      ),
    RestaurantTablesCompanion.insert(
      zoneId: SeedIds.zoneVip,
      name: 'VIP-1',
      capacity: 8,
      posX: const Value(0.0),
      posY: const Value(320.0),
    ),
  ];
  await db.batch((batch) => batch.insertAll(db.restaurantTables, tables));

  await db.batch((batch) {
    batch.insertAll(db.printStations, [
      PrintStationsCompanion.insert(
        id: Value(SeedIds.stationCuisine),
        name: 'Cuisine',
        ipAddress: const Value('192.168.1.100'),
      ),
      PrintStationsCompanion.insert(
        id: Value(SeedIds.stationBar),
        name: 'Bar',
        ipAddress: const Value('192.168.1.101'),
      ),
    ]);
  });

  await db.batch((batch) {
    batch.insertAll(db.categories, [
      CategoriesCompanion.insert(
        id: Value(SeedIds.catEntrees),
        name: 'Entrées',
        nameAr: const Value('المقبلات'),
        printStationId: const Value(SeedIds.stationCuisine),
        sortOrder: const Value(0),
      ),
      CategoriesCompanion.insert(
        id: Value(SeedIds.catPlats),
        name: 'Plats',
        nameAr: const Value('الأطباق'),
        printStationId: const Value(SeedIds.stationCuisine),
        sortOrder: const Value(1),
      ),
      CategoriesCompanion.insert(
        id: Value(SeedIds.catBoissons),
        name: 'Boissons',
        nameAr: const Value('المشروبات'),
        printStationId: const Value(SeedIds.stationBar),
        sortOrder: const Value(2),
      ),
      CategoriesCompanion.insert(
        id: Value(SeedIds.catDesserts),
        name: 'Desserts',
        nameAr: const Value('الحلويات'),
        printStationId: const Value(SeedIds.stationCuisine),
        sortOrder: const Value(3),
      ),
    ]);
  });

  await _seedModifierGroups(db);
  await _seedProducts(db);
  await _seedIngredientsAndRecipes(db, now);
}

Future<void> _seedModifierGroups(AppDatabase db) async {
  await db.batch((batch) {
    batch.insertAll(db.modifierGroups, [
      ModifierGroupsCompanion.insert(
        id: Value(SeedIds.modCuisson),
        name: 'Cuisson',
        nameAr: const Value('الطبخ'),
        isMultipleChoice: false,
        isRequired: true,
      ),
      ModifierGroupsCompanion.insert(
        id: Value(SeedIds.modSupplements),
        name: 'Suppléments',
        nameAr: const Value('إضافات'),
        isMultipleChoice: true,
        isRequired: false,
      ),
      ModifierGroupsCompanion.insert(
        id: Value(SeedIds.modSauces),
        name: 'Sauces',
        nameAr: const Value('الصلصات'),
        isMultipleChoice: true,
        isRequired: false,
      ),
    ]);
  });

  await db.batch((batch) {
    batch.insertAll(db.modifierOptions, [
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modCuisson,
        name: 'Saignant',
        sortOrder: const Value(0),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modCuisson,
        name: 'À point',
        sortOrder: const Value(1),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modCuisson,
        name: 'Bien cuit',
        sortOrder: const Value(2),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modSupplements,
        name: 'Fromage',
        priceExtra: const Value(10.0),
        sortOrder: const Value(0),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modSupplements,
        name: 'Bacon',
        priceExtra: const Value(12.0),
        sortOrder: const Value(1),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modSauces,
        name: 'Ketchup',
        sortOrder: const Value(0),
      ),
      ModifierOptionsCompanion.insert(
        modifierGroupId: SeedIds.modSauces,
        name: 'Mayo',
        sortOrder: const Value(1),
      ),
    ]);
  });
}

Future<void> _seedProducts(AppDatabase db) async {
  final catalog = <({
    String id,
    String cat,
    String name,
    double dine,
    double? take,
    int sort,
  })>[
    (
      id: _uuid.v4(),
      cat: SeedIds.catEntrees,
      name: 'Salade Marocaine',
      dine: 35,
      take: 30,
      sort: 0,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catEntrees,
      name: 'Harira',
      dine: 25,
      take: 22,
      sort: 1,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catEntrees,
      name: 'Briouates au fromage',
      dine: 40,
      take: 35,
      sort: 2,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catPlats,
      name: 'Tajine Poulet',
      dine: 85,
      take: 80,
      sort: 3,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catPlats,
      name: 'Couscous Royal',
      dine: 120,
      take: 110,
      sort: 4,
    ),
    (
      id: SeedIds.productSteak,
      cat: SeedIds.catPlats,
      name: 'Steak Grillé',
      dine: 145,
      take: 140,
      sort: 5,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catPlats,
      name: 'Poisson du jour',
      dine: 95,
      take: 90,
      sort: 6,
    ),
    (
      id: SeedIds.productBurger,
      cat: SeedIds.catPlats,
      name: 'Burger Ritaj',
      dine: 75,
      take: 70,
      sort: 7,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catPlats,
      name: 'Pizza Margherita',
      dine: 65,
      take: 60,
      sort: 8,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catBoissons,
      name: 'Thé à la menthe',
      dine: 15,
      take: 15,
      sort: 9,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catBoissons,
      name: 'Coca-Cola 33cl',
      dine: 18,
      take: 18,
      sort: 10,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catBoissons,
      name: 'Jus d\'orange frais',
      dine: 22,
      take: 20,
      sort: 11,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catBoissons,
      name: 'Eau minérale 50cl',
      dine: 10,
      take: 10,
      sort: 12,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catDesserts,
      name: 'Pastilla au lait',
      dine: 45,
      take: 40,
      sort: 13,
    ),
    (
      id: _uuid.v4(),
      cat: SeedIds.catDesserts,
      name: 'Crème caramel',
      dine: 30,
      take: 28,
      sort: 14,
    ),
  ];

  await db.batch((batch) {
    for (final p in catalog) {
      batch.insert(
        db.products,
        ProductsCompanion.insert(
          id: Value(p.id),
          categoryId: p.cat,
          name: p.name,
          priceDineIn: p.dine,
          priceTakeaway: Value(p.take),
          sortOrder: Value(p.sort),
        ),
      );
    }
  });

  await db.batch((batch) {
    batch.insertAll(db.productModifiers, [
      ProductModifiersCompanion.insert(
        productId: SeedIds.productSteak,
        modifierGroupId: SeedIds.modCuisson,
      ),
      ProductModifiersCompanion.insert(
        productId: SeedIds.productBurger,
        modifierGroupId: SeedIds.modSupplements,
      ),
      ProductModifiersCompanion.insert(
        productId: SeedIds.productBurger,
        modifierGroupId: SeedIds.modSauces,
      ),
    ]);
  });
}

Future<void> _seedIngredientsAndRecipes(AppDatabase db, DateTime now) async {
  const ingBeef = '00000000-0000-4000-8000-000000000070';
  const ingBun = '00000000-0000-4000-8000-000000000071';

  await db.batch((batch) {
    batch.insertAll(db.ingredients, [
      IngredientsCompanion.insert(
        id: const Value(ingBeef),
        name: 'Bœuf',
        unit: 'kg',
        costPerUnit: 90,
        updatedAt: now,
      ),
      IngredientsCompanion.insert(
        id: const Value(ingBun),
        name: 'Pain burger',
        unit: 'pièce',
        costPerUnit: 3,
        updatedAt: now,
      ),
    ]);
  });

  await db.batch((batch) {
    batch.insertAll(db.recipeItems, [
      RecipeItemsCompanion.insert(
        productId: SeedIds.productSteak,
        ingredientId: ingBeef,
        quantityUsed: 0.25,
      ),
      RecipeItemsCompanion.insert(
        productId: SeedIds.productBurger,
        ingredientId: ingBeef,
        quantityUsed: 0.15,
      ),
      RecipeItemsCompanion.insert(
        productId: SeedIds.productBurger,
        ingredientId: ingBun,
        quantityUsed: 1,
      ),
    ]);
  });

  await db.batch((batch) {
    batch.insertAll(db.kitchenNotes, [
      KitchenNotesCompanion.insert(
        name: 'Sans oignon',
        nameAr: const Value('بدون بصل'),
        sortOrder: const Value(1),
      ),
      KitchenNotesCompanion.insert(
        name: 'Bien cuit',
        nameAr: const Value('مطبوخ جيداً'),
        sortOrder: const Value(2),
      ),
      KitchenNotesCompanion.insert(
        name: 'Peu salé',
        sortOrder: const Value(3),
      ),
    ]);
  });
}
