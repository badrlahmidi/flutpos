/// Libellés et constantes pour les courses (entrée / plat / dessert).
abstract final class CourseHelpers {
  CourseHelpers._();

  static const int minCourse = 1;
  static const int maxCourse = 3;

  static String badgeLabel(int courseNumber) => 'C$courseNumber';

  static String emojiForCourse(int courseNumber) {
    return switch (courseNumber) {
      1 => '🥗',
      2 => '🥩',
      3 => '🍰',
      _ => '🍽️',
    };
  }

  static String labelForCourse(int courseNumber) {
    return switch (courseNumber) {
      1 => 'Entrée',
      2 => 'Plat',
      3 => 'Dessert',
      _ => 'Course $courseNumber',
    };
  }
}
