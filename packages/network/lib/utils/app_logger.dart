import 'package:logging/logging.dart';

/// Singleton configured logger for the network package (security fix [MOY-N04]).
///
/// Replaces every `print()` call in the WebSocket/mDNS layer with structured
/// log records. By default the minimum level is [Level.INFO]; call [init] with
/// [Level.WARNING] (or higher) in release builds to suppress informational
/// logs.
///
/// Sensitive data (PIN, tokens, amounts) must never be logged — use
/// [maskDeviceId] when a device identifier is required.
final class AppLogger {
  AppLogger._();

  static final AppLogger instance = AppLogger._();

  final Logger _root = Logger('PosNetwork');

  bool _initialized = false;

  /// Initializes the hierarchical logger (idempotent).
  void init({Level? level}) {
    if (_initialized) {
      return;
    }
    _initialized = true;

    final effectiveLevel = level ?? Level.INFO;

    hierarchicalLoggingEnabled = true;
    Logger.root.level = effectiveLevel;
    _root.level = effectiveLevel;

    Logger.root.onRecord.listen((record) {
      // In production this can be forwarded to Sentry or Crashalytics.
      // ignore: avoid_print
      print(
        '[${record.time.toIso8601String()}] '
        '${record.level.name} '
        '${record.loggerName}: ${record.message}',
      );
    });
  }

  void info(String message, {Object? error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _root.info(message, error, stackTrace);
  }

  void warning(String message, {Object? error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _root.warning(message, error, stackTrace);
  }

  void severe(String message, {Object? error, StackTrace? stackTrace}) {
    _ensureInitialized();
    _root.severe(message, error, stackTrace);
  }

  void _ensureInitialized() {
    if (!_initialized) {
      init();
    }
  }

  /// Masks a device id so it is safe to log in production.
  ///
  /// Example: `dev_1234abcd5678efgh` → `dev_****efgh`.
  static String maskDeviceId(String deviceId) {
    if (deviceId.length <= 8) {
      return '****';
    }
    final prefix = deviceId.substring(0, 4);
    final suffix = deviceId.substring(deviceId.length - 4);
    return '$prefix****$suffix';
  }
}