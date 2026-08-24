import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Session utilisateur authentifié — partagée avec GoRouter.
///
/// Security fix [MOY-F03] — invalidation explicite au démarrage (cold start),
/// distinction `invalidate()` (boot) / `clear()` (logout).
class AppSession extends ChangeNotifier {
  AppSession._();

  static final AppSession instance = AppSession._();

  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  void setUser(User user) {
    _user = user;
    notifyListeners();
  }

  /// Déconnexion manuelle (logout) ou timeout explicite.
  void clear() {
    _user = null;
    notifyListeners();
  }

  /// Invalidation explicite — appelée au démarrage de l'app (cold start) pour
  /// s'assurer qu'une session présumée ouverte (suite à un crash ou restore)
  /// n'est jamais considérée valide (security fix [MOY-F03]).
  ///
  /// Ne pas confondre avec [clear] (logout utilisateur) : `invalidate()` est
  /// automatique et silencieux.
  void invalidate() {
    if (_user != null) {
      _user = null;
      notifyListeners();
    }
  }
}