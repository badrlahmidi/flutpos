# Contexte du Projet : RitajPOS / Ritagestion (Édition 2026)

## 1. Vision et Objectif
Développement d'une solution POS (Point of Sale) de nouvelle génération pour la restauration, conçue pour être "Offline-First". Le système doit fonctionner sans interruption même en cas de coupure internet, avec une synchronisation transparente des données dès le retour du réseau. 
L'architecture repose sur un modèle "PC First" pour la caisse principale, avec des applications mobiles légères pour la prise de commande par les serveurs.

## 2. Tech Stack (2026) — Versions réelles installées
- **Framework Core :** Flutter 3.44.1, Dart 3.12.1 (Impeller activé).
- **Architecture d'état :** BLoC (`flutter_bloc` ^9.0.0).
- **Base de données locale :** Drift (`drift` ^2.33.0) + sqlite3 ^3.3.2.
- **Synchronisation Cloud :** PowerSync (`powersync` ^1.5.0) + Supabase/PostgreSQL.
- **Réseau Local & Découverte :** `ns_ds_network` 1.0.5 (package interne monorepo, basé sur mdns_dart) + `shelf` ^1.4.2 (Serveur WebSocket local).
- **Impression Hardware :** `unified_esc_pos_printer` ^1.2.0 (USB, Ethernet, Bluetooth).
- **UI Desktop :** `desktop_multi_window`, `window_manager`.

## 3. Plateformes Cibles
- **Application Caisse :** `Windows` (PC de caisse principal)
- **Application Waiters :** `Android` / `iOS` (Smartphones/Tablettes serveurs)

## 4. Structure du Monorepo (Melos)
- `/packages/core` : Base Drift (22 tables), modèles de données, entités métier (partagé).
- `/packages/ns_ds_network` : Découverte et annonce mDNS LAN (`_ritajpos._tcp`).
- `/packages/network` : Logique WebSocket serveur/client, protocole, SyncQueue (partagé).
- `/apps/pos_desktop` : Application Caisse principale sous Windows (UI PC).
- `/apps/waiter_mobile` : Application prise de commande des serveurs (UI Mobile).

## 5. Règles d'Architecture Strictes pour l'Agent IA
1. **Identifiants :** Toutes les tables de la base de données doivent utiliser des UUID (String) pour éviter les conflits de synchronisation.
2. **Offline-First :** Aucune action métier (ajout au panier, paiement) ne doit dépendre d'un appel API externe en temps réel. Tout est écrit en local via Drift, puis synchronisé.
3. **Séparation des préoccupations :** Le code métier (BLoC/Drift) doit être agnostique de l'UI.
4. **Idempotence :** Les messages réseau WebSocket doivent tous posséder un `messageId` unique.
5. **Immutabilité des prix :** Le prix d'un article est copié dans `OrderItems.unitPrice` au moment de la commande. Les calculs de totaux utilisent TOUJOURS ce prix figé.
6. **Fallback des prix :** Lors de l'ajout au panier : `price = orderType == 'TAKEAWAY' ? (product.priceTakeaway ?? product.priceDineIn) : product.priceDineIn`.
