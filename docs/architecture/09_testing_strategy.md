# Stratégie de Tests

Un POS manipule de l'argent. Zéro bug toléré sur les calculs de prix, TVA et monnaie rendue.

---

## 1. Pyramide de Tests

```
        ┌──────────┐
        │  E2E (5%) │  ← Flux complet : Commande → Paiement → Clôture Z
       ┌┴──────────┴┐
       │ Widget (20%)│  ← Composants UI Atomic Design
      ┌┴────────────┴┐
      │ BLoC (30%)    │  ← Tous les états et transitions
     ┌┴──────────────┴┐
     │ Unit (45%)      │  ← Calculs, formatters, repositories
     └────────────────┘
```

---

## 2. Tests Unitaires (45% — packages/core)

### Calculs financiers (CRITIQUE — Couverture 100%)
```
test/usecases/
├── calculate_order_total_test.dart
├── calculate_tax_test.dart
├── calculate_change_test.dart
├── apply_discount_test.dart
├── split_bill_test.dart
└── food_cost_deduction_test.dart
```

**Scénarios obligatoires :**
- Calcul total avec modificateurs payants
- Remise % sur un ticket avec TVA multiple
- Split bill par 3 sur un montant non divisible (333.33 DH)
- Monnaie rendue sur paiement mixte (Carte 200 + Espèces 300 pour 320 DH)
- Food cost : vente d'un burger → déduction fromage, pain, viande
- Fallback prix : priceTakeaway null → utiliser priceDineIn

### Repositories & DAOs
```
test/repositories/
├── orders_repository_test.dart
├── products_repository_test.dart
├── cash_session_repository_test.dart
└── sync_queue_repository_test.dart
```

**Utiliser :** Base Drift en mémoire (`NativeDatabase.memory()`) pour les tests

---

## 3. Tests BLoC (30%)

**Package :** `bloc_test` ^9.0.0

### BLoCs à tester en priorité

| BLoC | Transitions critiques |
|---|---|
| `OrderBloc` | Ajout item → Calcul total → Envoi cuisine → Paiement |
| `PaymentBloc` | Split payment → Calcul monnaie → Clôture ticket |
| `CartBloc` | Ajout/suppression items → Modificateurs → Notes |
| `SessionBloc` | Ouverture → X-Report → Z-Report → Clôture |
| `SyncBloc` | Offline queue → Reconnexion → Purge queue |
| `AuthBloc` | PIN correct → PIN incorrect x3 → Verrouillage |

### Pattern de test BLoC
```dart
blocTest<OrderBloc, OrderState>(
  'should calculate total with modifiers and discount',
  build: () => OrderBloc(repository: mockRepo),
  act: (bloc) {
    bloc.add(OrderItemAdded(product: burger, modifiers: [bacon]));
    bloc.add(DiscountApplied(type: 'PERCENTAGE', value: 10));
  },
  expect: () => [
    OrderLoading(),
    OrderReady(total: 54.0), // (50 + 10 bacon) * 0.9 = 54
  ],
);
```

---

## 4. Tests Widget (20%)

### Composants Atomic Design à tester
```
test/widgets/
├── atoms/
│   ├── pos_button_test.dart        # Taille min 64x64, ripple effect
│   ├── price_tag_test.dart         # Format DH, décimales
│   └── status_badge_test.dart      # Couleurs selon statut
├── molecules/
│   ├── product_card_test.dart      # Image, nom, prix, tap callback
│   ├── cart_item_test.dart         # Quantité, swipe-to-delete
│   └── table_tile_test.dart        # Statut coloré, nombre couverts
└── organisms/
    ├── products_grid_test.dart     # Responsiveness, scroll vertical
    └── cart_panel_test.dart        # Total, bouton PAYER massif
```

**Règles de test UI :**
- Vérifier que tous les boutons ont `minSize >= 64x64`
- Vérifier qu'aucune couleur n'est codée en dur (utilise Theme)
- Vérifier le contraste du bouton PAYER

---

## 5. Tests d'Intégration (5%)

### Flux critiques E2E
```
integration_test/
├── full_order_flow_test.dart       # Commande → Cuisine → Paiement → Ticket
├── offline_sync_flow_test.dart     # Offline → Queue → Reconnexion → Sync
├── session_lifecycle_test.dart     # Ouverture → Ventes → Pay-out → Clôture Z
└── split_bill_flow_test.dart       # Split par article + paiement mixte
```

---

## 6. Golden Tests (Régression visuelle)

**Package :** `golden_toolkit`

Capturer des screenshots de référence pour :
- Écran de caisse principal (3 colonnes)
- Modal de paiement
- Plan de salle
- Ticket de caisse (format impression)

**Commande :** `flutter test --update-goldens` pour régénérer les références

---

## 7. Outils & Configuration

### Packages de test dans `dev_dependencies`
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  bloc_test: ^9.0.0
  mocktail: ^1.0.0
  golden_toolkit: ^0.15.0
  drift_dev: ^3.0.0
```

### Coverage minimum requis
| Couche | Minimum |
|---|---|
| `usecases/` (calculs financiers) | **100%** |
| `blocs/` | **90%** |
| `repositories/` | **80%** |
| `widgets/` | **60%** |
| Global | **75%** |

### Commande CI
```bash
flutter test --coverage
# Vérifier le seuil
lcov --summary coverage/lcov.info
```
