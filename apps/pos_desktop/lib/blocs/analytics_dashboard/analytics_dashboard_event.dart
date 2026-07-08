import 'package:equatable/equatable.dart';

sealed class AnalyticsDashboardEvent extends Equatable {
  const AnalyticsDashboardEvent();

  @override
  List<Object?> get props => [];
}

final class AnalyticsDashboardStarted extends AnalyticsDashboardEvent {
  const AnalyticsDashboardStarted();
}

final class AnalyticsDashboardRefreshRequested extends AnalyticsDashboardEvent {
  const AnalyticsDashboardRefreshRequested();
}

/// Changement de la date sélectionnée pour le dashboard journalier.
final class AnalyticsDashboardDateChanged extends AnalyticsDashboardEvent {
  const AnalyticsDashboardDateChanged(this.date);

  final DateTime date;

  @override
  List<Object?> get props => [date];
}

/// Changement de la plage de dates pour le dashboard multi-jours.
final class AnalyticsDashboardRangeChanged extends AnalyticsDashboardEvent {
  const AnalyticsDashboardRangeChanged({
    required this.start,
    required this.end,
  });

  final DateTime start;
  final DateTime end;

  @override
  List<Object?> get props => [start, end];
}
