# Sécurité & Authentification

## 1. Gestion des PIN (Authentification locale)

### Stockage sécurisé
- **INTERDIT** de stocker le PIN en clair dans la base de données
- Utiliser `bcrypt` (package `bcrypt`) pour hasher le PIN avant insertion
- Le champ `Users.pinHash` contient le hash, jamais le PIN original

### Flux d'authentification
```
Utilisateur tape son PIN → hash(PIN) → compare avec pinHash en BDD
                                         ├── Match → Autoriser
                                         └── No match → Refuser (max 3 tentatives)
```

### Verrouillage automatique
- **PC Desktop :** Auto-lock après **120 secondes** d'inactivité → écran PIN
- **Mobile Waiter :** Auto-lock après **60 secondes** d'inactivité
- Le timer se reset à chaque interaction tactile

---

## 2. Matrice des Permissions (RBAC)

| Action | WAITER | CASHIER | ADMIN |
|---|:---:|:---:|:---:|
| Prendre une commande | ✅ | ✅ | ✅ |
| Ajouter des articles | ✅ | ✅ | ✅ |
| Annuler un article (non envoyé) | ✅ | ✅ | ✅ |
| Annuler un article (envoyé en cuisine) | ❌ | ❌ | ✅ PIN |
| Appliquer une remise | ❌ | ❌ | ✅ PIN |
| Offrir un article (100% Void) | ❌ | ❌ | ✅ PIN |
| Encaisser un ticket | ❌ | ✅ | ✅ |
| Ouvrir le tiroir-caisse | ❌ | ✅ | ✅ |
| Réouvrir un ticket payé | ❌ | ❌ | ✅ PIN |
| Ouvrir une session de caisse | ❌ | ✅ | ✅ |
| Clôturer Z | ❌ | ✅ | ✅ |
| Pay-in / Pay-out | ❌ | ❌ | ✅ PIN |
| Modifier les prix des produits | ❌ | ❌ | ✅ |
| Gérer les utilisateurs | ❌ | ❌ | ✅ |
| Réinitialiser un PIN | ❌ | ❌ | ✅ |
| Voir les rapports / statistiques | ❌ | ❌ | ✅ |

### Mécanisme "PIN Manager"
Pour les actions marquées "✅ PIN", le flux est :
1. Le caissier/serveur initie l'action (ex: Void)
2. Un modal s'affiche : "Autorisation requise — Entrez le PIN Manager"
3. Le PIN est vérifié contre les users avec `role == ADMIN`
4. Si valide → action exécutée + entrée AuditTrail avec `userId` du manager
5. Si invalide → action bloquée + log de tentative échouée

---

## 3. Audit Trail (Journal de sécurité)

### Actions tracées obligatoirement

| Action | Déclencheur | Données enregistrées |
|---|---|---|
| `VOID_ITEM` | Annulation d'un article envoyé | orderId, itemId, raison, montant |
| `APPLY_DISCOUNT` | Remise appliquée | orderId, type, valeur, raison |
| `REOPEN_TICKET` | Réouverture d'un ticket payé | orderId, ancien statut |
| `CASH_DRAWER_OPEN` | Ouverture tiroir sans paiement | sessionId |
| `PAY_OUT` | Sortie d'espèces | sessionId, montant, raison |
| `PAY_IN` | Entrée d'espèces | sessionId, montant, raison |
| `CLOSE_SESSION` | Clôture Z | sessionId, écart, raison |
| `RESET_PIN` | Réinitialisation PIN | targetUserId |
| `PRICE_CHANGE` | Modification de prix produit | productId, ancien prix, nouveau prix |
| `LOGIN_FAILED` | 3 tentatives PIN échouées | terminal, IP |

### Rétention
- Les entrées AuditTrail sont **immuables** (pas de DELETE, pas d'UPDATE)
- Synchronisées vers le cloud via PowerSync
- Conservation minimum : **12 mois** (obligation légale Maroc)

---

## 4. Sécurité Réseau (LAN)

- Le serveur WebSocket n'accepte que les connexions du réseau local (vérification IP)
- Chaque terminal mobile est identifié par un `deviceId` unique dans les messages
- Les messages WebSocket contiennent un `messageId` UUID pour prévenir le replay
- En production : envisager TLS pour le WebSocket (`wss://`) si données sensibles

---

## 5. Protection de l'Application Desktop

- **Mode Kiosque :** `window_manager` force le plein écran (pas de Alt+F4)
- **Raccourcis bloqués :** Désactiver Alt+Tab, Win key en mode caisse
- **Pas d'accès explorateur :** L'application ne permet pas de naviguer dans les fichiers
