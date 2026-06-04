import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

import '../di/service_locator.dart';

/// Mode de prise de commande (table vs comptoir) — persistant en BDD.
class PosServiceMode extends ChangeNotifier {
  PosServiceMode._();

  static final PosServiceMode instance = PosServiceMode._();

  ServiceMode _mode = ServiceMode.tableService;
  bool _loaded = false;

  ServiceMode get mode => _mode;
  bool get isQuickService => _mode == ServiceMode.quickService;
  bool get isTableService => _mode == ServiceMode.tableService;
  bool get isLoaded => _loaded;

  Future<void> loadFromDatabase() async {
    final config = await sl<PrintRepository>().getRestaurantConfig();
    _mode = ServiceMode.fromDb(config?.defaultServiceMode ?? 'TABLE_SERVICE');
    _loaded = true;
    notifyListeners();
  }

  Future<void> setMode(ServiceMode mode) async {
    if (_mode == mode) {
      return;
    }
    _mode = mode;
    notifyListeners();
    await sl<PrintRepository>().updateDefaultServiceMode(mode.dbValue);
  }

  Future<void> toggle() => setMode(_mode.toggled);
}
