/// Grille d'espacement 8px — Fat-Finger / Ritagestion Design System.
abstract final class AppSpacing {
  static const double spacingXs = 4;
  static const double spacingS = 8;
  static const double spacingM = 16;
  static const double spacingL = 24;
  static const double spacingXl = 32;

  /// Alias courts pour usage interne du thème.
  static const double xs = spacingXs;
  static const double s = spacingS;
  static const double m = spacingM;
  static const double l = spacingL;
  static const double xl = spacingXl;

  /// Cible tactile minimale (Fat-Finger Rule).
  static const double minTouchTarget = 64;
}
