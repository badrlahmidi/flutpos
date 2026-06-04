# Publication GitHub — premier push

## 1. Créer le dépôt sur GitHub

1. [github.com/new](https://github.com/new) → nom ex. `ritagestion` ou `flutpos`
2. **Ne pas** initialiser avec README (déjà présent localement)
3. Copier l’URL HTTPS : `https://github.com/<ORG_OU_USER>/<REPO>.git`

## 2. Pousser depuis la machine locale

```powershell
cd c:\devzone\flutpos

git remote add origin https://github.com/<ORG_OU_USER>/<REPO>.git
git push -u origin main
```

## 3. Pull request

Le dépôt inclut un modèle automatique : [`.github/pull_request_template.md`](../.github/pull_request_template.md).

Pour une **livraison de sprint**, copiez aussi le contenu de [`.github/PULL_REQUEST_TEMPLATE/sprint_delivery.md`](../.github/PULL_REQUEST_TEMPLATE/sprint_delivery.md) dans la description.

### Branche feature

```powershell
git checkout -b feature/sprint4-floor-plan
git push -u origin feature/sprint4-floor-plan
```

Puis sur GitHub : **Compare & pull request** → base `main` (le template se pré-remplit).

### Exemple de titre PR

- `feat(pos): Sprint 4 — plan de salle et transfert tables`
- `fix(payment): correction monnaie sur split espèces`
- `docs: mise à jour roadmap Sprint 3`

Avec [GitHub CLI](https://cli.github.com/) :

```bash
gh pr create --base main --title "feat: Sprint 4 — gestion de salle" --body-file .github/PULL_REQUEST_TEMPLATE/sprint_delivery.md
```

## 4. CI recommandée (à ajouter)

```yaml
# .github/workflows/ci.yml
- melos bootstrap
- cd packages/core && dart test
- cd apps/pos_desktop && flutter analyze
```
