import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

/// Session utilisateur authentifié — partagée avec GoRouter.
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

  void clear() {
    _user = null;
    notifyListeners();
  }
}
