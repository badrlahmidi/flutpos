# Stratégie de Gestion des Erreurs

Un POS en restauration ne peut JAMAIS crasher. Ce document définit la stratégie de résilience à chaque couche.

---

## 1. Principes Fondamentaux

1. **Aucun crash silencieux** — Chaque erreur doit être capturée, loggée et affichée
2. **Dégradation gracieuse** — Si un composant tombe, les autres continuent
3. **L'argent d'abord** — En cas de doute, toujours sauvegarder la transaction en cours
4. **Recovery automatique** — Le système doit se relever tout seul après une coupure

---

## 2. Gestion par Couche

### Couche BDD (Drift/SQLite)

| Erreur | Comportement attendu |
|---|---|
| BDD corrompue | Détecter au démarrage → proposer restauration depuis le backup local |
| Espace disque plein | Alerte visuelle rouge. Purger les logs anciens automatiquement |
| Migration échouée | Rollback à la version précédente + alerte admin |

**Auto-save :** Toutes les commandes `OPEN` sont sauvegardées automatiquement toutes les **5 secondes** via un timer Dart.

**Recovery au redémarrage :**
```
Au lancement → Vérifier les Orders avec status == OPEN
             → Si trouvées → Les ré-afficher dans le panier du caissier
             → Notification : "X commandes récupérées après redémarrage"
```

### Couche Réseau (WebSocket)

| Erreur | Comportement attendu |
|---|---|
| WebSocket déconnecté | Retry avec backoff exponentiel : 1s → 2s → 4s → 8s → max 30s |
| Timeout (pas d'ACK après 10s) | Re-envoyer le message (idempotent grâce au messageId) |
| mDNS ne trouve pas la caisse | Afficher "Caisse introuvable" + bouton "Saisir IP manuellement" |
| Message malformé reçu | Logger + ignorer. Ne jamais crasher sur un JSON invalide |

**Heartbeat :** Le PC envoie un `PING` toutes les **10 secondes** aux mobiles connectés. Si 3 PINGs manqués → marquer le terminal comme déconnecté.

### Couche Impression (ESC/POS)

| Erreur | Comportement attendu |
|---|---|
| Imprimante hors ligne | Stocker le ticket en file d'attente BDD (PrintQueue) |
| Plus de papier | Alerte visuelle "Imprimante [Cuisine] : plus de papier" |
| Timeout impression | Retry x3 puis file d'attente |
| Imprimante non trouvée | Proposer la liste des imprimantes détectées sur le réseau |

**Bouton "Réimprimer" :** Toujours disponible sur chaque ticket depuis l'historique.

### Couche BLoC (État)

Chaque BLoC doit implémenter ces états :
```dart
abstract class OrderState {}
class OrderInitial extends OrderState {}
class OrderLoading extends OrderState {}
class OrderReady extends OrderState { final CompleteOrder order; }
class OrderError extends OrderState { 
  final String message;      // Message localisé pour l'UI
  final String? technicalId; // ID technique pour le debug
  final OrderState? previousState; // État précédent pour retry
}
```

**Règle :** Un `OrderError` doit TOUJOURS conserver le `previousState` pour permettre un "Réessayer" sans perdre les données en cours.

---

## 3. Logging & Monitoring

### Niveaux de log

| Niveau | Usage | Exemple |
|---|---|---|
| `DEBUG` | Développement uniquement | "BLoC event: OrderItemAdded" |
| `INFO` | Flux normal | "Session ouverte par Ahmed (CASHIER)" |
| `WARNING` | Anomalie non bloquante | "Imprimante Cuisine timeout, retry 2/3" |
| `ERROR` | Erreur récupérable | "WebSocket déconnecté, passage en mode offline" |
| `FATAL` | Erreur irrécupérable | "Base de données corrompue" |

### Crash Reporting (Production)
- Intégrer `sentry_flutter` pour capturer les crashs à distance
- Chaque crash inclut : version app, OS, dernier BLoC state, dernière action utilisateur
- Les données sensibles (PIN, montants) ne sont JAMAIS envoyées à Sentry

---

## 4. Mode Dégradé (Urgence)

Si la BDD est inaccessible ou corrompue :
1. Afficher un écran "Mode Urgence" avec un fond rouge
2. Permettre uniquement l'encaissement manuel (montant saisi, pas de produits)
3. Stocker les transactions dans un fichier CSV local temporaire
4. Au retour de la BDD → importer le CSV et réconcilier
