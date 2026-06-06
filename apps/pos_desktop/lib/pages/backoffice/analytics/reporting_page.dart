import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../blocs/reporting/reporting_bloc.dart';
import '../../../blocs/reporting/reporting_event.dart';
import '../../../blocs/reporting/reporting_state.dart';
import '../../../di/service_locator.dart';
import '../../../services/report_export_service.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../widgets/backoffice/backoffice_page_header.dart';
import '../../../widgets/reporting/period_picker_dialog.dart';
import '../../../widgets/reporting/report_print_preview.dart';

/// Page de Reporting multi-onglets style Aronium.
class ReportingPage extends StatelessWidget {
  const ReportingPage({super.key, this.embeddedInShell = false});

  final bool embeddedInShell;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReportingBloc(
        analyticsRepository: sl<AnalyticsRepository>(),
        exportService: sl<ReportExportService>(),
      )..add(const ReportingStarted()),
      child: _ReportingView(embeddedInShell: embeddedInShell),
    );
  }
}

class _ReportingView extends StatefulWidget {
  const _ReportingView({required this.embeddedInShell});

  final bool embeddedInShell;

  @override
  State<_ReportingView> createState() => _ReportingViewState();
}

class _ReportingViewState extends State<_ReportingView>
    with TickerProviderStateMixin {
  TabController? _tabController;
  int _lastActiveIndex = 0;

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  void _syncTabController(ReportingShellState shell) {
    if (_tabController == null || _tabController!.length != shell.tabCount) {
      _tabController?.dispose();
      _tabController = TabController(
        length: shell.tabCount,
        vsync: this,
        initialIndex: shell.activeTabIndex.clamp(0, shell.tabCount - 1),
      );
      _tabController!.addListener(() {
        if (_tabController!.indexIsChanging) return;
        context.read<ReportingBloc>().add(
              ReportingTabSelected(_tabController!.index),
            );
      });
      _lastActiveIndex = shell.activeTabIndex;
    } else if (shell.activeTabIndex != _lastActiveIndex &&
        _tabController!.index != shell.activeTabIndex) {
      _tabController!.animateTo(shell.activeTabIndex);
    }
    _lastActiveIndex = shell.activeTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReportingBloc, ReportingState>(
      listenWhen: (prev, curr) {
        if (curr is ReportingShellState) {
          return curr.exportMessage != null;
        }
        return false;
      },
      listener: (context, state) {
        if (state is ReportingShellState && state.exportMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.exportMessage!),
              backgroundColor:
                  state.exportIsError ? Theme.of(context).colorScheme.error : null,
            ),
          );
          context.read<ReportingBloc>().add(const ReportingExportMessageAcknowledged());
        }
      },
      builder: (context, state) {
        if (state is! ReportingShellState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        _syncTabController(state);
        final scheme = Theme.of(context).colorScheme;
        final controller = _tabController!;

        return Scaffold(
          backgroundColor: AppColors.scaffoldDark,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.embeddedInShell)
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.l,
                    AppSpacing.l,
                    AppSpacing.l,
                    0,
                  ),
                  child: const BackofficePageHeader(
                    title: 'Statistiques & Rapports',
                    subtitle: 'Analyses de performance',
                  ),
                ),
              Material(
                color: scheme.surface,
                child: TabBar(
                  controller: controller,
                  isScrollable: true,
                  tabAlignment: TabAlignment.start,
                  labelColor: scheme.primary,
                  unselectedLabelColor: scheme.onSurfaceVariant,
                  indicatorColor: scheme.primary,
                  tabs: [
                    const Tab(
                      icon: Icon(Icons.list_alt_outlined, size: 18),
                      text: 'Sélectionner',
                    ),
                    ...state.openTabs.map(
                      (tab) => Tab(
                        child: _ReportTabLabel(
                          title: tab.title,
                          isLoading: tab.isLoading,
                          onClose: () => context.read<ReportingBloc>().add(
                                ReportingTabClosed(tab.id),
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              Expanded(
                child: TabBarView(
                  controller: controller,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _SelectorTab(shell: state),
                    ...state.openTabs.map(
                      (tab) => ReportPrintPreview(
                        tab: tab,
                        onPrint: tab.isReady && tab.type != ReportType.dashboard
                            ? () => _export(context, tab.id, ReportExportFormat.print)
                            : tab.isReady && tab.type == ReportType.dashboard
                                ? () => _export(context, tab.id, ReportExportFormat.print)
                                : null,
                        onExportCsv: tab.isReady && tab.type != ReportType.dashboard
                            ? () => _export(context, tab.id, ReportExportFormat.csv)
                            : null,
                        onExportPdf: tab.isReady
                            ? () => _export(context, tab.id, ReportExportFormat.pdf)
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _export(BuildContext context, String tabId, ReportExportFormat format) {
    context.read<ReportingBloc>().add(
          ReportingExportRequested(tabId: tabId, format: format),
        );
  }
}

class _ReportTabLabel extends StatelessWidget {
  const _ReportTabLabel({
    required this.title,
    required this.isLoading,
    required this.onClose,
  });

  final String title;
  final bool isLoading;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isLoading)
          const Padding(
            padding: EdgeInsets.only(right: 6),
            child: SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
        Text(title),
        const SizedBox(width: 4),
        InkWell(
          onTap: onClose,
          borderRadius: BorderRadius.circular(12),
          child: const Padding(
            padding: EdgeInsets.all(2),
            child: Icon(Icons.close, size: 16),
          ),
        ),
      ],
    );
  }
}

class _SelectorTab extends StatelessWidget {
  const _SelectorTab({required this.shell});

  final ReportingShellState shell;

  static final _periodFmt = DateFormat('d MMM yyyy', 'fr_FR');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final bloc = context.read<ReportingBloc>();
    final filters = shell.filters;
    final options = shell.filterOptions;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          width: 280,
          child: ColoredBox(
            color: scheme.surfaceContainerHighest,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
                  child: Text(
                    'TYPES DE RAPPORTS',
                    style: theme.textTheme.labelSmall?.copyWith(
                      letterSpacing: 1.2,
                      fontWeight: FontWeight.w600,
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    children: ReportType.values.map((type) {
                      return _ReportTypeItem(
                        type: type,
                        isSelected: type == shell.selectedType,
                        onTap: () =>
                            bloc.add(ReportingTypeSelected(type)),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const VerticalDivider(width: 1),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  shell.selectedType.label,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.l),
                if (shell.isLoadingOptions)
                  const LinearProgressIndicator()
                else ...[
                  _FilterSection(
                    label: 'PÉRIODE',
                    child: OutlinedButton.icon(
                      onPressed: () => _pickPeriod(context, bloc, filters),
                      icon: const Icon(Icons.date_range_outlined, size: 18),
                      label: Text(
                        '${_periodFmt.format(filters.startDate)}  →  ${_periodFmt.format(filters.endDate)}',
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  _FilterSection(
                    label: 'UTILISATEUR / SERVEUR',
                    child: _FilterDropdown<String?>(
                      value: filters.userId,
                      hint: 'Tous les utilisateurs',
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Tous les utilisateurs'),
                        ),
                        ...?options?.users.map(
                          (u) => DropdownMenuItem<String?>(
                            value: u.id,
                            child: Text(u.name),
                          ),
                        ),
                      ],
                      onChanged: (value) => bloc.add(
                        ReportingFiltersChanged(
                          filters.copyWith(
                            userId: value,
                            clearUserId: value == null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (shell.selectedType == ReportType.productSales) ...[
                    const SizedBox(height: AppSpacing.m),
                    _FilterSection(
                      label: 'CATÉGORIE',
                      child: _FilterDropdown<String?>(
                        value: filters.categoryId,
                        hint: 'Toutes les catégories',
                        items: [
                          const DropdownMenuItem<String?>(
                            value: null,
                            child: Text('Toutes les catégories'),
                          ),
                          ...?options?.categories.map(
                            (c) => DropdownMenuItem<String?>(
                              value: c.id,
                              child: Text(c.name),
                            ),
                          ),
                        ],
                        onChanged: (value) => bloc.add(
                          ReportingFiltersChanged(
                            filters.copyWith(
                              categoryId: value,
                              clearCategoryId: value == null,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.m),
                  _FilterSection(
                    label: 'SESSION DE CAISSE',
                    child: _FilterDropdown<String?>(
                      value: filters.sessionId,
                      hint: 'Toutes les sessions',
                      items: [
                        const DropdownMenuItem<String?>(
                          value: null,
                          child: Text('Toutes les sessions'),
                        ),
                        ...?options?.sessions.map(
                          (s) => DropdownMenuItem<String?>(
                            value: s.id,
                            child: Text(s.label, overflow: TextOverflow.ellipsis),
                          ),
                        ),
                      ],
                      onChanged: (value) => bloc.add(
                        ReportingFiltersChanged(
                          filters.copyWith(
                            sessionId: value,
                            clearSessionId: value == null,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (shell.selectedType == ReportType.dashboard) ...[
                    const SizedBox(height: AppSpacing.m),
                    Text(
                      'Le tableau de bord affiche les KPI du dernier jour de la période sélectionnée.',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
                const Spacer(),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    FilledButton.icon(
                      onPressed: () =>
                          bloc.add(const ReportingRunRequested()),
                      icon: const Icon(Icons.play_arrow_outlined, size: 18),
                      label: const Text('Afficher'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => bloc.add(
                        const ReportingRunRequested(
                          exportAfterLoad: ReportExportFormat.print,
                        ),
                      ),
                      icon: const Icon(Icons.print_outlined, size: 18),
                      label: const Text('Imprimer'),
                    ),
                    OutlinedButton.icon(
                      onPressed: shell.selectedType == ReportType.dashboard
                          ? null
                          : () => bloc.add(
                                const ReportingRunRequested(
                                  exportAfterLoad: ReportExportFormat.csv,
                                ),
                              ),
                      icon: const Icon(Icons.table_view_outlined, size: 18),
                      label: const Text('Excel'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => bloc.add(
                        const ReportingRunRequested(
                          exportAfterLoad: ReportExportFormat.pdf,
                        ),
                      ),
                      icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                      label: const Text('PDF'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickPeriod(
    BuildContext context,
    ReportingBloc bloc,
    ReportFilters filters,
  ) async {
    final result = await PeriodPickerDialog.show(
      context,
      initialStart: filters.startDate,
      initialEnd: filters.endDate,
    );
    if (result != null && context.mounted) {
      bloc.add(
        ReportingFiltersChanged(
          filters.copyWith(startDate: result.start, endDate: result.end),
        ),
      );
    }
  }
}

class _FilterSection extends StatelessWidget {
  const _FilterSection({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            letterSpacing: 1.2,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}

class _FilterDropdown<T> extends StatelessWidget {
  const _FilterDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      decoration: InputDecoration(
        hintText: hint,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      isExpanded: true,
      items: items,
      onChanged: onChanged,
    );
  }
}

class _ReportTypeItem extends StatelessWidget {
  const _ReportTypeItem({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final ReportType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? scheme.primaryContainer : Colors.transparent,
          border: isSelected
              ? Border(left: BorderSide(color: scheme.primary, width: 3))
              : null,
        ),
        child: Text(
          type.label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            color: isSelected ? scheme.primary : null,
          ),
        ),
      ),
    );
  }
}
