# Schéma de Base de Données (Drift / SQLite)

Le système utilise une base de données relationnelle locale.
Toutes les tables utilisent des UUID (String) comme clé primaire pour la compatibilité Offline-First.

**Total : 22 tables** | **Version du schéma : 2**

---

## 1. Configuration du Restaurant

### RestaurantConfig
Configuration globale (une seule ligne par installation).
- `id` (Text, UUID, PK)
- `name` (Text) — Nom du restaurant
- `address` (Text, nullable)
- `phone` (Text, nullable)
- `ice` (Text, nullable) — Identifiant Commun de l'Entreprise (obligatoire factures Maroc)
- `rc` (Text, nullable) — Registre de Commerce
- `identifiantFiscal` (Text, nullable) — IF fiscal
- `currency` (Text, default: `MAD`)
- `logoPath` (Text, nullable)
- `defaultServiceMode` (Text, default: `TABLE_SERVICE`) — `TABLE_SERVICE`, `QUICK_SERVICE`
- `updatedAt` (DateTime)

---

## 2. Organisation du Restaurant & Staff

### Users
- `id` (Text, UUID, PK)
- `name` (Text)
- `pinHash` (Text) — **Hash bcrypt du PIN** (jamais en clair)
- `role` (Text) — `ADMIN`, `CASHIER`, `WAITER`
- `isActive` (Boolean, default: true)
- `createdAt` (DateTime, nullable)
- `updatedAt` (DateTime, nullable)

### Zones
- `id` (Text, UUID, PK)
- `name` (Text)
- `sortOrder` (Integer, default: 0)

### RestaurantTables
- `id` (Text, UUID, PK)
- `zoneId` (Text, FK → Zones.id)
- `name` (Text) — ex: "T12"
- `capacity` (Integer)
- `status` (Text, default: `FREE`) — `FREE`, `OCCUPIED`, `RESERVED`
- `posX` (Real, nullable) — Position X plan de salle visuel
- `posY` (Real, nullable) — Position Y plan de salle visuel

### Reservations *(NOUVELLE)*
Réservations de tables (scénario #19).
- `id` (Text, UUID, PK)
- `tableId` (Text, FK → RestaurantTables.id)
- `customerName` (Text)
- `customerPhone` (Text, nullable)
- `guestCount` (Integer)
- `reservedAt` (DateTime)
- `notes` (Text, nullable)
- `status` (Text, default: `CONFIRMED`) — `CONFIRMED`, `SEATED`, `CANCELLED`, `NO_SHOW`
- `createdAt` (DateTime)

### TimeAttendance *(NOUVELLE)*
Pointage des employés (scénario #42).
- `id` (Text, UUID, PK)
- `userId` (Text, FK → Users.id)
- `clockIn` (DateTime)
- `clockOut` (DateTime, nullable)
- `notes` (Text, nullable)
- `createdAt` (DateTime)

---

## 3. Catalogue, Menus et Impression

### PrintStations
- `id` (Text, UUID, PK)
- `name` (Text)
- `ipAddress` (Text, nullable)
- `type` (Text, default: `THERMAL_PRINTER`) — `THERMAL_PRINTER`, `KDS_SCREEN`
- `isActive` (Boolean, default: true)

### Categories
- `id` (Text, UUID, PK)
- `name` (Text)
- `nameAr` (Text, nullable) — Nom en arabe
- `image` (Text, nullable)
- `printStationId` (Text, nullable, FK → PrintStations.id)
- `sortOrder` (Integer, default: 0)
- `scheduledStartTime` (Text, nullable) — ex: "18:00" pour Ftour Ramadan
- `scheduledEndTime` (Text, nullable) — ex: "21:00"
- `isActive` (Boolean, default: true)

### Products
- `id` (Text, UUID, PK)
- `categoryId` (Text, FK → Categories.id)
- `name` (Text)
- `nameAr` (Text, nullable) — Nom arabe ticket cuisine (scénario #23)
- `barcode` (Text, nullable) — Scan douchette (scénario #29)
- `priceDineIn` (Real) — Accepte 0
- `priceTakeaway` (Real, nullable) — Si null → priceDineIn
- `priceDelivery` (Real, nullable) — Prix Glovo/Deliveroo
- `cost` (Real, nullable) — Coût de revient
- `taxRate` (Real, default: 20.0) — Taux TVA en % (scénario #31)
- `image` (Text, nullable)
- `defaultNotes` (Text, nullable)
- `trackStock` (Boolean, default: false)
- `currentStock` (Real, default: 0)
- `sortOrder` (Integer, default: 0)
- `isActive` (Boolean, default: true)

### ModifierGroups
- `id` (Text, UUID, PK)
- `name` (Text) — ex: "Cuisson Viande"
- `nameAr` (Text, nullable)
- `isMultipleChoice` (Boolean)
- `isRequired` (Boolean)

### ModifierOptions *(NOUVELLE)*
Options individuelles d'un groupe (scénario #1).
- `id` (Text, UUID, PK)
- `modifierGroupId` (Text, FK → ModifierGroups.id)
- `name` (Text) — ex: "Saignant", "Supplément Bacon"
- `nameAr` (Text, nullable)
- `priceExtra` (Real, default: 0.0) — Surcoût (0 si inclus)
- `sortOrder` (Integer, default: 0)
- `isActive` (Boolean, default: true)

### ProductModifiers
Liaison Produit ↔ Groupes de modificateurs.
- `productId` (Text, FK → Products.id)
- `modifierGroupId` (Text, FK → ModifierGroups.id)

### Ingredients *(NOUVELLE)*
Matières premières pour le Food Cost (scénario #48).
- `id` (Text, UUID, PK)
- `name` (Text)
- `unit` (Text) — `KG`, `L`, `PIECE`, `G`, `ML`
- `costPerUnit` (Real)
- `currentStock` (Real, default: 0)
- `minimumStock` (Real, default: 0) — Seuil d'alerte
- `updatedAt` (DateTime)

### RecipeItems *(NOUVELLE)*
Fiche technique : 1 produit fini = N ingrédients (scénario #48).
- `id` (Text, UUID, PK)
- `productId` (Text, FK → Products.id)
- `ingredientId` (Text, FK → Ingredients.id)
- `quantityUsed` (Real) — ex: 150 pour 150g

---

## 4. Opérations, Commandes et Trésorerie

### CashSessions
- `id` (Text, UUID, PK)
- `cashierId` (Text, FK → Users.id)
- `openedAt` (DateTime)
- `closedAt` (DateTime, nullable)
- `openingBalance` (Real)
- `closingBalance` (Real, nullable)
- `expectedBalance` (Real, nullable) — Solde calculé par le système
- `closingNote` (Text, nullable) — Raison d'écart (scénario #36)
- `status` (Text, default: `OPEN`) — `OPEN`, `CLOSED`

### CashMovements *(NOUVELLE)*
Entrées/Sorties de caisse hors ventes (scénario #33).
- `id` (Text, UUID, PK)
- `sessionId` (Text, FK → CashSessions.id)
- `userId` (Text, FK → Users.id)
- `type` (Text) — `PAY_IN`, `PAY_OUT`
- `amount` (Real)
- `reason` (Text) — ex: "Achat pain urgence"
- `createdAt` (DateTime)

### Orders
- `id` (Text, UUID, PK)
- `sessionId` (Text, FK → CashSessions.id)
- `waiterId` (Text, FK → Users.id)
- `tableId` (Text, nullable, FK → RestaurantTables.id)
- `orderType` (Text) — `DINE_IN`, `TAKEAWAY`, `DELIVERY`
- `source` (Text, default: `MANUAL`) — `MANUAL`, `GLOVO`, `DELIVEROO`, `WEBSITE`
- `externalRef` (Text, nullable) — Numéro commande livreur #1455
- `status` (Text, default: `OPEN`) — `OPEN`, `SENT`, `PROFORMA`, `PAID`, `CANCELLED`, `VOID`, `LOSS`
- `discountType` (Text, nullable) — `PERCENTAGE`, `FIXED_AMOUNT`
- `discountValue` (Real, nullable)
- `discountReason` (Text, nullable)
- `discountAuthorizedBy` (Text, nullable, FK → Users.id)
- `guestCount` (Integer, default: 1)
- `createdAt` (DateTime)
- `updatedAt` (DateTime, nullable)

### OrderItems
- `id` (Text, UUID, PK)
- `orderId` (Text, FK → Orders.id)
- `productId` (Text, FK → Products.id)
- `quantity` (Real)
- `unitPrice` (Real) — **Prix figé au moment de la commande**
- `taxRate` (Real) — TVA figée au moment de la commande
- `customNotes` (Text, nullable)
- `courseNumber` (Integer, default: 1) — 1=Entrée, 2=Plat, 3=Dessert
- `isFired` (Boolean, default: false) — "Réclamé" envoyé en cuisine
- `status` (Text, default: `PENDING`) — `PENDING`, `PREPARING`, `SERVED`, `VOIDED`
- `voidReason` (Text, nullable)
- `voidAuthorizedBy` (Text, nullable, FK → Users.id)
- `createdAt` (DateTime)

### OrderItemModifiers *(NOUVELLE)*
Modificateurs sélectionnés par ligne de commande (scénario #1).
- `id` (Text, UUID, PK)
- `orderItemId` (Text, FK → OrderItems.id)
- `modifierOptionId` (Text, FK → ModifierOptions.id)
- `priceExtra` (Real) — Prix figé au moment de la commande

### Discounts *(NOUVELLE)*
Promotions et vouchers prédéfinis (scénario #38, #39).
- `id` (Text, UUID, PK)
- `name` (Text) — ex: "Bon Instagram 50 DH"
- `type` (Text) — `PERCENTAGE`, `FIXED_AMOUNT`, `EMPLOYEE_MEAL`
- `value` (Real)
- `code` (Text, nullable) — Code promo ou QR
- `maxUses` (Integer, nullable) — null = illimité
- `currentUses` (Integer, default: 0)
- `validFrom` (DateTime, nullable)
- `validUntil` (DateTime, nullable)
- `isActive` (Boolean, default: true)

### Payments
- `id` (Text, UUID, PK)
- `orderId` (Text, FK → Orders.id)
- `paymentMethod` (Text) — `CASH`, `CARD`, `TPE`, `CHEQUE`, `VOUCHER`, `EMPLOYEE_MEAL`
- `amount` (Real)
- `reference` (Text, nullable) — Référence TPE ou numéro de chèque
- `paidAt` (DateTime)

---

## 5. Synchronisation & Audit

### SyncQueue *(NOUVELLE)*
File d'attente de synchronisation Offline-First.
- `id` (Text, UUID, PK)
- `action` (Text) — `CREATE_ORDER`, `ADD_ITEMS`, `VOID_ITEM`, etc.
- `payload` (Text) — JSON sérialisé (Event Envelope)
- `status` (Text, default: `PENDING_SYNC`) — `PENDING_SYNC`, `SENT`, `ACKED`, `FAILED`
- `retryCount` (Integer, default: 0)
- `createdAt` (DateTime)
- `lastAttemptAt` (DateTime, nullable)

### AuditTrail *(NOUVELLE)*
Journal d'audit pour traçabilité (scénario #14, #33, #40).
- `id` (Text, UUID, PK)
- `userId` (Text, FK → Users.id)
- `action` (Text) — `VOID_ITEM`, `APPLY_DISCOUNT`, `REOPEN_TICKET`, `CASH_DRAWER_OPEN`, `PAY_OUT`, `PAY_IN`, `CLOSE_SESSION`, `RESET_PIN`, `PRICE_CHANGE`
- `targetType` (Text) — `ORDER`, `ORDER_ITEM`, `CASH_SESSION`, `PRODUCT`, `USER`
- `targetId` (Text) — UUID de l'entité concernée
- `details` (Text, nullable) — JSON (ancien prix, nouveau prix, raison...)
- `createdAt` (DateTime)

---

## 6. Modèles Agrégés (Classes Dart)

### OrderItemWithProduct
- `orderItem` (OrderItem)
- `product` (Product)
- `modifiers` (List\<OrderItemModifier>)

### CompleteOrder
- `order` (Order)
- `table` (RestaurantTable?, nullable si à emporter)
- `waiter` (User)
- `items` (List\<OrderItemWithProduct>)
- `payments` (List\<Payment>)
- **Getters :**
  - `subtotalAmount` = Σ (item.quantity × (item.unitPrice + Σ modifiers.priceExtra))
  - `discountAmount` = calcul selon discountType/discountValue
  - `totalAmount` = subtotalAmount − discountAmount
  - `totalPaid` = Σ (payment.amount)
  - `remainingToPay` = totalAmount − totalPaid
  - `changeToReturn` = max(0, totalPaid − totalAmount)

---

## 7. Règles de Calcul Critiques

> **#1 Immutabilité prix :** Calcul via `OrderItems.unitPrice`, jamais `Products.priceDineIn`.

> **#2 Immutabilité modificateurs :** `OrderItemModifiers.priceExtra` est figé à la commande.

> **#3 Immutabilité TVA :** `OrderItems.taxRate` copié de `Products.taxRate` à la commande.

> **#4 Routage impression :** Par catégorie → PrintStation (Bar vs Cuisine).

> **#5 Fallback prix :** `price = orderType == 'TAKEAWAY' ? (priceTakeaway ?? priceDineIn) : priceDineIn`

> **#6 Food Cost auto :** Quand OrderItem passe en `SERVED`, déduire les ingrédients via RecipeItems.

> **#7 Audit obligatoire :** Toute action sensible DOIT créer une entrée AuditTrail AVANT exécution.
