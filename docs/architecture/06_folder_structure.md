# Architecture de Code (Clean Architecture + Feature-First)

## 1. Structure du Monorepo (Melos)

```
ritagestion/
├── melos.yaml                    # Configuration Melos
├── pubspec.yaml                  # Workspace root
├── .cursorrules                  # Règles IA
├── docs/architecture/            # Documentation technique
│
├── packages/
│   ├── core/                     # Modèles, BDD, logique métier partagée
│   │   ├── lib/
│   │   │   ├── database/         # Drift tables, DAOs, app_database.dart
│   │   │   ├── entities/         # Modèles métier purs (CompleteOrder, etc.)
│   │   │   ├── enums/            # OrderType, PaymentMethod, UserRole, etc.
│   │   │   ├── repositories/     # Interfaces abstraites des repos
│   │   │   ├── usecases/         # Logique métier isolée (CalculateTotal, ApplyDiscount)
│   │   │   └── utils/            # UUID generator, formatters, date utils
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   └── network/                  # WebSocket, mDNS, API, SyncQueue
│       ├── lib/
│       │   ├── server/           # PosNetworkServer (Shelf, côté PC)
│       │   ├── client/           # WaiterNetworkClient (côté Mobile)
│       │   ├── discovery/        # mDNS via ns_ds_network
│       │   ├── protocol/         # EventEnvelope, actions, sérialisation
│       │   └── sync/             # SyncQueueManager, retry logic
│       ├── test/
│       └── pubspec.yaml
│
├── apps/
│   ├── pos_desktop/              # Application Caisse PC (Windows)
│   │   ├── lib/
│   │   │   ├── main.dart
│   │   │   ├── app.dart          # MaterialApp, thème, routing
│   │   │   ├── di/               # Injection de dépendances (GetIt)
│   │   │   ├── theme/            # app_theme.dart, colors.dart, spacing.dart
│   │   │   ├── navigation/       # GoRouter config
│   │   │   ├── blocs/            # BLoCs spécifiques Desktop
│   │   │   ├── pages/
│   │   │   │   ├── auth/         # Écran PIN
│   │   │   │   ├── floor_plan/   # Plan de salle
│   │   │   │   ├── pos/          # Écran caisse principal
│   │   │   │   ├── payment/      # Écran encaissement
│   │   │   │   ├── session/      # Ouverture / Clôture Z
│   │   │   │   └── backoffice/   # Gestion produits, rapports
│   │   │   └── widgets/          # Composants Atomic Design
│   │   │       ├── atoms/        # PosButton, PriceTag, StatusBadge
│   │   │       ├── molecules/    # ProductCard, CartItem, TableTile
│   │   │       └── organisms/    # ProductsGrid, CartPanel, CategoryBar
│   │   ├── windows/
│   │   └── pubspec.yaml
│   │
│   └── waiter_mobile/            # Application Serveurs (Android/iOS)
│       ├── lib/
│       │   ├── main.dart
│       │   ├── app.dart
│       │   ├── di/
│       │   ├── theme/
│       │   ├── blocs/
│       │   ├── pages/
│       │   │   ├── connect/      # Découverte mDNS + connexion
│       │   │   ├── tables/       # Liste des tables
│       │   │   ├── order/        # Prise de commande
│       │   │   └── status/       # Suivi commandes envoyées
│       │   └── widgets/
│       └── pubspec.yaml
│
└── tools/                        # Scripts utilitaires
    ├── seed_data.dart            # Données de test (Mock)
    └── generate_mocks.dart       # Générateur de mocks pour tests
```

---

## 2. Conventions de Nommage

| Élément | Convention | Exemple |
|---|---|---|
| Fichiers | `snake_case.dart` | `cash_session_bloc.dart` |
| Classes | `PascalCase` | `CashSessionBloc` |
| BLoC Events | `PascalCase` verbe passé | `OrderItemAdded`, `PaymentSubmitted` |
| BLoC States | `PascalCase` adjectif/nom | `OrderLoading`, `OrderReady`, `OrderError` |
| Enums | `PascalCase` valeurs `camelCase` | `enum OrderType { dineIn, takeaway, delivery }` |
| Tables Drift | `PascalCase` pluriel | `class Orders extends Table` |
| DAOs | `PascalCase` + `Dao` | `OrdersDao`, `ProductsDao` |
| Repositories | `Interface` + `Impl` | `OrderRepository` / `OrderRepositoryImpl` |

---

## 3. Règles d'Import

```dart
// 1. Dart SDK
import 'dart:async';

// 2. Flutter SDK
import 'package:flutter/material.dart';

// 3. Packages externes (pub.dev)
import 'package:flutter_bloc/flutter_bloc.dart';

// 4. Packages internes (monorepo)
import 'package:core/database/app_database.dart';

// 5. Imports relatifs (même package)
import '../widgets/atoms/pos_button.dart';
```

---

## 4. Séparation des Couches (Règle stricte)

```
┌─────────────────────────────────────────┐
│  PRESENTATION (pages, widgets, blocs)   │  ← Connaît Domain uniquement
├─────────────────────────────────────────┤
│  DOMAIN (entities, usecases, repos IF)  │  ← Zéro dépendance externe
├─────────────────────────────────────────┤
│  DATA (database, network, repos IMPL)   │  ← Implémente Domain
└─────────────────────────────────────────┘
```

- **INTERDIT :** Importer Drift dans un fichier `pages/` ou `widgets/`
- **INTERDIT :** Importer Flutter dans un fichier `usecases/` ou `entities/`
- **OBLIGATOIRE :** Les BLoCs communiquent avec la couche Data via les Repositories (interfaces)
