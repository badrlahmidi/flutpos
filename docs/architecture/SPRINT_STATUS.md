# Statut des sprints — Ritagestion

> Dernière mise à jour : **5 juin 2026** — voir [`audit_analysis.md`](../../audit_analysis.md) (document de référence unique).

## Vue d’ensemble

| Sprint | Statut | Progression | Tests / analyse |
|--------|--------|-------------|-----------------|
| 0 Fondations | ✅ Terminé | 100 % | Drift 24 tables, seed, thème, bcrypt |
| 1 Caisse MVP | ✅ Terminé | ~95 % | UI maquette Ritaj POS, BLoC Cart, impression |
| 2 Réseau LAN | ✅ Terminé | ~95 % | Serveur PC ✅ · Mobile sync miroir ✅ |
| 3 Trésorerie | ✅ Terminé | ~95 % | 30+ tests financiers, Z-Report, ICE |
| 4 Salle avancée | ✅ Terminé | ~92 % | Plan salle, KDS « À suivre », Glovo, courses |
| 5 Cloud & SaaS | ✅ Terminé* | ~75 % | PowerSync local, dashboard, export CSV |
| **Amélioration P1** | ✅ Terminé | **100 %** | Actions 5–9 + UI maquette |

**Suite de tests** : `core` **83/83** · `network` **15/15** · `pos_desktop` **16/16** · `waiter_mobile` **1/1** · **115 total** ✅

**Note globale** : **8,4/10** — détail dans [`audit_analysis.md`](../../audit_analysis.md).

---

## Sprint amélioration P1 — Checklist (juin 2026)

| Action | Livrable | Statut |
|--------|----------|--------|
| **5** | Mobile MVP tables + connexion mDNS | ✅ |
| **5+** | Sync PC miroir (`GET_OPEN_ORDER`, `mirrorOrderSnapshot`, ACK) | ✅ |
| **5+** | Vérification session caisse PC (`/ping` + bannière mobile) | ✅ |
| **6** | Vouchers + scan QR + `VoucherRepository` | ✅ |
| **7** | Courses desktop (CartBloc, UI, impression RECLAME) | ✅ |
| **7** | Mobile ADD_ITEMS + UPDATE_ITEM_COURSE + réclame | ✅ |
| **7** | KDS lignes non fired « À suivre » | ✅ |
| **7** | Tests BLoC `CartCourseFireRequested` / `CartItemCourseChanged` | ✅ |
| **8** | `CatalogAdminPage` nameAr | ✅ |
| **8** | Impression AR `textRaster` RTL | ✅ |
| **8** | Notes `AutoDirectionTextField` (desktop + mobile) | ✅ |
| **9** | Use cases salle (`TableOperations`, `SplitBill`, `TransferTable`) | ✅ |
| **UI** | Maquette [`docs/ui-inspiration/`](../ui-inspiration/) appliquée POS | ✅ |

### Dettes mineures post-P1

| Item | Statut |
|------|--------|
| `initializeDateFormatting('fr_FR')` — crash impression | ⚠️ À corriger (P2-1) |
| Note de commande persistée en BDD | ⏳ P2-2 |
| Test E2E mobile ↔ PC en CI | ⏳ P2-3 |
| Bouton « EN ATTENTE » fonctionnel | ⏳ P2 |
| Favoris produits persistés | ⏳ P2 |

---

## Sprint 4 — Checklist détaillée

| Étape | Livrable | Statut |
|-------|----------|--------|
| 1 | Plan de salle visuel par zone | ✅ |
| 2 | Transfert + fusion de tables | ✅ |
| 2 | Split bill par article | ✅ |
| 2 | Split bill par montant (UI) | ⏳ Use case seul |
| 3 | Module réservations + RESERVED −30 min | ✅ |
| 4 | Commandes Glovo/Deliveroo | ✅ |
| 5 | Annulation grâce 30 s + toggle service | ✅ |
| 6 | Regroupement tickets bar | ✅ |
| 6 | KDS + WebSocket + lignes « À suivre » | ✅ |
| — | Courses Réclamé / Suite | ✅ |

---

## Sprint 5 — Checklist détaillée

| Étape | Livrable | Statut |
|-------|----------|--------|
| 1 | PowerSync schema + connector | ✅ |
| 1 | Recovery disaster (Supabase prod) | ⏳ |
| 2 | Silent Update catalogue | ✅ |
| 3 | Dashboard analytique | ✅ |
| 4 | Pointage RH | ✅ |
| 5 | Export comptable CSV | ✅ |
| — | Multi-tenant | ⏳ Post-MVP |
| — | Pertes / démarque | ⏳ Post-MVP |
| — | Menus Ramadan | ⏳ Post-MVP |
| — | Food cost auto (vente) | ⏳ |
| — | Ventes par serveur | ⏳ P2-6 |

---

## Couverture des 50 scénarios métier

| Phase | Couverts | Partiels | Manquants |
|-------|----------|----------|-----------|
| Phase 1 — Prise de commande | 7 | 1 | 2 |
| Phase 2 — Gestion salle | 8 | 1 | 1 |
| Phase 3 — Cuisine & impression | 8 | 1 | 1 |
| Phase 4 — Encaissement | 10 | 0 | 0 |
| Phase 5 — Back-office | 6 | 2 | 2 |
| **Total** | **39 (78 %)** | **5 (10 %)** | **6 (12 %)** |

---

## Prochaines étapes (P2)

1. **P2-1** — Fix locale `fr_FR` impression (`initializeDateFormatting`)  
2. **P2-2** — Note de commande persistée  
3. **P2-3** — Test E2E CI mobile ↔ PC  
4. **P2-4** — Validation imprimante AR réelle  
5. **P2-5** — PowerSync production Supabase  
6. **P2-6** — Rapport ventes par serveur  

---

## Vérifications manuelles recommandées

- [ ] `cd packages/core && dart test` (83 tests)
- [ ] `cd packages/network && dart test` (15 tests)
- [ ] `cd apps/pos_desktop && flutter test` (16 tests)
- [ ] Caisse : UI maquette — recherche, catégories, panier, PAYER
- [ ] Mobile : session PC ouverte → commande → sync miroir PC
- [ ] KDS : lignes « À suivre » + PRÊT sur fired
- [ ] Impression cuisine AR + ticket client (après fix P2-1)
- [ ] Voucher : scan QR → USED
