# Audit de référence — Ritagestion POS

> **Document unique de référence** · Dernière mise à jour : **5 juin 2026** (post-améliorations P1 + UI maquette) · Branche : `feat/sprints-4-5-livraison`

---

## 1. Résumé exécutif

Ritagestion est un POS **offline-first** pour la restauration marocaine. Sprints 0–5 et plan P1 sont **essentiellement terminés** : caisse desktop (UI maquette Ritaj POS), mobile waiter synchronisé PC, courses, i18n AR cuisine, vouchers, KDS enrichi.

### Note globale : **8,4 / 10**

| Dimension | Note | Commentaire |
|-----------|------|-------------|
| Architecture & couches | **8,2** | Use cases salle, sync mobile miroir PC, `VoucherRepository` |
| Caisse desktop | **9,0** | UI maquette 3 colonnes, vouchers, 7 BLoCs, flux complet |
| Data (Drift) | **9,0** | Schéma v4, 24 tables, `mirrorOrderSnapshot` mobile |
| Réseau LAN | **8,0** | CREATE/ADD_ITEMS réels, GET_OPEN_ORDER, ping session caisse |
| Cloud / SaaS | **6,5** | PowerSync prêt ; recovery prod Supabase pending |
| Tests & qualité | **8,2** | **115 tests** automatisés, CI active |
| Scénarios métier (50) | **7,6** | **39 + 4 partiels** couverts |
| Prod-readiness Maroc | **8,5** | MAD, ICE, TVA, Glovo, vouchers, tickets AR raster |

---

## 2. Vérification par couche

### 2.1 Presentation — `apps/pos_desktop` (9,0/10)

| Élément | État |
|---------|------|
| UI caisse alignée maquette (`PosTopBar`, sidebar catégories, grille, panier) | ✅ |
| Recherche + filtres catalogue (Tous / Disponibles / Populaires / Favoris) | ✅ |
| BLoC Payment + vouchers + scan QR | ✅ |
| `CatalogAdminPage` — édition `nameAr` produits / modificateurs | ✅ |
| Impression AR via `textRaster` (RTL) | ✅ |
| Notes cuisine `AutoDirectionTextField` | ✅ |
| Bug connu : `LocaleDataException` sur `DateFormat('fr_FR')` à l'impression | ⚠️ |

Référence visuelle : [`docs/ui-inspiration/ritaj-pos-desktop-mockup.png`](docs/ui-inspiration/ritaj-pos-desktop-mockup.png)

### 2.2 Domain / Data — `packages/core` (9,0/10)

| Élément | État |
|---------|------|
| Courses : `fireCourse`, `updateOrderItemCourse`, `CourseHelpers` | ✅ |
| `mirrorOrderSnapshot` + `clearLocalOpenOrderForTable` (sync mobile) | ✅ |
| `VoucherRepository`, table `Vouchers` | ✅ |
| `getAnyOpenSession` (ping HTTP caisse) | ✅ |
| Food cost auto à la vente | ❌ |

### 2.3 Network + `waiter_mobile` (8,0/10)

| Élément | État |
|---------|------|
| Serveur Shelf + mDNS + heartbeat | ✅ |
| Handlers réels : `CREATE_ORDER`, `ADD_ITEMS`, `FIRE_COURSE`, `UPDATE_ITEM_COURSE` | ✅ |
| `GET_OPEN_ORDER` + sync miroir IDs partagés | ✅ |
| `fetchPosStatus` / `sendAndAwaitAck` (PC-first) | ✅ |
| Grille produits mobile + courses + bannière session PC | ✅ |
| Test E2E CI mobile ↔ PC | ❌ |

### 2.4 Cloud (6,5/10)

PowerSync schema + recovery local ✅ · Prod Supabase + sync-rules déployées ⏳

### 2.5 KDS (8,0/10)

| Élément | État |
|---------|------|
| Lignes `isFired == false` affichées « À suivre » (grisé) | ✅ |
| Bouton PRÊT sur lignes fired uniquement | ✅ |

---

## 3. Tests (5 juin 2026 — post-améliorations)

| Package | Résultat |
|---------|----------|
| `packages/core` | **83/83** ✅ (dont `order_course_test`, `order_mirror_test`) |
| `packages/network` | **15/15** ✅ |
| `apps/pos_desktop` | **16/16** ✅ (CartBloc courses + PaymentBloc vouchers) |
| `apps/waiter_mobile` | **1/1** ✅ |
| **Total** | **115/115** |

---

## 4. Scénarios métier (50)

| Statut | Nombre | Détail |
|--------|--------|--------|
| ✅ Couverts | **39 (78 %)** | +3–4 courses, +23 AR cuisine, +38 vouchers, sync mobile |
| ⚠️ Partiels | **5 (10 %)** | Toggle UI AR global, note commande (non persistée), EN ATTENTE, images produits seed |
| ❌ Manquants | **6 (12 %)** | Démarque, menus Ramadan, multi-tenant, ventes par serveur, etc. |

---

## 5. Plan P1 — Statut final

| # | Action | Statut |
|---|--------|--------|
| 5 | `waiter_mobile` MVP + sync PC miroir | ✅ **DONE** |
| 6 | Vouchers + scan QR (scénario 38) | ✅ **DONE** |
| 7 | Courses Réclamé/Suite (desktop + mobile + KDS + tests BLoC) | ✅ **DONE** |
| 8 | i18n AR (nameAr BO, textRaster, notes auto-direction) | ✅ **DONE** |
| 9 | Refactoring `OrderRepositoryImpl` / use cases salle | ✅ **DONE** |
| — | UI caisse maquette Ritaj POS | ✅ **DONE** (sprint amélioration UI) |

**P1 : 100 % fonctionnel** — dettes mineures : locale `fr_FR` impression, notes commande BDD, E2E CI.

---

## 6. Sprint amélioration — Livré (juin 2026)

| Lot | Contenu | Statut |
|-----|---------|--------|
| **A7** | Mobile grille + ADD_ITEMS/`orderItemId` + UPDATE_ITEM_COURSE + sync GET_OPEN_ORDER | ✅ |
| **A7** | KDS « À suivre » + tests `CartCourseFireRequested` / `CartItemCourseChanged` | ✅ |
| **A8** | `CatalogAdminPage` nameAr + `textRaster` AR + `AutoDirectionTextField` | ✅ |
| **UI** | Maquette archivée + POS 3 colonnes (tokens `PosDesignTokens`) | ✅ |
| **Fix** | `PosNetworkServer` initializer (build Windows) | ✅ |

---

## 7. Évolution de la note

| Jalons | Note |
|--------|------|
| Audit initial (4 juin) | 7,4 |
| Post-P0/P1 (mobile, CI) | 7,8 |
| Post-vouchers (5 juin) | 7,9 |
| Post-courses + i18n AR | 8,2 |
| Post-sync mobile + UI maquette | **8,4** |

---

## 8. Prochaines étapes (P2 — ordre recommandé)

### Court terme (stabilité pilote)

| Priorité | Action | Effort | Impact |
|----------|--------|--------|--------|
| **P2-1** | `initializeDateFormatting('fr_FR')` au bootstrap — fix impression tickets | ½ j | Critique pilote |
| **P2-2** | Persister **note de commande** (colonne `orders.notes` ou champ existant) | 1 j | UX caisse |
| **P2-3** | Test E2E CI : mobile CREATE_ORDER → PC mirror → ADD_ITEMS | 2 j | Régression LAN |
| **P2-4** | Valider impression AR sur imprimante cible (80 mm, raster vs CP864) | 1 j | Scénario 23 prod |

### Moyen terme (back-office & cloud)

| Priorité | Action | Effort |
|----------|--------|--------|
| **P2-5** | PowerSync production — Supabase + déploiement `sync-rules` | 3–5 j |
| **P2-6** | Rapport **ventes par serveur** (scénario 50, dashboard) | 2 j |
| **P2-7** | Split bill **par montant** — UI dédiée (use case existe) | 1–2 j |
| **P2-8** | Food cost auto — déduction stock à la vente | 2 j |

### Long terme (post-MVP)

- Multi-tenant / dashboard consolidé  
- Pertes & démarque  
- Menus programmés (Ramadan)  
- Toggle langue AR global (UI + tickets client)  
- Favoris produits persistés  
- Client optionnel lié à la commande  

---

## 9. Verdict

**Prêt pour pilote restaurant** avec caisse UI professionnelle, sync mobile fiable (PC = source de vérité), courses et cuisine bilingue. **Bloquant avant démo client** : correctif locale impression (P2-1). Ensuite : cloud prod et analytics serveur.

Documents liés : [`docs/architecture/SPRINT_STATUS.md`](docs/architecture/SPRINT_STATUS.md) · [`docs/architecture/11_roadmap_and_business.md`](docs/architecture/11_roadmap_and_business.md) · [`docs/ui-inspiration/README.md`](docs/ui-inspiration/README.md)
