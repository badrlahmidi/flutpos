# 🎨 MEGA REFONTE VISUELLE — Ritagestion POS Desktop

## 📋 Inventaire Complet des Views

| # | Page / View | Fichier | Layout Actuel | Problème |
|---|-------------|---------|---------------|----------|
| 1 | **Login (PIN)** | `pages/auth/auth_page.dart` | Centré vertical, simple | Basique, pas de branding |
| 2 | **POS Caisse** | `pages/pos/pos_page.dart` | 3 colonnes (catégories 240px / grille / panier 380px) | Bon layout, theme faible |
| 3 | **Plan de salle** | `pages/floor_plan/floor_plan_page.dart` | AppBar + Stack positionnée | AppBar standard, pas de sidebar |
| 4 | **Split Bill** | `pages/floor_plan/split_bill_page.dart` | 2 colonnes drag-drop | OK fonctionnel |
| 5 | **Encaissement** | `pages/payment/payment_page.dart` | 3 colonnes (numpad / résumé / méthodes) | Manque polish |
| 6 | **Trésorerie Hub** | `pages/session/session_hub_page.dart` | Liste verticale de boutons | Très basique, pas de structure |
| 7 | **Clôture Z** | `pages/session/z_close_page.dart` | Formulaire vertical | OK fonctionnel |
| 8 | **KDS Cuisine** | `pages/kds/kds_page.dart` | Liste de cards | Pas de grid, basique |
| 9 | **Réservations** | `pages/reservations/reservations_page.dart` | Liste + FAB | Pas de calendrier |
| 10 | **Catalogue Admin** | `pages/backoffice/catalog_admin_page.dart` | TabBar + ListView | Pas de sidebar shell |
| 11 | **Dashboard Analytics** | `pages/backoffice/analytics_dashboard_page.dart` | KPI grid + charts | Bon mais pas de shell |
| 12 | **Export Comptable** | `pages/backoffice/accounting_export_page.dart` | Formulaire vertical | Pas de shell |

---

## 🏗️ ARCHITECTURE DE NAVIGATION CIBLE

```
AuthPage (PIN) ──→ MainMenuPage (TUILES) ──→ PosPage (FULLSCREEN)
                                          ──→ FloorPlanPage (FULLSCREEN)
                                          ──→ BackofficeShell (SIDEBAR)
                                                ├── Gestion Menu
                                                │   ├── Catégories
                                                │   ├── Produits
                                                │   ├── Modificateurs
                                                │   └── Notes cuisine
                                                ├── Trésorerie
                                                │   ├── Session active
                                                │   ├── Pay-in / Pay-out
                                                │   └── Clôture Z
                                                ├── Dashboard Analytics
                                                ├── Export Comptable
                                                ├── Réservations
                                                └── Paramètres
                                          ──→ KdsPage (FULLSCREEN)
```

---

## 🎨 NOUVEAU DESIGN SYSTEM — Dark Pro Theme

### Palette de couleurs

```dart
// ─── BACKGROUNDS ───
static const scaffoldDark    = Color(0xFF0F1117);  // Fond principal
static const surfaceDark     = Color(0xFF1A1D27);  // Cards / panels
static const surfaceElevated = Color(0xFF232733);  // Elevated cards
static const surfaceHover    = Color(0xFF2A2E3B);  // Hover states

// ─── ACCENTS ───
static const accentBlue      = Color(0xFF6C8EFF);  // Primary actions
static const accentGreen     = Color(0xFF4ADE80);  // Success / Payé
static const accentOrange    = Color(0xFFFB923C);  // Warnings / Attente
static const accentRed       = Color(0xFFEF4444);  // Erreurs / Void
static const accentPurple    = Color(0xFFA78BFA);  // Info / badges

// ─── TEXT ───
static const textPrimary     = Color(0xFFF1F5F9);  // Titres
static const textSecondary   = Color(0xFF94A3B8);  // Sous-titres
static const textMuted       = Color(0xFF64748B);  // Hints

// ─── BORDERS ───
static const borderSubtle    = Color(0xFF2A2E3B);
static const borderActive    = Color(0xFF6C8EFF);
```

### Typographie

```dart
// Heading:  Inter 700, 28-32sp
// Title:    Inter 600, 16-18sp
// Body:     Inter 400, 14sp
// Caption:  Inter 500, 11-12sp
// Monospace prix: JetBrains Mono 700 (pour montants)
```

### Composants clés

```dart
// Cards: borderRadius 16, border 1px borderSubtle, bg surfaceDark
// Buttons primaires: bg accentBlue, radius 12, height 52
// Buttons danger: bg accentRed
// Inputs: bg surfaceElevated, border borderSubtle, radius 10
// Sidebar: width 260, bg surfaceDark, border-right borderSubtle
// Tuiles menu: 180x160, radius 20, gradient subtle, icon 48px
```

---

## 📄 REFONTE PAR PAGE

### 1. 🔐 LOGIN PAGE — Immersive Dark

**Avant:** Simple colonne centrée, icon Material, fond blanc
**Après:** Fullscreen dark, branding premium

```
┌──────────────────────────────────────────────────┐
│                                                  │
│              ╔══════════════════╗                │
│              ║   🔷 LOGO       ║                │
│              ║  RITAGESTION    ║                │
│              ║  ─────────────  ║                │
│              ║  Système POS    ║                │
│              ║                 ║                │
│              ║  ● ● ● ○ ○ ○   ║  PIN dots     │
│              ║                 ║                │
│              ║  [1] [2] [3]   ║                │
│              ║  [4] [5] [6]   ║  Numpad glass  │
│              ║  [7] [8] [9]   ║                │
│              ║  [⌫] [0] [→]   ║                │
│              ║                 ║                │
│              ║  [Connexion|Pointage]            │
│              ╚══════════════════╝                │
│                                                  │
│  v1.0 · Ritaj Info · 2026          Heure: 14:30 │
└──────────────────────────────────────────────────┘
```

**Specs:**
- Background: gradient radial `scaffoldDark` → `#0A0C12`
- Card login: `surfaceDark` + glassmorphism (border glow accentBlue 0.1)
- Numpad buttons: `surfaceElevated`, hover `surfaceHover`, ripple `accentBlue`
- PIN dots: animated scale + glow on fill
- Logo: SVG ou texte stylisé avec gradient accentBlue→accentPurple
- Animation: `flutter_animate` fade+slideUp on mount

---

### 2. 🏠 MAIN MENU PAGE (NOUVEAU) — Tuiles par module

**Page actuellement MANQUANTE — à créer**

```
┌──────────────────────────────────────────────────┐
│  RITAGESTION          Bonjour, Ahmed    🔒 14:35 │
├──────────────────────────────────────────────────┤
│                                                  │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐          │
│   │  🛒     │ │  🍽️     │ │  👨‍🍳    │          │
│   │  CAISSE │ │ SALLE   │ │ CUISINE │          │
│   │ (POS)  │ │ (Plan)  │ │  (KDS)  │          │
│   └─────────┘ └─────────┘ └─────────┘          │
│                                                  │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐          │
│   │  📋     │ │  💰     │ │  📊     │          │
│   │  MENU   │ │ TRÉSOR. │ │ STATS   │          │
│   │(Gestion)│ │(Caisse) │ │(Analyt.)│          │
│   └─────────┘ └─────────┘ └─────────┘          │
│                                                  │
│   ┌─────────┐ ┌─────────┐ ┌─────────┐          │
│   │  📅     │ │  📤     │ │  ⚙️     │          │
│   │ RÉSERV. │ │ EXPORT  │ │ PARAM.  │          │
│   │         │ │ COMPTA. │ │         │          │
│   └─────────┘ └─────────┘ └─────────┘          │
│                                                  │
│  Session: Ouverte · Fond: 500.00 DH    ● Online │
└──────────────────────────────────────────────────┘
```

**Specs:**
- Grid de tuiles: `GridView.count(crossAxisCount: 3, childAspectRatio: 1.1)`
- Chaque tuile: 180×160px, `surfaceDark`, radius 20, icon 48px centré
- Hover: scale 1.03 + border `accentBlue` + ombre bleue subtile
- Animation entrée: staggered fadeIn+scale (flutter_animate)
- Barre top: user avatar, horloge temps réel, bouton lock
- Barre bottom: état session + statut réseau
- Accès conditionnel par rôle (admin vs serveur)

---

### 3. 🛒 POS PAGE — Fullscreen Optimisé

**Layout actuel OK (3 colonnes), polish needed**

```
┌──────────────────────────────────────────────────┐
│ ☰ │ 🛒 POS │ ⟳ 🖨️ 💰 📊 🏠 │ ● LAN 2 │ 14:35 │
├────┼──────────────────────────┼──────────────────┤
│    │  [🔍 Recherche...]  [Tous|Pop|★]           │
│CAT │                                    │ PANIER │
│    │  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │        │
│Burg│  │Prod│ │Prod│ │Prod│ │Prod│      │ item 1 │
│    │  │Card│ │Card│ │Card│ │Card│      │ item 2 │
│Pizz│  └────┘ └────┘ └────┘ └────┘      │ item 3 │
│    │  ┌────┐ ┌────┐ ┌────┐ ┌────┐      │        │
│Bois│  │    │ │    │ │    │ │    │      │────────│
│    │  └────┘ └────┘ └────┘ └────┘      │ ST  xx │
│Dess│                                    │ TVA xx │
│    │                                    │ TOT XX │
│    │                                    │        │
│    │                                    │[PAYER] │
└────┴────────────────────────────────────┴────────┘
```

**Améliorations:**
- CategoryBar: icônes + nom, indicateur sélection animé (barre gauche accentBlue)
- ProductCard: radius 16, image placeholder coloré, nom+prix, badge stock
- CartPanel: header avec type commande, footer sticky avec totaux + bouton PAYER
- Bouton PAYER: full-width, height 64, gradient accentGreen, texte blanc bold
- TopBar: compacte, icônes outline, horloge, indicateur réseau animé
- Transitions: produit ajouté → micro-animation scale+fade dans le panier

---

### 4. 🍽️ FLOOR PLAN — Fullscreen avec toolbar

**Améliorations:**
- Retirer AppBar standard → TopBar custom comme POS
- Tuiles tables: radius 16, status par couleur de bordure (libre=vert, occupée=orange, réservée=violet)
- Timer visible sur chaque table occupée
- Zones en chips dans une barre horizontale stylisée
- Légende intégrée dans la TopBar

---

### 5. 💳 PAYMENT PAGE — Split 3 colonnes pro

**Améliorations:**
- Numpad: boutons arrondis, fond surfaceElevated, texte 24sp
- Quick bills MAD: chips colorés (20=vert, 50=bleu, 100=violet, 200=orange)
- Summary card: glassmorphism, montants en JetBrains Mono
- Payment methods: grosses tuiles verticales avec icônes (💵 Espèces, 💳 Carte, 📱 TPE)
- Change card: animation reveal + breakdown visuel des billets

---

### 6. 📋 BACKOFFICE SHELL (NOUVEAU) — Sidebar + Content

**Pattern pour TOUS les modules de gestion**

```
┌──────────────────────────────────────────────────┐
│  🏠 ← Retour Menu    GESTION MENU        14:35  │
├────────────┬─────────────────────────────────────┤
│            │                                     │
│ 📂 Catég.  │   ┌─ Titre section ─────────── 🔍 ┐│
│ 📦 Produits│   │                                ││
│ 🔧 Modif.  │   │  DataTable / ListView          ││
│ 📝 Notes   │   │  avec actions CRUD             ││
│ 🏷️ Prix    │   │                                ││
│            │   │  [+ Ajouter]                   ││
│            │   │                                ││
│────────────│   └────────────────────────────────┘│
│ 💰 Trésor. │                                     │
│ 📊 Stats   │                                     │
│ 📤 Export  │                                     │
│ 📅 Réserv. │                                     │
│ ⚙️ Param.  │                                     │
│            │                                     │
└────────────┴─────────────────────────────────────┘
```

**Specs:**
- Sidebar: width 260, bg `surfaceDark`, séparateurs entre groupes
- Items sidebar: height 48, icon + label, hover `surfaceHover`
- Item actif: bg `accentBlue.withOpacity(0.15)`, border-left 3px accentBlue
- Content area: bg `scaffoldDark`, padding 24
- Chaque sous-module = sa propre page dans le content area
- Header content: titre + search + bouton ajouter
- DataTable: alternating rows, hover highlight, actions inline

---

## 📦 PACKAGES RECOMMANDÉS

### Layout & Navigation

| Package | Usage | Priorité |
|---------|-------|----------|
| `go_router` | Navigation déclarative + ShellRoute pour sidebar | 🔴 Critique |
| `sidebarx` | Sidebar animée cross-platform | 🟡 Moyen |
| `flutter_adaptive_scaffold` | Layout adaptatif (rail ↔ sidebar) | 🟡 Moyen |

### Animations & Polish

| Package | Usage | Priorité |
|---------|-------|----------|
| `flutter_animate` | Micro-animations chainables (fade, scale, slide) | 🔴 Critique |
| `shimmer` | Loading placeholders premium | 🟢 Nice-to-have |
| `lottie` | Animations vectorielles (success checkmark, etc.) | 🟢 Nice-to-have |

### UI Components

| Package | Usage | Priorité |
|---------|-------|----------|
| `fl_chart` | Graphiques dashboard (déjà utilisé ou à ajouter) | 🔴 Critique |
| `data_table_2` | DataTable avancée avec tri, pagination, fixed cols | 🔴 Critique |
| `flutter_slidable` | Swipe actions sur les listes (edit/delete) | 🟡 Moyen |
| `badges` | Badges notification sur icônes | 🟢 Nice-to-have |

### Desktop Specifics

| Package | Usage | Priorité |
|---------|-------|----------|
| `window_manager` | ✅ Déjà présent | — |
| `google_fonts` | ✅ Déjà présent (Inter) | — |
| `multi_window` | Écran client secondaire | 🟢 Futur |

### Fonts à ajouter

| Font | Usage |
|------|-------|
| `Inter` | ✅ Déjà en place — corps de texte |
| `JetBrains Mono` | Montants / prix — lisibilité chiffres |
| `Outfit` | Alternative titre si on veut plus moderne |

---

## 🔄 PLAN D'IMPLÉMENTATION

### Phase 1 — Theme & Design Tokens (1 jour)
1. Créer `app_colors_v2.dart` avec palette dark
2. Créer `app_theme_v2.dart` avec dark ThemeData complet
3. Mettre à jour `pos_design_tokens.dart`
4. Ajouter `flutter_animate` au pubspec
5. Toggle dark/light dans `app.dart`

### Phase 2 — Navigation (1-2 jours)
1. Ajouter `go_router` au pubspec
2. Créer `MainMenuPage` (tuiles)
3. Créer `BackofficeShell` (sidebar layout)
4. Migrer navigation de push/pop → GoRouter
5. Implémenter ShellRoute pour backoffice

### Phase 3 — Pages Fullscreen (2 jours)
1. Refonte `AuthPage` — dark + glassmorphism + animations
2. Polish `PosPage` — CategoryBar icons, ProductCard premium, CartPanel
3. Polish `FloorPlanPage` — retirer AppBar, custom TopBar
4. Polish `PaymentPage` — numpad + quick bills + methods

### Phase 4 — Backoffice Modules (2-3 jours)
1. Créer sous-pages CRUD: Catégories, Produits, Modificateurs, Notes
2. Implémenter DataTable avec `data_table_2`
3. Formulaires création/édition en dialog ou page
4. Refonte Trésorerie dans le shell
5. Refonte Dashboard dans le shell
6. Refonte Export Comptable dans le shell
7. Refonte Réservations dans le shell

### Phase 5 — Polish & Animations (1 jour)
1. Staggered animations sur toutes les grilles
2. Page transitions (fade/slide)
3. Micro-animations feedback (ajout panier, paiement)
4. Loading skeletons avec `shimmer`
5. Test complet de tous les flux

---

## 📁 NOUVELLE STRUCTURE FICHIERS

```
apps/pos_desktop/lib/
├── app.dart                          # GoRouter setup
├── main.dart
├── navigation/
│   └── app_router.dart               # NOUVEAU — GoRouter config
├── theme/
│   ├── app_colors.dart               # MODIFIÉ — dark palette
│   ├── app_theme.dart                # MODIFIÉ — dark ThemeData
│   ├── app_spacing.dart              # Inchangé
│   ├── app_typography.dart           # MODIFIÉ — + JetBrains Mono
│   └── pos_design_tokens.dart        # MODIFIÉ — dark tokens
├── pages/
│   ├── auth/
│   │   └── auth_page.dart            # MODIFIÉ — dark redesign
│   ├── main_menu/
│   │   └── main_menu_page.dart       # NOUVEAU
│   ├── pos/                          # MODIFIÉ — polish
│   ├── floor_plan/                   # MODIFIÉ — polish
│   ├── payment/                      # MODIFIÉ — polish
│   ├── kds/                          # MODIFIÉ — grid layout
│   ├── backoffice/
│   │   ├── backoffice_shell.dart     # NOUVEAU — sidebar layout
│   │   ├── menu_management/          # NOUVEAU
│   │   │   ├── categories_page.dart
│   │   │   ├── products_page.dart
│   │   │   ├── modifiers_page.dart
│   │   │   └── notes_page.dart
│   │   ├── treasury/                 # REFACTORÉ depuis session/
│   │   │   ├── treasury_page.dart
│   │   │   └── z_close_page.dart
│   │   ├── analytics/                # REFACTORÉ
│   │   │   └── analytics_dashboard_page.dart
│   │   ├── accounting/               # REFACTORÉ
│   │   │   └── accounting_export_page.dart
│   │   ├── reservations/             # REFACTORÉ
│   │   │   └── reservations_page.dart
│   │   └── settings/                 # NOUVEAU
│   │       └── settings_page.dart
│   └── session/                      # SUPPRIMÉ (→ backoffice/treasury)
├── widgets/
│   ├── atoms/
│   │   ├── pos_button.dart           # MODIFIÉ — dark variants
│   │   ├── glass_card.dart           # NOUVEAU — glassmorphism
│   │   └── animated_tile.dart        # NOUVEAU — menu tile
│   ├── molecules/
│   │   └── sidebar_item.dart         # NOUVEAU
│   └── organisms/
│       ├── backoffice_sidebar.dart    # NOUVEAU
│       └── top_bar.dart              # NOUVEAU — shared top bar
```

---

> [!IMPORTANT]
> Ce document est la **spécification de référence**. Chaque phase doit être implémentée séquentiellement. Phase 1 (Theme) est le prérequis de toutes les autres.
