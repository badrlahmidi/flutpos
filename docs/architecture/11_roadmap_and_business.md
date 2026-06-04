# Roadmap de Développement — 6 Sprints + Conseils Métier Maroc

## Vue d'ensemble

```
Sprint 0 ──→ Sprint 1 ──→ Sprint 2 ──→ Sprint 3 ──→ Sprint 4 ──→ Sprint 5
Fondations   Caisse MVP   Réseau LAN   Trésorerie   Salle avancé  Cloud & SaaS
 (1 sem)      (2 sem)      (2 sem)      (2 sem)       (2 sem)       (3 sem)
```

**Durée totale estimée : 12 semaines (3 mois)**

---

## Sprint 0 — Fondations (Semaine 1) ✅

### Objectifs
- [x] Initialiser le monorepo Melos selon `06_folder_structure.md`
- [x] Configurer Drift : générer les 22 tables du schéma `02_database_schema.md`
- [x] Créer `app_theme.dart` avec le Design System complet (`05_design_system.md`)
- [x] Implémenter le hachage PIN avec bcrypt (`07_security_and_auth.md`)
- [x] Insérer les données Mock (seed) :
  - 3 utilisateurs (1 Admin, 1 Caissier, 1 Serveur)
  - 3 zones (Salle, Terrasse, VIP) + 8 tables
  - 2 stations d'impression (Cuisine, Bar)
  - 4 catégories (Entrées, Plats, Boissons, Desserts)
  - 15 produits avec modificateurs (cuissons, suppléments)
  - 1 RestaurantConfig avec ICE, RC
- [ ] Setup CI : `flutter analyze` + `flutter test` sur chaque push
- [ ] Premier golden test de l'écran PIN

### Livrables
- Monorepo fonctionnel avec `melos bootstrap`
- BDD Drift initialisée + fichier `.g.dart` généré
- Thème Material appliqué

---

## Sprint 1 — Caisse Desktop MVP (Semaines 2-3) ✅*

### Objectifs
- [x] **Écran d'authentification PIN** (numpad tactile, 64x64px par touche)
- [x] **Écran principal 3 colonnes :**
  - Gauche : Barre de catégories (vertical, pas de scroll horizontal)
  - Centre : Grille de produits (SliverGrid responsive)
  - Droite : Panneau panier avec total en temps réel
- [x] **BLoC Cart :** Ajout/suppression articles, modificateurs, notes libres
- [x] **BLoC Session :** Ouverture de session de caisse (PIN + fond de caisse) — hub Sprint 3
- [x] **Modal Modificateurs :** Popup avec cuissons, suppléments (boutons rapides)
- [x] **Impression ticket :**
  - Ticket client (résumé, total, mode de paiement)
  - Ticket cuisine avec routage par catégorie → station d'impression
- [ ] **Recherche produit + scan code-barres** (champ focusé par défaut)
- [ ] **Gestion des courses** (Réclamé/Suite, bouton "Envoyer la suite")
- [ ] **Multi-window :** Fenêtre client sur 2ème écran (total en cours)
- [x] **Mode plein écran** via window_manager (empêcher sortie)

### Livrables
- Prise de commande fonctionnelle sur PC
- Impression thermique testée sur vraie imprimante
- 30+ tests unitaires sur les calculs de prix

---

## Sprint 2 — Réseau LAN + Mobile Waiters (Semaines 4-5) ✅

### Objectifs
- [x] **Serveur Shelf** sur le PC avec routes HTTP + WebSocket
- [x] **Broadcast mDNS** (`_ritajpos._tcp`) depuis le PC
- [x] **App mobile — Écran connexion :** Découverte auto + fallback IP manuelle
- [x] **App mobile — Liste des tables** avec statut coloré (libre/occupé)
- [x] **App mobile — Prise de commande** : grille produits, modificateurs, notes
- [x] **Flux complet :** Mobile envoie commande → PC reçoit → Imprime en cuisine
- [x] **SyncQueue :** File d'attente locale sur le mobile
- [x] **Mode Offline :** Commande sauvegardée localement si WiFi coupé
- [x] **Heartbeat :** Ping toutes les 10s, détection déconnexion
- [x] **Alerte stock temps réel :** WebSocket broadcast quand stock = 0

### Livrables
- Communication PC ↔ Mobile fonctionnelle en WiFi
- Prise de commande offline testée (couper le WiFi et reconnecter)
- Ticket cuisine imprimé depuis le mobile du serveur

---

## Sprint 3 — Trésorerie & Encaissement (Semaines 6-7) ✅

> Détail : [`SPRINT_STATUS.md`](SPRINT_STATUS.md) · Prompt : [`SPRINT3_TREASURY_PROMPT.md`](SPRINT3_TREASURY_PROMPT.md)

### Objectifs
- [x] **Écran paiement :**
  - Boutons rapides : Espèces, Carte, TPE, Chèque, Voucher, Repas employé
  - Split Payment multi-méthodes
  - Calculateur de monnaie visuel (décomposition billets MAD)
- [x] **Proforma :** Impression + verrouillage de la table (`PROFORMA`)
- [x] **Tiroir-caisse :** Ouverture ESC/POS sur paiement espèces (+ audit manuel)
- [x] **Pay-in / Pay-out** avec raison obligatoire + PIN admin
- [x] **Facture entreprise** avec saisie ICE + numéro séquentiel (schéma v3)
- [x] **Remises :**
  - % ou montant fixe sur le ticket global
  - Void par article avec PIN manager + raison
  - Mode paiement repas employé (encaissement)
- [ ] **Vouchers :** Saisie code promo ou scan QR
- [x] **X-Report** (brouillard de caisse, consultation sans clôturer)
- [x] **Z-Report** (clôture définitive avec écart justifié)
- [x] **AuditTrail :** Log de chaque action sensible

### Livrables
- [x] Cycle complet : Ouverture → Ventes → Pay-out → Clôture Z
- [x] Tests unitaires 100% sur les calculs financiers (`packages/core`, 30 tests)
- [x] Audit trail fonctionnel

---

## Sprint 4 — Gestion de Salle Avancée (Semaines 8-9)

### Objectifs
- [ ] **Plan de salle visuel** : Grille par zone avec tables colorées selon statut
- [ ] **Transfert de table** : Déplacer une commande de Table A → Table B
- [ ] **Fusion de tables** : Combiner 2 tickets ouverts
- [ ] **Split Bill par montant** : Division égale entre N personnes
- [ ] **Split Bill par article** : Drag-and-drop sur PC
- [ ] **Écran Cuisine (KDS)** : Tablette WebSocket, bouton "Prêt" → notif serveur
- [ ] **Regroupement tickets bar** : "4x Café" au lieu de 4 tickets
- [ ] **Réservations** : Module basique avec blocage de table
- [ ] **Gestion couverts** : Ajustement pour statistiques panier moyen
- [ ] **Annulation avec grâce** : <30s et non imprimé → invisible. Sinon → ticket ANNULATION
- [ ] **Bascule Service Rapide / Table** en un clic
- [ ] **Commandes Glovo/Deliveroo** : Intégration basique (saisie manuelle avec source + externalRef)

### Livrables
- Gestion salle complète avec tous les scénarios de la Phase 2
- KDS fonctionnel sur tablette Android
- Split bill testé en conditions réelles

---

## Sprint 5 — Cloud, Multi-tenant & Analytics (Semaines 10-12)

### Objectifs
- [ ] **PowerSync + Supabase :** Synchronisation bidirectionnelle
- [ ] **Recovery disaster :** Nouveau PC → restauration complète en 1 minute
- [ ] **Silent Update :** Modification prix depuis le cloud → push sur la caisse
- [ ] **Dashboard analytique :**
  - CA par jour/semaine/mois
  - Produits les plus vendus
  - Heures de pointe
  - Performances par serveur (upsell)
  - Food cost réel vs théorique
- [ ] **Export comptable :** CSV/Excel avec séparation CA sur place/livraison/TVA
- [ ] **Multi-tenant :** Isolation par restaurant, dashboard consolidé
- [ ] **Pointage employés :** Clock-in/out avec calcul heures travaillées
- [ ] **Pertes/Démarque :** Scan produit → choisir "Périmé" → mise à jour stock
- [ ] **Menus programmés :** Catégories avec créneaux horaires (Ftour Ramadan)
- [ ] **Food Cost automatique :** Vente → déduction ingrédients via RecipeItems

### Livrables
- Synchronisation cloud testée (couper internet → reconnecter → vérifier intégrité)
- Dashboard avec graphiques
- Export CSV fonctionnel
- Multi-restaurant opérationnel

---

## Conseils Métier — Marché Marocain de la Restauration

### 1. La monnaie en Dirhams — Game Changer UX
Aucun POS concurrent au Maroc n'a de calculateur de monnaie visuel. Implémentez :
- Client donne 200 DH pour 153 DH → "Monnaie : 47 DH"
- Décomposition : 2×20 DH + 1×5 DH + 1×2 DH
- Boutons rapides : "200 DH", "100 DH", "50 DH" (les billets que le client tend)
- C'est la fonctionnalité qui fera dire au caissier "ce logiciel est intelligent"

### 2. Les coupures électriques (été marocain)
Fréquentes, surtout en juillet-août et dans les villes moyennes :
- **Auto-save toutes les 5s** sur les commandes en cours
- **Recovery mode** au redémarrage : détecter les commandes OPEN non payées
- **UPS (onduleur)** : recommander dans le guide d'installation
- Le POS doit redémarrer en <10 secondes et retrouver son état

### 3. Le Ramadan — Rush du Ftour
Le Ftour (rupture du jeûne) crée un rush extrême entre 19h et 20h :
- **Mode pré-commande :** Les tables sont préparées à l'avance avec commandes pré-saisies
- **Menus programmés :** La catégorie "Ftour" apparaît automatiquement à 18h et disparaît à 21h
- **Impression groupée :** Envoyer toutes les commandes en cuisine d'un coup à l'heure du Ftour

### 4. L'ICE — Obligation légale
Depuis la réforme fiscale :
- L'**ICE** (Identifiant Commun de l'Entreprise) est obligatoire sur les factures
- Le ticket de caisse standard n'exige pas l'ICE
- Mais le bouton "Facture" doit exiger : Nom entreprise + ICE client
- Stocker l'ICE du restaurant dans `RestaurantConfig`

### 5. Intégration Glovo — Argument de vente #1
Glovo domine la livraison au Maroc. Les restaurants ont une tablette Glovo séparée et retapent manuellement :
- **Phase 1 (Sprint 4) :** Saisie manuelle avec `source = GLOVO` + `externalRef = #1455`
- **Phase 2 (post-lancement) :** API Glovo pour réception automatique
- Le ticket cuisine doit afficher en gros : "🛵 GLOVO #1455" au lieu d'un numéro de table

### 6. Le double clavier FR/AR (Darija)
- Les serveurs communiquent en Darija (arabe dialectal marocain)
- Les notes libres doivent supporter la saisie arabe
- **Ne pas traduire automatiquement** : laisser le serveur écrire ce qu'il veut
- Le toggle FR/AR est un simple bouton sur le clavier virtuel

### 7. La TVA marocaine
- Taux standard : **20%**
- Taux réduit : **10%** (restauration sur place dans certains cas)
- Taux réduit : **7%** (certains produits alimentaires de base)
- **Exonéré :** Pain, farine de base
- Le champ `Products.taxRate` permet de gérer cette complexité par produit

### 8. Le marché cible marocain
Les restaurants marocains se divisent en 3 segments :
- **Snacks/Fast-food** (60%) : Service rapide, pas de tables, peu de serveurs → Mode Quick Service
- **Restaurants classiques** (30%) : Service à table, plan de salle, serveurs avec mobile → Mode Table Service
- **Haut de gamme** (10%) : Multi-zone (terrasse, salle, VIP), réservations, split bill → Full POS
- Ritagestion doit couvrir les 3 avec un simple toggle dans `RestaurantConfig.defaultServiceMode`
