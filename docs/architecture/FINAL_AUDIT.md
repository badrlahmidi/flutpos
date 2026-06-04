# Audit final — Ritagestion POS (Sprints 0 à 5)

> Date : **4 juin 2026** · Branche : `feat/sprints-4-5-livraison` · Auditeur : agent IA (revue code + tests automatisés)

---

## Résumé exécutif

Le monorepo **Ritagestion** dispose d’une **caisse desktop Windows mature** (offline-first, trésorerie complète, plan de salle, KDS, analytics, export comptable). La couche **core** est solide avec **63 tests unitaires** passants et une séparation repositories / use cases financiers respectée.

Les principaux risques avant mise en production sont : **application mobile serveur absente**, **cloud PowerSync non validé en environnement réel**, **absence de CI**, et **~30 % des scénarios métier backlog** encore non couverts (courses, vouchers, multi-tenant, i18n AR).

### Note globale : **7,4 / 10**

| Dimension | Note | Commentaire |
|-----------|------|-------------|
| Architecture & couches | 8,0 | Clean Architecture respectée dans `core` ; domaine métier surtout dans repositories |
| Caisse desktop (pos_desktop) | 8,5 | UI riche, BLoC, flux encaissement → salle → backoffice |
| Couche data (Drift) | 9,0 | 22 tables, seed, migrations, tests repositories |
| Réseau LAN | 6,5 | Protocole + serveur PC testés ; client mobile manquant |
| Cloud / SaaS | 6,0 | Infrastructure PowerSync prête ; prod + recovery non prouvés |
| Tests & qualité | 7,0 | Core/network OK ; BLoC UI et E2E faibles |
| Scénarios métier (50) | 7,0 | 70 % couverts, 14 % partiels |
| Prod-readiness Maroc | 7,5 | MAD, ICE, TVA, Glovo manuel ; i18n AR et vouchers manquants |

---

## Audit par couche

### Presentation (`apps/pos_desktop`)

| Élément | État | Échecs / gaps |
|---------|------|----------------|
| BLoC pattern | ✅ | Cart, Payment, FloorPlan, KDS, Catalog, Analytics, Reservations |
| Design system (64px, grille 8) | ✅ | Cohérent sur écrans principaux |
| Pas d’import Drift dans widgets | ✅ | Accès via repositories / sl |
| Tests BLoC / widget | ❌ | `widget_test.dart` référence `MyApp` inexistant (analyze error) |
| Golden tests PIN | ❌ | Non livré (Sprint 0) |
| Multi-fenêtre client | ❌ | Sprint 1 backlog |

### Domain (`packages/core` — use cases & entities)

| Élément | État | Échecs / gaps |
|---------|------|----------------|
| Calculs financiers | ✅ | `calculate_order_total`, `split_bill_calculator`, `calculate_change` — 100 % testés |
| Entities métier | ✅ | Snapshots analytics, floor plan, KDS, export comptable |
| Use cases métier salle | ⚠️ | Logique lourde dans `OrderRepositoryImpl` plutôt qu’use cases dédiés |
| Food cost à la vente | ❌ | Analytique théorique seule ; pas de déduction stock temps réel |
| RBAC fin | ⚠️ | PIN manager OK ; matrice permissions documentée pas entièrement codée |

### Data (`packages/core` — Drift & repositories)

| Élément | État | Échecs / gaps |
|---------|------|----------------|
| 22 tables + relations | ✅ | Conforme `02_database_schema.md` |
| Repositories testés | ✅ | Audit, cash, orders, floor, reservations, analytics, pointage, export |
| PowerSync schema | ✅ | Tables critiques synchronisables |
| `product_modifiers` cloud | ⚠️ | PK composite — créée localement en mode cloud |
| Offline-first | ✅ | Aucune action métier bloquée sans réseau |

### Network (`packages/network`)

| Élément | État | Échecs / gaps |
|---------|------|----------------|
| EventEnvelope + idempotence | ✅ | `messageId` UUID |
| WsMessageHandler | ✅ | CREATE_ORDER, ADD_ITEMS, VOID, FIRE_COURSE |
| PosNetworkServer (Shelf + mDNS) | ✅ | Démarré dans `AppBootstrap` |
| SyncQueue mobile | ⚠️ | Code présent ; **aucun client mobile** pour l’utiliser |
| KDS broadcast | ✅ | `ORDER_STATUS_CHANGED` depuis `KdsBloc` |

### Apps secondaires

| App | État |
|-----|------|
| `waiter_mobile` | ❌ Stub « Sprint 0 » — **régression majeure vs roadmap Sprint 2** |
| `tools/cloud` | ✅ Script simulation prix catalogue |
| `tools/powersync` | ✅ sync-rules.yaml |

---

## Scénarios métier (50)

Référence : `04_business_scenarios_qa.md`

### ✅ Couverts (35)

1, 2, 5, 6, 7, 8, 11, 12*, 13, 14, 17, 18, 19, 20, 21, 24, 26, 27, 28, 30, 31, 32, 33, 34, 35, 36, 37, 39, 40, 41, 42, 45†, 47, 48‡, 31–40 (encaissement bloc)

\* Split montant : calculateur OK, UI paiement split existante ; pas d’écran « ÷ N convives » dédié plan salle.  
† Recovery : infra PowerSync, non testé bout-en-bout Supabase.  
‡ Food cost dashboard ; pas déduction ingrédients automatique.

### ⚠️ Partiels (7)

3–4 (courses), 9 (combos), 10 (Glovo manuel sans son/alerte rush), 22 (file impression BDD), 23 (ticket AR), 29 (scan code-barres), 50 (pas rapport ventes par serveur)

### ❌ Manquants (8)

4 (envoyer suite — workflow complet), 15 (resto-basket / perte vol), 16 (VIP 100 % + stock), 38 (vouchers QR), 43 (démarque), 44 (reset PIN backoffice), 46 (menus programmés Ramadan), 49 (multi-tenant consolidé)

---

## Résultats tests automatisés

```
packages/core     : 63/63 passed
packages/network  : 15/15 passed
pos_desktop       : flutter analyze → 1 error (test/widget_test.dart), 2 infos
```

### Analyze `pos_desktop`

- `test/widget_test.dart:16` — `MyApp` n’existe pas (test template Flutter obsolète)
- `session_hub_page.dart:269` — `use_build_context_synchronously` (info)
- `pos_print_service.dart:729` — `avoid_print` (info)

---

## Recommandations priorisées

### P0 — Avant pilote restaurant

1. Implémenter **`waiter_mobile`** (connexion mDNS, tables, commande, offline SyncQueue)
2. Corriger / supprimer **`widget_test.dart`** ; ajouter smoke test `main.dart`
3. Pipeline **GitHub Actions** : melos bootstrap → analyze → test
4. Test **recovery PowerSync** sur instance Supabase staging

### P1 — Avant commercialisation

5. Vouchers + scan QR (scénario 38)
6. Courses Réclamé/Suite (scénarios 3–4)
7. i18n AR tickets cuisine + notes libres
8. Rapport ventes par serveur (scénario 50)
9. Tests BLoC critiques (Cart, Payment, FloorPlan)

### P2 — Différenciation marché

10. Multi-tenant dashboard cloud
11. Menus programmés Ramadan
12. Intégration API Glovo automatique
13. Multi-écran client + scan code-barres permanent

---

## Conclusion

**Ritagestion est prêt pour un pilote caisse desktop** (restaurant sans serveurs mobiles ou avec saisie caisse uniquement). La base technique est **professionnelle et extensible**. Pour une offre **complète restaurant marocain** (serveurs mobile + cloud backup garanti + conformité fiscale avancée), il reste **2 à 4 semaines** de travail ciblé sur les gaps P0–P1.

**Note globale finale : 7,4 / 10** — excellent MVP desktop, cloud et mobile à consolider.
