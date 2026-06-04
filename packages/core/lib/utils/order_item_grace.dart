import '../database/app_database.dart';

/// Annulation discrète (< 30 s, non envoyée en cuisine) — scénario #18.
abstract final class OrderItemGrace {
  OrderItemGrace._();

  static const Duration gracePeriod = Duration(seconds: 30);

  static bool isEligible(OrderItem item, {DateTime? now}) {
    if (item.isFired) {
      return false;
    }
    final instant = now ?? DateTime.now().toUtc();
    final age = instant.difference(item.createdAt);
    return !age.isNegative && age <= gracePeriod;
  }

  static int? remainingGraceSeconds(OrderItem item, {DateTime? now}) {
    if (!isEligible(item, now: now)) {
      return null;
    }
    final instant = now ?? DateTime.now().toUtc();
    final elapsed = instant.difference(item.createdAt).inSeconds;
    return (gracePeriod.inSeconds - elapsed).clamp(0, gracePeriod.inSeconds);
  }
}
