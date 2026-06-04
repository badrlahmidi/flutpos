# Ritagestion POS

Solution de caisse **offline-first** pour la restauration au Maroc (Flutter monorepo Melos).

## Structure

| Package / App | Rôle |
|---------------|------|
| `packages/core` | BDD Drift, repositories, use cases financiers, audit |
| `packages/network` | WebSocket, mDNS, sync LAN |
| `apps/pos_desktop` | Caisse Windows |
| `apps/waiter_mobile` | Serveurs mobile (Sprint 2) |
| `docs/architecture/` | Spécifications et prompts sprint |

## Démarrage rapide

```bash
dart pub global activate melos
melos bootstrap
cd apps/pos_desktop
flutter run -d windows   # ou chrome si pas de toolchain VS C++
```

**PIN démo (seed)** : Admin `1234`, Caissier `5678`, Serveur `9012`

## Sprints

| Sprint | Statut | Doc |
|--------|--------|-----|
| 0 Fondations | ✅ | `docs/architecture/SPRINT0_FOUNDATIONS_PROMPT.md` |
| 1 Caisse MVP | ✅ (partiel) | `docs/architecture/SPRINT1_DESKTOP_MVP_PROMPT.md` |
| 2 Réseau LAN | ✅ | `docs/architecture/SPRINT2_NETWORK_PROMPT.md` |
| 3 Trésorerie | ✅ | `docs/architecture/SPRINT3_TREASURY_PROMPT.md` |
| 4 Salle avancée | ⏳ | `docs/architecture/SPRINT4_ADVANCED_FLOOR_PROMPT.md` |

Détail roadmap : [`docs/architecture/11_roadmap_and_business.md`](docs/architecture/11_roadmap_and_business.md)

## Tests core

```bash
cd packages/core
dart test
```

## Licence

Propriétaire — Ritagestion.
