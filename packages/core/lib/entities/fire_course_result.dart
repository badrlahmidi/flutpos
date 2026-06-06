import '../database/app_database.dart';

/// Résultat d'un envoi de course en cuisine (`fireCourse`).
class FireCourseResult {
  const FireCourseResult({
    required this.orderId,
    required this.courseNumber,
    required this.firedItems,
  });

  final String orderId;
  final int courseNumber;
  final List<OrderItem> firedItems;

  bool get isEmpty => firedItems.isEmpty;
}
