# Ritagestion POS

Solution de caisse **offline-first** pour la restauration au Maroc (Flutter monorepo Melos).

**Dépôt :** [github.com/badrlahmidi/flutpos](https://github.com/badrlahmidi/flutpos)

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
| 2 Réseau LAN | ⚠️ (serveur PC ✅, mobile ❌) | `docs/architecture/SPRINT2_NETWORK_PROMPT.md` |
| 3 Trésorerie | ✅ | `docs/architecture/SPRINT3_TREASURY_PROMPT.md` |
| 4 Salle avancée | ✅ (~88 %) | `docs/architecture/SPRINT4_ADVANCED_FLOOR_PROMPT.md` |
| 5 Cloud & SaaS | ✅ (~75 %) | `docs/architecture/SPRINT5_CLOUD_SAAS_PROMPT.md` |

Détail : [`docs/architecture/SPRINT_STATUS.md`](docs/architecture/SPRINT_STATUS.md) · Roadmap : [`docs/architecture/11_roadmap_and_business.md`](docs/architecture/11_roadmap_and_business.md) · **Audit de référence : [`audit_analysis.md`](audit_analysis.md)**

## Tests core

```bash
cd packages/core
dart test
```

## Licence

Propriétaire — Ritagestion.
