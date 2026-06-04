L'écosystème Flutter en 2026 a franchi un cap majeur pour les logiciels de caisse (POS) et la restauration. Les défis historiques — lenteurs sur le bureau, gestion chaotique des imprimantes, et lourdeur du code généré — ont de nouvelles solutions standards.

Voici l'état de l'art technique pour bâtir un POS robuste et évolutif cette année.

## 1. Hardware et Impression Thermique (Le grand nettoyage)

Gérer le protocole ESC/POS sur différents canaux (Réseau, USB, Bluetooth) nécessitait souvent de bricoler plusieurs librairies. L'écosystème s'est consolidé autour d'API unifiées qui gèrent nativement les tiroirs-caisses, les codes-barres et la découpe du papier.

| Librairie 2026 | Cas d'usage principal | Pourquoi l'utiliser |
| --- | --- | --- |
| `unified_esc_pos_printer` | Caisse centrale & Cuisine | La révélation 2026 : un seul PrinterManager gère USB, BLE, et Réseau (TCP/IP). |
| `flutter_thermal_printer_pos` | Impression sans fil | Excellent support de l'impression d'images complexes (logos) et des QR codes natifs. |
| `ns_ds_network` | Découverte réseau | Essentiel pour la découverte automatique des imprimantes IP (KDS/Cuisine). |

## 2. Bases de données "Offline-First" et Synchro Locale

Un POS de restaurant ne peut pas s'arrêter si la connexion internet du local saute. La tendance 2026 est au **Mesh Networking** et à la synchronisation asynchrone pour les architectures SaaS multi-tenant.

* **Ditto (Mesh Networking) :** Permet à plusieurs terminaux (ex: tablette serveur, écran cuisine, caisse principale) de se synchroniser entre eux en réseau local (LAN/Bluetooth) même sans internet.
* **PowerSync + Supabase :** Le duo idéal pour le cloud. Les données sont écrites localement dans une base SQLite, puis PowerSync gère la synchronisation en arrière-plan vers le serveur dès que la connexion revient, évitant toute perte de transaction.
* **Drift / Isar :** Pour le stockage local pur. **Drift** reste indispensable si ton système gère une trésorerie complexe avec des relations SQL fortes, tandis qu'**Isar** est imbattable pour la recherche textuelle ultra-rapide (ex: taper un nom de plat dans un catalogue de 2000 articles).

## 3. Architecture et Flutter Core

Les mises à jour de Flutter et Dart en 2026 apportent des gains de performance critiques pour les terminaux desktop (Windows/Linux) et les bornes tactiles Android.

* **Impeller sur Desktop & Android :** Le nouveau moteur de rendu Impeller remplace officiellement Skia. Il élimine complètement les micro-ralentissements (jank) lors du défilement des grandes grilles de menus avec images ou lors de l'ouverture des tiroirs de paiement.
* **Dart Macros (Fini `build_runner`) :** L'arrivée du "Static Metaprogramming" (comme la macro `@JsonCodable`) permet de générer la sérialisation JSON des commandes et des menus à la volée pendant la compilation. Tu n'as plus besoin d'attendre l'exécution de `build_runner` à chaque modification d'un modèle.
* **Wasm (WebAssembly) par défaut :** Si tu développes le panneau d'administration cloud (back-office) en Flutter Web, la compilation Wasm offre désormais des performances et une réactivité quasi identiques à du code natif.

## 4. Multi-fenêtrage et Interface

Le support du **Multi-Window** natif sur Windows et macOS est enfin stable. Depuis un seul code source Dart, tu peux désormais gérer deux fenêtres physiques séparées de manière asynchrone. C'est parfait pour afficher une interface complexe sur l'écran tactile du caissier, tout en détachant un récapitulatif de commande épuré sur l'écran orienté vers le client.

---------------------------------

Pour bâtir une architecture **PC First** (Caisse centrale sous Windows/Linux) couplée à une application **Mobile** pour les serveurs (Waiters), le choix des versions et des dépendances en 2026 doit être guidé par trois piliers : la stabilité du multi-fenêtrage sur PC, la légèreté sur mobile, et une base de données locale synchronisée.

Voici la stack technique validée et figée pour démarrer notre projet *from scratch*.

---

## 1. Versions Core (Flutter & Dart)

Nous partons sur la dernière version stable de 2026. Elle apporte le moteur de rendu **Impeller** activé par défaut sur Windows et Android (zéro ralentissement sur les listes de menus) et les **Macros Dart** qui éliminent le besoin de générer du code avec `build_runner`.

* **Flutter SDK :** `^3.40.0` (ou version stable actuelle de 2026)
* **Dart SDK :** `^3.8.0`
* **Target Platforms :**
* **Application Caisse :** `Windows` (PC de caisse principal)
* **Application Waiters :** `Android` / `iOS` (Smartphones/Tablettes serveurs)



---

## 2. Dépendances et Librairies Clés (2026)

### Gestion d'État (State Management) et Architecture

Pour un POS, l'état doit être ultra-prévisible (gestion du panier, sessions de caisse, modifications de tables).

* **`bloc` / `flutter_bloc` (`^9.0.0`) :** Le choix standard pour les systèmes critiques comme un POS. L'architecture BLoC permet de séparer strictement la logique métier (calcul des taxes, réductions) des interfaces PC et Mobile.

### Base de Données Locale & Synchronisation

La caisse PC sert de serveur local ou communique avec une base locale synchronisée.

* **`drift` (`^3.0.0`) + `drift_sqflite` / `sqlite3` :** Idéal pour stocker le catalogue de produits, l'état des tables et les transactions. Drift (anciennement Moor) offre une gestion relationnelle (SQL) robuste, essentielle pour la comptabilité d'une caisse.
* **`powersync` (`^1.5.0`) :** Utilisé pour la synchronisation *Offline-First*. Si internet coupe, la caisse et les terminaux mobiles continuent de fonctionner sur leur base SQLite locale. Dès que le réseau revient, PowerSync synchronise les commandes vers ton backend (Supabase/PostgreSQL) en arrière-plan.

### Matériel, Impression et Réseau Local

* **`unified_esc_pos_printer` (`^1.2.0`) :** La librairie unifiée pour l'impression thermique ESC/POS. Elle gère l'envoi des tickets en USB depuis le PC de caisse et l'envoi des bons de commande en Cuisine via le réseau (TCP/IP) depuis le PC ou les smartphones des serveurs.
* **`ns_ds_network` (`^1.0.5`) :** Pour que l'application mobile des serveurs détecte automatiquement l'adresse IP du PC de caisse principal sur le réseau local du restaurant.

### Interface Graphique (UI) Spécifique PC

* **`desktop_multi_window` (`^0.2.0`) :** Crucial pour la caisse sur PC. Permet d'ouvrir une deuxième fenêtre physique depuis l'application principale (ex: l'écran client qui affiche le total de la commande pendant que le caissier encaisse).
* **`window_manager` (`^0.4.0`) :** Permet de contrôler la fenêtre Windows (forcer le mode plein écran natif pour empêcher les caissiers de quitter l'application, définir des tailles minimales).

---

## 3. Synthèse du `pubspec.yaml` Initial

Voici le fichier de configuration de départ que nous allons utiliser pour initialiser les deux applications (ou un projet monorepo) :

```yaml
name: ritaj_pos_core
description: "Solution POS Restaurant 2026 - Caisse & Waiters"
version: 1.0.0+1

environment:
  sdk: ">=3.8.0 <4.0.0"
  flutter: ">=3.40.0"

dependencies:
  flutter:
    sdk: flutter

  # Gestion d'état
  flutter_bloc: ^9.0.0
  equatable: ^2.0.5

  # Base de données & Synchro Offline-First
  drift: ^3.0.0
  sqlite3_flutter_libs: ^0.5.0
  powersync: ^1.5.0

  # Réseau & Impression Hardware
  unified_esc_pos_printer: ^1.2.0
  ns_ds_network: ^1.0.5
  dio: ^5.5.0 # Pour les appels API back-office REST

  # UI & Spécificités Desktop (PC First)
  window_manager: ^0.4.0
  desktop_multi_window: ^0.2.0
  google_fonts: ^6.2.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  # Outils de développement
  drift_dev: ^3.0.0

```

---

## Prochaine étape

La stack étant validée pour 2026, nous pouvons concevoir la base proprement.

Pour concevoir une architecture de base de données digne d'un POS leader sur le marché, particulièrement dans un contexte *offline-first* (où la synchronisation réseau peut sauter), il y a une règle d'or : **toutes les tables doivent utiliser des identifiants uniques (UUID)** en format texte, et inclure des dates de création/mise à jour. Cela évite les conflits d'ID lorsque les serveurs prennent des commandes sur mobile hors ligne et se synchronisent ensuite avec la caisse.

Au-delà de tes champs, un système robuste exige de gérer les variantes (cuissons, suppléments), les plans de salle, et les sessions de caisse (clôture Z).

Voici la modélisation complète sous forme de tables **Drift** (Dart).

### 1. Organisation du Restaurant & Staff

```dart
// Utilisateurs (Caissiers, Serveurs, Managers)
class Users extends Table {
  TextColumn get id => text()(); // UUID
  TextColumn get name => text()();
  TextColumn get pin => text().withLength(min: 4, max: 6)();
  TextColumn get role => text()(); // Enum: ADMIN, CASHIER, WAITER
  BoolColumn get isActive => boolean().withDefault(const Constant(true))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Configuration des zones (Terrasse, Salle, VIP)
class Zones extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Tables physiques du restaurant
class RestaurantTables extends Table {
  TextColumn get id => text()();
  TextColumn get zoneId => text().references(Zones, #id)();
  TextColumn get name => text()(); // ex: "T12"
  IntColumn get capacity => integer()();
  TextColumn get status => text().withDefault(const Constant('FREE'))(); // FREE, OCCUPIED
  
  @override
  Set<Column> get primaryKey => {id};
}

```

### 2. Catalogue, Menus et Impression

```dart
// Stations d'impression (Cuisine, Bar, Caisse, Comptoir Glovo)
class PrintStations extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get ipAddress => text().nullable()();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Categories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get image => text().nullable()();
  TextColumn get printStationId => text().nullable().references(PrintStations, #id)();
  
  @override
  Set<Column> get primaryKey => {id};
}

class Products extends Table {
  TextColumn get id => text()();
  TextColumn get categoryId => text().references(Categories, #id)();
  TextColumn get name => text()();
  
  // Gestion des prix selon le canal
  RealColumn get priceDineIn => real()(); // Accepte 0 (ex: verre d'eau)
  RealColumn get priceTakeaway => real().nullable()(); // Si null, on utilisera priceDineIn
  RealColumn get priceDelivery => real().nullable()(); // ex: Prix Glovo/Deliveroo
  RealColumn get cost => real().nullable()(); // Coût de revient (Food cost)
  
  TextColumn get image => text().nullable()();
  TextColumn get defaultNotes => text().nullable()(); // Notes par défaut
  
  // Stock
  BoolColumn get trackStock => boolean().withDefault(const Constant(false))();
  RealColumn get currentStock => real().withDefault(const Constant(0))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Modificateurs (Crucial pour la restauration : Cuissons, Sauces, Suppléments)
class ModifierGroups extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()(); // ex: "Cuisson Viande", "Suppléments"
  BoolColumn get isMultipleChoice => boolean()();
  BoolColumn get isRequired => boolean()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Liaison Produit <-> Modificateurs (Un burger a des choix de cuisson)
class ProductModifiers extends Table {
  TextColumn get productId => text().references(Products, #id)();
  TextColumn get modifierGroupId => text().references(ModifierGroups, #id)();
}

```

### 3. Opérations, Commandes et Trésorerie

```dart
// Sessions de caisse (Ouverture, Clôture Z, Fonds de caisse)
class CashSessions extends Table {
  TextColumn get id => text()();
  TextColumn get cashierId => text().references(Users, #id)();
  DateTimeColumn get openedAt => dateTime()();
  DateTimeColumn get closedAt => dateTime().nullable()();
  RealColumn get openingBalance => real()();
  RealColumn get closingBalance => real().nullable()();
  TextColumn get status => text().withDefault(const Constant('OPEN'))();
  
  @override
  Set<Column> get primaryKey => {id};
}

// L'entête de la commande (Ticket)
class Orders extends Table {
  TextColumn get id => text()();
  TextColumn get sessionId => text().references(CashSessions, #id)();
  TextColumn get waiterId => text().references(Users, #id)();
  TextColumn get tableId => text().nullable().references(RestaurantTables, #id)(); // Null si emporter/livraison
  
  TextColumn get orderType => text()(); // DINE_IN, TAKEAWAY, DELIVERY
  TextColumn get status => text().withDefault(const Constant('OPEN'))(); // OPEN, SENT, PAID, CANCELLED
  
  IntColumn get guestCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// Les articles dans la commande
class OrderItems extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get productId => text().references(Products, #id)();
  
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()(); // Le prix figé au moment de la commande
  TextColumn get customNotes => text().nullable()(); // ex: "Sans oignons"
  
  TextColumn get status => text().withDefault(const Constant('PENDING'))(); // PENDING, PREPARING, SERVED
  
  @override
  Set<Column> get primaryKey => {id};
}

// Paiements (Permet le split-payment : payer une partie en espèces, une partie en carte)
class Payments extends Table {
  TextColumn get id => text()();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get paymentMethod => text()(); // CASH, CARD, TPE, CHEQUE
  RealColumn get amount => real()();
  DateTimeColumn get paidAt => dateTime()();
  
  @override
  Set<Column> get primaryKey => {id};
}

```

### Détails clés de cette architecture :

1. **Fallback des Prix :** Dans la logique métier, lors de l'ajout au panier, tu pourras faire : `price = orderType == 'TAKEAWAY' ? (product.priceTakeaway ?? product.priceDineIn) : product.priceDineIn`.
2. **OrderItems.unitPrice :** Il est impératif de copier le prix du produit dans la ligne de commande. Si tu modifies le prix d'un produit demain, cela ne doit pas altérer la comptabilité des tickets d'hier.
3. **PrintStation séparée :** En liant la station d'impression à la catégorie, dès qu'un serveur valide la commande, l'application vérifie chaque article : les boissons partent sur l'IP de l'imprimante du bar, les plats sur l'IP de la cuisine.


Voici comment configurer le fichier de base de données principal avec **Drift** et implémenter la logique métier pour regrouper nos données relationnelles.

Pour manipuler un ticket de caisse dans l'interface UI (sur le PC de caisse ou sur le mobile du serveur), nous avons besoin d'un **modèle agrégé** qui rassemble l'entête de la commande, la table, le serveur, les articles commandés et les détails des produits.

Voici l'implémentation complète dans ton fichier `app_database.dart` :

### 1. Définition des classes de données agrégées

Ces classes intermédiaires permettent de manipuler proprement un article avec son produit, ainsi qu'une commande complète.

```dart
import 'package:drift/drift.dart';
import 'package:drift_sqflite/drift_sqflite.dart'; // Ou native_database selon l'OS

// Import de tes fichiers de tables créés précédemment
// import 'tables.dart'; 

part 'app_database.g.dart';

/// Associe un article commandé avec les détails immuables du produit
class OrderItemWithProduct {
  final OrderItem orderItem;
  final Product product;

  OrderItemWithProduct({
    required this.orderItem,
    required this.product,
  });
}

/// Représente le ticket de caisse complet avec toutes ses relations
class CompleteOrder {
  final Order order;
  final RestaurantTable? table; // Null si à emporter ou livraison
  final User waiter;
  final List<OrderItemWithProduct> items;
  final List<Payment> payments;

  CompleteOrder({
    required this.order,
    this.table,
    required this.waiter,
    required this.items,
    required this.payments,
  });

  // Un getter bien pratique pour le calcul du total à la volée dans l'UI
  double get totalAmount => items.fold(0.0, (sum, item) => sum + (item.orderItem.quantity * item.orderItem.unitPrice));
  double get totalPaid => payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get remainingToPay => totalAmount - totalPaid;
}

```

### 2. Configuration de la Base de Données (`@DriftDatabase`)

C'est ici que l'on déclare toutes nos tables et qu'on écrit la requête relationnelle (Join).

```dart
@DriftDatabase(tables: [
  Users,
  Zones,
  RestaurantTables,
  PrintStations,
  Categories,
  Products,
  ModifierGroups,
  ProductModifiers,
  CashSessions,
  Orders,
  OrderItems,
  Payments,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase(QueryExecutor e) : super(e);

  @override
  int get schemaVersion => 1;

  // =========================================================================
  // REQUÊTE : Récupérer un ticket complet par son ID (Futur)
  // =========================================================================
  Future<CompleteOrder?> getCompleteOrder(String orderId) async {
    // 1. Récupérer l'entête, la table associée et le serveur
    final orderQuery = select(orders).join([
      leftOuterJoin(restaurantTables, restaurantTables.id.equalsExp(orders.tableId)),
      innerJoin(users, users.id.equalsExp(orders.waiterId)),
    ])..where(orders.id.equals(orderId));

    final orderRow = await orderQuery.getSingleOrNull();
    if (orderRow == null) return null;

    final orderData = orderRow.readTable(orders);
    final tableData = orderRow.readTableOrNull(restaurantTables);
    final waiterData = orderRow.readTable(users);

    // 2. Récupérer toutes les lignes d'articles de cette commande avec leur produit
    final itemsQuery = select(orderItems).join([
      innerJoin(products, products.id.equalsExp(orderItems.productId)),
    ])..where(orderItems.orderId.equals(orderId));

    final itemsRows = await itemsQuery.get();
    final itemsWithProducts = itemsRows.map((row) {
      return OrderItemWithProduct(
        orderItem: row.readTable(orderItems),
        product: row.readTable(products),
      );
    }).toList();

    // 3. Récupérer les paiements déjà effectués sur ce ticket
    final paymentsList = await (select(payments)
          ..where((t) => t.orderId.equals(orderId)))
        .get();

    return CompleteOrder(
      order: orderData,
      table: tableData,
      waiter: waiterData,
      items: itemsWithProducts,
      payments: paymentsList,
    );
  }

  // =========================================================================
  // REQUÊTE TEMPS RÉEL : Idéal pour l'écran de la caisse ou le suivi serveur (Stream)
  // =========================================================================
  Stream<CompleteOrder?> watchCompleteOrder(String orderId) {
    // Version Stream pour rafraîchir l'écran dès qu'un serveur ajoute un plat depuis son mobile
    return select(orders).join([
      leftOuterJoin(restaurantTables, restaurantTables.id.equalsExp(orders.tableId)),
      innerJoin(users, users.id.equalsExp(orders.waiterId)),
    ])..where(orders.id.equals(orderId))
    .watchSingleOrNull()
    .asyncMap((orderRow) async {
      if (orderRow == null) return null;

      final orderData = orderRow.readTable(orders);
      final tableData = orderRow.readTableOrNull(restaurantTables);
      final waiterData = orderRow.readTable(users);

      final itemsRows = await (select(orderItems).join([
        innerJoin(products, products.id.equalsExp(orderItems.productId)),
      ])..where(orderItems.orderId.equals(orderId))).get();

      final itemsWithProducts = itemsRows.map((row) {
        return OrderItemWithProduct(
          orderItem: row.readTable(orderItems),
          product: row.readTable(products),
        );
      }).toList();

      final paymentsList = await (select(payments)
            ..where((t) => t.orderId.equals(orderId)))
          .get();

      return CompleteOrder(
        order: orderData,
        table: tableData,
        waiter: waiterData,
        items: itemsWithProducts,
        payments: paymentsList,
      );
    });
  }
}

```

### Pourquoi cette approche est redoutable pour ton architecture PC + Mobile ?

1. **`watchCompleteOrder` (Réactivité locale) :** En utilisant un `Stream`, l'application PC du caissier se mettra à jour instantanément à l'écran dès que l'application mobile d'un serveur (Waiters) synchronisera une nouvelle ligne de commande dans la base locale.
2. **Indépendance des prix (`unitPrice`) :** Remarque bien que l'on calcule le `totalAmount` en multipliant `orderItem.quantity * orderItem.unitPrice`. Même si le prix du produit change dans la table `Products`, la facture reste inchangée et juste.

Mettre en place une architecture réseau locale fluide est le cœur d'un système POS performant. L'objectif est qu'un serveur se connecte au Wi-Fi du restaurant et que son application mobile trouve instantanément la caisse centrale, sans avoir à taper d'adresse IP manuellement.

Pour cela, nous allons combiner **Shelf** (pour le serveur HTTP/WebSocket ultra-léger en Dart sur le PC) et **ns_ds_network** (basé sur mDNS/Bonjour pour la découverte de services).

Voici comment architecturer cette communication.

---

## 1. Côté PC (Caisse) : Hébergement et Diffusion (Broadcasting)

Sur le PC de caisse Windows/Linux, l'application Flutter doit lancer un serveur local en arrière-plan et annoncer sa présence sur le réseau.

**Dépendances requises dans `pubspec.yaml` (PC) :**

```yaml
dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.0
  shelf_web_socket: ^1.0.0
  web_socket_channel: ^2.4.0
  ns_ds_network: ^1.0.5 # Pour le broadcast mDNS

```

**Implémentation du Serveur Local (`local_server.dart`) :**

```dart
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ns_ds_network/ns_ds_network.dart';

class PosNetworkServer {
  final int port = 8080;
  final String serviceType = '_ritajpos._tcp'; // Identifiant unique pour ton écosystème
  final String serviceName = 'Caisse Principale';
  
  List<WebSocketChannel> activeClients = [];

  Future<void> startServer() async {
    final router = Router();

    // 1. Route HTTP standard (ex: vérifier le statut)
    router.get('/ping', (Request request) {
      return Response.ok('{"status": "online", "version": "4.0.1"}', 
        headers: {'content-type': 'application/json'});
    });

    // 2. Route WebSocket (pour les commandes en temps réel)
    router.get('/ws', webSocketHandler((WebSocketChannel webSocket) {
      activeClients.add(webSocket);
      print('Nouveau terminal serveur connecté !');

      webSocket.stream.listen((message) {
        print('Commande reçue depuis mobile: $message');
        // Traiter l'ajout au panier via BLoC/Drift ici
        
        // Exemple : Confirmer la réception au mobile
        webSocket.sink.add('{"status": "received", "orderId": "..."}');
      }, onDone: () {
        activeClients.remove(webSocket);
      });
    }));

    // Lancement du serveur sur toutes les interfaces réseau (0.0.0.0)
    final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
    final server = await io.serve(handler, InternetAddress.anyIPv4, port);
    print('Serveur POS démarré sur le port ${server.port}');

    // 3. Diffuser le service sur le réseau local via mDNS
    await _broadcastService();
  }

  Future<void> _broadcastService() async {
    final ns = NsDsNetwork();
    await ns.registerService(
      type: serviceType,
      name: serviceName,
      port: port,
    );
    print('Service $serviceType diffusé sur le réseau local.');
  }
}

```

---

## 2. Côté Mobile (Waiters) : Découverte et Connexion

Sur l'application mobile (Android/iOS), le serveur ouvre l'application. Celle-ci scanne le réseau de manière asynchrone, trouve l'IP du PC, et s'y connecte automatiquement.

**Dépendances requises dans `pubspec.yaml` (Mobile) :**

```yaml
dependencies:
  dio: ^5.5.0
  web_socket_channel: ^2.4.0
  ns_ds_network: ^1.0.5 # Pour la découverte mDNS

```

**Implémentation du Client (`pos_client_service.dart`) :**

```dart
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ns_ds_network/ns_ds_network.dart';

class WaiterNetworkClient {
  final String serviceType = '_ritajpos._tcp';
  String? serverIp;
  int? serverPort;
  WebSocketChannel? _wsChannel;
  final Dio _dio = Dio();

  // 1. Découvrir la caisse sur le réseau
  Future<void> discoverAndConnect() async {
    final ns = NsDsNetwork();
    
    print('Recherche de la caisse principale...');
    
    // Écouter les services diffusés sur le réseau
    ns.discoverServices(serviceType).listen((ServiceInfo service) async {
      print('Caisse trouvée à IP: ${service.host} Port: ${service.port}');
      
      serverIp = service.host;
      serverPort = service.port;
      
      // Stopper la recherche une fois trouvée (optimisation batterie)
      ns.stopDiscovery(); 
      
      // 2. Établir la connexion WebSocket
      _connectWebSocket();
    });
  }

  void _connectWebSocket() {
    if (serverIp == null || serverPort == null) return;

    final wsUrl = Uri.parse('ws://$serverIp:$serverPort/ws');
    _wsChannel = WebSocketChannel.connect(wsUrl);

    _wsChannel!.stream.listen(
      (message) {
        print('Message de la caisse : $message');
        // Mettre à jour l'UI (ex: la cuisine a validé le plat)
      },
      onError: (error) => print('Erreur WebSocket: $error'),
      onDone: () => print('Déconnecté de la caisse. Tentative de reconnexion...'),
    );
  }

  // 3. Envoyer une commande (Exemple)
  void sendOrderToCaisse(String orderJson) {
    if (_wsChannel != null) {
      _wsChannel!.sink.add(orderJson);
    } else {
      // Fallback: Stocker dans PowerSync/Drift localement si hors ligne
      print('Caisse injoignable, sauvegarde locale...');
    }
  }
}

```

---

## 3. Gestion de la Déconnexion (Offline-First)

L'architecture ci-dessus gère le chemin critique ("Happy Path"). Toutefois, les serveurs vont se déplacer en terrasse où le Wi-Fi peut couper.

La logique d'intégration avec **PowerSync / Drift** intervient ici :

1. Le serveur (Waiter) prend la commande sur le mobile.
2. L'application enregistre **d'abord** la commande dans la base locale mobile (Drift).
3. Elle essaie d'envoyer la commande via WebSocket (`sendOrderToCaisse`).
4. Si le WebSocket est déconnecté, la commande reste en statut `PENDING_SYNC` en base locale. Dès que le `NsDsNetwork` retrouve la caisse, la file d'attente est purgée et envoyée.


-------------------------


Mettre en place une architecture réseau locale fluide est le cœur d'un système POS performant. L'objectif est qu'un serveur se connecte au Wi-Fi du restaurant et que son application mobile trouve instantanément la caisse centrale, sans avoir à taper d'adresse IP manuellement.

Pour cela, nous allons combiner **Shelf** (pour le serveur HTTP/WebSocket ultra-léger en Dart sur le PC) et **ns_ds_network** (basé sur mDNS/Bonjour pour la découverte de services).

Voici comment architecturer cette communication.

---

## 1. Côté PC (Caisse) : Hébergement et Diffusion (Broadcasting)

Sur le PC de caisse Windows/Linux, l'application Flutter doit lancer un serveur local en arrière-plan et annoncer sa présence sur le réseau.

**Dépendances requises dans `pubspec.yaml` (PC) :**

```yaml
dependencies:
  shelf: ^1.4.0
  shelf_router: ^1.1.0
  shelf_web_socket: ^1.0.0
  web_socket_channel: ^2.4.0
  ns_ds_network: ^1.0.5 # Pour le broadcast mDNS

```

**Implémentation du Serveur Local (`local_server.dart`) :**

```dart
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ns_ds_network/ns_ds_network.dart';

class PosNetworkServer {
  final int port = 8080;
  final String serviceType = '_ritajpos._tcp'; // Identifiant unique pour ton écosystème
  final String serviceName = 'Caisse Principale';
  
  List<WebSocketChannel> activeClients = [];

  Future<void> startServer() async {
    final router = Router();

    // 1. Route HTTP standard (ex: vérifier le statut)
    router.get('/ping', (Request request) {
      return Response.ok('{"status": "online", "version": "4.0.1"}', 
        headers: {'content-type': 'application/json'});
    });

    // 2. Route WebSocket (pour les commandes en temps réel)
    router.get('/ws', webSocketHandler((WebSocketChannel webSocket) {
      activeClients.add(webSocket);
      print('Nouveau terminal serveur connecté !');

      webSocket.stream.listen((message) {
        print('Commande reçue depuis mobile: $message');
        // Traiter l'ajout au panier via BLoC/Drift ici
        
        // Exemple : Confirmer la réception au mobile
        webSocket.sink.add('{"status": "received", "orderId": "..."}');
      }, onDone: () {
        activeClients.remove(webSocket);
      });
    }));

    // Lancement du serveur sur toutes les interfaces réseau (0.0.0.0)
    final handler = const Pipeline().addMiddleware(logRequests()).addHandler(router.call);
    final server = await io.serve(handler, InternetAddress.anyIPv4, port);
    print('Serveur POS démarré sur le port ${server.port}');

    // 3. Diffuser le service sur le réseau local via mDNS
    await _broadcastService();
  }

  Future<void> _broadcastService() async {
    final ns = NsDsNetwork();
    await ns.registerService(
      type: serviceType,
      name: serviceName,
      port: port,
    );
    print('Service $serviceType diffusé sur le réseau local.');
  }
}

```

---

## 2. Côté Mobile (Waiters) : Découverte et Connexion

Sur l'application mobile (Android/iOS), le serveur ouvre l'application. Celle-ci scanne le réseau de manière asynchrone, trouve l'IP du PC, et s'y connecte automatiquement.

**Dépendances requises dans `pubspec.yaml` (Mobile) :**

```yaml
dependencies:
  dio: ^5.5.0
  web_socket_channel: ^2.4.0
  ns_ds_network: ^1.0.5 # Pour la découverte mDNS

```

**Implémentation du Client (`pos_client_service.dart`) :**

```dart
import 'package:dio/dio.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:ns_ds_network/ns_ds_network.dart';

class WaiterNetworkClient {
  final String serviceType = '_ritajpos._tcp';
  String? serverIp;
  int? serverPort;
  WebSocketChannel? _wsChannel;
  final Dio _dio = Dio();

  // 1. Découvrir la caisse sur le réseau
  Future<void> discoverAndConnect() async {
    final ns = NsDsNetwork();
    
    print('Recherche de la caisse principale...');
    
    // Écouter les services diffusés sur le réseau
    ns.discoverServices(serviceType).listen((ServiceInfo service) async {
      print('Caisse trouvée à IP: ${service.host} Port: ${service.port}');
      
      serverIp = service.host;
      serverPort = service.port;
      
      // Stopper la recherche une fois trouvée (optimisation batterie)
      ns.stopDiscovery(); 
      
      // 2. Établir la connexion WebSocket
      _connectWebSocket();
    });
  }

  void _connectWebSocket() {
    if (serverIp == null || serverPort == null) return;

    final wsUrl = Uri.parse('ws://$serverIp:$serverPort/ws');
    _wsChannel = WebSocketChannel.connect(wsUrl);

    _wsChannel!.stream.listen(
      (message) {
        print('Message de la caisse : $message');
        // Mettre à jour l'UI (ex: la cuisine a validé le plat)
      },
      onError: (error) => print('Erreur WebSocket: $error'),
      onDone: () => print('Déconnecté de la caisse. Tentative de reconnexion...'),
    );
  }

  // 3. Envoyer une commande (Exemple)
  void sendOrderToCaisse(String orderJson) {
    if (_wsChannel != null) {
      _wsChannel!.sink.add(orderJson);
    } else {
      // Fallback: Stocker dans PowerSync/Drift localement si hors ligne
      print('Caisse injoignable, sauvegarde locale...');
    }
  }
}

```

---

## 3. Gestion de la Déconnexion (Offline-First)

L'architecture ci-dessus gère le chemin critique ("Happy Path"). Toutefois, les serveurs vont se déplacer en terrasse où le Wi-Fi peut couper.

La logique d'intégration avec **PowerSync / Drift** intervient ici :

1. Le serveur (Waiter) prend la commande sur le mobile.
2. L'application enregistre **d'abord** la commande dans la base locale mobile (Drift).
3. Elle essaie d'envoyer la commande via WebSocket (`sendOrderToCaisse`).
4. Si le WebSocket est déconnecté, la commande reste en statut `PENDING_SYNC` en base locale. Dès que le `NsDsNetwork` retrouve la caisse, la file d'attente est purgée et envoyée.


-----------------------------
Avant de taper la première ligne de code de notre architecture Flutter, il est crucial de cartographier toutes les fonctionnalités d'un POS moderne. Si l'on oublie une fonctionnalité majeure à cette étape (comme le paiement divisé), cela peut nous obliger à réécrire toute la base de données plus tard.

Pour qu'une solution puisse rivaliser avec les leaders du marché et potentiellement évoluer vers un modèle SaaS multi-boutiques, voici les modules fonctionnels indispensables à prévoir dès la conception :

### 1. Prise de Commande & Encaissement Avancé

C'est le cœur du système. Les cas simples sont faciles, mais le POS doit gérer les scénarios de restauration réels :

* **Le Split Bill (Partage de l'addition) :** La capacité de diviser une table par nombre de personnes (ex: diviser 500 DH par 3), ou par article (une personne paie son burger, l'autre paie sa salade).
* **Les Transferts & Fusions :** Un client veut changer de la table 4 à la terrasse (Table 12). Ou bien deux tables d'amis se rejoignent et veulent fusionner leurs additions.
* **Gestion des remises et offerts :** Remise en pourcentage (%) ou en montant fixe, applicable sur un seul article ou sur le ticket global, avec obligation d'avoir un PIN Manager pour valider l'action.
* **Taxes et Frais de Service :** Gestion de la TVA multiple (si les boissons alcoolisées n'ont pas la même taxe que la nourriture) et application automatique des frais de service ou d'emballage pour les commandes à emporter.

### 2. Back-Office, Stock et Fiches Techniques (Food Cost)

Un simple contrôle de stock "1 burger vendu = 1 burger en moins" ne suffit pas en restauration.

* **Fiches Techniques (Recettes) :** La vente d'un "Cheeseburger" doit déduire automatiquement 1 pain, 150g de viande hachée, et 1 tranche de cheddar du stock des matières premières.
* **Alertes de Stock Minimum :** Indiquer visuellement aux serveurs sur leur application mobile qu'il ne reste plus que 2 parts de gâteau au chocolat avant même qu'ils ne prennent la commande.
* **Inventaire et Pertes :** Module pour faire l'inventaire de fin de mois et déclarer les pertes (plats renvoyés, produits périmés).

### 3. Intégrations et Écosystème (Omnicanalité)

Le POS ne doit plus être une île isolée.

* **Agrégateurs de Livraison :** Une API entrante pour recevoir directement les commandes Glovo, Deliveroo ou du site web du restaurant directement sur la caisse PC, sans avoir besoin des tablettes spécifiques à ces livreurs.
* **Paiement Intégré (TPE) :** Connexion directe avec les terminaux de paiement par carte pour envoyer le montant automatiquement sans que le caissier n'ait à le retaper (évite les erreurs de saisie).

### 4. Gestion du Personnel et Sécurité

* **Pointage (Time & Attendance) :** Les employés utilisent leur code PIN ou un badge RFID sur l'écran du PC pour signaler leur arrivée (Clock-in) et leur départ (Clock-out).
* **Contrôle des Tiroirs-caisses (Cash Management) :** Suivi strict des entrées/sorties d'espèces (Pay-in / Pay-out), comme lorsqu'un manager prend 50 DH dans la caisse pour acheter du pain en urgence.
* **Audit Trail (Historique des actions) :** Enregistrer chaque action critique (annulation de plat, réouverture d'un ticket payé) avec l'ID de l'utilisateur et l'heure exacte pour éviter la fraude.

### 5. Vision Multi-tenant (Modèle SaaS)

Si tu déploies cette solution pour plusieurs clients ou franchises :

* **Synchronisation Cloud Master :** Un gérant qui possède 3 restaurants doit pouvoir changer le prix d'un café depuis un tableau de bord web, et l'information redescend instantanément sur les caisses PC des 3 locaux.
* **Dashboard Analytique :** Rapports de fin de journée (Clôture Z), produits les plus vendus, heures de pointe, et rentabilité par catégorie.

---


C'est la bonne approche. On garde cette feuille de route globale sous le coude pour itérer en mode Agile. L'objectif immédiat est de sécuriser et de blinder le "Core" du système : l'architecture locale, la synchronisation Drift/PowerSync, et la communication WebSocket entre la caisse et les terminaux.

Pour accélérer l'initialisation de ce projet de nouvelle génération, particulièrement si tu utilises des IDE avec des agents IA (comme Cursor, Windsurf ou Cline), la meilleure pratique consiste à regrouper tout ce que nous venons de définir dans un document de référence.

Voici le plan d'action pour le "Sprint 1" du développement :

### 1. Création du Workspace (Monorepo)

Puisque le code métier (modèles, logique de panier, structure WebSocket) sera partagé entre l'application PC et l'application Mobile, il est recommandé d'utiliser un monorepo avec **Melos** (le standard Flutter pour gérer plusieurs packages).

La structure idéale :

* `/packages/core` : Contient la base Drift, les modèles de données, et les entités métier (partagé).
* `/packages/network` : Contient la logique WebSocket, mDNS et API (partagé).
* `/apps/pos_desktop` : L'application Caisse principale sous Windows (UI PC).
* `/apps/waiter_mobile` : L'application pour la prise de commande des serveurs (UI Mobile).

### 2. Le fichier de contexte (Prompt Master)

Au lieu de copier-coller des bouts de code, tu peux créer un fichier `architecture.md` (ou `.cursorrules`) à la racine de ton projet. Tu y insères :

1. Le `pubspec.yaml` de base que nous avons défini.
2. Le schéma des tables Drift (Users, Orders, Products...).
3. La structure de l'Enveloppe JSON pour le WebSocket.

En fournissant ce contexte global à ton agent de codage, il générera les BLoCs, les interfaces et la logique de base en respectant strictement l'architecture *offline-first*, sans s'éparpiller.

### 3. Les premières briques à coder

Une fois l'environnement généré, l'ordre logique d'implémentation est le suivant :

1. **La couche Données :** Initialisation de Drift et génération du fichier `.g.dart`. Création de quelques données de test (Mock) pour un utilisateur, une table et deux produits.
2. **La couche Réseau :** Lancement du serveur Shelf sur l'application Desktop et test de connexion avec Postman (ou un script simple) pour valider que le WebSocket répond.
3. **L'UI Basique :** Un écran de caisse très brut avec une grille de produits et un panier, juste pour valider l'insertion dans la base locale.

---



C’est une excellente démarche. En tant que développeur, on a souvent tendance à penser "modèle de données" avant de penser "réalité du terrain". Dans la restauration, le logiciel de caisse n’est pas juste un outil comptable, c'est le système nerveux du service. S'il demande trop de clics, les serveurs vont le détester ; s'il n'est pas sécurisé, le patron perdra de l'argent.

Enfilons la casquette du restaurateur. Voici 50 scénarios réels, intenses et parfois chaotiques qui arrivent tous les jours, divisés en 5 zones d'opération. C'est ton **Product Backlog** ultime.

---

### Phase 1 : La Prise de Commande (La zone de guerre des serveurs)

1. **Le client veut un burger, sans tomate, supplément bacon, cuisson à point.**
* *Réponse POS :* Gestion des modificateurs (inclus, payants, obligatoires). L'UI mobile doit avoir des boutons rapides, pas de texte à taper manuellement.


2. **Le client demande le plat du jour, mais la cuisine vient d'épuiser le stock.**
* *Réponse POS :* Alerte de stock en temps réel. Dès que la cuisine signale la rupture (ou que le compteur atteint 0), le bouton se grise sur l'app de tous les serveurs instantanément via WebSocket.


3. **Table 4 commande tout d'un coup, mais veut les entrées d'abord, plats "à suivre".**
* *Réponse POS :* Notion de "Réclamé" / "Suite". Le ticket s'imprime en cuisine avec une ligne de séparation claire.


4. **Les clients ont fini l'entrée, il faut envoyer la suite.**
* *Réponse POS :* Bouton "Réclamer la suite" sur la table. Ça sort un petit ticket en cuisine : "Table 4 - ENVOYER LES PLATS".


5. **Le client est allergique aux arachides.**
* *Réponse POS :* Possibilité d'ajouter une note libre en rouge clignotant sur le ticket cuisine.


6. **Le Wi-Fi de la terrasse saute pendant que le serveur prend une grosse commande.**
* *Réponse POS :* Architecture *Offline-First*. L'application mobile enregistre la commande en SQLite local et l'envoie silencieusement dès que le serveur repasse la porte.


7. **Le serveur s'est trompé et a envoyé la commande sur la Table 8 au lieu de la 9.**
* *Réponse POS :* Fonction "Transférer les articles" vers une autre table avant que la note ne soit sortie.


8. **Le client est assis, mais demande que son dessert soit emballé pour l'emporter.**
* *Réponse POS :* Changement de type de commande par article (Dine-in vs Takeaway), appliquant potentiellement un frais d'emballage (+2 DH) et désactivant la TVA sur place si applicable.


9. **Le menu enfant inclut un dessert, mais l'enfant le choisira plus tard.**
* *Réponse POS :* Les formules (Combos) doivent accepter des éléments "en attente de sélection" sans bloquer l'envoi de la commande principale.


10. **Une commande Glovo/Deliveroo sonne en plein rush.**
* *Réponse POS :* Le POS doit émettre un son distinct. La commande s'intègre directement sans que le caissier ne doive tout retaper.



---

### Phase 2 : Gestion de la Salle (Le Tétris du Manager)

11. **Deux amis (Table 2) croisent trois autres amis (Table 5) et rejoignent leur table.**
* *Réponse POS :* Fonction "Fusionner Tables". Les deux tickets sont combinés, la Table 2 redevient "Libre".


12. **C'est le moment de payer. Ils sont 4 et veulent diviser l'addition globale par 4.**
* *Réponse POS :* Fonction "Split Bill by Amount". L'addition de 400 DH génère 4 sous-tickets de 100 DH.


13. **C'est le moment de payer. Chacun veut payer EXACTEMENT ce qu'il a mangé.**
* *Réponse POS :* Fonction "Split by Item". Interface drag-and-drop sur le PC pour glisser le coca de l'un et la pizza de l'autre dans des tickets séparés.


14. **Le client refuse de payer son plat car il était froid.**
* *Réponse POS :* Fonction "Offert/Annulé" (Void) avec obligation de saisir le code PIN du manager et de choisir une raison (ex: "Erreur Cuisine", "Plat froid").


15. **Un client part en courant sans payer (Resto-Basket).**
* *Réponse POS :* Clôture du ticket en mode "Perte / Vol" pour que la caisse balance sans mettre le caissier en défaut.


16. **Le patron arrive avec un invité VIP. Repas 100% offert.**
* *Réponse POS :* Remise de 100% sur le ticket. Le coût des ingrédients est quand même déduit du stock.


17. **Changement de nombre de couverts en cours de service.**
* *Réponse POS :* Ajustement possible pour que le ratio "Panier moyen par client" dans les statistiques de fin de mois soit correct.


18. **Un client annule son supplément frites juste après la commande.**
* *Réponse POS :* Si le ticket n'est pas encore imprimé (délai de grâce de 30s), annulation invisible. Si déjà imprimé, impression d'un ticket "ANNULATION FRITES" rouge en cuisine.


19. **Réservation pour ce soir à 20h30.**
* *Réponse POS :* Module basique de réservation bloquant le statut de la table à partir de 20h.


20. **Le restaurant fait du "Service Rapide" le midi et du "Service à Table" le soir.**
* *Réponse POS :* Le système doit basculer du mode "Paiement avant consommation" (Fast-food) au mode "Ouvrir une table" en un clic.



---

### Phase 3 : Cuisine & Impression (Le nerf de la guerre)

21. **Un ticket contient un Mojito, une Salade et un Café.**
* *Réponse POS :* Routing intelligent. Le Mojito et le Café sortent sur l'imprimante IP du Bar, la Salade sort sur l'imprimante IP de la Cuisine.


22. **L'imprimante cuisine n'a plus de papier, les commandes s'accumulent.**
* *Réponse POS :* File d'attente d'impression en base de données. Quand on remet le papier, on peut cliquer sur "Réimprimer les tickets non sortis" depuis le PC.


23. **Le serveur tape "Viande bien cuite", le chef ne lit que l'arabe.**
* *Réponse POS :* Double nommage dans la base de données. L'UI serveur affiche le français, le ticket cuisine imprime l'alias en arabe.


24. **Le chef fait tomber le ticket dans la sauce.**
* *Réponse POS :* Bouton "Réimprimer le ticket de préparation" depuis n'importe quel terminal.


25. **"Est-ce que je peux avoir la sauce de la salade César, mais sur mon Burger ?"**
* *Réponse POS :* Bouton "Message Libre" sur le clavier du mobile pour des requêtes non standardisées.


26. **Un ticket Glovo doit sortir, mais c'est le livreur qui attend.**
* *Réponse POS :* Le ticket de préparation doit inclure en gros le numéro de commande du livreur (#1455) et non un numéro de table.


27. **Le propriétaire installe un Écran Cuisine (KDS) au lieu d'une imprimante.**
* *Réponse POS :* Les commandes s'affichent sur une tablette via WebSocket. Le cuisinier tape sur le plat pour le passer en "Prêt", ce qui envoie une notif au serveur.


28. **Le barman est noyé sous les commandes individuelles.**
* *Réponse POS :* Mode "Regroupement" sur le ticket de synthèse : S'il y a 4 tables qui commandent 1 café, le barman voit "4 x Café" en gros au lieu de lire 4 petits tickets.


29. **Un produit doit être scanné au code-barres (ex: une canette à emporter).**
* *Réponse POS :* Le champ de recherche PC doit être focusé par défaut pour qu'un coup de douchette scanne immédiatement l'article sans utiliser la souris.


30. **La commande est "À emporter" (Takeaway).**
* *Réponse POS :* Le ticket cuisine doit le spécifier en gras pour que la cuisine le mette dans une barquette fermée et non sur une assiette.



---

### Phase 4 : Encaissement & Trésorerie (L'argent de la journée)

31. **Le client paie 500 DH. Le ticket fait 320 DH. Il paie 200 par Carte et 300 en Espèces.**
* *Réponse POS :* Split Payment multi-méthodes. Le système calcule la monnaie à rendre (-180 DH en espèces).


32. **Le client demande l'addition avant de payer.**
* *Réponse POS :* Bouton "Imprimer Proforma". Ça verrouille la table pour que le serveur n'ajoute plus de plats par erreur pendant que le client prépare sa carte.


33. **Le manager donne 100 DH de la caisse au plongeur pour aller acheter du pain en urgence.**
* *Réponse POS :* Bouton "Pay-out" (Sortie de caisse) pour tracer ce trou dans la trésorerie lors du comptage final.


34. **Le client a besoin d'une facture pour son entreprise.**
* *Réponse POS :* Bouton "Facture". Saisie rapide du Nom de l'entreprise et de l'ICE (Identifiant Commun d'Entreprise) pour l'impression.


35. **Fin du service à 1h du matin : Le caissier compte les billets.**
* *Réponse POS :* Le "X-Report" (Brouillard de caisse) lui dit combien il devrait avoir. Le "Z-Report" (Clôture) gèle les données de la journée et les envoie au serveur cloud.


36. **La caisse a un déficit de 30 DH à la clôture.**
* *Réponse POS :* Le système exige une "Raison d'écart" validée par le manager pour valider la clôture Z.


37. **Paiement TPE refusé, mais le caissier a déjà cliqué sur "Payé par Carte".**
* *Réponse POS :* Réouverture du ticket (nécessite PIN) pour changer le moyen de paiement en espèces.


38. **Un client utilise un bon de réduction de 50 DH gagné sur Instagram.**
* *Réponse POS :* Gestion des Vouchers. Scanner le QR code ou taper le code pour déduire le montant net.


39. **Les employés ont droit à 1 repas gratuit par jour.**
* *Réponse POS :* Compte "Consommation Personnel". Le coût est enregistré, mais n'impacte pas le chiffre d'affaires imposable.


40. **Le tiroir-caisse s'ouvre tout seul.**
* *Réponse POS :* Le logiciel doit envoyer la commande ESC/POS d'ouverture (`27 112 0 25 250`) *uniquement* lors d'un paiement en espèces ou d'une autorisation manager.



---

### Phase 5 : Back-Office, Multi-tenant & Statistiques (La direction)

41. **Le propriétaire veut changer le prix du Coca de 15 à 18 DH.**
* *Réponse POS :* Il le fait sur son panel web à la maison. PowerSync pousse la mise à jour (Silent Update) sur le PC du restaurant sans couper la caisse.


42. **Un serveur arrive au travail.**
* *Réponse POS :* Module "Pointage" (Clock-in) via un code PIN ou badge RFID sur l'écran PC, calculant ses heures travaillées.


43. **Une bouteille de lait tourne et on doit la jeter.**
* *Réponse POS :* Module "Pertes/Démarque". On scanne le lait, on choisit "Périmé", le stock est mis à jour sans générer de revenus.


44. **Le serveur a oublié son code PIN en plein rush.**
* *Réponse POS :* Le manager peut réinitialiser le PIN instantanément depuis le back-office PC sans redémarrer l'application.


45. **Le PC grille à cause d'une surtension électrique.**
* *Réponse POS :* Le gérant achète un PC d'urgence, télécharge l'app Ritagestion, s'identifie, et Supabase/PowerSync redescend toute la base de données et les tables ouvertes en 1 minute.


46. **Il faut gérer le menu du Ramadan (Ftour) avec des articles spéciaux.**
* *Réponse POS :* Menus programmés. La catégorie "Ftour" n'apparaît sur les tablettes qu'entre 18h et 21h.


47. **Le comptable veut exporter le chiffre d'affaires à la fin du mois.**
* *Réponse POS :* Export CSV/Excel automatisé depuis le cloud avec la séparation du CA sur place, livraison, et par TVA.


48. **Food Cost : Chaque pizza vendue doit déduire le fromage.**
* *Réponse POS :* Fiches techniques. Un produit fini = une nomenclature d'ingrédients déduits dynamiquement.


49. **Le gérant gère 3 restaurants dans 3 villes.**
* *Réponse POS :* Tableau de bord cloud consolidé (Multi-tenant) pour voir le CA global, ou filtrer par succursale.


50. **Analyser les performances de l'équipe.**
* *Réponse POS :* Rapport "Ventes par serveur" pour identifier qui fait le plus d'upsell (vendre des cafés/desserts) pour les primer.



---


C'est la méthode de travail parfaite. En fournissant ces fichiers à ton IDE (Cursor, Windsurf, ou Cline), l'agent IA aura une compréhension globale de l'architecture de Ritagestion et du contexte métier. Il ne te proposera plus de code générique, mais des solutions adaptées à ton écosystème *Offline-First*.

Voici les 4 fichiers Markdown à créer à la racine de ton projet (dans un dossier `docs/` ou `.cursor/rules/`). Tu peux les copier-coller directement.

### 1. Fichier : `01_project_context_and_stack.md`

Ce fichier définit les règles de base, les versions et la philosophie architecturale.

```markdown
# Contexte du Projet : RitajPOS / Ritagestion (Édition 2026)

## 1. Vision et Objectif
Développement d'une solution POS (Point of Sale) de nouvelle génération pour la restauration, conçue pour être "Offline-First". Le système doit fonctionner sans interruption même en cas de coupure internet, avec une synchronisation transparente des données dès le retour du réseau. 
L'architecture repose sur un modèle "PC First" pour la caisse principale, avec des applications mobiles légères pour la prise de commande par les serveurs.

## 2. Tech Stack (2026)
- **Framework Core :** Flutter ^3.40.0, Dart ^3.8.0 (Impeller activé, Dart Macros utilisés).
- **Architecture d'état :** BLoC (`flutter_bloc` ^9.0.0).
- **Base de données locale :** Drift (`drift` ^3.0.0) avec SQLite.
- **Synchronisation Cloud :** PowerSync (`powersync` ^1.5.0) + Supabase/PostgreSQL.
- **Réseau Local & Découverte :** `ns_ds_network` (mDNS) + `shelf` (Serveur WebSocket local).
- **Impression Hardware :** `unified_esc_pos_printer` ^1.2.0 (USB, Ethernet, Bluetooth).
- **UI Desktop :** `desktop_multi_window`, `window_manager`.

## 3. Règles d'Architecture Strictes pour l'Agent IA
1. **Identifiants :** Toutes les tables de la base de données doivent utiliser des UUID (String) pour éviter les conflits de synchronisation.
2. **Offline-First :** Aucune action métier (ajout au panier, paiement) ne doit dépendre d'un appel API externe en temps réel. Tout est écrit en local via Drift, puis synchronisé.
3. **Séparation des préoccupations :** Le code métier (BLoC/Drift) doit être agnostique de l'UI.
4. **Idempotence :** Les messages réseau WebSocket doivent tous posséder un `messageId` unique.

```

---

### 2. Fichier : `02_database_schema.md`

Ce fichier dicte à l'IA comment structurer les entités Drift.

```markdown
# Schéma de Base de Données (Drift / SQLite)

Le système utilise une base de données relationnelle locale. Voici les tables principales et leurs relations.

## Entités Principales
- **Users :** `id` (UUID), `name`, `pin` (4-6 digits), `role` (ADMIN, CASHIER, WAITER).
- **Zones & RestaurantTables :** Gestion du plan de salle. Une zone (ex: Terrasse) contient plusieurs tables.
- **PrintStations :** `id`, `name`, `ipAddress`. Gère le routage d'impression (Bar, Cuisine).

## Catalogue (Produits et Menus)
- **Categories :** `id`, `name`, `printStationId` (Clé étrangère pour le routage).
- **Products :** `id`, `categoryId`, `name`, `priceDineIn`, `priceTakeaway` (nullable), `priceDelivery` (nullable), `trackStock` (boolean).
- **ModifierGroups & ProductModifiers :** Gestion des suppléments (ex: Cuissons, Sauces).

## Opérations (Commandes et Trésorerie)
- **CashSessions :** Session de caisse (Ouverture, Clôture Z, Fonds de caisse).
- **Orders :** Entête du ticket. `id`, `sessionId`, `waiterId`, `tableId` (nullable), `orderType` (DINE_IN, TAKEAWAY, DELIVERY), `status` (OPEN, SENT, PAID, CANCELLED).
- **OrderItems :** Lignes de commande. `id`, `orderId`, `productId`, `quantity`, `unitPrice` (figé au moment de la commande), `status` (PENDING, PREPARING, SERVED).
- **Payments :** `id`, `orderId`, `paymentMethod` (CASH, CARD, TPE), `amount`. Permet le Split Payment.

**Règle de calcul de l'UI :** Le montant total d'une commande se calcule TOUJOURS en multipliant la `quantity` par le `unitPrice` de la table `OrderItems`, et jamais en appelant le prix actuel de la table `Products`.

```

---

### 3. Fichier : `03_network_protocol.md`

Ce fichier est crucial pour que l'IA génère les bonnes classes de communication entre le mobile et le PC.

```markdown
# Protocole Réseau Local (WebSocket)

L'application Mobile (Serveurs) et l'application Desktop (Caisse) communiquent via WebSocket en réseau local. La découverte se fait via mDNS (`_ritajpos._tcp`).

## L'Enveloppe JSON Standard
Tous les messages échangés doivent respecter cette structure stricte (Event Envelope) :

```json
{
  "messageId": "UUID-UNIQUE-POUR-CE-MESSAGE",
  "action": "ACTION_NAME",
  "timestamp": "ISO-8601-DATE",
  "deviceId": "ID_DU_TERMINAL",
  "payload": { ... }
}

```

## Actions Principales Supportées

* **CREATE_ORDER :** Ouverture d'une nouvelle table avec un panier initial.
* **ADD_ITEMS :** Ajout de produits à une commande existante.
* **VOID_ITEM :** Annulation d'un produit (nécessite la raison et l'ID d'autorisation dans le payload).
* **ACK :** Accusé de réception obligatoire envoyé par le PC. Le payload contient le `status` (SUCCESS/ERROR).

## Logique de Synchronisation Mobile

1. Le mobile écrit la commande dans sa base Drift locale (table `SyncQueue`).
2. Il tente d'envoyer le JSON via WebSocket.
3. À la réception de l'événement `ACK` depuis le PC, le mobile supprime la ligne de sa `SyncQueue`.

```

---

### 4. Fichier : `04_business_scenarios_qa.md`
C'est le fichier "Cahier des charges". Il empêchera l'IA d'oublier des cas particuliers (edge cases) quand elle écrira la logique métier.

```markdown
# Scénarios Métier (Product Backlog POS)

Le système doit être capable de gérer de manière native et fluide les scénarios de restauration suivants. Le code métier (BLoC) doit prévoir ces états.

## 1. Prise de Commande (Waiters)
- Modification avancée : Un produit peut avoir des suppléments payants ou gratuits (Modificateurs).
- Gestion des "Réclamés / À suivre" pour gérer l'ordre d'envoi des plats en cuisine.
- Changement à la volée du type de commande (sur place vers à emporter) modifiant potentiellement le prix ou la TVA.
- Mode Offline : Prise de commande ininterrompue même en zone morte Wi-Fi (ex: Terrasse).

## 2. Gestion de la Salle & Encaissement (Cashier)
- Transfert de table : Déplacer l'intégralité d'une commande d'une table A vers une table B.
- Fusion : Combiner deux tickets ouverts en un seul.
- Split Bill : Paiement divisé par montant égal, ou divisé par articles (drag-and-drop).
- Multi-paiements : Un même ticket peut être payé avec 3 méthodes différentes (ex: Espèces + Carte + Chèque).
- Remises et Offerts (Void) : Application de pourcentages ou montants fixes avec traçabilité de l'utilisateur (Audit Trail).

## 3. Cuisine & Impression
- Routage conditionnel : Les boissons s'impriment au bar, les plats chauds en cuisine, basés sur l'IP définie dans `Categories`.
- Gestion des défaillances matérielles : File d'attente d'impression et réimpression manuelle en cas de panne de papier.
- Groupement d'articles : Regrouper les articles identiques sur le ticket de préparation (ex: 4x Café).

## 4. Back-Office & Opérations
- Mouvements de caisse : Entrées (Pay-in) et Sorties (Pay-out) indépendantes des ventes.
- Clôture Z : Vérification de l'équilibre de la caisse avec gestion des écarts justifiés.
- Food Cost : Les produits finis doivent pouvoir déduire des matières premières (Ingrédients) via une nomenclature de fiche technique.

```


C'est le piège classique avec les agents IA. Quand on manipule des outils comme Cursor, Windsurf, Cline ou Claude Code, si on leur dit simplement "Crée un écran de caisse", ils vont générer une interface générique, souvent moche, avec des couleurs codées en dur et des boutons trop petits pour un usage tactile rapide.

L'IA est une excellente exécutante, mais une très mauvaise directrice artistique. Pour obtenir une UI/UX premium sans la laisser deviner, il faut la contraindre avec un cadre strict et adopter la méthode du "Component-First".

Voici le plan de bataille pour verrouiller l'UI/UX.

### 1. Figer le Design System (Le garde-fou absolu)

L'agent ne doit **jamais** choisir un espacement (padding), une couleur ou une taille de police au hasard. Tu dois créer un fichier de référence supplémentaire (ex: `05_design_system.md`) qui dicte les règles visuelles.

Dans ce fichier, impose tes variables :

* **Couleurs :** Définis le `primary` (ex: la couleur de Ritaj Informatique ou de la marque), `secondary`, `error` (rouge vif pour les annulations), `surface` (couleur des cartes).
* **Espacements (Spacing) :** Impose un système de grille stricte. "Utilise uniquement des multiples de 8 (8, 16, 24, 32) pour les paddings et margins."
* **Typographie :** Définis les styles (`headlineLarge`, `bodyMedium`).
* **Règle d'or pour l'agent :** Ajoute cette consigne stricte : *"INTERDICTION de coder des couleurs ou des paddings en dur dans les widgets. Tu dois obligatoirement utiliser `Theme.of(context).colorScheme` et `Theme.of(context).textTheme`."*

### 2. La technique du "Image-to-Code" (Vision Management)

Les LLM récents (Claude 3.5 Sonnet, GPT-4o) sont incroyablement performants en vision. Ne leur décris pas l'interface avec du texte, montre-leur.

1. Fais des captures d'écran des leaders du marché (Toast, Lightspeed, Square) ou trouve des concepts de POS sur Dribbble.
2. Glisse l'image dans ton prompt sur Cursor/Windsurf.
3. Demande : *"Analyse cette image. Ne te préoccupe pas de la logique métier pour l'instant. Reproduis exactement cette structure UI (tailles relatives, disposition des colonnes, alignements) en Flutter, en appliquant les couleurs et espacements de notre `05_design_system.md`."*

### 3. L'approche "Atomic Design" (Étape par étape)

Si tu demandes un écran complet, l'agent va paniquer et faire du code spaghetti. Tu dois lui faire construire l'interface brique par brique.

* **Étape 1 (Les atomes) :** Demande de coder un `PosButton` standardisé, puis un `PriceTag`.
* **Étape 2 (Les molécules) :** Demande de coder la `ProductCard` (qui inclut l'image, le nom, et le `PriceTag`).
* **Étape 3 (Les organismes) :** Demande de coder la `ProductsGrid` (qui affiche une liste de `ProductCard`).
* **Étape 4 (La page) :** Demande enfin d'assembler la grille avec la barre de menu latérale et le panneau du panier.

### 4. Injecter les Lois de l'UX Restauration (Fat-Finger Rules)

Dans ton contexte, ajoute ces règles UX non-négociables pour brider les choix de l'agent :

* **Touch Targets :** Précise que *"Cette application est utilisée par des serveurs en mouvement ou sur des écrans tactiles industriels. Tous les boutons cliquables (IconButtons, ListTiles) doivent avoir une zone de contact minimale de 64x64 pixels. Pas de petits textes."*
* **Zéro défilement horizontal :** Les serveurs détestent scroller horizontalement (c'est lent et imprécis). Impose à l'agent : *"Les catégories de menus doivent s'afficher sur une grille ou une liste verticale, jamais de ListView horizontal."*
* **Contraste visuel :** *"L'écran de caisse est la zone critique. Le bouton 'PAYER' doit être le plus massif de l'écran et utiliser une couleur de fond pleine, distincte de toutes les autres actions."*


Absolument. Ce fichier sera le "cerveau visuel" de ton agent. En l'ajoutant aux autres fichiers de contexte, tu t'assures que l'interface générée pour Ritagestion sera cohérente, professionnelle et surtout adaptée aux contraintes physiques d'un environnement de restauration.

Voici le contenu à copier-coller dans un fichier `05_design_system.md` (toujours dans ton dossier `docs/architecture/` ou `.cursorrules`).

---

```markdown
# Design System & Règles UX (RitajPOS / Ritagestion)

## 1. Directives Absolues pour l'Agent IA (@Agent)
- **INTERDICTION** de coder des couleurs en dur (ex: `Colors.blue` ou `Color(0xFF...)`) dans les widgets.
- **INTERDICTION** d'utiliser des marges ou paddings aléatoires. Utilise uniquement les variables de la section "Espacements".
- **OBLIGATION** d'utiliser systématiquement `Theme.of(context).colorScheme` et `Theme.of(context).textTheme`.
- L'objectif métier est la VITESSE D'EXÉCUTION pour les serveurs et caissiers. L'interface doit être aérée, avec des zones de clic massives.

## 2. Couleurs (ThemeData ColorScheme)
Toute l'application Flutter doit être construite autour d'un `ColorScheme` unifié.

* **Primary (`primary`) :** Couleur principale de la marque (ex: Indigo profond ou Bleu Tech). Utilisée pour les actions positives (Validation de ticket, Payé).
* **Secondary (`secondary`) :** Couleur d'accentuation (ex: Ambre ou Orange). Utilisée pour attirer l'attention (ex: Table en attente depuis trop longtemps).
* **Surface (`surface`) :** Fond des cartes, des modals et des tuiles de produits (Blanc pur ou Gris très clair en mode clair).
* **Background (`background`) :** Fond principal de l'application (Gris cassé `grey[50]` pour faire ressortir les éléments en Surface).
* **Error (`error`) :** Rouge vif. Réservé UNIQUEMENT aux annulations (Void), ruptures de stock et suppressions.
* **OnSurface / OnPrimary :** Couleurs de contraste pour le texte (Texte sombre sur Surface, Texte blanc sur Primary).

## 3. Système d'Espacement (Grille de 8px)
Tous les `Padding`, `Margin` et `SizedBox` doivent être des multiples de 8. 
* `spacingXs`: 4.0
* `spacingS`: 8.0 (Espacement entre une icône et son texte)
* `spacingM`: 16.0 (Padding standard intérieur d'une carte ou d'un bouton)
* `spacingL`: 24.0 (Espacement entre les grandes sections)
* `spacingXl`: 32.0 (Marge extérieure de l'écran)

## 4. Typographie (Google Fonts - Inter ou Roboto)
La lisibilité doit être parfaite, même de loin ou en plein soleil (terrasse).
* **HeadlineLarge :** Titres d'écran et montants totaux à payer (ex: **Bold 32sp**).
* **TitleMedium :** Noms des catégories et des produits sur la grille (ex: **SemiBold 16sp**).
* **BodyMedium :** Détails des articles dans le panier (ex: **Regular 14sp**).
* **LabelSmall :** Textes secondaires comme les notes, les badges de stock (ex: **Medium 11sp**).

## 5. Règles UX "Restauration" (Fat-Finger Rules)
1.  **Touch Targets Massifs :** Tous les boutons (`ElevatedButton`, `InkWell`, `GestureDetector`) DOIVENT avoir une taille minimale de `64x64` pixels.
2.  **Visibilité du Contraste :** Le bouton d'encaissement ("PAYER") doit être l'élément visuel le plus lourd de l'écran (Pleine largeur du panneau latéral, hauteur imposante, couleur `primary` ou couleur de succès dédiée).
3.  **Zéro Scroll Horizontal :** Les catégories, sous-catégories et listes de produits doivent s'afficher en grilles réactives (`SliverGrid` ou `Wrap`) ou en listes verticales.
4.  **Feedback Visuel Immédiat :** Chaque clic sur un produit doit générer un effet *Ripple* (splash) et un retour haptique si disponible sur l'appareil.
5.  **Accessibilité des Actions Rapides :** Les actions de suppression dans le panier doivent se faire via un bouton poubelle explicite ou un Swipe-to-delete large, sans nécessiter de confirmation pour chaque ligne (sauf si la commande est déjà envoyée en cuisine).

```

---

### Comment utiliser ce système avec ton IA :

Lorsque tu vas lui demander de générer le premier écran de l'application de caisse, ta commande (prompt) dans Cursor/Windsurf devra ressembler à ceci :

> "Je veux que tu crées l'écran principal de la caisse (Desktop) en te basant sur le fichier `05_design_system.md`. Crée d'abord un fichier `app_theme.dart` qui implémente exactement les couleurs, la typographie et les constantes d'espacement définies dans la documentation. Ensuite, génère la structure de l'écran avec une barre latérale pour les catégories, une grille centrale pour les produits, et un panneau latéral droit pour le panier."

Avec ce cadre, tu évites les allers-retours frustrants où l'IA te génère des boutons minuscules inutilisables sur un écran tactile.