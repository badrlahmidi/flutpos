import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

sealed class AnalyticsDashboardState extends Equatable {
  const AnalyticsDashboardState();

  @override
  List<Object?> get props => [];
}

final class AnalyticsDashboardInitial extends AnalyticsDashboardState {
  const AnalyticsDashboardInitial();
}

final class AnalyticsDashboardLoading extends AnalyticsDashboardState {
  const AnalyticsDashboardLoading();
}

final class AnalyticsDashboardReady extends AnalyticsDashboardState {
  const AnalyticsDashboardReady(this.snapshot);

  final DailyAnalyticsSnapshot snapshot;

  @override
  List<Object?> get props => [snapshot];
}

final class AnalyticsDashboardError extends AnalyticsDashboardState {
  const AnalyticsDashboardError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
