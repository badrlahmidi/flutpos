import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:test/test.dart';

void main() {
  late AppDatabase db;
  late ProductRepository products;
  late String categoryId;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    products = ProductRepositoryImpl(db);
    categoryId = 'cat-1';

    await db.into(db.categories).insert(
          CategoriesCompanion.insert(
            id: Value(categoryId),
            name: 'Boissons',
          ),
        );

    await db.into(db.products).insert(
          ProductsCompanion.insert(
            id: const Value('prod-1'),
            categoryId: categoryId,
            name: 'Café',
            priceDineIn: 15,
          ),
        );
  });

  tearDown(() async {
    await db.close();
  });

  test('watchProductsByCategory émet après mise à jour du prix', () async {
    final emissions = <List<Product>>[];
    final sub = products.watchProductsByCategory(categoryId).listen(emissions.add);

    await Future<void>.delayed(Duration.zero);
    expect(emissions.length, 1);
    expect(emissions.last.single.priceDineIn, 15);

    await (db.update(db.products)..where((p) => p.id.equals('prod-1'))).write(
      const ProductsCompanion(priceDineIn: Value(18)),
    );

    await Future<void>.delayed(Duration.zero);
    expect(emissions.length, greaterThan(1));
    expect(emissions.last.single.priceDineIn, 18);

    await sub.cancel();
  });

  test('watchActiveCategories émet quand une catégorie est désactivée', () async {
    final emissions = <List<Category>>[];
    final sub = products.watchActiveCategories().listen(emissions.add);

    await Future<void>.delayed(Duration.zero);
    expect(emissions.last.length, 1);

    await (db.update(db.categories)..where((c) => c.id.equals(categoryId)))
        .write(const CategoriesCompanion(isActive: Value(false)));

    await Future<void>.delayed(Duration.zero);
    expect(emissions.last, isEmpty);

    await sub.cancel();
  });
}
