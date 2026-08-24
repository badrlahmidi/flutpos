# ROADMAP UNIQUE — Ritagestion POS

> **Dernière mise à jour : 24 août 2026** · Branche active : `main`

---

## État actuel — Audit du 24 août 2026

### Note globale : **8,4 / 10**

| Dimension | Note | Détail |
|-----------|------|--------|
| Architecture & Clean Arch | **8,5** | 16 repositories, 8 use cases, 9 BLoCs, barrel exports propres |
| Base de données (Drift) | **9,0** | 29 tables (v11 : + Customers, DevicePairings, ActiveSessions), seed data |
| Caisse Desktop (POS) | **8,5** | UI 3 colonnes, vouchers, courses, recherche, impression |
| Réseau LAN (mobile↔PC) | **8,5** | Bind LAN réparé, pairing WS complet, RBAC+dedup+rate-limit actifs, sync miroir |
| Backoffice & CRUD | **7,0** | P2.1–P2.3 CRUD catégories/produits/modifiers **fait** ; reste P2.4 extras + P2.5 paiements/taxes |
| Tests | **9,5** | core 94✅, network 25✅, desktop 21✅ — 100% verts |
| Reporting & Analytics | **7,5** | Dashboard KPI, 4 rapports Drift, exports CSV/PDF, period picker |
| Cloud / SaaS | **5,0** | PowerSync schema prêt, déploiement Supabase prod non fait |
| Prod-readiness Maroc | **7,5** | MAD, ICE, TVA multi-taux, Glovo, tickets AR raster |

### Tests — 24 août 2026

| Package | Résultat |
|---------|----------|
| `packages/core` | **94/94** ✅ |
| `packages/network` | **25/25** ✅ (+4 tests pairing/RBAC/validation) |
| `apps/pos_desktop` | **21/21** ✅ |
| **Total passants** | **140/140** ✅ (100% verts) |

### P1.5 — STABILISATION SÉCURITÉ RÉSEAU (Complétée ✅ 24 août 2026)

> Audit complet monorepo puis réparation du WIP sécurité resté à moitié câblé.

| # | Tâche | Statut | Notes |
|---|-------|--------|-------|
| 1.5.1 | Réparer suite network (7 tests rouges du WIP RBAC/dedup) | ✅ Fait | Nouveau contrat : enveloppe `ERROR` dédiée + `userRole` requis sur commandes métier |
| 1.5.2 | Fix crash `AppLogger` (`hierarchicalLoggingEnabled`) | ✅ Fait | `app_logger.dart` — plantait le serveur au 1er warning |
| 1.5.3 | **Bind LAN réparé** : `loopbackIPv4` → `anyIPv4` (param `bindAddress`) | ✅ Fait | Les téléphones peuvent enfin se connecter à la caisse |
| 1.5.4 | Handler `PAIRING_REQUEST` implémenté (dead-end → flux complet) | ✅ Fait | Token 5 min validé via `DevicePairingRepository`, cache rechargé au restart |
| 1.5.5 | Client mobile : rôles estampolés (`defaultUserRole=WAITER`), `sessionToken`, `pairWithServer()`, ERROR = réponse terminale de la queue | ✅ Fait | `waiter_network_client.dart` |
| 1.5.6 | Fix build Android : `res/xml/network_security_config.xml` recréé (contenu était coincé dans le fichier parasite `apps/wait`, supprimé) + permission `INTERNET` ajoutée | ✅ Fait | Cleartext LAN assumé jusqu'à migration wss:// (P7) |


### Fichiers nettoyés (14 supprimés)

- `audit_analysis.md`, `gemini_pos_brainstorming.md` (69KB de brainstorming obsolète)
- `docs/CLAUDE_CODE_MEGA_PROMPT.md`, `docs/MEGA_REFONTE_VISUELLE.md`, `docs/GITHUB_SETUP.md`
- `docs/architecture/SPRINT_STATUS.md`, `SPRINT0-5_*_PROMPT.md` (6 fichiers)
- `docs/architecture/00_MEGA_PROMPT_START.md`, `11_roadmap_and_business.md`

### Structure conservée

```
docs/
├── architecture/           # 10 specs de référence (01→10)
│   ├── 01_project_context_and_stack.md
│   ├── 02_database_schema.md
│   ├── 03_network_protocol.md
│   ├── 04_business_scenarios_qa.md
│   ├── 05_design_system.md
│   ├── 06_folder_structure.md
│   ├── 07_security_and_auth.md
│   ├── 08_error_handling_strategy.md
│   ├── 09_testing_strategy.md
│   └── 10_i18n_and_localization.md
├── mega_refonte_commerciale.md   # Vision produit 360° (référence)
├── company_database_plan.md      # Plan Mon Établissement
├── floor_plan_tables_plan.md     # Plan Salle interactive
├── payment_taxes_plan.md         # Plan Paiements & Taxes
├── print_management_plan.md      # Plan Impression & Stations
├── reporting_refonte_plan.md     # Plan Reporting (quasi terminé)
├── settings_config_plan.md       # Plan Paramètres app
├── users_security_plan.md        # Plan Sécurité (terminé)
└── ui-inspiration/               # Mockup POS desktop
```

---

## Roadmap — 8 Phases

```
P1 Stabilisation ──→ P2 Backoffice ──→ P3 Salle ──→ P4 Historique
    (Complétée)       (5 jours)        (3 jours)     (3 jours)

P5 Clients ──→ P6 Impression ──→ P7 Cloud ──→ P8 Polish & Go Live
  (3 jours)      (3 jours)       (5 jours)      (5 jours)
```

**Durée totale estimée : ~28 jours de dev**

---

### P1 — STABILISATION (Complétée ✅)

> Objectif : tout compile, tout passe, branche propre.

| # | Tâche | Statut | Fichiers / Notes |
|---|-------|--------|------------------|
| 1.1 | **Réparer les 4 tests desktop cassés** (cart_bloc, floor_plan_bloc, payment_bloc, ticket_content_builder) | ✅ Fait | `apps/pos_desktop/test/` - Tous passants |
| 1.2 | **Fix `initializeDateFormatting('fr_FR')`** au bootstrap pour l'impression | ✅ Fait | `app_bootstrap.dart` |
| 1.3 | **Merge `feat/sprints-4-5-livraison` → `main`** | ✅ Fait | Fusionné & validé |
| 1.4 | Vérifier `flutter build windows --debug` passe sans erreur | ✅ Fait | Validé |

**Critère de succès** : `dart test` / `flutter test` = 116/116 ✅ partout.

---

### P2 — BACKOFFICE CRUD COMPLET (5 jours)

> Objectif : tous les modules de gestion ont des interfaces CRUD fonctionnelles.
> Référence : `mega_refonte_commerciale.md` §2

| # | Tâche | Effort | Plan de réf. |
|---|-------|--------|-------------|
| 2.1 | **Page Catégories** — DataTable CRUD (nom, couleur, ordre, station impression) | 1j | — |
| 2.2 | **Page Produits** — DataTable CRUD, filtres par catégorie, recherche, toggle actif | 1j | — |
| 2.3 | **Page Modificateurs** — DataTable groupée, CRUD options + prix extra | 1j | — |
| 2.4 | **Page Mon Établissement** — 4 onglets (société, motifs annulation, logo, reset DB) | 1j | `company_database_plan.md` |
| 2.5 | **Page Modes de Paiement & Taxes** — config dynamique, tiroir-caisse, TVA | 1j | `payment_taxes_plan.md` |

**Critère de succès** : Depuis le backoffice shell, chaque sous-module CRUD fonctionne end-to-end.

---

### P3 — SALLE INTERACTIVE (3 jours)

> Objectif : plan de salle drag-and-drop, éditeur et vue live.
> Référence : `floor_plan_tables_plan.md`

| # | Tâche | Effort |
|---|-------|--------|
| 3.1 | **Canevas interactif** — tables positionnées x/y, colorées par statut, total affiché | 1j |
| 3.2 | **Éditeur drag-and-drop** — snap-to-grid, ajout/suppression tables, resize zones | 1,5j |
| 3.3 | **Timer live** sur chaque table occupée + refresh auto | ½j |

---

### P4 — HISTORIQUE VENTES & RETOURS (3 jours)

> Objectif : journal des ventes consultable, avoirs et remboursements partiels.
> Référence : `mega_refonte_commerciale.md` §Historique

| # | Tâche | Effort |
|---|-------|--------|
| 4.1 | **Journal des ventes** — split-pane (haut: documents, bas: lignes articles), recherche par n° | 1j |
| 4.2 | **Schéma Drift avoirs** — table `CreditNotes`, lien `orderId`, ajustement stock | 1j |
| 4.3 | **Assistant de retour** — sélection d'articles, mode remboursement, impression avoir | 1j |

---

### P5 — CLIENTS & PROMOTIONS (3 jours)

> Objectif : base contacts et moteur de promotions POS.
> Référence : `mega_refonte_commerciale.md` §Clients

| # | Tâche | Effort |
|---|-------|--------|
| 5.1 | **Table Drift `Contacts`** + repository — ICE client, adresse, téléphone, remise par défaut | 1j |
| 5.2 | **Tiroir d'édition contacts** — onglets Client/Fournisseur, recherche | 1j |
| 5.3 | **Moteur de promotions** — plages horaires, jours, catégories ciblées, application auto POS | 1j |

---

### P6 — IMPRESSION & PARAMÈTRES (3 jours)

> Objectif : config impression complète + paramètres généraux.
> Référence : `print_management_plan.md`, `settings_config_plan.md`

| # | Tâche | Effort |
|---|-------|--------|
| 6.1 | **Config stations d'impression** — pilotes physiques (80/58mm), test d'impression, RTL | 1j |
| 6.2 | **Gabarits de tickets** — personnalisation en-tête/pied, QR code, logo | 1j |
| 6.3 | **Page Paramètres généraux** — multi-onglets (caisse, format doc, backups, SMTP) | 1j |

---

### P7 — CLOUD & PRODUCTION (5 jours)

> Objectif : sync cloud fonctionnelle, installeur, prêt pour pilote.

| # | Tâche | Effort |
|---|-------|--------|
| 7.1 | **PowerSync + Supabase production** — sync-rules, déploiement, test bout-en-bout | 2j |
| 7.2 | **Recovery disaster** — nouveau PC → restauration < 2 min | 1j |
| 7.3 | **Backup automatique** local (scheduler SQLite → dossier Documents) | ½j |
| 7.4 | **Installeur MSIX** — package Windows signé + auto-update | 1j |
| 7.5 | **Test E2E CI** — mobile CREATE_ORDER → PC mirror → ADD_ITEMS → impression | ½j |

---

### P8 — POLISH & COMMERCIALISATION (5 jours)

> Objectif : UX premium, prêt pour démo client et vente.

| # | Tâche | Effort |
|---|-------|--------|
| 8.1 | **Dark theme finalisé** — palette complète, JetBrains Mono pour prix | 1j |
| 8.2 | **GoRouter migration** — navigation déclarative, ShellRoute backoffice | 1j |
| 8.3 | **Animations** — flutter_animate, staggered grids, micro-animations panier | 1j |
| 8.4 | **Multi-tenant** — isolation par restaurant, dashboard consolidé | 1j |
| 8.5 | **Pilote restaurant** — déploiement réel, ajustements terrain | 1j |

---

## Backlog post-commercialisation

| Feature | Priorité |
|---------|----------|
| Menus programmés Ramadan (Ftour) | Moyenne |
| API Glovo réception automatique | Moyenne |
| Food cost auto — déduction ingrédients à la vente | Haute |
| Pertes & démarque (scan produit → périmé) | Moyenne |
| Écran client 2ème moniteur (multi-window) | Basse |
| Toggle langue AR global (UI + tickets client) | Basse |
| Favoris produits persistés | Basse |
| Split bill par montant — UI dédiée | Moyenne |
| Rapport ventes par heure / jour semaine | Moyenne |
| App web back-office (Flutter Web / Wasm) | Basse |

---

## Règles de développement (rappel)

- **Offline-First** : jamais de dépendance réseau externe pour les actions métier
- **UUID** partout, **prix figés** dans `OrderItems.unitPrice`
- **BLoC** pour la gestion d'état, **Clean Architecture** (Presentation → Domain → Data)
- **Grille 8px**, touch targets **≥ 64px**, zéro scroll horizontal
- **`Theme.of(context)`** uniquement — jamais de couleurs en dur
- **Tests** : 100% coverage sur les calculs financiers

---

## Documents de référence

| Fichier | Rôle |
|---------|------|
| `docs/architecture/01→10` | Spécifications techniques figées |
| `docs/mega_refonte_commerciale.md` | Vision produit 360° |
| `docs/*_plan.md` (6 fichiers) | Plans d'implémentation par module |
| `.cursorrules` | Règles pour l'agent IA |
| Ce fichier (`ROADMAP.md`) | **Source unique de vérité** |
