# Statut des sprints — Ritagestion

> Dernière mise à jour : juin 2026 (Sprint 3 terminé côté `pos_desktop` + `core`).

## Vue d’ensemble

| Sprint | Statut | Progression |
|--------|--------|-------------|
| 0 Fondations | ✅ Terminé | 100 % |
| 1 Caisse MVP | ✅ Terminé* | ~85 % |
| 2 Réseau LAN | ✅ Terminé | 100 % |
| 3 Trésorerie | ✅ Terminé | ~95 % |
| 4 Salle avancée | ⏳ À faire | 0 % |
| 5 Cloud & SaaS | ⏳ À faire | 0 % |

\* Sprint 1 : hors scope actuel — scan code-barres, multi-écran client, gestion courses avancée.

---

## Sprint 3 — Checklist détaillée

| Étape | Livrable | Statut |
|-------|----------|--------|
| 1 | `calculate_order_total`, `calculate_change`, `split_bill` + tests 100 % | ✅ |
| 2 | `AuditRepository`, audit avant actions sensibles | ✅ |
| 3 | `PaymentPage`, split, MAD, multi-paiements | ✅ |
| 4 | Reçu TVA, tiroir ESC/POS, proforma | ✅ |
| 5 | Remise globale, void + PIN Manager, ticket VOID cuisine | ✅ |
| 6 | Sessions caisse, pay-in/out, X-Report, Z-Report | ✅ |
| 7 | Facture ICE, n° séquentiel, impression FACTURE | ✅ |
| — | Vouchers / scan QR promo | ⏳ Sprint 3+ |

### Vérifications manuelles (post-sprint)

- [ ] `cd packages/core && dart test`
- [ ] Ouvrir caisse → vente → encaissement espèces (tiroir simulé console)
- [ ] Void article envoyé cuisine (PIN `1234`)
- [ ] Clôture Z avec écart justifié
- [ ] Facture ICE 15 chiffres

---

## Fichiers clés Sprint 3

```
packages/core/lib/usecases/
packages/core/lib/repositories/audit_repository*.dart
packages/core/lib/repositories/cash_session_repository*.dart
packages/core/lib/utils/order_totals.dart
packages/core/lib/utils/moroccan_ice.dart
apps/pos_desktop/lib/blocs/payment/
apps/pos_desktop/lib/pages/payment/
apps/pos_desktop/lib/pages/session/
apps/pos_desktop/lib/services/print/
```
