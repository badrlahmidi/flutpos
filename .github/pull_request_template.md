## Résumé

<!-- Décrivez en 2–3 phrases l'objectif de cette PR (quoi + pourquoi). -->

-

## Type de changement

- [ ] Feature (nouvelle fonctionnalité)
- [ ] Fix (correction de bug)
- [ ] Refactor (sans changement de comportement)
- [ ] Docs (documentation / roadmap uniquement)
- [ ] Test (ajout ou correction de tests)
- [ ] Chore (CI, dépendances, tooling)

## Sprint / périmètre

<!-- Ex. Sprint 4 — Plan de salle, ou « hotfix encaissement » -->

- **Sprint :** 
- **Étapes / tickets :** 

## Modifications principales

<!-- Liste courte des fichiers ou modules touchés -->

- 

## Checklist développeur

- [ ] J'ai lu les docs pertinentes dans `docs/architecture/`
- [ ] Pas de couleurs en dur — `Theme.of(context).colorScheme` uniquement
- [ ] Touch targets ≥ 64 px (Fat-Finger)
- [ ] UUID pour les nouveaux identifiants
- [ ] Actions sensibles : audit **avant** mutation + PIN Manager si RBAC l'exige
- [ ] Écriture locale Drift d'abord (offline-first)
- [ ] `dart analyze` sans erreur sur les packages modifiés

## Tests

```bash
cd packages/core && dart test
cd apps/pos_desktop && dart analyze lib
# cd apps/waiter_mobile && flutter test   # si mobile touché
```

- [ ] Tests unitaires ajoutés ou mis à jour
- [ ] Calculs financiers : couverture maintenue à 100 % sur `packages/core/lib/usecases/`

## Plan de test manuel

<!-- Scénarios à rejouer sur caisse (PIN démo admin : 1234) -->

1. 
2. 
3. 

## Captures / logs (optionnel)

<!-- Screenshots, extrait console impression simulée, etc. -->

## Notes pour le relecteur

<!-- Points d'attention, dette technique, follow-up -->

-

## Références

<!-- Liens issues, `docs/architecture/SPRINT_STATUS.md`, scénarios `04_business_scenarios_qa.md` -->

-
