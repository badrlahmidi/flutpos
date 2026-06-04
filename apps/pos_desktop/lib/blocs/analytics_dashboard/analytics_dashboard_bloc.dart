import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'analytics_dashboard_event.dart';
import 'analytics_dashboard_state.dart';

class AnalyticsDashboardBloc
    extends Bloc<AnalyticsDashboardEvent, AnalyticsDashboardState> {
  AnalyticsDashboardBloc({required AnalyticsRepository analyticsRepository})
      : _analytics = analyticsRepository,
        super(const AnalyticsDashboardInitial()) {
    on<AnalyticsDashboardStarted>(_onStarted);
    on<AnalyticsDashboardRefreshRequested>(_onRefresh);
  }

  final AnalyticsRepository _analytics;

  Future<void> _onStarted(
    AnalyticsDashboardStarted event,
    Emitter<AnalyticsDashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefresh(
    AnalyticsDashboardRefreshRequested event,
    Emitter<AnalyticsDashboardState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<AnalyticsDashboardState> emit) async {
    emit(const AnalyticsDashboardLoading());
    try {
      final snapshot = await _analytics.loadDailyDashboard();
      emit(AnalyticsDashboardReady(snapshot));
    } catch (e) {
      emit(AnalyticsDashboardError('$e'));
    }
  }
}
