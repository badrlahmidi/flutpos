# Ritagestion POS

Solution de caisse **offline-first** pour la restauration au Maroc (Flutter monorepo Melos).

**Dépôt :** [github.com/badrlahmidi/flutpos](https://github.com/badrlahmidi/flutpos)

## Structure

| Package / App | Rôle |
|---------------|------|
| `packages/core` | BDD Drift (26 tables), repositories, use cases, entités |
| `packages/network` | Serveur Shelf, WebSocket, mDNS, sync LAN |
| `apps/pos_desktop` | Caisse Windows (8 BLoCs, 9 pages, Atomic Design) |
| `apps/waiter_mobile` | Application serveurs mobile |
| `docs/architecture/` | 10 spécifications techniques de référence |
| `docs/*_plan.md` | Plans d'implémentation par module |

## Démarrage rapide

```bash
dart pub global activate melos
melos bootstrap
cd apps/pos_desktop
flutter run -d windows
```

**PIN démo (seed)** : Admin `1234`, Caissier `5678`, Serveur `9012`

## Tests

```bash
cd packages/core && dart test        # 93 tests
cd packages/network && dart test     # 18 tests
cd apps/pos_desktop && flutter test  # 5 tests (4 à réparer)
```

## Roadmap

Voir [`ROADMAP.md`](ROADMAP.md) — **source unique de vérité**.

8 phases : Stabilisation → Backoffice CRUD → Salle interactive → Historique → Clients → Impression → Cloud → Polish.

## Documentation

| Document | Contenu |
|----------|---------|
| `ROADMAP.md` | Audit + roadmap unifié |
| `docs/mega_refonte_commerciale.md` | Vision produit 360° |
| `docs/architecture/01→10` | Specs techniques (stack, DB, réseau, scénarios, design, sécurité, tests, i18n) |
| `.cursorrules` | Règles de développement pour l'agent IA |

## Licence

Propriétaire — Ritagestion / Ritaj Info.
