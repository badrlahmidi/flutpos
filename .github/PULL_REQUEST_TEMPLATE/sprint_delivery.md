## Livraison sprint — [Sprint N — Titre]

### Résumé

<!-- Synthèse de la livraison sprint (objectifs métier + technique). -->

Cette PR regroupe la livraison **Sprint N** pour Ritagestion POS (caisse desktop + `packages/core`).

### Checklist sprint (roadmap)

Voir [`docs/architecture/SPRINT_STATUS.md`](../docs/architecture/SPRINT_STATUS.md) et [`11_roadmap_and_business.md`](../docs/architecture/11_roadmap_and_business.md).

- [ ] Objectifs sprint cochés dans la roadmap
- [ ] Prompt sprint mis à jour (statut TERMINÉ si applicable)
- [ ] Tests core passent (`dart test` dans `packages/core`)

### Fonctionnalités livrées

| Étape | Statut | Notes |
|-------|--------|-------|
| 1 | ⬜ | |
| 2 | ⬜ | |
| 3 | ⬜ | |

### Parcours de validation bout-en-bout

1. Connexion PIN → ouverture session caisse (Trésorerie)
2. Prise de commande → cuisine → encaissement
3. (Adapter selon le sprint)

### Tests automatisés

```bash
melos bootstrap
cd packages/core && dart test
cd apps/pos_desktop && dart analyze lib
```

### Hors scope / reporté

<!-- Ex. vouchers QR, CI GitHub Actions -->

-

### Prochain sprint

<!-- Lien vers SPRINT4 ou tâches suivantes -->

-
