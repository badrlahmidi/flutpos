import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

abstract class ReportingEvent extends Equatable {
  const ReportingEvent();

  @override
  List<Object?> get props => [];
}

class ReportingStarted extends ReportingEvent {
  const ReportingStarted();
}

class ReportingFiltersChanged extends ReportingEvent {
  const ReportingFiltersChanged(this.filters);

  final ReportFilters filters;

  @override
  List<Object?> get props => [filters];
}

class ReportingTypeSelected extends ReportingEvent {
  const ReportingTypeSelected(this.reportType);

  final ReportType reportType;

  @override
  List<Object?> get props => [reportType];
}

class ReportingRunRequested extends ReportingEvent {
  const ReportingRunRequested({this.exportAfterLoad});

  /// Lance un export automatique une fois le rapport chargé.
  final ReportExportFormat? exportAfterLoad;

  @override
  List<Object?> get props => [exportAfterLoad];
}

class ReportingTabSelected extends ReportingEvent {
  const ReportingTabSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

class ReportingTabClosed extends ReportingEvent {
  const ReportingTabClosed(this.tabId);

  final String tabId;

  @override
  List<Object?> get props => [tabId];
}

class ReportingExportRequested extends ReportingEvent {
  const ReportingExportRequested({
    required this.tabId,
    required this.format,
  });

  final String tabId;
  final ReportExportFormat format;

  @override
  List<Object?> get props => [tabId, format];
}

class ReportingExportMessageAcknowledged extends ReportingEvent {
  const ReportingExportMessageAcknowledged();
}

enum ReportExportFormat { csv, pdf, print }
