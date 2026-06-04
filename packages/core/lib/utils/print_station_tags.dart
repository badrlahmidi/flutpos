import '../database/app_database.dart';

/// Helpers pour le routage impression / KDS.
abstract final class PrintStationTags {
  PrintStationTags._();

  static bool isBar(PrintStation station) {
    final name = station.name.toLowerCase();
    return name.contains('bar') || name.contains('boisson');
  }

  static bool isKdsScreen(PrintStation station) =>
      station.type == 'KDS_SCREEN';
}
