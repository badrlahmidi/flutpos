# 💰 MEGA PROMPT — Sprint 3 : Trésorerie & Encaissement

> **Statut : ✅ TERMINÉ** (juin 2026) — Checklist : [`SPRINT_STATUS.md`](SPRINT_STATUS.md)

> Copie-colle l'intégralité du bloc ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude) pour maintenance ou Sprint 4+.

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter/Dart senior spécialisé dans les systèmes financiers POS. Tu travailles sur "Ritagestion", une solution de caisse hors-ligne pour le Maroc.

## ÉTAT ACTUEL (Sprints 0, 1, 2 et 3 terminés ✅)

Les bases sont solides : 
- **Core** : 22 tables Drift (schéma v3 : facture ICE sur Orders), use cases financiers, audit, sessions caisse.
- **UI** : Caisse 3 colonnes, encaissement, trésorerie X/Z, remises, voids, proforma, facture ICE.
- **Réseau** : Serveur Shelf + SyncQueue opérationnels.

## DIRECTIVE OBLIGATOIRE

Lis impérativement ces documents dans `docs/architecture/` avant de coder :
- `02_database_schema.md` : CashSessions, CashMovements, Payments, Orders, AuditTrail.
- `07_security_and_auth.md` : RBAC et Audit Trail. PIN Manager pour actions sensibles.
- `09_testing_strategy.md` : Couverture 100% sur les calculs financiers.
- `10_i18n_and_localization.md` : Monnaie MAD, décomposition billets.

## TÂCHE : Sprint 3 — TERMINÉ (référence implémentation)

### ✅ Étape 1 : Calculs Financiers purs
- `calculate_order_total.dart`, `calculate_change.dart`, `split_bill_calculator.dart` + tests

### ✅ Étape 2 : Audit Trail
- `AuditRepository`, `CashSessionRepository`, `OrderRepository` (discount, void)

### ✅ Étape 3 : Écran d'Encaissement
- `PaymentBloc`, `PaymentPage`, numpad, billets MAD, split payment

### ✅ Étape 4 : Impression & Tiroir
- Reçu TVA (`TaxBreakdown`), tiroir espèces, proforma + statut `PROFORMA`

### ✅ Étape 5 : Remises et Voids
- Remise globale + PIN Manager, void cuisine + ticket ANNULATION

### ✅ Étape 6 : Trésorerie
- `pages/session/` : ouverture, pay-in/out, X-Report, Z-Report

### ✅ Étape 7 : Facture ICE
- Toggle facture, ICE 15 chiffres, `invoiceNumber` séquentiel, ticket FACTURE

### ⏳ Reste hors scope Sprint 3
- Vouchers / scan QR promo (`Discounts` table)

---
Pour nouveau travail, enchaîner avec **Sprint 4** (`SPRINT4_ADVANCED_FLOOR_PROMPT.md`).
```

---

## VÉRIFICATIONS POST-SPRINT 3

1. **Tests unitaires critiques :**
   ```bash
   cd packages/core
   dart test
   ```
2. **Test du Void et du PIN Manager :**
   Lancez la caisse, essayez de supprimer un produit "Envoyé". La pop-up PIN doit s'afficher. Testez avec un PIN erroné puis le PIN Admin (1234).
3. **Ouverture de session et Clôture Z :**
   Ouvrez la session avec un fond de caisse, faites des ventes mixtes (Carte + Espèces), faites un Pay-out, puis clôturez la caisse (Z-Report). Le tiroir virtuel doit "s'ouvrir" (message console) lors des actions espèces.
4. **Facture ICE :**
   Encaissement → toggle Facture → nom + ICE 15 chiffres → ticket FACTURE en simulation.
