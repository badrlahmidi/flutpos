# 🚀 MEGA PROMPT — Refonte Visuelle Ritagestion POS Desktop

> **Instruction pour Claude Code :** Copier-coller ce prompt en entier dans Claude Code. Il contient toutes les instructions, le contexte, et les checklists pour exécuter la refonte complète.

---

## 📋 CONTEXTE PROJET

Tu travailles sur un **POS (Point of Sale) Flutter Desktop** pour la restauration au Maroc.

- **Monorepo Melos** : `c:\devzone\flutpos\`
- **App cible** : `apps/pos_desktop/`
- **Core package** : `packages/core/`
- **Architecture** : Clean Architecture, BLoC, Drift (SQLite), Atomic Design
- **OS cible** : Windows Desktop
- **Langue UI** : Français

### Structure actuelle des pages :
```
apps/pos_desktop/lib/
├── app.dart                    # MaterialApp, home=AuthPage
├── main.dart
├── theme/                      # app_colors, app_theme, app_spacing, app_typography, pos_design_tokens
├── pages/
│   ├── auth/auth_page.dart            # Login PIN
│   ├── pos/pos_page.dart              # Caisse 3 colonnes (765 lignes)
│   ├── floor_plan/floor_plan_page.dart # Plan salle
│   ├── floor_plan/split_bill_page.dart
│   ├── payment/payment_page.dart      # Encaissement
│   ├── session/session_hub_page.dart  # Trésorerie
│   ├── session/z_close_page.dart      # Clôture Z
│   ├── kds/kds_page.dart              # Cuisine
│   ├── reservations/reservations_page.dart
│   ├── backoffice/catalog_admin_page.dart
│   ├── backoffice/analytics_dashboard_page.dart
│   └── backoffice/accounting_export_page.dart
├── blocs/    # cart, catalog, floor_plan, kds, payment, reservations, analytics_dashboard
├── widgets/
│   ├── atoms/    # pos_button, amount_numpad, price_tag, auto_direction_text_field
│   ├── molecules/ # cart_item_tile, product_card, service_mode_toggle
│   ├── organisms/ # cart_panel, category_bar, pos_catalog_toolbar, pos_top_bar, products_grid
│   └── dialogs/  # apply_discount, manager_pin, void_item, voucher
├── di/       # GetIt service locator, app_bootstrap
├── services/ # print, accounting_export, pos_service_mode
├── platform/ # desktop_window
└── utils/    # discount_flow, manager_auth, price_formatter
```

---

## 🎯 OBJECTIF GLOBAL

Exécuter une **refonte visuelle complète** en 5 phases :
1. Nouveau Dark Theme pro
2. Navigation GoRouter + MainMenu + BackofficeShell
3. Polish des pages fullscreen (Auth, POS, FloorPlan, Payment)
4. Modules backoffice avec CRUD
5. Animations et polish final

**Règles STRICTES :**
- NE PAS casser la logique métier existante (BLoCs, repositories, entities)
- Utiliser `Theme.of(context).colorScheme` et `Theme.of(context).textTheme` — jamais de couleurs en dur dans les widgets
- Garder tous les commentaires et docstrings existants
- Grille d'espacement 8px (AppSpacing)
- Touch targets minimum 64px (Fat-Finger Rule)
- Tester la compilation après chaque phase : `cd apps/pos_desktop && flutter build windows --debug`

---

## 📦 PHASE 0 — INSTALLATION PACKAGES

### Instructions :
```bash
cd c:\devzone\flutpos\apps\pos_desktop
flutter pub add go_router
flutter pub add flutter_animate
flutter pub add data_table_2
flutter pub add sidebarx
flutter pub add fl_chart
```

Vérifier que `google_fonts` et `window_manager` sont déjà dans le pubspec.yaml.

### Checklist Phase 0 :
- [ ] `go_router` ajouté au pubspec.yaml et résolu
- [ ] `flutter_animate` ajouté et résolu
- [ ] `data_table_2` ajouté et résolu
- [ ] `sidebarx` ajouté et résolu
- [ ] `fl_chart` ajouté et résolu (ou déjà présent)
- [ ] `flutter pub get` passe sans erreur
- [ ] Compilation `flutter build windows --debug` réussie

---

## 🎨 PHASE 1 — DARK THEME & DESIGN TOKENS

### 1.1 Modifier `theme/app_colors.dart`

Remplacer la palette light par un système dual (light+dark). Ajouter :

```dart
abstract final class AppColors {
  // ─── DARK PALETTE (principale) ───
  static const scaffoldDark    = Color(0xFF0F1117);
  static const surfaceDark     = Color(0xFF1A1D27);
  static const surfaceElevated = Color(0xFF232733);
  static const surfaceHover    = Color(0xFF2A2E3B);

  static const accentBlue      = Color(0xFF6C8EFF);
  static const accentGreen     = Color(0xFF4ADE80);
  static const accentOrange    = Color(0xFFFB923C);
  static const accentRed       = Color(0xFFEF4444);
  static const accentPurple    = Color(0xFFA78BFA);

  static const textPrimary     = Color(0xFFF1F5F9);
  static const textSecondary   = Color(0xFF94A3B8);
  static const textMuted       = Color(0xFF64748B);

  static const borderSubtle    = Color(0xFF2A2E3B);
  static const borderActive    = Color(0xFF6C8EFF);

  // Conserver lightColorScheme existant
  // Ajouter darkColorScheme
  static ColorScheme get darkColorScheme => const ColorScheme(
    brightness: Brightness.dark,
    primary: accentBlue,
    onPrimary: Color(0xFFFFFFFF),
    primaryContainer: Color(0xFF1E2A4A),
    onPrimaryContainer: accentBlue,
    secondary: accentOrange,
    onSecondary: Color(0xFF000000),
    secondaryContainer: Color(0xFF3D2800),
    onSecondaryContainer: accentOrange,
    surface: surfaceDark,
    onSurface: textPrimary,
    surfaceContainerHighest: surfaceElevated,
    onSurfaceVariant: textSecondary,
    error: accentRed,
    onError: Color(0xFFFFFFFF),
    errorContainer: Color(0xFF3D0000),
    onErrorContainer: accentRed,
    outline: borderSubtle,
    outlineVariant: Color(0xFF1E2230),
    tertiary: accentPurple,
    tertiaryContainer: Color(0xFF2D1F5E),
    onTertiaryContainer: accentPurple,
  );
}
```

### 1.2 Modifier `theme/app_theme.dart`

Ajouter un getter `static ThemeData get dark` qui utilise `darkColorScheme`. Copier la structure de `light` mais adapter les couleurs. Changer `scaffoldBackgroundColor` en `AppColors.scaffoldDark`.

### 1.3 Modifier `theme/app_typography.dart`

Ajouter JetBrains Mono pour les prix :
```dart
static TextStyle priceStyle(ColorScheme scheme) => GoogleFonts.jetBrainsMono(
  fontSize: 18,
  fontWeight: FontWeight.w700,
  color: scheme.onSurface,
);
```

### 1.4 Modifier `theme/pos_design_tokens.dart`

Mettre à jour les couleurs pour le dark theme (shellBackground → scaffoldDark, etc.)

### 1.5 Modifier `app.dart`

Changer `theme: AppTheme.light` → `theme: AppTheme.dark` (ou `darkTheme: AppTheme.dark, themeMode: ThemeMode.dark`)

### Checklist Phase 1 :
- [ ] `app_colors.dart` — palette dark complète + `darkColorScheme`
- [ ] `app_theme.dart` — getter `dark` avec tous les component themes
- [ ] `app_typography.dart` — JetBrains Mono ajouté pour prix
- [ ] `pos_design_tokens.dart` — tokens mis à jour pour dark
- [ ] `app.dart` — utilise le dark theme
- [ ] Compilation réussie
- [ ] L'app démarre avec le thème dark

---

## 🗺️ PHASE 2 — NAVIGATION & NOUVELLES PAGES

### 2.1 Créer `navigation/app_router.dart`

```dart
import 'package:go_router/go_router.dart';
// Configurer GoRouter avec :
// - / → AuthPage
// - /menu → MainMenuPage
// - /pos → PosPage (fullscreen, pas de shell)
// - /floor → FloorPlanPage (fullscreen)
// - /kds → KdsPage (fullscreen)
// - /payment/:orderId → PaymentPage (fullscreen)
// - /backoffice → BackofficeShell (ShellRoute)
//   - /backoffice/menu/categories → CategoriesPage
//   - /backoffice/menu/products → ProductsPage
//   - /backoffice/menu/modifiers → ModifiersPage
//   - /backoffice/menu/notes → NotesPage
//   - /backoffice/treasury → TreasuryPage
//   - /backoffice/treasury/z-close → ZClosePage
//   - /backoffice/analytics → AnalyticsDashboardPage
//   - /backoffice/accounting → AccountingExportPage
//   - /backoffice/reservations → ReservationsPage
//   - /backoffice/settings → SettingsPage
```

**IMPORTANT :** Le `User` authentifié doit être passé via un state global (provider ou GoRouter extra). Les pages qui nécessitent `user` (PosPage, FloorPlanPage, etc.) doivent le recevoir.

### 2.2 Créer `pages/main_menu/main_menu_page.dart`

Page de tuiles 3×3. Chaque tuile = `_MenuTile` widget avec :
- Icon (48px), Label, sous-label optionnel
- onTap → `context.go('/pos')`, `context.go('/floor')`, etc.
- Couleur accent par tuile
- Animation `flutter_animate` : staggered fadeIn + scale à l'entrée

Tuiles :
1. 🛒 CAISSE (POS) → `/pos`
2. 🍽️ SALLE (Plan) → `/floor`
3. 👨‍🍳 CUISINE (KDS) → `/kds`
4. 📋 GESTION MENU → `/backoffice/menu/categories`
5. 💰 TRÉSORERIE → `/backoffice/treasury`
6. 📊 STATISTIQUES → `/backoffice/analytics`
7. 📅 RÉSERVATIONS → `/backoffice/reservations`
8. 📤 EXPORT COMPTA. → `/backoffice/accounting`
9. ⚙️ PARAMÈTRES → `/backoffice/settings`

### 2.3 Créer `pages/backoffice/backoffice_shell.dart`

Layout avec sidebar persistante. Utiliser `SidebarX` ou construire manuellement :

```dart
Scaffold(
  body: Row(
    children: [
      // Sidebar 260px
      Container(
        width: 260,
        color: Theme.of(context).colorScheme.surface,
        child: Column(
          children: [
            // Header avec logo + bouton retour menu
            // Liste des items de navigation groupés
            // Footer avec version
          ],
        ),
      ),
      VerticalDivider(width: 1),
      // Content area
      Expanded(child: child), // child vient du ShellRoute
    ],
  ),
)
```

Items sidebar groupés :
- **MENU** : Catégories, Produits, Modificateurs, Notes
- **FINANCE** : Trésorerie, Export comptable
- **ANALYSE** : Dashboard
- **AUTRES** : Réservations, Paramètres

### 2.4 Modifier `app.dart`

Remplacer `MaterialApp(home: AuthPage())` par `MaterialApp.router(routerConfig: appRouter)`.

### 2.5 Migrer la navigation existante

Chercher tous les `Navigator.of(context).push` et `Navigator.of(context).pushReplacement` et les remplacer par `context.go()` ou `context.push()` de GoRouter. Fichiers impactés :
- `auth_page.dart` — après login → `context.go('/menu')`
- `pos_page.dart` — boutons treasury, dashboard, lock
- `floor_plan_page.dart` — boutons KDS, reservations, treasury, POS
- `session_hub_page.dart` — boutons analytics, catalog, export
- `payment_page.dart` — retour après paiement

### Checklist Phase 2 :
- [ ] `navigation/app_router.dart` créé avec toutes les routes
- [ ] `pages/main_menu/main_menu_page.dart` créé — grille de tuiles
- [ ] `pages/backoffice/backoffice_shell.dart` créé — sidebar layout
- [ ] `app.dart` migré vers `MaterialApp.router`
- [ ] `auth_page.dart` navigation migrée vers GoRouter
- [ ] `pos_page.dart` navigation migrée
- [ ] `floor_plan_page.dart` navigation migrée
- [ ] `session_hub_page.dart` navigation migrée (ou intégré dans shell)
- [ ] `payment_page.dart` navigation migrée
- [ ] Toutes les routes fonctionnent (test navigation)
- [ ] Compilation réussie

---

## ✨ PHASE 3 — POLISH PAGES FULLSCREEN

### 3.1 Refonte `auth_page.dart`

- Background : gradient radial dark
- Card PIN : glassmorphism (border glow subtle, backdrop blur si possible)
- Numpad : boutons arrondis `surfaceElevated`, hover `surfaceHover`
- PIN dots : animation scale+glow quand remplis (flutter_animate)
- Logo : texte "RITAGESTION" en gradient ou accent color
- Info version et heure en bas
- Wrap dans `Animate()` pour fadeIn+slideUp à l'entrée

### 3.2 Polish `pos_page.dart`

- CategoryBar : ajouter icônes par catégorie, indicateur sélection = barre gauche accentBlue
- ProductCard : radius 16, fond surfaceDark, badge stock vert/rouge
- CartPanel header : afficher type commande + table label
- CartPanel footer : sticky, bouton PAYER gradient accentGreen, height 64, full-width
- TopBar : utiliser les nouvelles couleurs, icônes outline cohérentes
- Bouton retour menu (🏠) dans la TopBar

### 3.3 Polish `floor_plan_page.dart`

- Remplacer AppBar standard par TopBar custom (comme POS)
- Tuiles tables : radius 16, bordure colorée selon statut
- Timer visible sur tables occupées (texte elapsed)
- Bouton retour menu dans la barre

### 3.4 Polish `payment_page.dart`

- Numpad : boutons plus gros, arrondis, fond surfaceElevated
- Quick bills MAD : chips colorés distincts par valeur
- Summary : montants en JetBrains Mono
- Methods : grosses tuiles verticales avec icône + label
- ChangeCard : animation reveal

### 3.5 Polish `kds_page.dart`

- Passer de ListView à GridView responsive (2-3 colonnes selon largeur)
- Cards : bordure gauche colorée selon temps d'attente (<5min=vert, 5-15=orange, >15=rouge)
- Timer animé par ticket
- Bouton PRÊT plus visible (accentGreen)

### Checklist Phase 3 :
- [ ] `auth_page.dart` — dark redesign + glassmorphism + animations
- [ ] `pos_page.dart` — CategoryBar icônes + ProductCard premium + CartPanel polish
- [ ] `floor_plan_page.dart` — TopBar custom + tuiles améliorées
- [ ] `payment_page.dart` — numpad + summary + methods polish
- [ ] `kds_page.dart` — grid layout + timer coloré
- [ ] Tous les flux fonctionnels (login→menu→pos→pay→retour)
- [ ] Compilation réussie

---

## 📋 PHASE 4 — MODULES BACKOFFICE CRUD

### 4.1 Créer `pages/backoffice/menu_management/categories_page.dart`

- DataTable (data_table_2) avec colonnes : Nom, Couleur, Ordre, Nb produits, Actions
- Bouton [+ Catégorie] en haut à droite
- Dialog création/édition avec champs : nom, couleur (picker), ordre
- Actions inline : Éditer, Supprimer (avec confirmation)
- Utiliser `ProductRepository` pour les données

### 4.2 Créer `pages/backoffice/menu_management/products_page.dart`

- DataTable : Nom FR, Nom AR, Catégorie, Prix, Prix livraison, TVA, Stock, Actions
- Filtrable par catégorie (dropdown)
- Recherche par nom
- Dialog CRUD complet
- Bouton toggle actif/inactif

### 4.3 Créer `pages/backoffice/menu_management/modifiers_page.dart`

- DataTable : Groupe, Option, Nom AR, Prix extra, Actions
- Groupé par ModifierGroup
- CRUD dialog

### 4.4 Créer `pages/backoffice/menu_management/notes_page.dart`

- Liste des notes cuisine prédéfinies
- CRUD simple (nom FR, nom AR)

### 4.5 Refactorer `session_hub_page.dart` → `backoffice/treasury/treasury_page.dart`

- Même logique, nouveau layout dans le shell backoffice
- Retirer AppBar (le shell gère le header)
- Organiser en cards : Session active, Mouvements, Actions

### 4.6 Refactorer les autres pages backoffice

Déplacer et adapter au shell :
- `analytics_dashboard_page.dart` → `backoffice/analytics/`
- `accounting_export_page.dart` → `backoffice/accounting/`
- `reservations_page.dart` → `backoffice/reservations/`
- Créer `backoffice/settings/settings_page.dart` (placeholder)

Pour chaque : retirer l'AppBar (la sidebar fait office de navigation), adapter le layout pour occuper toute la zone content.

### Checklist Phase 4 :
- [ ] `categories_page.dart` — CRUD DataTable fonctionnel
- [ ] `products_page.dart` — CRUD DataTable avec filtres
- [ ] `modifiers_page.dart` — CRUD DataTable groupé
- [ ] `notes_page.dart` — CRUD simple
- [ ] `treasury_page.dart` — refactoré dans le shell
- [ ] `z_close_page.dart` — refactoré dans le shell
- [ ] `analytics_dashboard_page.dart` — refactoré dans le shell
- [ ] `accounting_export_page.dart` — refactoré dans le shell
- [ ] `reservations_page.dart` — refactoré dans le shell
- [ ] `settings_page.dart` — placeholder créé
- [ ] Sidebar navigue correctement vers chaque sous-page
- [ ] Tous les CRUD fonctionnent (create, read, update, delete)
- [ ] Compilation réussie

---

## 💫 PHASE 5 — ANIMATIONS & POLISH FINAL

### 5.1 Animations d'entrée

Sur toutes les grilles et listes, ajouter un staggered animation :
```dart
.animate(delay: Duration(milliseconds: index * 50))
.fadeIn(duration: 300.ms)
.slideY(begin: 0.1, end: 0)
```

### 5.2 Page transitions

Configurer dans GoRouter des `CustomTransitionPage` avec fade+slide pour les transitions entre pages.

### 5.3 Micro-animations

- Ajout au panier : scale bounce sur le CartPanel
- Paiement réussi : checkmark animé (ou Lottie)
- Erreur : shake animation sur le champ
- PIN digit : scale bounce sur le dot

### 5.4 Loading states

Remplacer les `CircularProgressIndicator` seuls par des skeletons :
```dart
Container(
  decoration: BoxDecoration(
    color: colorScheme.surfaceContainerHighest,
    borderRadius: BorderRadius.circular(12),
  ),
).animate(onPlay: (c) => c.repeat())
 .shimmer(duration: 1200.ms)
```

### 5.5 Nouveaux widgets utilitaires

- `widgets/atoms/glass_card.dart` — card avec border glow et backdrop
- `widgets/atoms/animated_tile.dart` — tuile menu avec hover scale
- `widgets/molecules/sidebar_item.dart` — item sidebar avec indicateur actif
- `widgets/organisms/top_bar.dart` — barre top réutilisable (POS, FloorPlan, KDS)

### Checklist Phase 5 :
- [ ] Staggered animations sur MainMenu tuiles
- [ ] Staggered animations sur ProductsGrid
- [ ] Staggered animations sur KDS grid
- [ ] Page transitions configurées dans GoRouter
- [ ] Micro-animation ajout panier
- [ ] Micro-animation PIN dots
- [ ] Loading skeletons (au moins 3 pages)
- [ ] `glass_card.dart` créé
- [ ] `animated_tile.dart` créé
- [ ] `sidebar_item.dart` créé
- [ ] `top_bar.dart` partagé créé
- [ ] Test complet : Auth → Menu → POS → Pay → Retour → Backoffice → tous sous-modules
- [ ] Compilation finale réussie
- [ ] Aucune régression fonctionnelle

---

## ⚠️ RÈGLES CRITIQUES

1. **Après CHAQUE phase**, exécuter : `cd c:\devzone\flutpos\apps\pos_desktop && flutter analyze && flutter build windows --debug`
2. **Ne jamais modifier** les fichiers dans `packages/core/` sauf si un nouveau repository/method est nécessaire pour les CRUD
3. **Conserver** les `import` relatifs existants, adapter seulement les paths qui changent
4. **Ne pas supprimer** les anciens fichiers tant que les nouveaux ne fonctionnent pas
5. **Tester** la navigation complète après Phase 2 avant de continuer
6. Si un package pose problème de compatibilité, le noter et continuer sans

---

## 🏁 COMMENCER

Commence par **Phase 0** (installation packages), puis **Phase 1** (theme). Après chaque phase, affiche la checklist avec les items cochés ✅ et signale tout problème rencontré.

**GO !**
