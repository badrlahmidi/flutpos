/// Token-bucket rate limiter for WebSocket messages (security fix [MOY-N05]).
///
/// Limits each device to a configurable burst and refill rate to prevent
/// message-flooding / denial-of-service. Heartbeat messages ([WsAction.ping],
/// [WsAction.pong]) are exempt.
class WsRateLimiter {
  WsRateLimiter({
    this.capacity = 30,
    this.refillPerSecond = 3,
    this.burstMax = 50,
    this.disconnectThreshold = 3,
    this.window = const Duration(seconds: 10),
  });

  /// Token bucket capacity per device (messages allowed in [window]).
  final int capacity;

  /// Tokens refilled per second.
  final int refillPerSecond;

  /// Instantaneous burst ceiling.
  final int burstMax;

  /// Violation count after which a device should be disconnected.
  final int disconnectThreshold;

  /// Sliding window duration.
  final Duration window;

  final Map<String, _Bucket> _buckets = {};

  /// Tracks how many rate-limit violations each device has accumulated.
  final Map<String, int> _violations = {};

  /// Returns `true` if the message is allowed, `false` if rate-limited.
  bool tryConsume(String deviceId, {String? action}) {
    // Heartbeat / ACK messages are exempt from throttling.
    if (action == 'PING' || action == 'PONG' || action == 'ACK') {
      return true;
    }

    final now = DateTime.now();
    final bucket = _buckets.putIfAbsent(deviceId, () => _Bucket(now));

    // Refill tokens based on elapsed time.
    final elapsedSeconds = now.difference(bucket.lastRefill).inMicroseconds /
        Duration.microsecondsPerSecond;
    final refilled =
        (elapsedSeconds * refillPerSecond).floor().clamp(0, burstMax);
    if (refilled > 0) {
      bucket.tokens = (bucket.tokens + refilled).clamp(0, burstMax);
      bucket.lastRefill = now;
    }

    if (bucket.tokens <= 0) {
      _violations[deviceId] = (_violations[deviceId] ?? 0) + 1;
      return false;
    }

    bucket.tokens -= 1;
    return true;
  }

  /// Returns the number of consecutive violations for [deviceId].
  int violationsFor(String deviceId) => _violations[deviceId] ?? 0;

  /// Whether [deviceId] has exceeded the disconnect threshold.
  bool shouldDisconnect(String deviceId) =>
      violationsFor(deviceId) >= disconnectThreshold;

  /// Resets violations counter (e.g. after a successful grace period).
  void resetViolations(String deviceId) => _violations.remove(deviceId);

  /// Removes the bucket and violations for a disconnected device.
  void removeDevice(String deviceId) {
    _buckets.remove(deviceId);
    _violations.remove(deviceId);
  }

  /// Clears all state (server shutdown).
  void clear() {
    _buckets.clear();
    _violations.clear();
  }
}

class _Bucket {
  _Bucket(DateTime now)
      : tokens = 30,
        lastRefill = now;

  int tokens;
  DateTime lastRefill;
}