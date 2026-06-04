/// Arrondi monétaire MAD à 2 décimales (centimes).
double roundMoney(double value) => (value * 100).round() / 100;

/// Conversion DH → centimes entiers.
int toCents(double amount) => (roundMoney(amount) * 100).round();

/// Conversion centimes → DH.
double fromCents(int cents) => cents / 100;

/// Arrondi au dixième de dirham (plus petite pièce : 0,10 DH).
double roundToTenCentimes(double amount) =>
    fromCents((toCents(amount) / 10).round() * 10);
