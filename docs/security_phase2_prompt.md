# Prompt Complet — Remédiation Sécurité Phase 2/3/4 (Toutes Failles Restantes)

## Contexte Projet

```
Projet : Ritagestion POS (Flutter Monorepo Melos)
Stack  : Flutter 3.40 / Dart 3.8 / drift 3.0 / flutter_bloc 9.0 / bcrypt / shelf / powersync 1.5
CWD    : c:\devzone\flutpos
Architecture : Clean Architecture (Presentation → Domain → Data)
Monorepo :
  - packages/core/      → BDD Drift, modèles, logique métier, repositories
  - packages/network/   → WebSocket, mDNS, sync
  - apps/pos_desktop/   → Application Caisse Windows
  - apps/waiter_mobile/ → Application Serveurs Android/iOS

Règles obligatoires (.cursorrules) :
  - Offline-First : écrire en local (Drift) d'abord
  - UUID obligatoire pour tous les IDs
  - Immutabilité des prix dans OrderItems.unitPrice
  - BLoC Pattern (flutter_bloc), séparation stricte UI/logique
  - Pas de couleurs en dur → Theme.of(context).colorScheme
  - Grille 8px, touch targets ≥ 64px
  - PIN hashé bcrypt, actions sensibles = PIN Manager + AuditTrail
  - Tests : 100% coverage calculs financiers, 90% sur BLoCs

AVANT toute modification :
  1. Lire ROADMAP.md
  2. Lire docs/architecture/ (10 fichiers)
  3. Consulter docs/*_plan.md

Schema BDD actuel : version 10 (Phase 1 déjà appliquée)
```

---

## Failles à Corriger — Ordre de Priorité

### PHASE 2 — Sévérité HAUTE (6 failles)

#### [HAUTE-N02] deviceId auto-déclaré — usurpation d'identité terminal
```yaml
Fichier     : packages/network/lib/server/pos_network_server.dart (~ligne 215)
Problème    : _registerClient(webSocket, envelope.deviceId) accepte n'importe quel deviceId
Impact      : Usurpation de terminal, pas de vérification de pairing
Solution    :
  - Créer table `device_pairings` (deviceId, pairingToken, pairedAt, deviceName, isActive)
  - Générer un pairing token (UUID) affiché sur le POS desktop (QR code)
  - Le waiter mobile scanne le QR → obtient le pairingToken
  - Sur connexion WebSocket, le client envoie { deviceId, pairingToken }
  - Le serveur valide le token avant _registerClient()
  - Ajouter commande `PAIRING_REQUEST` dans le protocole
Fichiers    :
  - packages/core/lib/database/tables/device_pairings.dart (NOUVEAU)
  - packages/core/lib/repositories/device_pairing_repository.dart (NOUVEAU)
  - packages/network/lib/server/pos_network_server.dart (MODIFIER)
  - packages/network/lib/client/pos_network_client.dart (MODIFIER)
  - apps/pos_desktop/lib/pages/backoffice/device_pairing_page.dart (NOUVEAU)
  - apps/waiter_mobile/lib/pages/scanner_page.dart (MODIFIER)
  - packages/core/lib/database/app_database.dart (AJOUTER table + migration v11)
Contraintes :
  - Le pairing token expire après 5 minutes
  - Max 3 devices pairés simultanément
  - Le manager doit confirmer le pairing (PIN Manager)
```

#### [HAUTE-A04] Pas de RBAC sur messages WebSocket
```yaml
Fichiers   : packages/network/lib/server/ws_message_handler.dart
             packages/network/lib/server/pos_network_server.dart
Problème   : Aucune vérification du rôle utilisateur sur les actions WS
Impact     : Un serveur peut envoyer des commandes réservées manager
Solution   :
  - Ajouter `sessionToken` et `userRole` dans EventEnvelope
  - À la connexion WS, le client envoie { deviceId, pairingToken, sessionToken, userRole }
  - Le serveur valide le sessionToken contre la table `active_sessions`
  - Créer matrice de permissions par commande :
      CREATE_ORDER        → serveur, manager
      APPLY_DISCOUNT      → manager uniquement
      CANCEL_ORDER        → manager uniquement
      CLOSE_CASH_SESSION  → manager uniquement
      VOID_PAYMENT        → manager uniquement
  - Avant chaque handle(), vérifier permissionMatrix[command].contains(userRole)
  - Logger refus dans audit_trail
Fichiers   :
  - packages/core/lib/database/tables/active_sessions.dart (NOUVEAU)
  - packages/core/lib/services/rbac_permission_checker.dart (NOUVEAU)
  - packages/network/lib/server/ws_message_handler.dart (MODIFIER)
  - packages/network/lib/server/pos_network_server.dart (MODIFIER)
  - packages/network/lib/models/event_envelope.dart (MODIFIER)
  - docs/architecture/07_security_and_auth.md (CONSULTER pour matrice permissions)
Contraintes :
  - sessionToken expire après 8h d'inactivité
  - Validation du token à chaque message (pas seulement à la connexion)
```

#### [HAUTE-F02] Pas d'auto-lock de session après inactivité
```yaml
Fichiers   : apps/pos_desktop/lib/pages/auth/auth_bloc.dart (MODIFIER)
             apps/pos_desktop/lib/app.dart ou main.dart (MODIFIER)
             apps/pos_desktop/lib/services/session_timeout_service.dart (NOUVEAU)
Problème   : Aucun verrouillage automatique → caisse ouverte indéfiniment
Impact     : Accès non autorisé si le caissier quitte son poste
Solution   :
  - Créer SessionTimeoutService avec Listener sur Mouse/Keyboard/Touch
  - Timer de 5 minutes (configurable dans settings)
  - Au timeout : émettre AuthAutoLocked(), effacer AppSession.currentUser
  - Afficher l'écran de verrouillage (ré-auth PIN)
  - Sauvegarder l'état courant (commande en cours) avant lock
  - Au déverrouillage : restaurer l'état
Fichiers   :
  - apps/pos_desktop/lib/services/session_timeout_service.dart (NOUVEAU)
  - apps/pos_desktop/lib/blocs/auth/auth_bloc.dart (MODIFIER — ajouter AuthAutoLocked event)
  - apps/pos_desktop/lib/blocs/auth/auth_event.dart (MODIFIER)
  - apps/pos_desktop/lib/blocs/auth/auth_state.dart (MODIFIER — ajouter AuthAutoLocked state)
  - apps/pos_desktop/lib/app.dart (MODIFIER — wrapper avec Listener)
Contraintes :
  - Le timeout est configurable (settings → default 5 min)
  - En mode "train de payer" (payment en cours), le timeout est suspendu
  - Le timeout redémarre après chaque interaction
```

#### [HAUTE-M01] android:allowBackup non désactivé
```yaml
Fichiers   : apps/waiter_mobile/android/app/src/main/AndroidManifest.xml
             apps/pos_desktop/windows/runner/main.cpp (vérifier équivalent desktop)
Problème   : adb backup peut extraire la BDD SQLite
Impact     : Vol de données via backup ADB
Solution   :
  - Ajouter sur <application> : android:allowBackup="false" android:fullBackupContent="false"
  - Ajouter android:dataExtractionRules="@@xml/data_extraction_rules"
  - Créer res/xml/data_extraction_rules.xml avec strict no-backup
Fichiers   :
  - apps/waiter_mobile/android/app/src/main/AndroidManifest.xml (MODIFIER)
  - apps/waiter_mobile/android/app/src/main/res/xml/data_extraction_rules.xml (NOUVEAU)
Contraintes :
  - Ne pas casser les autres permissions existantes
  - Tester que l'app s'installe toujours correctement
```

#### [HAUTE-D02] customerId sans contrainte de clé étrangère
```yaml
Fichier    : packages/core/lib/database/tables/orders.dart (ligne 16-17)
Problème   : customerId est text().nullable()() sans FK → orphelins possibles
Impact     : Intégrité référentielle compromise
Solution   :
  - Remplacer par : text().nullable().references(Customers, #id, onDelete: KeyAction.setNull)()
  - Ajouter migration v11 : ALTER TABLE orders ADD FOREIGN KEY
  - Nettoyer les orphelins existants avant migration (SET NULL où customerId non trouvé)
Fichiers   :
  - packages/core/lib/database/tables/orders.dart (MODIFIER)
  - packages/core/lib/database/app_database.dart (MODIFIER — migration v11)
Contraintes :
  - La migration doit gérer les orphelins existants (UPDATE orders SET customerId = NULL WHERE customerId NOT IN (SELECT id FROM customers))
  - Vérifier que CustomerRepository ne casse pas
```

#### [HAUTE-N03] Pas de validation des payloads WebSocket
```yaml
Fichier    : packages/network/lib/server/ws_message_handler.dart
Problème   : Les payloads JSON entrants ne sont pas validés avant écriture BDD
Impact     : Valeurs négatives, UUIDs malformés, types incorrects
Solution   :
  - Créer un validateur par type de commande :
      CreateOrderValidator → valide items[], quantities > 0, UUIDs valides, montants >= 0
      ApplyDiscountValidator → valide type (PERCENT/FIXED), value >= 0, value <= total
      PaymentValidator → valide method enum, amount > 0, amount <= remaining
  - Avant chaque handle() : appeler validator.validate(envelope.opData)
  - En cas d'invalidité : rejeter avec message d'erreur structuré
  - Logger les tentatives invalides
Fichiers   :
  - packages/network/lib/server/validators/create_order_validator.dart (NOUVEAU)
  - packages/network/lib/server/validators/apply_discount_validator.dart (NOUVEAU)
  - packages/network/lib/server/validators/payment_validator.dart (NOUVEAU)
  - packages/network/lib/server/validators/base_validator.dart (NOUVEAU — interface)
  - packages/network/lib/server/ws_message_handler.dart (MODIFIER)
Contraintes :
  - Utiliser le pattern Stratégie (Map<TypeCommande, Validator>)
  - Messages d'erreur standardisés { code, message, field }
  - Tests unitaires pour chaque validator (100% coverage)
```

---

### PHASE 3 — Sévérité MOYENNE (8 failles)

#### [MOY-D03] Pas de chiffrement SQLite (SQLCipher)
```yaml
Fichiers   : packages/core/lib/database/app_database_opener.dart
             packages/core/pubspec.yaml
Problème   : Le fichier .sqlite est en clair sur disque
Impact     : Accès physique = exposition totale des données
Solution   :
  - Remplacer sqlite3_flutter_libs par sqlcipher_flutter_libs
  - Générer une clé de chiffrement (32 bytes aléatoires) au premier lancement
  - Stocker la clé dans le keystore sécurisé :
      - Windows : flutter_secure_storage (DPAPI)
      - Android : AndroidKeystore
      - iOS : Keychain
  - Passer la clé à NativeDatabase(path, key: encryptionKey)
  - Migration des données existantes (lire ancienne DB non chiffrée → créer nouvelle DB chiffrée → copier)
Fichiers   :
  - packages/core/pubspec.yaml (MODIFIER — remplacer sqlite3_flutter_libs par sqlcipher_flutter_libs)
  - packages/core/lib/database/app_database_opener.dart (MODIFIER)
  - packages/core/lib/services/encryption_key_service.dart (NOUVEAU)
  - packages/core/lib/services/database_migration_service.dart (NOUVEAU — migration clair → chiffré)
Contraintes :
  - Ajouter flutter_secure_storage aux dépendances
  - La migration doit être atomique (backup → chiffrer → vérifier → supprimer backup)
  - En cas d'échec, restaurer depuis le backup
  - Tester sur les 3 plateformes (Windows, Android, iOS)
```

#### [MOY-D04] Pas de soft-delete (deletedAt)
```yaml
Fichiers   : packages/core/lib/database/tables/orders.dart
             packages/core/lib/database/tables/customers.dart
             packages/core/lib/database/tables/cash_sessions.dart
             packages/core/lib/database/tables/payments.dart
             packages/core/lib/database/tables/order_items.dart
Problème   : Hard delete = violation de l'exigence d'audit trail
Impact     : Enregistrements supprimés non traçables
Solution   :
  - Ajouter `deletedAt DateTimeColumn nullable` sur les tables sensibles
  - Modifier tous les repositories : DELETE → UPDATE SET deletedAt = now
  - Modifier tous les SELECT : WHERE deletedAt IS NULL
  - Ajouter mixin SoftDeletable sur les entités
  - Créer SoftDeleteInterceptor Drift pour automatiser
Fichiers   :
  - packages/core/lib/database/tables/orders.dart (MODIFIER)
  - packages/core/lib/database/tables/customers.dart (MODIFIER)
  - packages/core/lib/database/tables/cash_sessions.dart (MODIFIER)
  - packages/core/lib/database/tables/payments.dart (MODIFIER)
  - packages/core/lib/database/tables/order_items.dart (MODIFIER)
  - packages/core/lib/database/mixins/soft_deletable.dart (NOUVEAU)
  - packages/core/lib/database/app_database.dart (MODIFIER — migration v11)
  - Tous les fichiers dans packages/core/lib/repositories/ (MODIFIER — WHERE deletedAt IS NULL)
Contraintes :
  - La migration v11 doit ajouter la colonne sans perdre de données
  - Les rapports/analytics doivent pouvoir voir les enregistrements supprimés (mode audit)
  - Ajouter un flag `includeDeleted` dans les queries de reporting
```

#### [MOY-N04] print() au lieu de logging structuré
```yaml
Fichiers   : packages/network/lib/server/pos_network_server.dart
             packages/network/lib/client/pos_network_client.dart
Problème   : print() dans toute la couche réseau (lignes 124, 159, 168, 191, etc.)
Impact     : Logs non structurés, fuite d'infos en production
Solution   :
  - Ajouter package `logging` aux dépendances
  - Créer packages/network/lib/utils/app_logger.dart (singleton configuré)
  - Remplacer tous les print() par :
      logger.info(...)  → événements normaux (connexion, déconnexion)
      logger.warning(...) → erreurs récupérables
      logger.severe(...) → erreurs critiques
  - En production (kReleaseMode) : niveau WARNING minimum
  - En debug : niveau INFO
  - Optionnel : intégrer sentry_flutter pour les severe()
Fichiers   :
  - packages/network/pubspec.yaml (MODIFIER — ajouter logging)
  - packages/network/lib/utils/app_logger.dart (NOUVEAU)
  - packages/network/lib/server/pos_network_server.dart (MODIFIER — remplacer tous print())
  - packages/network/lib/client/pos_network_client.dart (MODIFIER)
Contraintes :
  - Ne jamais logger de données sensibles (PIN, tokens, montants)
  - Masquer les deviceId partiels en production (ex: "dev_****ab12")
```

#### [MOY-M02] Pas de Network Security Configuration
```yaml
Fichiers   : apps/waiter_mobile/android/app/src/main/AndroidManifest.xml
             apps/waiter_mobile/android/app/src/main/res/xml/network_security_config.xml (NOUVEAU)
Problème   : Pas de restriction sur le trafic cleartext
Impact     : Trafic HTTP non chiffré possible (MITM)
Solution   :
  - Créer network_security_config.xml :
      <network-security-config>
        <base-config cleartextTrafficPermitted="false">
          <trust-anchors>
            <certificates src="system"/>
          </trust-anchors>
        </base-config>
        <domain-config cleartextTrafficPermitted="true">
          <domain includeSubdomains="true">10.0.2.2</domain>  <!-- émulateur -->
          <domain includeSubdomains="true">localhost</domain>
        </domain-config>
      </network-security-config>
  - Ajouter sur <application> : android:networkSecurityConfig="@xml/network_security_config"
Fichiers   :
  - apps/waiter_mobile/android/app/src/main/res/xml/network_security_config.xml (NOUVEAU)
  - apps/waiter_mobile/android/app/src/main/AndroidManifest.xml (MODIFIER)
  - apps/pos_desktop/ (vérifier équivalent Windows si applicable)
Contraintes :
  - Le cleartext reste nécessaire pour le loopback en développement uniquement
  - En release build : cleartextTrafficPermitted="false" partout
```

#### [MOY-N05] Pas de rate limiting WebSocket
```yaml
Fichiers   : packages/network/lib/server/pos_network_server.dart
             packages/network/lib/server/ws_rate_limiter.dart (NOUVEAU)
Problème   : Un client peut inonder le serveur de messages (DoS)
Impact     : Déni de service
Solution   :
  - Créer WsRateLimiter (token bucket algorithm) :
      - Capacité : 30 messages / 10 secondes par connexion
      - Refill : 3 tokens / seconde
      - Burst max : 50 messages instantanés
  - Dans handleWebSocketMessage() : vérifier rateLimiter.tryConsume(deviceId)
  - Si dépassé : envoyer ERROR avec code RATE_LIMITED + fermer connexion après 3 violations
  - Logger les violations
Fichiers   :
  - packages/network/lib/server/ws_rate_limiter.dart (NOUVEAU)
  - packages/network/lib/server/pos_network_server.dart (MODIFIER)
Contraintes :
  - Le rate limiter est par deviceId, pas par IP
  - Les messages de heartbeat/ping sont exemptés
  - Test unitaire : simuler 100 messages en 1 seconde → vérifier rejet
```

#### [MOY-A05] PIN en clair dans buffer String
```yaml
Fichier    : apps/pos_desktop/lib/pages/auth/auth_bloc.dart
Problème   : String _pinBuffer = '' conserve le PIN en mémoire heap
Impact     : Dump mémoire peut révéler le PIN
Solution   :
  - Utiliser Uint8List au lieu de String pour stocker les caractères PIN
  - Après usage (succès ou échec) : remplir avec des zéros (ZeroOut)
  - Utiliser package crypto pour effacer sécurisé
Fichiers   :
  - apps/pos_desktop/lib/pages/auth/auth_bloc.dart (MODIFIER)
Contraintes :
  - L'UI doit toujours afficher les astérisques (*) correctement
  - Le buffer est effacé après chaque soumission ou annulation
```

#### [MOY-F03] Session singleton en mémoire
```yaml
Fichier    : apps/pos_desktop/lib/services/app_session.dart (MODIFIER)
Problème   : AppSession.instance.setUser() sans invalidation explicite
Impact     : Session potentiellement invalide après crash
Solution   :
  - Ajouter méthode invalidate() qui efface currentUser + notifie les listeners
  - Appeler invalidate() au démarrage de l'app (cold start)
  - Ajouter ChangeNotifier ou ValueNotifier pour réactivité UI
Fichiers   :
  - apps/pos_desktop/lib/services/app_session.dart (MODIFIER)
  - apps/pos_desktop/lib/main.dart (MODIFIER — appeler invalidate() au boot)
Contraintes :
  - Ne pas perdre l'état si l'app est juste suspendue (mise en arrière-plan)
```

#### [MOY-M03] Permission CAMERA — vérifier demande runtime
```yaml
Fichier    : apps/waiter_mobile/lib/pages/scanner_page.dart
Problème   : La permission CAMERA doit être demandée à l'exécution
Solution   :
  - Ajouter package permission_handler
  - Dans scanner_page.dart initState() :
      if (await Permission.camera.request().isDenied) {
        showPermissionDeniedDialog();
        return;
      }
  - Gérer le cas "permanently denied" → ouvrir Paramètres
Fichiers   :
  - apps/waiter_mobile/pubspec.yaml (MODIFIER — ajouter permission_handler)
  - apps/waiter_mobile/lib/pages/scanner_page.dart (MODIFIER)
  - apps/waiter_mobile/lib/widgets/permission_denied_dialog.dart (NOUVEAU)
Contraintes :
  - iOS : ajouter NSCameraUsageDescription dans Info.plist
  - Android : vérifier que la permission est bien dans AndroidManifest.xml (déjà présente)
```

---

### PHASE 4 — Sévérité BASSE (4 failles)

#### [BAS-A06] PIN minimum 4 chiffres
```yaml
Fichier    : apps/pos_desktop/lib/pages/auth/auth_bloc.dart
Solution   : Passer minPinLength de 4 à 6. Ajouter migration pour les PINs existants (forcer reset au prochain login).
Contraintes : Les PINs actuels doivent être invalidés (forceChangePin = true sur tous les users existants).
```

#### [BAS-F04] Validation format code-barres
```yaml
Fichier    : apps/pos_desktop/lib/pages/auth/auth_page.dart
Solution   : Valider avec RegExp(r'^[0-9]{4,6}$') avant d'injecter dans le BLoC. Rejeter silencieusement les formats invalides.
```

#### [BAS-N06] Déduplication messageId
```yaml
Fichier    : packages/network/lib/server/ws_message_handler.dart
Solution   : Maintenir un cache LRU (package lru_cache ou Map avec taille max 1000). Vérifier messageId avant traitement. Rejeter les doublons avec ACK silencieux.
```

#### [BAS-M04] debuggable=false explicite
```yaml
Fichier    : apps/waiter_mobile/android/app/build.gradle
Solution   : Ajouter debuggable false dans buildTypes.release.
```

---

## Ordre d'Implémentation Recommandé

```
Sprint 1 (Phase 2 - Réseau/Auth) :
  1. D02 (FK customerId) — rapide, migration v11
  2. M01 (allowBackup) — trivial, AndroidManifest
  3. N03 (Validation payloads WS) — nouveaux validators
  4. N02 (Pairing device) — table + QR + protocole
  5. A04 (RBAC WS) — matrice permissions + sessionToken
  6. F02 (Auto-lock) — SessionTimeoutService

Sprint 2 (Phase 3 - Infrastructure) :
  7. N04 (Logging) — remplacer print()
  8. N05 (Rate limiting) — WsRateLimiter
  9. M02 (Network Security Config)
  10. A05 (PIN buffer sécurisé)
  11. F03 (Session invalidation)
  12. M03 (Camera runtime permission)
  13. D04 (Soft-delete) — impact large sur repositories
  14. D03 (SQLCipher) — le plus risqué, migration données

Sprint 3 (Phase 4 - Polish) :
  15. A06, F04, N06, M04
```

---

## Prompt à Copier-Coller

```text
Tu es Cline, un expert en sécurité applicative Flutter/Dart. Continue le projet Ritagestion POS (monorepo Melos à c:\devzone\flutpos).

CONTEXTE :
- Phase 1 de sécurité déjà appliquée (A01, A02, A03, D01, C01, C02, C03 corrigés)
- Schema BDD Drift version 10
- Les 3 packages (core, pos_desktop, waiter_mobile) compilent sans erreur
- AVANT toute modification : lire ROADMAP.md + docs/architecture/ + .cursorrules

MISSION : Implémenter TOUTES les corrections de sécurité restantes (Phase 2 + 3 + 4) selon le document docs/security_phase2_prompt.md qui contient le détail de chaque faille, les fichiers à modifier/créer, et les contraintes.

ORDRE D'IMPLÉMENTATION :
1. [D02] FK customerId → migration v11
2. [M01] allowBackup="false"
3. [N03] Validation payloads WS (créer validators/)
4. [N02] Pairing device (table device_pairings + QR code + protocole)
5. [A04] RBAC WebSocket (matrice permissions + sessionToken)
6. [F02] Auto-lock session (SessionTimeoutService)
7. [N04] Remplacer print() par logging
8. [N05] Rate limiting WS
9. [M02] Network Security Config Android
10. [A05] PIN buffer sécurisé (Uint8List + zero-out)
11. [F03] Session invalidation
12. [M03] Camera runtime permission
13. [D04] Soft-delete (deletedAt + WHERE deletedAt IS NULL)
14. [D03] SQLCipher (migration clair → chiffré)
15. [A06] PIN 6 chiffres
16. [F04] Validation code-barres
17. [N06] Déduplication messageId
18. [M04] debuggable=false

RÈGLES :
- Après chaque modification : dart analyze / flutter analyze sur les 3 packages
- Migration BDD : incrémenter schemaVersion et ajouter migration steps
- Régénérer le code Drift avec : dart run build_runner build --delete-conflicting-outputs
- Aucune donnée sensible dans les logs
- Tests unitaires sur les validators et le rate limiter
- Vérifier la compatibilité Windows + Android + iOS
- Ne pas casser le mode offline-first

Commence par lire ROADMAP.md et docs/security_phase2_prompt.md, puis implémente dans l'ordre ci-dessus en vérifiant la compilation après chaque étape.