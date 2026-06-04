// Simule une mise à jour catalogue cloud (silent update) en modifiant le prix local.
//
// Usage (POS ouvert sur la même base) :
//   dart run tools/cloud/simulate_catalog_price_update.dart --product-id <uuid> --price 22.5
//
// Avec chemin DB explicite (Windows) :
//   dart run tools/cloud/simulate_catalog_price_update.dart --db "%USERPROFILE%\Documents\ritagestion.db" --product-id ... --price 22.5

import 'dart:io';

import 'package:core/core.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final params = _parseArgs(args);
  final dbPath = params.dbPath ?? _defaultDbPath();
  final productId = params.productId;
  final newPrice = params.price;

  if (productId == null || newPrice == null) {
    stderr.writeln(
      'Arguments requis : --product-id <uuid> --price <montant>\n'
      'Optionnel : --db <chemin/ritagestion.db>',
    );
    exit(1);
  }

  final file = File(dbPath);
  if (!file.existsSync()) {
    stderr.writeln('Base introuvable : $dbPath');
    exit(1);
  }

  final db = AppDatabase(NativeDatabase(file));
  try {
    final updated = await (db.update(db.products)
          ..where((p) => p.id.equals(productId)))
        .write(ProductsCompanion(priceDineIn: Value(newPrice)));

    if (updated == 0) {
      stderr.writeln('Produit introuvable : $productId');
      exit(1);
    }

    stdout.writeln(
      'Prix mis à jour → $newPrice MAD pour $productId ($dbPath)\n'
      'Le POS doit rafraîchir la grille sans redémarrage (CatalogBloc watch).',
    );
  } finally {
    await db.close();
  }
}

String _defaultDbPath() {
  final home = Platform.environment['USERPROFILE'] ??
      Platform.environment['HOME'] ??
      Directory.current.path;
  return p.join(home, 'Documents', 'ritagestion.db');
}

({String? dbPath, String? productId, double? price}) _parseArgs(
  List<String> args,
) {
  String? dbPath;
  String? productId;
  double? price;

  for (var i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--db':
        dbPath = args[++i];
      case '--product-id':
        productId = args[++i];
      case '--price':
        price = double.tryParse(args[++i]);
    }
  }

  return (dbPath: dbPath, productId: productId, price: price);
}
