import 'connection_state.dart';

/// Notifier d'état de connexion — API compatible [ValueNotifier] sans dépendance Flutter.
///
/// Permet d'exécuter `dart test` sur le package [network] tout en restant
/// consommable par l'UI via `addListener`.
class ConnectionStateNotifier {
  ConnectionStateNotifier([ConnectionState initial = ConnectionState.disconnected])
      : _value = initial;

  ConnectionState _value;

  /// État courant de la connexion réseau.
  ConnectionState get value => _value;

  set value(ConnectionState newValue) {
    if (_value == newValue) {
      return;
    }
    _value = newValue;
    _notifyListeners();
  }

  final List<void Function()> _listeners = [];

  /// Enregistre un écouteur appelé à chaque changement d'état.
  void addListener(void Function() listener) {
    _listeners.add(listener);
  }

  /// Retire un écouteur précédemment enregistré.
  void removeListener(void Function() listener) {
    _listeners.remove(listener);
  }

  /// Libère les écouteurs.
  void dispose() {
    _listeners.clear();
  }

  void _notifyListeners() {
    for (final listener in List<void Function()>.from(_listeners)) {
      listener();
    }
  }
}
