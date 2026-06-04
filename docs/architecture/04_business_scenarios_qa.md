# Scénarios Métier (Product Backlog POS)

Le système doit être capable de gérer de manière native et fluide les scénarios de restauration suivants. Le code métier (BLoC) doit prévoir ces états.

---

## Phase 1 : Prise de Commande (La zone de guerre des serveurs)

1. **Burger personnalisé** — Modificateurs (inclus, payants, obligatoires). UI mobile avec boutons rapides, pas de texte à taper.
2. **Plat du jour épuisé** — Alerte stock temps réel. Le bouton se grise sur tous les terminaux via WebSocket.
3. **Entrées d'abord, plats "à suivre"** — Notion de "Réclamé / Suite". Ticket avec séparation claire en cuisine.
4. **Envoyer la suite** — Bouton "Réclamer la suite" qui imprime "Table X — ENVOYER LES PLATS" en cuisine.
5. **Allergies** — Note libre en rouge clignotant sur le ticket cuisine.
6. **Wi-Fi terrasse coupé** — Offline-First : commande enregistrée en SQLite local, envoyée au retour du réseau.
7. **Erreur de table** — Transférer les articles vers une autre table avant sortie de la note.
8. **Dessert à emporter** — Changement de type par article (Dine-in vs Takeaway), frais d'emballage potentiel.
9. **Menu enfant avec dessert à choisir plus tard** — Formules (Combos) avec éléments "en attente de sélection".
10. **Commande Glovo/Deliveroo en plein rush** — Son distinct, intégration directe sans retaper.

---

## Phase 2 : Gestion de la Salle (Le Tétris du Manager)

11. **Fusion de tables** — Deux tickets combinés, ancienne table redevient "Libre".
12. **Split Bill par montant** — Division égale de l'addition (400 DH ÷ 4 = 100 DH chacun).
13. **Split Bill par article** — Drag-and-drop sur PC pour affecter chaque article à un sous-ticket.
14. **Plat refusé (froid)** — Offert/Annulé (Void) avec PIN manager et raison obligatoire.
15. **Resto-Basket (client parti)** — Clôture en mode "Perte / Vol" sans mettre le caissier en défaut.
16. **Invité VIP (100% offert)** — Remise 100% mais coût ingrédients déduit du stock.
17. **Changement de couverts** — Ajustement pour statistiques "Panier moyen par client".
18. **Annulation supplément post-commande** — Si <30s et non imprimé : annulation invisible. Sinon : ticket "ANNULATION" rouge en cuisine.
19. **Réservation** — Module basique bloquant le statut de la table.
20. **Service Rapide midi / Service à Table soir** — Bascule "Paiement avant consommation" ↔ "Ouvrir une table" en un clic.

---

## Phase 3 : Cuisine & Impression (Le nerf de la guerre)

21. **Routage intelligent** — Mojito/Café → imprimante Bar, Salade → imprimante Cuisine.
22. **Panne de papier** — File d'attente d'impression en BDD + bouton "Réimprimer les tickets non sortis".
23. **Double nommage** — UI serveur en français, ticket cuisine en arabe.
24. **Ticket perdu** — Bouton "Réimprimer le ticket de préparation" depuis n'importe quel terminal.
25. **Requête non standardisée** — Bouton "Message Libre" sur le clavier mobile.
26. **Ticket Glovo** — Numéro de commande livreur (#1455) en gros au lieu d'un numéro de table.
27. **Écran Cuisine (KDS)** — Commandes via WebSocket sur tablette. Le cuisinier tape "Prêt" → notif au serveur.
28. **Regroupement barman** — Mode synthèse : "4 x Café" au lieu de 4 petits tickets.
29. **Code-barres** — Champ de recherche PC focusé par défaut pour scan douchette immédiat.
30. **Takeaway** — Ticket cuisine spécifie en gras "À emporter" pour barquette fermée.

---

## Phase 4 : Encaissement & Trésorerie (L'argent de la journée)

31. **Split Payment multi-méthodes** — 200 Carte + 300 Espèces pour un ticket de 320 DH → monnaie -180 DH.
32. **Proforma** — "Imprimer Proforma" verrouille la table (plus d'ajout de plats).
33. **Pay-out** — Sortie de caisse tracée (ex: 100 DH pour acheter du pain).
34. **Facture entreprise** — Saisie Nom entreprise + ICE (Identifiant Commun d'Entreprise).
35. **Clôture Z** — X-Report (brouillard) puis Z-Report (clôture définitive + envoi cloud).
36. **Déficit de caisse** — "Raison d'écart" validée par le manager pour clôturer.
37. **TPE refusé** — Réouverture du ticket (PIN) pour changer le moyen de paiement.
38. **Bon de réduction** — Vouchers : scan QR ou saisie code pour déduire le montant.
39. **Repas employé** — Compte "Consommation Personnel" (coût enregistré, hors CA imposable).
40. **Tiroir-caisse** — Commande ESC/POS d'ouverture (`27 112 0 25 250`) uniquement sur paiement espèces ou autorisation manager.

---

## Phase 5 : Back-Office, Multi-tenant & Statistiques (La direction)

41. **Mise à jour des prix à distance** — Panel web → PowerSync Silent Update sur le PC.
42. **Pointage** — Clock-in/Clock-out via PIN ou badge RFID.
43. **Pertes/Démarque** — Scanner produit, choisir "Périmé", stock mis à jour sans revenus.
44. **PIN oublié** — Réinitialisation instantanée depuis le back-office PC.
45. **PC grillé (surtension)** — Nouveau PC → Supabase/PowerSync redescend la BDD en 1 minute.
46. **Menus programmés (Ramadan)** — Catégorie "Ftour" visible seulement entre 18h et 21h.
47. **Export comptable** — CSV/Excel avec séparation CA sur place, livraison, par TVA.
48. **Food Cost** — Fiches techniques : un produit fini = nomenclature d'ingrédients déduits.
49. **Multi-tenant** — Dashboard cloud consolidé pour gérer 3 restaurants.
50. **Performances équipe** — Rapport "Ventes par serveur" pour identifier l'upsell.
