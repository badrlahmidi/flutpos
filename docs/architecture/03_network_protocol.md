# Protocole Réseau Local (WebSocket)

L'application Mobile (Serveurs) et l'application Desktop (Caisse) communiquent via WebSocket en réseau local. La découverte se fait via mDNS (`_ritajpos._tcp`).

---

## 1. Stack Réseau

### Côté PC (Caisse) — Serveur
- **`shelf`** (^1.4.0) + **`shelf_router`** (^1.1.0) : Serveur HTTP léger en Dart.
- **`shelf_web_socket`** (^1.0.0) : Handler WebSocket pour Shelf.
- **`web_socket_channel`** (^2.4.0) : Gestion des canaux WebSocket.
- **`ns_ds_network`** (^1.0.5) : Broadcast mDNS pour annoncer la caisse sur le réseau local.

### Côté Mobile (Waiters) — Client
- **`dio`** (^5.5.0) : Appels HTTP (ping, statut).
- **`web_socket_channel`** (^2.4.0) : Connexion WebSocket vers la caisse.
- **`ns_ds_network`** (^1.0.5) : Découverte mDNS pour trouver automatiquement l'IP de la caisse.

---

## 2. Découverte Automatique (mDNS)

- **Service Type :** `_ritajpos._tcp`
- **Service Name :** `Caisse Principale`
- **Port par défaut :** `8080`

### Flux de découverte :
1. Le PC de caisse démarre et enregistre son service mDNS via `ns_ds_network.registerService()`.
2. L'application mobile scanne le réseau via `ns_ds_network.discoverServices()`.
3. Dès que le service `_ritajpos._tcp` est trouvé, l'app mobile récupère l'IP et le port, et se connecte.
4. La recherche est stoppée après connexion (optimisation batterie).

---

## 3. Routes du Serveur Local (Shelf)

| Route | Type | Description |
| --- | --- | --- |
| `GET /ping` | HTTP | Vérification du statut. Retourne `{"status": "online", "version": "..."}` |
| `GET /ws` | WebSocket | Canal de communication temps réel pour les commandes |

---

## 4. L'Enveloppe JSON Standard (Event Envelope)

Tous les messages échangés via WebSocket doivent respecter cette structure stricte :

```json
{
  "messageId": "UUID-UNIQUE-POUR-CE-MESSAGE",
  "action": "ACTION_NAME",
  "timestamp": "ISO-8601-DATE",
  "deviceId": "ID_DU_TERMINAL",
  "payload": { ... }
}
```

---

## 5. Actions Principales Supportées

| Action | Direction | Description |
| --- | --- | --- |
| `CREATE_ORDER` | Mobile → PC | Ouverture d'une nouvelle table avec un panier initial |
| `ADD_ITEMS` | Mobile → PC | Ajout de produits à une commande existante |
| `VOID_ITEM` | Mobile → PC | Annulation d'un produit (nécessite raison + ID autorisation) |
| `ACK` | PC → Mobile | Accusé de réception. Payload contient `status` (SUCCESS/ERROR) |

---

## 6. Logique de Synchronisation Mobile (Offline-First)

1. Le mobile écrit la commande dans sa base Drift locale (table `SyncQueue`).
2. Il tente d'envoyer le JSON via WebSocket.
3. À la réception de l'événement `ACK` depuis le PC, le mobile supprime la ligne de sa `SyncQueue`.
4. Si le WebSocket est déconnecté, la commande reste en statut `PENDING_SYNC` en base locale.
5. Dès que `NsDsNetwork` retrouve la caisse, la file d'attente est purgée et envoyée.
