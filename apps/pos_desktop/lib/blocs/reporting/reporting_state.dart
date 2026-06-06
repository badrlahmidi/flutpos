import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class ReportingState extends Equatable {
  const ReportingState();

  @override
  List<Object?> get props => [];
}

class ReportingInitial extends ReportingState {
  const ReportingInitial();
}

/// Onglet de rapport ouvert (style Aronium).
class OpenReportTab extends Equatable {
  const OpenReportTab({
    required this.id,
    required this.type,
    required this.title,
    this.isLoading = false,
    this.errorMessage,
    this.header,
    this.rows = const [],
    this.dashboardSnapshot,
  });

  final String id;
  final ReportType type;
  final String title;
  final bool isLoading;
  final String? errorMessage;
  final ReportHeader? header;
  final List<dynamic> rows;
  final DailyAnalyticsSnapshot? dashboardSnapshot;

  bool get isReady => !isLoading && errorMessage == null;

  OpenReportTab copyWith({
    bool? isLoading,
    String? errorMessage,
    ReportHeader? header,
    List<dynamic>? rows,
    DailyAnalyticsSnapshot? dashboardSnapshot,
    bool clearError = false,
  }) {
    return OpenReportTab(
      id: id,
      type: type,
      title: title,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      header: header ?? this.header,
      rows: rows ?? this.rows,
      dashboardSnapshot: dashboardSnapshot ?? this.dashboardSnapshot,
    );
  }

  @override
  List<Object?> get props => [
        id,
        type,
        title,
        isLoading,
        errorMessage,
        header,
        rows,
        dashboardSnapshot,
      ];
}

class ReportingShellState extends ReportingState {
  const ReportingShellState({
    required this.filters,
    required this.selectedType,
    required this.openTabs,
    required this.activeTabIndex,
    this.filterOptions,
    this.isLoadingOptions = false,
    this.exportMessage,
    this.exportIsError = false,
  });

  final ReportFilters filters;
  final ReportType selectedType;
  final List<OpenReportTab> openTabs;
  final int activeTabIndex;
  final ReportingFilterOptions? filterOptions;
  final bool isLoadingOptions;
  final String? exportMessage;
  final bool exportIsError;

  int get tabCount => 1 + openTabs.length;

  ReportingShellState copyWith({
    ReportFilters? filters,
    ReportType? selectedType,
    List<OpenReportTab>? openTabs,
    int? activeTabIndex,
    ReportingFilterOptions? filterOptions,
    bool? isLoadingOptions,
    String? exportMessage,
    bool? exportIsError,
    bool clearExportMessage = false,
  }) {
    return ReportingShellState(
      filters: filters ?? this.filters,
      selectedType: selectedType ?? this.selectedType,
      openTabs: openTabs ?? this.openTabs,
      activeTabIndex: activeTabIndex ?? this.activeTabIndex,
      filterOptions: filterOptions ?? this.filterOptions,
      isLoadingOptions: isLoadingOptions ?? this.isLoadingOptions,
      exportMessage:
          clearExportMessage ? null : (exportMessage ?? this.exportMessage),
      exportIsError: exportIsError ?? this.exportIsError,
    );
  }

  @override
  List<Object?> get props => [
        filters,
        selectedType,
        openTabs,
        activeTabIndex,
        filterOptions,
        isLoadingOptions,
        exportMessage,
        exportIsError,
      ];
}
