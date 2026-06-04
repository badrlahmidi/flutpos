# 🌐 MEGA PROMPT — Sprint 2 : Réseau LAN (Shelf + WebSocket + NsDsNetwork)

> Copie-colle l'intégralité du bloc ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude).

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter/Dart senior spécialisé dans les architectures réseau local et les systèmes POS temps réel. Tu travailles sur "Ritagestion", une solution de caisse offline-first pour la restauration marocaine.

## ÉTAT ACTUEL DU PROJET (Sprint 0 terminé ✅)

Le monorepo Melos est initialisé et fonctionnel. Voici ce qui existe déjà :

### Versions réelles installées
- Flutter 3.44.1 / Dart 3.12.1
- drift 2.33.0 / drift_dev 2.33.0 / sqlite3 3.3.2
- ns_ds_network 1.0.5 (package interne monorepo, basé sur mdns_dart ^2.2.1)

### Structure existante
```
ritagestion/
├── melos.yaml
├── packages/
│   ├── core/                    ← BDD Drift fonctionnelle (22 tables, .g.dart généré)
│   │   └── lib/database/
│   │       ├── app_database.dart
│   │       ├── app_database.g.dart  (744 KB, 54 outputs)
│   │       ├── database_connection.dart
│   │       └── tables/              (22 fichiers de tables)
│   │
│   ├── ns_ds_network/           ← Package mDNS fonctionnel (2 tests OK)
│   │   └── lib/
│   │       ├── ns_ds_network.dart (barrel)
│   │       └── src/
│   │           ├── ns_ds_network.dart         ← NsDsNetwork singleton
│   │           ├── ns_ds_network_constants.dart ← _ritajpos._tcp, port 8080
│   │           └── discovered_service.dart    ← DiscoveredService model
│   │
│   └── network/                 ← QUASI-VIDE — C'est ici qu'on travaille
│       ├── pubspec.yaml         (dépend de: core, ns_ds_network, shelf, shelf_router, shelf_web_socket, web_socket_channel, dio)
│       └── lib/network.dart     (ne fait que re-exporter ns_ds_network)
│
├── apps/
│   ├── pos_desktop/             ← App Flutter Windows (thème + seed OK)
│   └── waiter_mobile/           ← App Flutter Android (squelette)
│
└── tools/
    └── seed_data.dart           ← Données mock insérées dans ritagestion_seed.db
```

### API NsDsNetwork existante (ne PAS la modifier)
```dart
// Singleton
NsDsNetwork.instance

// Côté PC — annoncer la caisse sur le LAN
await NsDsNetwork.instance.registerService(
  name: 'Caisse Principale',        // default
  type: '_ritajpos._tcp',            // default (NsDsNetworkConstants.serviceType)
  port: 8080,                        // default (NsDsNetworkConstants.defaultPort)
);

// Côté Mobile — trouver la caisse
List<DiscoveredService> caisses = await NsDsNetwork.instance.discoverServices();
// DiscoveredService { name, host, ipAddress, port, txtRecords }

// Arrêter l'annonce
await NsDsNetwork.instance.unregisterService();

// Raccourcis top-level
await registerService();
List<DiscoveredService> caisses = await discoverServices();
```

### Dépendances réseau dans packages/network/pubspec.yaml
```yaml
dependencies:
  core:
    path: ../core
  ns_ds_network:
    path: ../ns_ds_network
  shelf: ^1.4.2
  shelf_router: ^1.1.4
  shelf_web_socket: ^2.0.1
  web_socket_channel: ^3.0.2
  dio: ^5.8.0+1
```

## DIRECTIVE OBLIGATOIRE

AVANT de coder, lis les fichiers suivants dans `docs/architecture/` :
- `03_network_protocol.md` — Protocole WebSocket, enveloppe JSON, actions, sync
- `08_error_handling_strategy.md` — Retry WebSocket, heartbeat, mode offline
- `02_database_schema.md` — Table SyncQueue (section 5)
- `06_folder_structure.md` — Structure packages/network/

## TÂCHE : Implémenter le Sprint 2 — Réseau LAN complet

Crée tous les fichiers dans `packages/network/lib/` selon cette structure :

```
packages/network/lib/
├── network.dart                   ← Barrel file (exporter tout)
├── protocol/
│   ├── event_envelope.dart        ← Modèle EventEnvelope (messageId, action, timestamp, deviceId, payload)
│   ├── ws_action.dart             ← Enum/constantes des actions (CREATE_ORDER, ADD_ITEMS, VOID_ITEM, ACK, PING, etc.)
│   └── event_serializer.dart      ← Sérialisation/désérialisation JSON de l'EventEnvelope
├── server/
│   ├── pos_network_server.dart    ← Serveur Shelf HTTP + WebSocket (côté PC caisse)
│   ├── ws_client_registry.dart    ← Registre des clients WebSocket connectés (activeClients)
│   └── ws_message_handler.dart    ← Dispatcher : reçoit un EventEnvelope → route vers le bon handler
├── client/
│   ├── waiter_network_client.dart ← Client WebSocket pour l'app mobile serveur
│   └── connection_state.dart      ← Enum : DISCONNECTED, DISCOVERING, CONNECTING, CONNECTED, RECONNECTING
└── sync/
    └── sync_queue_manager.dart    ← Gère la SyncQueue Drift : enqueue, dequeue on ACK, retry on reconnect
```

### Fichier 1 : `protocol/event_envelope.dart`

Implémente la classe `EventEnvelope` conforme à `03_network_protocol.md` §4 :
```json
{
  "messageId": "UUID-UNIQUE",
  "action": "ACTION_NAME",
  "timestamp": "ISO-8601",
  "deviceId": "ID_DU_TERMINAL",
  "payload": { ... }
}
```
- Constructeur avec factory `EventEnvelope.fromJson(Map<String, dynamic>)`
- Méthode `Map<String, dynamic> toJson()`
- Factory `EventEnvelope.create({required String action, required String deviceId, Map<String, dynamic>? payload})` qui génère automatiquement le `messageId` (UUID v4) et le `timestamp` (DateTime.now().toIso8601String())
- Utilise le package `uuid` déjà disponible dans core

### Fichier 2 : `protocol/ws_action.dart`

Constantes des actions supportées (conforme à `03_network_protocol.md` §5) :
```dart
abstract final class WsAction {
  // Mobile → PC
  static const createOrder = 'CREATE_ORDER';
  static const addItems = 'ADD_ITEMS';
  static const voidItem = 'VOID_ITEM';
  static const requestBill = 'REQUEST_BILL';
  static const fireCourse = 'FIRE_COURSE';     // Réclamer la suite (scénario #4)
  static const updateStock = 'UPDATE_STOCK';    // Alerte stock temps réel (scénario #2)

  // PC → Mobile
  static const ack = 'ACK';
  static const stockAlert = 'STOCK_ALERT';      // Push stock=0 vers tous les mobiles (scénario #2)
  static const orderStatusChanged = 'ORDER_STATUS_CHANGED'; // KDS "Prêt" (scénario #27)

  // Bidirectionnel
  static const ping = 'PING';
  static const pong = 'PONG';
}
```

### Fichier 3 : `protocol/event_serializer.dart`

Classe utilitaire statique :
- `static String encode(EventEnvelope envelope)` → JSON String
- `static EventEnvelope decode(String json)` → EventEnvelope (avec try/catch, log erreur si JSON malformé, ne JAMAIS crasher)

### Fichier 4 : `server/pos_network_server.dart`

Le serveur POS côté PC caisse. Implémente :

1. **Démarrage** (`Future<void> start()`) :
   - Créer un `Router` Shelf avec les routes :
     - `GET /ping` → Retourne `{"status": "online", "version": "1.0.0", "activeSessions": N}`
     - `GET /ws` → WebSocket handler
   - Lancer le serveur sur `InternetAddress.anyIPv4` port `NsDsNetworkConstants.defaultPort` (8080)
   - Appeler `NsDsNetwork.instance.registerService()` pour annoncer sur mDNS
   - Lancer le heartbeat timer (PING toutes les 10 secondes à tous les clients)

2. **Gestion WebSocket** :
   - À chaque nouvelle connexion → ajouter dans `WsClientRegistry`
   - À chaque message reçu → décoder en `EventEnvelope` → passer au `WsMessageHandler`
   - À chaque déconnexion → retirer du `WsClientRegistry`

3. **Arrêt** (`Future<void> stop()`) :
   - Fermer tous les WebSocket clients
   - Arrêter le serveur Shelf
   - Appeler `NsDsNetwork.instance.unregisterService()`
   - Annuler le heartbeat timer

4. **Broadcast** (`void broadcast(EventEnvelope envelope)`) :
   - Envoyer un message à TOUS les clients connectés (ex: STOCK_ALERT)

### Fichier 5 : `server/ws_client_registry.dart`

Registre des terminaux connectés :
- `Map<String, WebSocketChannel> _clients` (clé = deviceId)
- `void add(String deviceId, WebSocketChannel channel)`
- `void remove(String deviceId)`
- `WebSocketChannel? get(String deviceId)`
- `List<WebSocketChannel> get all`
- `int get count`
- `bool isConnected(String deviceId)`

### Fichier 6 : `server/ws_message_handler.dart`

Dispatcher d'événements :
- Reçoit un `EventEnvelope` du WebSocket
- Switch sur `envelope.action` :
  - `WsAction.createOrder` → log + retourner ACK(SUCCESS) (le branchement réel au BLoC viendra au Sprint suivant)
  - `WsAction.addItems` → log + retourner ACK(SUCCESS)
  - `WsAction.voidItem` → log + retourner ACK(SUCCESS)
  - `WsAction.fireCourse` → log + retourner ACK(SUCCESS)
  - `WsAction.ping` → retourner PONG immédiatement
  - Action inconnue → retourner ACK(ERROR, message: "Unknown action")
- Chaque ACK est un EventEnvelope avec `action: WsAction.ack` et `payload: {"status": "SUCCESS/ERROR", "originalMessageId": "...", "message": "..."}`

### Fichier 7 : `client/connection_state.dart`

```dart
enum ConnectionState {
  disconnected,
  discovering,     // Scan mDNS en cours
  connecting,      // WebSocket handshake
  connected,       // Opérationnel
  reconnecting,    // Perte de connexion, retry en cours
}
```

### Fichier 8 : `client/waiter_network_client.dart`

Le client réseau côté mobile serveur. Implémente :

1. **Découverte** (`Future<DiscoveredService?> discover()`) :
   - Appeler `NsDsNetwork.instance.discoverServices()`
   - Retourner la première caisse trouvée, ou null si timeout
   - Mettre à jour l'état : `discovering` → `connecting` ou `disconnected`

2. **Connexion** (`Future<void> connect(String ip, int port)`) :
   - Ouvrir `WebSocketChannel.connect(Uri.parse('ws://$ip:$port/ws'))`
   - Écouter le stream avec gestion d'erreurs complète
   - Mettre à jour l'état : `connecting` → `connected`

3. **Découverte + Connexion auto** (`Future<void> discoverAndConnect()`) :
   - Combiner discover() puis connect()
   - Si échec : proposer le fallback "saisir IP manuellement"

4. **Envoi** (`Future<void> send(EventEnvelope envelope)`) :
   - Si connecté → envoyer le JSON via WebSocket
   - Si déconnecté → enqueue dans SyncQueue via SyncQueueManager

5. **Réception** :
   - Écouter les messages, décoder en EventEnvelope
   - Exposer un `Stream<EventEnvelope> get messages` pour que les BLoCs s'y abonnent
   - Gérer le PONG (réponse au PING du serveur)

6. **Reconnexion automatique** :
   - Sur `onDone` ou `onError` du WebSocket → passer en état `reconnecting`
   - Retry avec backoff exponentiel : 1s → 2s → 4s → 8s → max 30s
   - À la reconnexion → purger la SyncQueue

7. **Exposer l'état** :
   - `ValueNotifier<ConnectionState> connectionState`
   - Pour que l'UI mobile affiche un indicateur vert/rouge

### Fichier 9 : `sync/sync_queue_manager.dart`

Gestionnaire de la file d'attente offline (table SyncQueue de Drift) :

1. **Enqueue** (`Future<void> enqueue(EventEnvelope envelope)`) :
   - Insérer dans SyncQueue avec `status: PENDING_SYNC`, `action: envelope.action`, `payload: jsonEncode(envelope.toJson())`

2. **Flush** (`Future<void> flush(WaiterNetworkClient client)`) :
   - Récupérer toutes les entrées `PENDING_SYNC` ordonnées par `createdAt`
   - Pour chacune → envoyer via `client.send()` → mettre à jour le statut en `SENT`

3. **Acknowledge** (`void onAck(String originalMessageId)`) :
   - Trouver l'entrée SyncQueue dont le payload contient ce messageId
   - Mettre à jour le statut en `ACKED`
   - Optionnel : supprimer les entrées ACKED de plus de 24h

4. **On Reconnect** :
   - Appeler `flush()` automatiquement quand le client passe de `reconnecting` → `connected`

5. **Retry failed** (`Future<void> retryFailed()`) :
   - Reprendre les entrées `FAILED` dont `retryCount < 5`
   - Incrémenter `retryCount`, remettre en `PENDING_SYNC`

### Fichier 10 : `network.dart` (Barrel mis à jour)

Re-exporter tout proprement :
```dart
library network;

// Protocol
export 'protocol/event_envelope.dart';
export 'protocol/ws_action.dart';
export 'protocol/event_serializer.dart';

// Server (Desktop only)
export 'server/pos_network_server.dart';
export 'server/ws_client_registry.dart';
export 'server/ws_message_handler.dart';

// Client (Mobile only)
export 'client/waiter_network_client.dart';
export 'client/connection_state.dart';

// Sync
export 'sync/sync_queue_manager.dart';

// Re-export mDNS
export 'package:ns_ds_network/ns_ds_network.dart';
```

## RÈGLES NON-NÉGOCIABLES POUR CE SPRINT

1. **Ne PAS modifier** `packages/ns_ds_network/` — le package est stable et testé
2. **Ne PAS modifier** `packages/core/` — les tables Drift sont générées et fonctionnelles
3. **Utiliser les vraies versions** : shelf ^1.4.2, shelf_web_socket ^2.0.1, web_socket_channel ^3.0.2
4. **Importer core** pour accéder à `AppDatabase` et la table `SyncQueue` (via `import 'package:core/core.dart'`)
5. **Importer ns_ds_network** pour `NsDsNetwork.instance`, `DiscoveredService`, `NsDsNetworkConstants`
6. **JSON robuste** : ne JAMAIS crasher sur un JSON malformé — try/catch + log
7. **Heartbeat** : le serveur PING tous les 10s. Si un client ne PONG pas 3 fois → considéré déconnecté
8. **Backoff exponentiel** sur reconnexion client : 1s → 2s → 4s → 8s → max 30s
9. **Logs structurés** : utiliser `print()` pour l'instant (on intégrera un Logger plus tard)
10. **Documentation Dart** : chaque classe et méthode publique doit avoir un `///` docstring

## TESTS À ÉCRIRE

Crée `packages/network/test/` avec :
- `protocol/event_envelope_test.dart` — Sérialisation/désérialisation, UUID auto-généré, JSON malformé
- `protocol/event_serializer_test.dart` — Encode/decode round-trip
- `server/ws_client_registry_test.dart` — Add/remove/count clients
- `server/ws_message_handler_test.dart` — Dispatch correct des actions, ACK généré

## VALIDATION FINALE

Quand tu as fini, je veux pouvoir exécuter :
```bash
cd packages/network && dart test                    # Tous les tests passent
cd apps/pos_desktop && flutter analyze lib           # Zéro erreur
```

Et idéalement un script de test manuel :
```dart
// tools/test_network.dart — Lance le serveur, envoie un message, vérifie l'ACK
void main() async {
  final server = PosNetworkServer(database: db);
  await server.start();
  print('Serveur démarré sur :8080 — mDNS annoncé');
  // Tester : curl http://localhost:8080/ping
  // Tester : wscat -c ws://localhost:8080/ws puis envoyer un JSON EventEnvelope
}
```

Commence par le fichier `protocol/event_envelope.dart` et progresse fichier par fichier. Montre-moi le code complet de chaque fichier.
```

---

## COMMENT UTILISER CE PROMPT

1. Ouvre le projet dans ton IDE (Cursor / Windsurf / Cline)
2. Copie-colle le contenu entre les ``` ci-dessus dans le Composer
3. L'agent créera les 10 fichiers dans `packages/network/lib/` + les tests
4. Vérifie avec `cd packages/network && dart test`

## VÉRIFICATIONS POST-SPRINT

```bash
# 1. Tests réseau
cd packages/network && dart test

# 2. Analyse statique
cd packages/network && dart analyze lib

# 3. Test manuel serveur (depuis un terminal)
cd tools && dart run test_network.dart
# → Ouvre un autre terminal :
curl http://localhost:8080/ping
# → Doit retourner : {"status": "online", "version": "1.0.0"}

# 4. Test WebSocket (avec wscat)
npm install -g wscat
wscat -c ws://localhost:8080/ws
# → Envoyer :
{"messageId":"test-001","action":"PING","timestamp":"2026-06-04T20:00:00Z","deviceId":"terminal-1","payload":{}}
# → Doit recevoir un PONG

# 5. Test mDNS (depuis un autre PC ou mobile sur le même réseau)
# L'app mobile doit trouver automatiquement la caisse via discoverServices()
```
