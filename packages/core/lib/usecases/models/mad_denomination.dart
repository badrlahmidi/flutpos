/// Billet ou pièce MAD (valeur en DH).
class MadDenomination {
  const MadDenomination({
    required this.valueDh,
    required this.label,
    required this.isCoin,
  });

  final double valueDh;
  final String label;
  final bool isCoin;

  int get valueCents => (valueDh * 100).round();
}

/// Coupures courantes au Maroc (ordre décroissant pour l'algorithme glouton).
abstract final class MadDenominations {
  MadDenominations._();

  static const List<MadDenomination> all = [
    MadDenomination(valueDh: 200, label: '200 DH', isCoin: false),
    MadDenomination(valueDh: 100, label: '100 DH', isCoin: false),
    MadDenomination(valueDh: 50, label: '50 DH', isCoin: false),
    MadDenomination(valueDh: 20, label: '20 DH', isCoin: false),
    MadDenomination(valueDh: 10, label: '10 DH', isCoin: true),
    MadDenomination(valueDh: 5, label: '5 DH', isCoin: true),
    MadDenomination(valueDh: 2, label: '2 DH', isCoin: true),
    MadDenomination(valueDh: 1, label: '1 DH', isCoin: true),
    MadDenomination(valueDh: 0.5, label: '0,50 DH', isCoin: true),
    MadDenomination(valueDh: 0.2, label: '0,20 DH', isCoin: true),
    MadDenomination(valueDh: 0.1, label: '0,10 DH', isCoin: true),
  ];
}

/// Détail d'une coupure dans la monnaie à rendre.
class MadBreakdownEntry {
  const MadBreakdownEntry({
    required this.denomination,
    required this.count,
  });

  final MadDenomination denomination;
  final int count;

  double get subtotal => denomination.valueDh * count;
}
