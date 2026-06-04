# Internationalisation & Localisation (i18n / l10n)

## 1. Langues Supportées

| Langue | Code | Usage |
|---|---|---|
| Français | `fr` | Langue principale UI (serveurs, caissiers, back-office) |
| Arabe (Darija/Standard) | `ar` | Tickets cuisine, noms produits alternatifs |
| Anglais | `en` | Fallback technique, messages d'erreur système |

---

## 2. Implémentation Flutter

### Packages
```yaml
dependencies:
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
```

### Configuration MaterialApp
```dart
MaterialApp(
  locale: const Locale('fr'),
  supportedLocales: const [
    Locale('fr'),
    Locale('ar'),
    Locale('en'),
  ],
  localizationsDelegates: [
    AppLocalizations.delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
)
```

### Structure des fichiers ARB
```
lib/l10n/
├── app_fr.arb    # Français (principal)
├── app_ar.arb    # Arabe
└── app_en.arb    # Anglais (fallback)
```

---

## 3. Devise — Dirham Marocain (MAD)

### Formatage
```dart
import 'package:intl/intl.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'fr_MA',
  symbol: 'DH',
  decimalDigits: 2,
);

// Utilisation : currencyFormatter.format(320.50) → "320,50 DH"
```

### Règles
- Le symbole **DH** s'affiche APRÈS le montant (convention marocaine)
- Toujours 2 décimales pour les prix
- Séparateur décimal : virgule `,` (convention française)
- Séparateur milliers : espace ` ` (ex: 1 250,00 DH)

### Calculateur de Monnaie
Billets et pièces courants au Maroc :
- **Billets :** 200, 100, 50, 20 DH
- **Pièces :** 10, 5, 2, 1, 0.50, 0.20, 0.10 DH
- Afficher la décomposition optimale (ex: 47 DH = 2×20 + 1×5 + 1×2)

---

## 4. Double Nommage Produits (FR/AR)

### Base de données
- `Products.name` → Nom français (affiché sur l'UI serveur/caissier)
- `Products.nameAr` → Nom arabe (imprimé sur le ticket cuisine)
- Même logique pour `Categories.nameAr` et `ModifierOptions.nameAr`

### Ticket Cuisine
```
Si le produit a un nameAr :
  → Imprimer : "nameAr" (en gros) + "name" (en petit dessous)
Sinon :
  → Imprimer uniquement "name" en gros
```

### Saisie arabe
- Le clavier de notes libres (scénario #25) doit proposer un toggle FR/AR
- Pas de traduction automatique : le serveur tape en Darija ce qu'il veut
- Direction du texte : RTL uniquement pour les champs arabes, pas pour toute l'app

---

## 5. Dates et Heures

- Format date : `dd/MM/yyyy` (convention marocaine/française)
- Format heure : `HH:mm` (24h, pas AM/PM)
- Fuseau horaire : `Africa/Casablanca` (GMT+1, pas de changement d'heure depuis 2018)
- Ramadan : les horaires Ftour changent chaque jour → utiliser un calcul astronomique ou un fichier de config

---

## 6. Tickets de Caisse — Contenu Légal (Maroc)

Un ticket de caisse marocain doit contenir :
1. Nom et adresse du restaurant
2. **ICE** (Identifiant Commun de l'Entreprise) — Obligatoire sur factures
3. Date et heure de la transaction
4. Détail des articles avec prix unitaire et quantité
5. Montant total TTC
6. Mode de paiement
7. Numéro séquentiel du ticket

Pour une **facture** (demandée par un client entreprise), ajouter :
- Nom et ICE du client
- Numéro de facture séquentiel
- Détail TVA par taux (20%, 10%, 7% selon les produits)
