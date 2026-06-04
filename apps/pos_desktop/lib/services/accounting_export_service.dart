import 'dart:io';

import 'package:core/core.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;

/// Sauvegarde l'export comptable CSV sur le bureau Windows.
class AccountingExportService {
  AccountingExportService({
    required AccountingExportRepository repository,
  }) : _repository = repository;

  final AccountingExportRepository _repository;

  static final DateFormat _fileMonth = DateFormat('yyyy-MM', 'fr_FR');

  /// Génère et écrit le fichier CSV ; retourne le chemin absolu.
  Future<String> exportMonthlyToDesktop(DateTime month) async {
    final report = await _repository.loadMonthlyReport(month);
    final csv = AccountingCsvBuilder.build(report);
    final desktop = _resolveDesktopDirectory();
    final filename =
        'ritagestion_export_${_fileMonth.format(month)}.csv';
    final file = File(p.join(desktop.path, filename));
    await file.writeAsString('\uFEFF$csv');
    return file.path;
  }

  Directory _resolveDesktopDirectory() {
    final userProfile = Platform.environment['USERPROFILE'] ??
        Platform.environment['HOME'];
    if (userProfile != null) {
      final desktop = Directory(p.join(userProfile, 'Desktop'));
      if (desktop.existsSync()) {
        return desktop;
      }
      final bureau = Directory(p.join(userProfile, 'Bureau'));
      if (bureau.existsSync()) {
        return bureau;
      }
    }
    return Directory.current;
  }
}
