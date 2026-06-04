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

## 3. Pull request (optionnel)

Si vous travaillez sur une branche feature :

```powershell
git checkout -b feature/sprint3-treasury
git push -u origin feature/sprint3-treasury
```

Puis sur GitHub : **Compare & pull request** → base `main`.

Avec [GitHub CLI](https://cli.github.com/) :

```bash
gh pr create --title "Sprint 3 — Trésorerie & encaissement" --body "Livraison Sprints 0-3, roadmap à jour."
```

## 4. CI recommandée (à ajouter)

```yaml
# .github/workflows/ci.yml
- melos bootstrap
- cd packages/core && dart test
- cd apps/pos_desktop && flutter analyze
```
