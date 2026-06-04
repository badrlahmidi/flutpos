# Design System & Règles UX (RitajPOS / Ritagestion)

## 1. Directives Absolues pour l'Agent IA (@Agent)
- **INTERDICTION** de coder des couleurs en dur (ex: `Colors.blue` ou `Color(0xFF...)`) dans les widgets.
- **INTERDICTION** d'utiliser des marges ou paddings aléatoires. Utilise uniquement les variables de la section "Espacements".
- **OBLIGATION** d'utiliser systématiquement `Theme.of(context).colorScheme` et `Theme.of(context).textTheme`.
- L'objectif métier est la VITESSE D'EXÉCUTION pour les serveurs et caissiers. L'interface doit être aérée, avec des zones de clic massives.

## 2. Couleurs (ThemeData ColorScheme)
Toute l'application Flutter doit être construite autour d'un `ColorScheme` unifié.

* **Primary (`primary`) :** Couleur principale de la marque (ex: Indigo profond ou Bleu Tech). Utilisée pour les actions positives (Validation de ticket, Payé).
* **Secondary (`secondary`) :** Couleur d'accentuation (ex: Ambre ou Orange). Utilisée pour attirer l'attention (ex: Table en attente depuis trop longtemps).
* **Surface (`surface`) :** Fond des cartes, des modals et des tuiles de produits (Blanc pur ou Gris très clair en mode clair).
* **Background (`background`) :** Fond principal de l'application (Gris cassé `grey[50]` pour faire ressortir les éléments en Surface).
* **Error (`error`) :** Rouge vif. Réservé UNIQUEMENT aux annulations (Void), ruptures de stock et suppressions.
* **OnSurface / OnPrimary :** Couleurs de contraste pour le texte (Texte sombre sur Surface, Texte blanc sur Primary).

## 3. Système d'Espacement (Grille de 8px)
Tous les `Padding`, `Margin` et `SizedBox` doivent être des multiples de 8.
* `spacingXs`: 4.0
* `spacingS`: 8.0 (Espacement entre une icône et son texte)
* `spacingM`: 16.0 (Padding standard intérieur d'une carte ou d'un bouton)
* `spacingL`: 24.0 (Espacement entre les grandes sections)
* `spacingXl`: 32.0 (Marge extérieure de l'écran)

## 4. Typographie (Google Fonts - Inter ou Roboto)
La lisibilité doit être parfaite, même de loin ou en plein soleil (terrasse).
* **HeadlineLarge :** Titres d'écran et montants totaux à payer (ex: **Bold 32sp**).
* **TitleMedium :** Noms des catégories et des produits sur la grille (ex: **SemiBold 16sp**).
* **BodyMedium :** Détails des articles dans le panier (ex: **Regular 14sp**).
* **LabelSmall :** Textes secondaires comme les notes, les badges de stock (ex: **Medium 11sp**).

## 5. Règles UX "Restauration" (Fat-Finger Rules)
1. **Touch Targets Massifs :** Tous les boutons (`ElevatedButton`, `InkWell`, `GestureDetector`) DOIVENT avoir une taille minimale de `64x64` pixels.
2. **Visibilité du Contraste :** Le bouton d'encaissement ("PAYER") doit être l'élément visuel le plus lourd de l'écran (Pleine largeur du panneau latéral, hauteur imposante, couleur `primary` ou couleur de succès dédiée).
3. **Zéro Scroll Horizontal :** Les catégories, sous-catégories et listes de produits doivent s'afficher en grilles réactives (`SliverGrid` ou `Wrap`) ou en listes verticales.
4. **Feedback Visuel Immédiat :** Chaque clic sur un produit doit générer un effet *Ripple* (splash) et un retour haptique si disponible sur l'appareil.
5. **Accessibilité des Actions Rapides :** Les actions de suppression dans le panier doivent se faire via un bouton poubelle explicite ou un Swipe-to-delete large, sans nécessiter de confirmation pour chaque ligne (sauf si la commande est déjà envoyée en cuisine).

## 6. Approche "Atomic Design" (Méthodologie de construction UI)
L'interface doit être construite brique par brique :
* **Étape 1 (Atomes) :** `PosButton` standardisé, `PriceTag`.
* **Étape 2 (Molécules) :** `ProductCard` (image + nom + PriceTag).
* **Étape 3 (Organismes) :** `ProductsGrid` (liste de ProductCard).
* **Étape 4 (Page) :** Assemblage de la grille + barre de menu latérale + panneau du panier.
