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
