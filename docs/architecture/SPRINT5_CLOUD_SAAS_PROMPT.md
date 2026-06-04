# ☁️ MEGA PROMPT — Sprint 5 : Cloud, Multi-tenant & Analytics

> Copie-colle l'intégralité du bloc ci-dessous dans ton agent IA (Cursor, Windsurf, Cline, Claude).

---

## PROMPT À COPIER :

```
Tu es un architecte Cloud et ingénieur Flutter senior. Tu travailles sur le POS "Ritagestion", qui entre dans sa phase critique : la synchronisation Cloud (Offline-First to Cloud).

## ÉTAT ACTUEL (Sprints 0 à 4 terminés ✅)

L'application fonctionne parfaitement en réseau local :
- La BDD Drift gère les encaissements, le Split Bill, les tables et l'AuditTrail.
- Les WebSockets (`network` package) gèrent la comm PC ↔ Mobiles/KDS.
- L'interface tactile (Caisse + Plan de salle) est riche et "Fat-Finger" friendly.

## DIRECTIVES OBLIGATOIRES

- L'application **doit rester Offline-First**. Le POS ne doit JAMAIS dépendre d'une connexion internet pour encaisser un client ou ouvrir le tiroir-caisse.
- Nous utilisons `powersync` (^1.5.0) avec Supabase/PostgreSQL pour la réplication Cloud bidirectionnelle.
- Les identifiants sont déjà en UUID v4 (prérequis PowerSync validé).

## TÂCHE : Implémenter le Sprint 5 — Cloud, SaaS & Analytics

Ce sprint transforme le POS local en une solution SaaS connectée, permettant le backup en temps réel, la mise à jour silencieuse du catalogue depuis le web, et un tableau de bord analytique complet.

### Étape 1 : Configuration PowerSync & Supabase
Dans `packages/core/lib/database/` :
- Initialise la configuration `PowerSyncDatabase` (en complément ou remplacement partiel de `NativeDatabase` si tu suis les patterns PowerSync Flutter).
- Connecte PowerSync à l'URL Supabase via le JWT d'authentification (à moquer ou configurer via des variables d'environnement).
- **Objectif de Recovery** : Si je supprime la DB locale et que je me reconnecte, le POS doit télécharger toute sa configuration, ses tables, son catalogue, et son historique en moins d'une minute.

### Étape 2 : Silent Updates (Sync Cloud → Local)
- Démonstration de force : Si un Admin modifie le prix d'un produit sur le cloud (simulé via un script ou une interface), la base locale de la caisse se met à jour en arrière-plan.
- Ajoute un Stream/Listener sur les `Products` dans les BLoCs UI pour que le prix se rafraîchisse sur le POS sans nécessiter de redémarrage (Silent Update).

### Étape 3 : Tableau de bord analytique (Dashboard UI)
Dans `apps/pos_desktop/lib/pages/backoffice/` :
- Crée un écran "Dashboard Analytique" accessible via le menu.
- **KPIs (Cartes massives)** : 
  - Chiffre d'Affaires du jour (sur place vs livraison).
  - Nombre de tickets.
  - Panier moyen.
- **Graphiques** : (utilise un package comme `fl_chart`)
  - Ventes par heure (Heures de pointe).
  - Top 5 des produits les plus vendus.
- **Food Cost** : Écart entre le coût théorique des ingrédients (via `RecipeItems`) et les ventes.

### Étape 4 : Pointage des employés (Clock-in / Clock-out)
Dans `apps/pos_desktop/` :
- Ajoute une interface de pointage sur l'écran d'authentification (avant même de se connecter à la caisse).
- Le serveur tape son PIN et clique sur "Pointer l'Entrée" ou "Pointer la Sortie".
- Insère dans la table `TimeAttendance`.

### Étape 5 : Export Comptable (CSV/Excel)
Dans le Backoffice :
- Ajoute une fonctionnalité pour exporter le rapport Z mensuel.
- Format CSV (ou Excel) séparant clairement le Chiffre d'Affaires par taux de TVA (7%, 10%, 20%) et par type de règlement (Espèces, Carte, TPE).
- Utilise le package `csv` ou `path_provider` pour sauvegarder le fichier sur le bureau Windows de l'utilisateur.

---
Commence par **l'Étape 1 (PowerSync)** car elle impacte l'initialisation de la BDD. Montre-moi le code de setup PowerSync et comment il s'intègre avec ton `AppDatabase` Drift actuel.
```

---

## VÉRIFICATIONS POST-SPRINT 5

1. **Test Crash Recovery** :
   Fermez l'app. Renommez le fichier `ritagestion_seed.db` en `backup.db` (simulation de destruction du PC). Relancez l'app. Observez la synchronisation Cloud recréer la DB et restaurer les données en temps réel.
2. **Dashboard** :
   Accédez à l'écran backoffice. Les graphiques doivent se dessiner avec les données générées dans les sprints précédents.
3. **Export comptable** :
   Testez le bouton d'export CSV. Ouvrez le fichier généré dans Excel pour valider les colonnes TVA.
