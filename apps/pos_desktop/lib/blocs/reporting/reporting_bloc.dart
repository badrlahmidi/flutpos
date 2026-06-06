import 'package:core/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/report_export_service.dart';
import 'reporting_event.dart';
import 'reporting_state.dart';

class ReportingBloc extends Bloc<ReportingEvent, ReportingState> {
  ReportingBloc({
    required this.analyticsRepository,
    required this.exportService,
  }) : super(const ReportingInitial()) {
    on<ReportingStarted>(_onStarted);
    on<ReportingFiltersChanged>(_onFiltersChanged);
    on<ReportingTypeSelected>(_onTypeSelected);
    on<ReportingRunRequested>(_onRunRequested);
    on<ReportingTabSelected>(_onTabSelected);
    on<ReportingTabClosed>(_onTabClosed);
    on<ReportingExportRequested>(_onExportRequested);
    on<ReportingExportMessageAcknowledged>(_onExportMessageAcknowledged);
  }

  final AnalyticsRepository analyticsRepository;
  final ReportExportService exportService;

  int _tabCounter = 0;

  ReportFilters _defaultFilters() {
    return ReportFilters(
      startDate: DateTime.now().copyWith(
        hour: 0,
        minute: 0,
        second: 0,
        millisecond: 0,
      ),
      endDate: DateTime.now(),
    );
  }

  Future<void> _onStarted(
    ReportingStarted event,
    Emitter<ReportingState> emit,
  ) async {
    final filters = _defaultFilters();
    emit(
      ReportingShellState(
        filters: filters,
        selectedType: ReportType.productSales,
        openTabs: const [],
        activeTabIndex: 0,
        isLoadingOptions: true,
      ),
    );

    try {
      final options = await analyticsRepository.loadReportingFilterOptions(
        sessionPeriodStart: filters.startDate,
        sessionPeriodEnd: filters.endDate,
      );
      final current = state;
      if (current is ReportingShellState) {
        emit(current.copyWith(
          filterOptions: options,
          isLoadingOptions: false,
        ));
      }
    } catch (e) {
      final current = state;
      if (current is ReportingShellState) {
        emit(current.copyWith(isLoadingOptions: false));
      }
    }
  }

  Future<void> _reloadFilterOptions(Emitter<ReportingState> emit) async {
    final current = state;
    if (current is! ReportingShellState) return;

    try {
      final options = await analyticsRepository.loadReportingFilterOptions(
        sessionPeriodStart: current.filters.startDate,
        sessionPeriodEnd: current.filters.endDate,
      );
      emit(current.copyWith(filterOptions: options));
    } catch (_) {
      // Conserve les options précédentes.
    }
  }

  Future<void> _onFiltersChanged(
    ReportingFiltersChanged event,
    Emitter<ReportingState> emit,
  ) async {
    final current = state;
    if (current is! ReportingShellState) return;

    emit(current.copyWith(filters: event.filters));
    await _reloadFilterOptions(emit);
  }

  void _onTypeSelected(
    ReportingTypeSelected event,
    Emitter<ReportingState> emit,
  ) {
    final current = state;
    if (current is! ReportingShellState) return;
    emit(current.copyWith(selectedType: event.reportType));
  }

  void _onTabSelected(
    ReportingTabSelected event,
    Emitter<ReportingState> emit,
  ) {
    final current = state;
    if (current is! ReportingShellState) return;
    if (event.index < 0 || event.index >= current.tabCount) return;
    emit(current.copyWith(activeTabIndex: event.index));
  }

  void _onTabClosed(
    ReportingTabClosed event,
    Emitter<ReportingState> emit,
  ) {
    final current = state;
    if (current is! ReportingShellState) return;

    final tabIndex =
        current.openTabs.indexWhere((tab) => tab.id == event.tabId);
    if (tabIndex < 0) return;

    final newTabs = List<OpenReportTab>.from(current.openTabs)
      ..removeAt(tabIndex);

    var newActive = current.activeTabIndex;
    final closedUiIndex = tabIndex + 1;
    if (newActive == closedUiIndex) {
      newActive = 0;
    } else if (newActive > closedUiIndex) {
      newActive -= 1;
    }

    emit(current.copyWith(
      openTabs: newTabs,
      activeTabIndex: newActive,
    ));
  }

  Future<void> _onRunRequested(
    ReportingRunRequested event,
    Emitter<ReportingState> emit,
  ) async {
    final current = state;
    if (current is! ReportingShellState) return;

    final tabId = 'tab-${++_tabCounter}';
    final loadingTab = OpenReportTab(
      id: tabId,
      type: current.selectedType,
      title: current.selectedType.label,
      isLoading: true,
    );

    final newTabs = [...current.openTabs, loadingTab];
    emit(current.copyWith(
      openTabs: newTabs,
      activeTabIndex: newTabs.length,
      clearExportMessage: true,
    ));

    try {
      final loadedTab = await _loadTab(
        tabId: tabId,
        type: current.selectedType,
        filters: current.filters,
      );
      final updated = state;
      if (updated is! ReportingShellState) return;

      final tabs = updated.openTabs
          .map((t) => t.id == tabId ? loadedTab : t)
          .toList();
      emit(updated.copyWith(openTabs: tabs));

      if (event.exportAfterLoad != null) {
        await _exportTab(tabId, event.exportAfterLoad!, emit);
      }
    } catch (e) {
      final updated = state;
      if (updated is! ReportingShellState) return;

      final tabs = updated.openTabs
          .map(
            (t) => t.id == tabId
                ? t.copyWith(
                    isLoading: false,
                    errorMessage: '$e',
                  )
                : t,
          )
          .toList();
      emit(updated.copyWith(openTabs: tabs));
    }
  }

  Future<OpenReportTab> _loadTab({
    required String tabId,
    required ReportType type,
    required ReportFilters filters,
  }) async {
    switch (type) {
      case ReportType.productSales:
        final result =
            await analyticsRepository.getProductSalesReport(filters);
        return OpenReportTab(
          id: tabId,
          type: type,
          title: type.label,
          header: result.header,
          rows: result.lines,
        );

      case ReportType.categorySales:
        final result =
            await analyticsRepository.getCategorySalesReport(filters);
        return OpenReportTab(
          id: tabId,
          type: type,
          title: type.label,
          header: result.header,
          rows: result.lines,
        );

      case ReportType.paymentMethods:
        final result =
            await analyticsRepository.getPaymentMethodReport(filters);
        return OpenReportTab(
          id: tabId,
          type: type,
          title: type.label,
          header: result.header,
          rows: result.lines,
        );

      case ReportType.userSales:
        final result = await analyticsRepository.getUserSalesReport(filters);
        return OpenReportTab(
          id: tabId,
          type: type,
          title: type.label,
          header: result.header,
          rows: result.lines,
        );

      case ReportType.dashboard:
        final day = DateTime(
          filters.endDate.year,
          filters.endDate.month,
          filters.endDate.day,
        );
        final snapshot = await analyticsRepository.loadDailyDashboard(day: day);
        return OpenReportTab(
          id: tabId,
          type: type,
          title: type.label,
          dashboardSnapshot: snapshot,
        );
    }
  }

  Future<void> _exportTab(
    String tabId,
    ReportExportFormat format,
    Emitter<ReportingState> emit,
  ) async {
    final current = state;
    if (current is! ReportingShellState) return;

    final tab = current.openTabs.cast<OpenReportTab?>().firstWhere(
          (t) => t?.id == tabId,
          orElse: () => null,
        );
    if (tab == null || !tab.isReady) return;

    try {
      switch (format) {
        case ReportExportFormat.csv:
          final path = await exportService.exportCsv(tab);
          emit(current.copyWith(
            exportMessage: 'Export CSV enregistré : $path',
            exportIsError: false,
          ));
        case ReportExportFormat.pdf:
          final path = await exportService.exportPdfToDesktop(tab);
          emit(current.copyWith(
            exportMessage: 'Export PDF enregistré : $path',
            exportIsError: false,
          ));
        case ReportExportFormat.print:
          await exportService.printReport(tab);
          emit(current.copyWith(
            exportMessage: 'Impression lancée',
            exportIsError: false,
          ));
      }
    } catch (e) {
      emit(current.copyWith(
        exportMessage: 'Erreur export : $e',
        exportIsError: true,
      ));
    }
  }

  Future<void> _onExportRequested(
    ReportingExportRequested event,
    Emitter<ReportingState> emit,
  ) async {
    await _exportTab(event.tabId, event.format, emit);
  }

  void _onExportMessageAcknowledged(
    ReportingExportMessageAcknowledged event,
    Emitter<ReportingState> emit,
  ) {
    final current = state;
    if (current is ReportingShellState) {
      emit(current.copyWith(clearExportMessage: true));
    }
  }
}
