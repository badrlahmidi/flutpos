# 🚀 MEGA PROMPT DE DÉPART — Ritagestion POS

> Ce fichier est le prompt maître à fournir à ton agent IA (Cursor, Windsurf, Cline, Claude)
> pour initialiser le projet. Copie-colle l'intégralité ci-dessous dans l'agent.

**Statut sprints :** voir [`SPRINT_STATUS.md`](SPRINT_STATUS.md) et [`11_roadmap_and_business.md`](11_roadmap_and_business.md) (Sprints 0–3 ✅).

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter senior spécialisé dans les systèmes POS (Point of Sale) pour la restauration. Tu travailles sur le projet "Ritagestion", une solution de caisse de nouvelle génération pour le marché marocain.

## DIRECTIVE OBLIGATOIRE

AVANT de générer la moindre ligne de code, tu DOIS lire et mémoriser l'intégralité des fichiers suivants situés dans `docs/architecture/` :

1. `01_project_context_and_stack.md` — Stack technique, versions, philosophie Offline-First
2. `02_database_schema.md` — 22 tables Drift/SQLite avec relations et règles de calcul
3. `03_network_protocol.md` — Protocole WebSocket/mDNS entre PC et mobile
4. `04_business_scenarios_qa.md` — 50 scénarios métier réels de restauration
5. `05_design_system.md` — Design system, couleurs, espacements, règles UX Fat-Finger
6. `06_folder_structure.md` — Clean Architecture, monorepo Melos, conventions de nommage
7. `07_security_and_auth.md` — Hachage PIN, RBAC, matrice des permissions, audit trail
8. `08_error_handling_strategy.md` — Résilience par couche, recovery, mode dégradé
9. `09_testing_strategy.md` — Pyramide de tests, coverage, BLoC testing
10. `10_i18n_and_localization.md` — Bilingue FR/AR, devise MAD, contenu légal tickets Maroc
11. `11_roadmap_and_business.md` — Roadmap 6 sprints, conseils métier marché marocain

Tu ne dois JAMAIS contredire les décisions documentées dans ces fichiers. Si tu détectes une incohérence, signale-la AVANT de coder.

## CONTEXTE TECHNIQUE

- **Projet :** Ritagestion — POS Restaurant Offline-First
- **Framework :** Flutter ^3.40.0, Dart ^3.8.0
- **Architecture :** Clean Architecture + BLoC Pattern + Monorepo Melos
- **BDD locale :** Drift ^3.0.0 (22 tables avec UUID)
- **Sync cloud :** PowerSync ^1.5.0 + Supabase/PostgreSQL
- **Réseau LAN :** Shelf (WebSocket server) + ns_ds_network (mDNS)
- **Impression :** unified_esc_pos_printer ^1.2.0
- **Desktop :** desktop_multi_window + window_manager
- **Plateformes :** Windows (Caisse PC) + Android/iOS (Waiters Mobile)

## RÈGLES NON-NÉGOCIABLES

### Architecture
1. Toutes les tables utilisent des UUID (String) comme clé primaire
2. Aucune action métier ne dépend d'un appel réseau — tout est local d'abord (Drift)
3. Les prix sont FIGÉS dans OrderItems.unitPrice au moment de la commande
4. Les messages WebSocket ont un messageId unique (idempotence)
5. Le code métier (BLoC) est 100% agnostique de l'UI
6. Respecter la séparation des couches : Presentation → Domain → Data

### UI/UX (Fat-Finger Rules)
7. INTERDIT de coder des couleurs en dur — utiliser Theme.of(context).colorScheme
8. INTERDIT d'utiliser des paddings aléatoires — grille de 8px uniquement
9. Tous les boutons tactiles : minimum 64x64 pixels
10. Zéro scroll horizontal — grilles réactives ou listes verticales
11. Le bouton "PAYER" est le plus massif de l'écran
12. Feedback visuel immédiat sur chaque interaction (Ripple + haptique)

### Sécurité
13. PIN stocké en hash bcrypt, JAMAIS en clair
14. Actions sensibles = PIN Manager obligatoire + entrée AuditTrail
15. Auto-lock après 120s (PC) / 60s (Mobile)

### Code Quality
16. Nommage : fichiers snake_case, classes PascalCase, BLoC events au passé
17. Imports ordonnés : Dart SDK → Flutter → Packages externes → Packages internes → Relatifs
18. Tests unitaires 100% sur les calculs financiers
19. Pas de print() en production — utiliser un Logger structuré

## TÂCHE ACTUELLE : Sprint 0 — Fondations

Exécute les étapes suivantes dans cet ordre exact :

### Étape 1 : Initialiser le Monorepo Melos
Crée la structure de dossiers définie dans `06_folder_structure.md` :
- `packages/core/` avec son pubspec.yaml
- `packages/network/` avec son pubspec.yaml
- `apps/pos_desktop/` (Flutter Windows app)
- `apps/waiter_mobile/` (Flutter Android/iOS app)
- `melos.yaml` à la racine

### Étape 2 : Implémenter les 22 tables Drift
Dans `packages/core/lib/database/`, crée les fichiers de tables Drift en respectant EXACTEMENT le schéma de `02_database_schema.md`. Chaque table dans un fichier séparé organisé par domaine :
- `tables/restaurant_config.dart`
- `tables/users.dart`
- `tables/zones.dart`
- `tables/restaurant_tables.dart`
- `tables/reservations.dart`
- `tables/time_attendance.dart`
- `tables/print_stations.dart`
- `tables/categories.dart`
- `tables/products.dart`
- `tables/modifier_groups.dart`
- `tables/modifier_options.dart`
- `tables/product_modifiers.dart`
- `tables/ingredients.dart`
- `tables/recipe_items.dart`
- `tables/cash_sessions.dart`
- `tables/cash_movements.dart`
- `tables/orders.dart`
- `tables/order_items.dart`
- `tables/order_item_modifiers.dart`
- `tables/discounts.dart`
- `tables/payments.dart`
- `tables/sync_queue.dart`
- `tables/audit_trail.dart`

Puis crée `app_database.dart` qui déclare @DriftDatabase avec toutes les tables.

### Étape 3 : Créer le Design System
Dans `apps/pos_desktop/lib/theme/`, crée :
- `app_colors.dart` — ColorScheme selon `05_design_system.md`
- `app_spacing.dart` — Constantes d'espacement (multiples de 8)
- `app_typography.dart` — TextTheme avec Google Fonts (Inter)
- `app_theme.dart` — ThemeData complet assemblant les 3 fichiers ci-dessus

### Étape 4 : Données de Test (Seed)
Dans `tools/seed_data.dart`, crée un script qui insère :
- 1 RestaurantConfig (nom: "Chez Ritaj", ICE: "001234567000089")
- 3 Users : Admin (PIN: 1234), Caissier (PIN: 5678), Serveur (PIN: 9012)
- 3 Zones : Salle (4 tables), Terrasse (3 tables), VIP (1 table)
- 2 PrintStations : Cuisine (192.168.1.100), Bar (192.168.1.101)
- 4 Catégories : Entrées→Cuisine, Plats→Cuisine, Boissons→Bar, Desserts→Cuisine
- 15 Produits avec prix DineIn/Takeaway et quelques modificateurs
- 3 ModifierGroups : Cuisson (Saignant/À point/Bien cuit), Suppléments (Fromage/Bacon), Sauces (Ketchup/Mayo)

### Étape 5 : Générer le code Drift
Exécute `dart run build_runner build` pour générer le fichier `.g.dart`.

---

Confirme que tu as bien lu tous les fichiers de `docs/architecture/` et commence par l'Étape 1. Ne saute aucune étape. Montre-moi le code de chaque fichier créé.
```

---

## COMMENT UTILISER CE MEGA PROMPT

### Option A — Cursor / Windsurf
1. Ouvre le projet `c:\devzone\flutpos` dans Cursor/Windsurf
2. Ouvre le Composer (Ctrl+I ou Cmd+I)
3. Copie-colle le contenu entre les ``` ci-dessus
4. L'agent lira automatiquement les fichiers `docs/architecture/` grâce à la directive `.cursorrules`

### Option B — Claude / ChatGPT
1. Upload les 11 fichiers du dossier `docs/architecture/` en pièces jointes
2. Copie-colle le prompt ci-dessus
3. Claude/GPT génèrera le code en respectant le contexte

### Option C — Cline (VS Code)
1. Ouvre le projet dans VS Code avec l'extension Cline
2. Les fichiers `.cursorrules` sont automatiquement lus par Cline
3. Tape le prompt dans la barre Cline

---

## PROMPTS POUR LES SPRINTS SUIVANTS

### Sprint 1 — Après Sprint 0 validé :
```
Le Sprint 0 est terminé. Le monorepo Melos est initialisé, les 22 tables Drift sont générées, le thème est en place, et les données de test sont insérées.

Passe au Sprint 1 : Caisse Desktop MVP.
Réfère-toi à `11_roadmap_and_business.md` pour les objectifs détaillés.

Commence par :
1. L'écran d'authentification PIN (numpad tactile selon 05_design_system.md)
2. La structure 3 colonnes de l'écran principal (catégories | grille | panier)
3. Le CartBloc pour ajouter/supprimer des articles avec modificateurs

Applique l'approche Atomic Design : crée d'abord les atomes (PosButton, PriceTag), puis les molécules (ProductCard, CartItem), puis les organismes (ProductsGrid, CartPanel).
```

### Sprint 2 — Après Sprint 1 validé :
```
Le Sprint 1 est terminé. La caisse Desktop fonctionne : authentification PIN, grille de produits, panier avec modificateurs, impression ticket client et cuisine.

Passe au Sprint 2 : Réseau LAN + Mobile Waiters.
Réfère-toi à `03_network_protocol.md` et `11_roadmap_and_business.md`.

Commence par :
1. Le serveur Shelf dans packages/network/lib/server/
2. Le broadcast mDNS depuis le PC
3. L'app mobile waiter_mobile avec écran de découverte réseau
4. Le SyncQueueManager pour le mode offline
```
