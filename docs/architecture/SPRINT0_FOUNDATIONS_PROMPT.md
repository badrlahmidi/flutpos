# 🚀 MEGA PROMPT — Sprint 0 : Fondations

> Ce fichier est le prompt maître détaillé pour le Sprint 0. Copie-colle l'intégralité ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude).

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter/Dart senior spécialisé dans les architectures POS (Point of Sale). Tu travailles sur le projet "Ritagestion".

## ÉTAT CIBLE DU SPRINT 0

L'objectif de ce sprint est de poser les fondations robustes du monorepo : la base de données Drift complète (22 tables), la structure Melos, le Design System, et les données de test (Seed).

### Versions à utiliser
- Flutter 3.44.1 / Dart 3.12.1
- drift 2.33.0 / drift_dev 2.33.0 / sqlite3 3.3.2
- bcrypt ^1.1.3

## DIRECTIVES OBLIGATOIRES

AVANT de générer le code, tu DOIS te baser sur les règles définies dans `docs/architecture/` :
1. `06_folder_structure.md` — Pour la structure exacte du monorepo Melos.
2. `02_database_schema.md` — Pour les 22 tables Drift (utiliser stricto sensu les UUID, les types et les relations).
3. `05_design_system.md` — Pour le thème (couleurs sans code en dur, grille de 8px, typographie Inter/Roboto).
4. `07_security_and_auth.md` — Le PIN doit être hashé avec bcrypt, jamais en clair.

## TÂCHES À EXÉCUTER DANS L'ORDRE :

### Étape 1 : Initialisation Monorepo et `packages/core`
1. Crée le `melos.yaml` à la racine (avec les scripts `bootstrap`, `analyze`, `build:drift`, etc.).
2. Crée la structure `packages/core/` avec son `pubspec.yaml` (ajoute drift, sqlite3, path, uuid, bcrypt).
3. Crée `apps/pos_desktop/` et `apps/waiter_mobile/` avec des `pubspec.yaml` de base qui dépendent de `core`.

### Étape 2 : Implémentation de la Base de Données (Drift)
Dans `packages/core/lib/database/tables/`, crée les 22 fichiers Dart pour chaque table décrite dans `02_database_schema.md`.
Règles strictes :
- Clés primaires = `TextColumn get id => text().clientDefault(() => const Uuid().v4())()`.
- Respecter exactement les types (`RealColumn` pour les prix, `IntColumn`, `BoolColumn`).
- Ajouter les relations de clés étrangères logiciellement si nécessaire, ou au moins les champs `X_id`.

Ensuite, crée `packages/core/lib/database/app_database.dart` :
- Déclare `@DriftDatabase(tables: [ToutesLesTables])`.
- Implémente la connexion SQLite via `NativeDatabase`.
- Définit la version du schéma à 2.

### Étape 3 : Implémentation du Design System
Dans `apps/pos_desktop/lib/theme/`, crée :
1. `app_colors.dart` : Définit le `ColorScheme` (primary, secondary, surface, background, error).
2. `app_spacing.dart` : Constantes (spacingXs: 4, spacingS: 8, spacingM: 16, spacingL: 24, spacingXl: 32).
3. `app_typography.dart` : `TextTheme` pour la lisibilité POS.
4. `app_theme.dart` : Assemble le tout dans un `ThemeData`.

### Étape 4 : Hachage des PIN et Sécurité
Dans `packages/core/lib/utils/pin_hasher.dart` (ou équivalent) :
- Crée un utilitaire wrapper autour de `bcrypt` pour hasher un PIN et vérifier un PIN.

### Étape 5 : Script de Seed (Données Mock)
Dans `tools/seed_data.dart`, écris un script Dart autonome qui :
1. Initialise la base de données SQLite localement (`ritagestion_seed.db`).
2. Insère :
   - 1 RestaurantConfig (ICE, RC, Devise MAD).
   - 3 Users (Admin, Cashier, Waiter) avec leurs PIN passés dans le hacheur bcrypt.
   - 3 Zones (Salle, Terrasse, VIP) avec 8 Tables au total.
   - 2 PrintStations (Cuisine, Bar).
   - 4 Categories (Entrées, Plats, Desserts, Boissons).
   - 15 Products (avec `priceDineIn`, `taxRate`).
   - 3 ModifierGroups avec leurs ModifierOptions (ex: Cuisson viande, Suppléments).
3. Doit s'exécuter avec `dart run tools/seed_data.dart`.

### Étape 6 : Génération et Validation
- Explique les commandes à lancer pour générer le code Drift : `melos run build:drift`.
- Vérifie que l'analyse statique passe sur le package `core`.

Ne saute aucune étape. Montre-moi le code complet des fichiers clés (melos.yaml, un exemple de table Drift, app_database.dart, app_theme.dart, et le script seed_data.dart).
```

---

## VÉRIFICATIONS POST-SPRINT 0

Une fois que l'agent a terminé la génération, vous devez vérifier :

```bash
# 1. Installer les dépendances
melos bootstrap

# 2. Générer le code Drift
melos run build:drift

# 3. Vérifier l'analyse statique
melos run analyze

# 4. Générer les données de test
dart run tools/seed_data.dart
```

Si tout s'exécute sans erreur et que le fichier `ritagestion_seed.db` est créé, le Sprint 0 est validé.
