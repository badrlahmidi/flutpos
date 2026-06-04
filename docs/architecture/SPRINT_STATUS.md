# Statut des sprints — Ritagestion

> Dernière mise à jour : **4 juin 2026** — audit post-Sprints 0 à 5 (livraison `feat/sprints-4-5-livraison`).

## Vue d’ensemble

| Sprint | Statut | Progression | Tests / analyse |
|--------|--------|-------------|-----------------|
| 0 Fondations | ✅ Terminé | 100 % | Drift 22 tables, seed, thème, bcrypt |
| 1 Caisse MVP | ✅ Terminé* | ~85 % | Caisse 3 colonnes, BLoC Cart, impression |
| 2 Réseau LAN | ⚠️ Partiel | ~60 % | Serveur PC ✅ · App mobile ❌ (stub) |
| 3 Trésorerie | ✅ Terminé | ~95 % | 30+ tests financiers, Z-Report, ICE |
| 4 Salle avancée | ✅ Terminé* | ~88 % | Plan salle, KDS, Glovo, réservations |
| 5 Cloud & SaaS | ✅ Terminé* | ~75 % | PowerSync local, dashboard, export CSV |

**Suite de tests (4 juin 2026)** : `packages/core` **63/63** ✅ · `packages/network` **15/15** ✅ · `pos_desktop` analyze **1 error** (widget_test obsolète) + 2 infos.

\* Voir lacunes détaillées dans [`FINAL_AUDIT.md`](FINAL_AUDIT.md).

---

## Sprint 4 — Checklist détaillée

| Étape | Livrable | Statut |
|-------|----------|--------|
| 1 | Plan de salle visuel par zone (FREE / OCCUPIED / RESERVED) | ✅ |
| 2 | Transfert + fusion de tables (`OrderRepository`) | ✅ |
| 2 | Split bill par article (drag-and-drop UI) | ✅ |
| 2 | Split bill par montant (division égale) | ⚠️ Use case seul, pas d’UI dédiée |
| 3 | Module réservations + statut RESERVED −30 min | ✅ |
| 4 | Commandes Glovo/Deliveroo (source + externalRef) | ✅ |
| 5 | Annulation grâce 30 s + toggle Quick Service / Table | ✅ |
| 6 | Regroupement tickets bar (`KitchenTicketLineGrouper`) | ✅ |
| 6 | KDS + WebSocket `ORDER_STATUS_CHANGED` | ✅ |
| — | Gestion couverts (stats panier moyen) | ✅ (guestCount) |
| — | Courses Réclamé / Suite | ⏳ Post-MVP |

---

## Sprint 5 — Checklist détaillée

| Étape | Livrable | Statut |
|-------|----------|--------|
| 1 | PowerSync schema + connector + `CloudSyncConfig` | ✅ |
| 1 | Recovery disaster (Supabase réel) | ⏳ Non testé en prod |
| 2 | Silent Update catalogue (`watchProductsByCategory`) | ✅ |
| 3 | Dashboard analytique (KPI, heures, top 5, food cost) | ✅ |
| 4 | Pointage RH (clock-in/out sur écran auth) | ✅ |
| 5 | Export comptable CSV (; BOM UTF-8, TVA + modes) | ✅ |
| — | Multi-tenant / dashboard consolidé | ⏳ Post-MVP |
| — | Pertes / démarque | ⏳ Post-MVP |
| — | Menus programmés (Ramadan) | ⏳ Post-MVP |
| — | Food cost auto (déduction stock à la vente) | ⏳ Analytique seule |
| — | Ventes par serveur (upsell) | ⏳ Post-MVP |

---

## Couverture des 50 scénarios métier

| Phase | Couverts | Partiels | Manquants |
|-------|----------|----------|-----------|
| Phase 1 — Prise de commande | 6 | 2 | 2 |
| Phase 2 — Gestion salle | 8 | 1 | 1 |
| Phase 3 — Cuisine & impression | 7 | 2 | 2 |
| Phase 4 — Encaissement | 9 | 0 | 1 |
| Phase 5 — Back-office | 5 | 2 | 3 |
| **Total** | **35 (70 %)** | **7 (14 %)** | **8 (16 %)** |

Détail complet : [`FINAL_AUDIT.md`](FINAL_AUDIT.md#scénarios-métier-50).

---

## Lacunes critiques (priorité post-livraison)

1. **`apps/waiter_mobile`** — écran placeholder Sprint 0 ; le client mobile n’est pas implémenté malgré le serveur LAN actif sur le PC.
2. **CI GitHub Actions** — non configurée (`flutter analyze` + `dart test` à chaque push).
3. **PowerSync production** — nécessite Supabase + instance PowerSync + déploiement `tools/powersync/sync-rules.yaml`.
4. **Tests BLoC presentation** — objectif 90 % non atteint sur `pos_desktop`.
5. **i18n FR/AR** — contenu tickets partiellement FR ; pas de toggle clavier AR.
6. **Vouchers / scan QR** — reporté depuis Sprint 3.
7. **Courses (Réclamé/Suite)** — scénarios 3–4 non livrés.

---

## Fichiers clés Sprints 4–5

```
packages/core/lib/repositories/
  floor_plan_repository*.dart, reservation_repository*.dart, kds_repository*.dart
  analytics_repository*.dart, time_attendance_repository*.dart
  accounting_export_repository*.dart
packages/core/lib/database/cloud/
apps/pos_desktop/lib/pages/floor_plan/, kds/, reservations/, backoffice/
apps/pos_desktop/lib/blocs/floor_plan/, kds/, catalog/, analytics_dashboard/
tools/powersync/sync-rules.yaml
tools/cloud/simulate_catalog_price_update.dart
```

---

## Vérifications manuelles recommandées

- [ ] `cd packages/core && dart test` (63 tests)
- [ ] `cd packages/network && dart test` (15 tests)
- [ ] Plan salle : ouvrir Table 2 → transfert Table 4 → fusion
- [ ] KDS : marquer commande « Prêt » → événement WebSocket
- [ ] Glovo : commande DELIVERY + ticket cuisine en-tête livreur
- [ ] Dashboard : KPI jour + graphique heures
- [ ] Export CSV mois courant → ouvrir dans Excel
- [ ] Pointage : entrée/sortie PIN serveur
- [ ] (Cloud) Variables `POWERSYNC_URL` + JWT → recovery BDD
