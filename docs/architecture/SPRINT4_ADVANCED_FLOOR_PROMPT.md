# 🗺️ MEGA PROMPT — Sprint 4 : Gestion de Salle Avancée

> Copie-colle l'intégralité du bloc ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude).

---

## PROMPT À COPIER :

```
Tu es un ingénieur Flutter/Dart senior spécialisé dans les POS pour restaurants. Tu travailles sur le projet "Ritagestion".

## ÉTAT ACTUEL (Sprints 0, 1, 2, et 3 terminés ✅)

Les bases financières, l'encaissement et le réseau offline-first sont totalement opérationnels.
- Les calculs financiers, la clôture Z et l'AuditTrail fonctionnent à 100%.
- Le réseau (Shelf + WebSocket + mDNS) est actif, et la caisse peut gérer l'encaissement, les remises, et l'impression fiscale (ICE).

## DIRECTIVES OBLIGATOIRES AVANT DE CODER

Réfère-toi toujours aux règles définies dans `docs/architecture/` :
- `04_business_scenarios_qa.md` : Regarde particulièrement les scénarios liés aux tables (fusion, transfert, split bill par article) et aux livreurs (Glovo).
- `03_network_protocol.md` : Les événements KDS "Prêt" doivent être routés via WebSocket.
- Les touch-targets (64x64px), le Grid System, et l'architecture BLoC restent de rigueur.

## TÂCHE : Implémenter le Sprint 4 — Gestion de Salle Avancée

Ce sprint se concentre sur les interactions complexes de salle (tables, transferts) et l'extension du workflow vers la cuisine (KDS) et les livreurs.

Déploie les étapes suivantes avec une approche modulaire (Core ↔ pos_desktop).

### Étape 1 : Le Plan de Salle Visuel (Floor Plan UI)
Dans `apps/pos_desktop/lib/pages/floor_plan/` :
- Construis un écran interactif affichant un layout par `Zone` (ex: "Salle", "Terrasse").
- Chaque table (`RestaurantTables`) est représentée par une tuile colorée :
  - **Vert** : Libre (`FREE`)
  - **Rouge** : Occupée (`OCCUPIED`) avec affichage du timer (ex: "45 min") et du montant en cours.
  - **Orange** : Réservée (`RESERVED`) ou Proforma édité.
- Un clic sur une table libre ouvre une nouvelle commande (demande du nombre de couverts). Un clic sur une table occupée rouvre le ticket en cours.

### Étape 2 : Opérations Complexes sur les Tables
Intègre la logique dans `OrderRepository` et `FloorPlanBloc` :
- **Transfert de table** : Déplacer l'intégralité d'un ticket de la "Table 1" vers la "Table 5". Met à jour `Orders.tableId` et modifie les statuts des tables.
- **Fusion de tables** : Combiner deux tickets ouverts (ex: des amis se rejoignent). Fusionner les `OrderItems` sous un seul `OrderId` et libérer l'une des tables.
- **Split Bill par Article (Drag-and-Drop)** : Interface visuelle permettant de glisser un article (ex: 1 Coca) du ticket global vers un "Sous-ticket A" pour payer séparément.

### Étape 3 : Module de Réservations
Dans `apps/pos_desktop/lib/pages/reservations/` (ou un panneau latéral) :
- Ajoute la gestion des réservations (table `Reservations`).
- Permets de bloquer une table pour une heure précise (Nom, Téléphone, Couverts).
- Bascule automatique de la table en statut `RESERVED` 30 minutes avant l'heure prévue.

### Étape 4 : Gestion des Livraisons (Glovo / Deliveroo)
Dans l'interface principale de caisse :
- Ajoute un onglet "Livraisons" ou un bouton source rapide.
- Saisie manuelle rapide : Sélection de `source = GLOVO`, avec saisie optionnelle de `externalRef` (ex: "ID Glovo #1455").
- Ces commandes n'ont pas de `tableId` et passent en type `DELIVERY`. Le ticket cuisine doit imprimer en GROS : "🛵 GLOVO #1455".

### Étape 5 : Annulation avec Grâce & Mode Rapide
Dans la logique du `CartBloc` :
- **Annulation avec grâce** : Si un article est ajouté par erreur et supprimé dans les 30 secondes (sans être envoyé en cuisine), il disparaît sans trace (pas d'Audit, pas d'impression `VOID`).
- **Bascule Table / Quick Service** : Un bouton global (Top Bar) pour forcer le mode de prise de commande. En Quick Service, on by-pass le plan de salle et le `tableId` est nul (commande au comptoir).

### Étape 6 : Regroupement de Tickets Bar et KDS
Dans la gestion de l'impression et de l'envoi :
- **Regroupement** : Les articles identiques (ex: 4x Café) doivent être regroupés sur une seule ligne (Qte: 4) sur le ticket d'impression Bar, sauf s'ils ont des modificateurs différents.
- **KDS (Kitchen Display System)** : Pose les fondations du KDS. Un écran séparé (ou une route spécifique) affichant les tickets en attente. Un bouton "Prêt" déclenche un message WebSocket `ORDER_STATUS_CHANGED` pour notifier le serveur que le plat est prêt.

---
Commence par **l'Étape 1 (Le Plan de Salle Visuel)**, puis l'Étape 2. Procède de façon itérative. Montre-moi le code généré pour la couche BLoC/Repository et l'UI du plan de salle.
```

---

## VÉRIFICATIONS POST-SPRINT 4

Une fois ce sprint exécuté par l'agent, testez le workflow de salle complet :
1. Allez sur le Plan de Salle, ouvrez la **Table 2**. Ajoutez des plats. La table doit devenir **Rouge**.
2. Effectuez un **Transfert** de la Table 2 vers la **Table 4**. La 2 doit devenir verte, la 4 rouge.
3. Testez le **Split Bill par Article** (extrêmement utile pour les groupes).
4. Ouvrez une commande en sélectionnant la source **GLOVO** et imprimez un ticket cuisine pour vérifier la mention du livreur.
