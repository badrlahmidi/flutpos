# 🖥️ MEGA PROMPT — Sprint 1 : Caisse Desktop MVP

> Ce fichier est le prompt maître détaillé pour le Sprint 1. Copie-colle l'intégralité ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude).

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter/Dart senior spécialisé dans le développement d'interfaces POS (Point of Sale) tactiles et réactives. Tu travailles sur le projet "Ritagestion".

## ÉTAT ACTUEL DU PROJET (Sprint 0 terminé ✅)

Les fondations du monorepo sont en place. Le package `core` expose la base de données Drift (22 tables), l'utilitaire `PinHasher`, et les données de test sont injectées. Le Design System est défini dans `app_theme.dart`.

## OBJECTIF DU SPRINT 1
Développer l'application `pos_desktop` (Caisse Windows) en appliquant les principes de Clean Architecture (Feature-First) et d'Atomic Design. L'objectif est d'avoir une prise de commande complète : Auth PIN → Panier → Impression.

## DIRECTIVES OBLIGATOIRES AVANT DE CODER
Assure-toi de respecter les documents d'architecture (présents dans `docs/architecture/`) :
1. `05_design_system.md` : **Règles "Fat-Finger"**. Boutons tactiles de taille minimum `64x64px`. Aucune couleur en dur (utiliser `Theme.of(context).colorScheme`).
2. `06_folder_structure.md` : **Architecture Feature-First**. Les BLoCs communiquent avec la DB via des Repositories.
3. `02_database_schema.md` : Les prix sont ajoutés au panier dans `OrderItems.unitPrice` (figés au moment de la commande).
4. **Immutabilité** : Le code ne doit jamais muter d'états directement, mais passer par des événements `flutter_bloc`.

## TÂCHES À EXÉCUTER DANS L'ORDRE :

### Étape 1 : Injection de dépendances et Repositories
Dans `apps/pos_desktop/lib/di/`, configure l'injection de dépendances (ex: `get_it` ou `provider` simple) pour injecter :
- L'instance de `AppDatabase` (du package `core`).
- Les repositories (à créer dans `packages/core/lib/repositories/`) : `AuthRepository` (qui utilise `PinHasher`), `ProductRepository`, `OrderRepository`.

### Étape 2 : Écran d'Authentification PIN (Auth Feature)
Crée `apps/pos_desktop/lib/pages/auth/` avec :
- `AuthBloc` : Gère les états `AuthInitial`, `AuthLoading`, `AuthSuccess(User)`, `AuthFailure`.
- Un clavier numérique (Numpad) tactile massif (touches `64x64px` minimum).
- La logique : L'utilisateur tape son PIN → le BLoC vérifie avec `AuthRepository.verifyPin` → si succès, redirection vers l'écran de caisse.

### Étape 3 : Composants Atomic Design
Dans `apps/pos_desktop/lib/widgets/`, crée les composants réutilisables basés sur le `ThemeData` :
- **Atoms** : `PosButton` (avec effet Ripple), `PriceTag` (format "XX,XX DH").
- **Molecules** : `ProductCard` (image placeholder/icône + nom + prix).
- **Organisms** : `CategoryBar` (liste verticale des catégories), `ProductsGrid` (SliverGrid responsive).

### Étape 4 : Écran Principal de Caisse (POS Feature)
Crée l'interface en 3 colonnes :
- **Colonne de gauche (20%)** : `CategoryBar`. Pas de scroll horizontal.
- **Colonne centrale (50%)** : `ProductsGrid` affichant les produits de la catégorie sélectionnée.
- **Colonne de droite (30%)** : `CartPanel`.
Configure le mode plein écran (`window_manager`) pour bloquer la sortie.

### Étape 5 : BLoC Cart (Gestion du Panier)
Crée `CartBloc` qui gère les entités (ex: `CompleteOrder` avec `OrderItemWithProduct`) :
- Événements : `AddItem`, `RemoveItem`, `UpdateQuantity`, `AddModifier`.
- Calcul des totaux dynamiques (Sous-total + Modificateurs + TVA).
- **Fallback des prix** : Applique le prix selon le type de commande (`DineIn` ou `Takeaway`).

### Étape 6 : Modificateurs (Popup/Modal)
Lorsqu'un produit possède des modificateurs (ex: Cuisson de la viande), affiche un modal massif permettant de sélectionner rapidement "Saignant", "Supplément Fromage", etc.

### Étape 7 : Impression Thermique (Simulée puis implémentée)
Crée un service d'impression utilisant `unified_esc_pos_printer` :
- **Ticket Cuisine** : Envoi asynchrone des plats vers l'IP définie dans `PrintStations`.
- **Ticket Client** : Impression locale USB/Ethernet du reçu final.

Ne saute aucune étape. Procède étape par étape. Commence par l'Étape 1 (DI et Repositories) et montre-moi le code généré.
```

---

## VÉRIFICATIONS POST-SPRINT 1

Une fois le code généré par l'agent, testez le flux complet :
1. Lancez l'application Desktop (`flutter run -d windows`).
2. Saisissez le PIN `1234` (Admin).
3. Cliquez sur une catégorie, ajoutez des produits au panier.
4. Testez l'ajout d'un produit avec un modificateur (Cuisson).
5. Vérifiez que le total se met à jour correctement et que l'interface est "Fat-Finger friendly" (boutons assez gros).
