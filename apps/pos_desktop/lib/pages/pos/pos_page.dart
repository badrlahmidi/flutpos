import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../blocs/catalog/catalog_bloc.dart';
import '../../blocs/catalog/catalog_event.dart';
import '../../blocs/catalog/catalog_state.dart';
import '../../di/app_bootstrap.dart';
import '../../di/service_locator.dart';
import '../../platform/desktop_window.dart';
import '../payment/payment_page.dart';
import '../../services/print/pos_print_service.dart';
import '../../theme/app_spacing.dart';
import '../../theme/pos_design_tokens.dart';
import '../../widgets/organisms/pos_catalog_toolbar.dart';
import '../../widgets/organisms/pos_top_bar.dart';
import '../../utils/discount_flow.dart';
import '../../utils/manager_auth.dart';
import '../../widgets/dialogs/void_item_dialog.dart';
import '../../widgets/widgets.dart';
import '../auth/auth_page.dart';
import '../floor_plan/floor_plan_page.dart';
import '../session/session_hub_page.dart';
import '../backoffice/analytics_dashboard_page.dart';
import 'delivery/delivery_orders_panel.dart';
import 'modifiers/modifier_selection_dialog.dart';

/// Écran caisse principal — layout maquette Ritaj POS.
class PosPage extends StatelessWidget {
  const PosPage({
    super.key,
    required this.user,
    this.orderId,
    this.tableLabel,
  });

  final User user;
  final String? orderId;
  final String? tableLabel;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => CartBloc(
            orderRepository: sl<OrderRepository>(),
            cashSessionRepository: sl<CashSessionRepository>(),
          )..add(
              CartStarted(
                user,
                existingOrderId: orderId,
              ),
            ),
        ),
        BlocProvider(
          create: (_) => CatalogBloc(
            productRepository: sl<ProductRepository>(),
          )..add(const CatalogStarted()),
        ),
      ],
      child: _PosView(user: user, tableLabel: tableLabel),
    );
  }
}

class _PosView extends StatefulWidget {
  const _PosView({required this.user, this.tableLabel});

  final User user;
  final String? tableLabel;

  @override
  State<_PosView> createState() => _PosViewState();
}

class _PosViewState extends State<_PosView> with WindowListener {
  final _orderRepository = sl<OrderRepository>();
  final _productRepository = sl<ProductRepository>();
  final _searchController = TextEditingController();

  final Set<String> _printedKitchenItemIds = {};
  final Set<String> _favoriteProductIds = {};
  PosWorkspace _workspace = PosWorkspace.register;
  PosProductFilter _productFilter = PosProductFilter.all;
  Map<String, int> _categoryCounts = {};

  @override
  void initState() {
    super.initState();
    if (DesktopWindow.isKioskTarget) {
      windowManager.addListener(this);
    }
    _loadCategoryCounts();
    _searchController.addListener(() => setState(() {}));
  }

  Future<void> _loadCategoryCounts() async {
    final categories = await _productRepository.getActiveCategories();
    final counts = <String, int>{};
    for (final cat in categories) {
      counts[cat.id] =
          (await _productRepository.getProductsByCategory(cat.id)).length;
    }
    if (mounted) {
      setState(() => _categoryCounts = counts);
    }
  }

  List<Product> _filterProducts(List<Product> products) {
    final query = _searchController.text.trim().toLowerCase();
    var list = products;
    if (query.isNotEmpty) {
      list = list
          .where(
            (p) =>
                p.name.toLowerCase().contains(query) ||
                (p.nameAr?.toLowerCase().contains(query) ?? false),
          )
          .toList();
    }
    switch (_productFilter) {
      case PosProductFilter.all:
      case PosProductFilter.available:
        return list;
      case PosProductFilter.popular:
        return list.take(12).toList();
      case PosProductFilter.favorites:
        return list.where((p) => _favoriteProductIds.contains(p.id)).toList();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    if (DesktopWindow.isKioskTarget) {
      windowManager.removeListener(this);
    }
    super.dispose();
  }

  @override
  void onWindowClose() {}

  void _onCategorySelected(Category category) {
    context.read<CatalogBloc>().add(CatalogCategorySelected(category.id));
  }

  Future<void> _onProductTap(Product product) async {
    final cartState = context.read<CartBloc>().state;
    if (cartState.isOrderLocked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            cartState.isProforma
                ? 'Commande en proforma — ajout impossible'
                : 'Commande verrouillée',
          ),
        ),
      );
      return;
    }

    final hasModifiers = await _productRepository.hasModifiers(product.id);
    if (!mounted) {
      return;
    }

    if (hasModifiers) {
      final groups =
          await _productRepository.getModifierGroupsForProduct(product.id);
      if (!mounted) {
        return;
      }

      final selected = await showModifierSelectionDialog(
        context: context,
        product: product,
        groups: groups,
      );
      if (!mounted || selected == null) {
        return;
      }

      context.read<CartBloc>().add(
            CartItemAddedWithModifiers(
              product: product,
              options: selected.options,
              customNotes: selected.customNotes,
            ),
          );
      return;
    }

    context.read<CartBloc>().add(CartItemAdded(product));
  }

  Future<bool> _confirmLeaveCurrentCart() async {
    final order = context.read<CartBloc>().state.orderOrNull;
    if (order == null || order.activeItems.isEmpty) {
      return true;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Changer de ticket ?'),
        content: const Text(
          'Le panier actuel contient des articles. '
          'Ouvrez un autre ticket seulement après encaissement ou vidage.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
    return ok == true;
  }

  Future<void> _startDeliveryOrder(
    OrderSource source,
    String? externalRef,
  ) async {
    if (!await _confirmLeaveCurrentCart() || !mounted) {
      return;
    }

    context.read<CartBloc>().add(
          CartStarted(
            widget.user,
            deliverySource: source,
            externalRef: externalRef,
          ),
        );
    setState(() => _workspace = PosWorkspace.deliveries);
  }

  Future<void> _openDeliveryOrder(String orderId) async {
    if (!await _confirmLeaveCurrentCart() || !mounted) {
      return;
    }

    context.read<CartBloc>().add(
          CartStarted(
            widget.user,
            existingOrderId: orderId,
          ),
        );
    setState(() => _workspace = PosWorkspace.deliveries);
  }

  void _onServiceModeChanged(ServiceMode mode) {
    if (mode == ServiceMode.tableService && mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => FloorPlanPage(user: widget.user),
        ),
      );
    }
  }

  void _lockRegister() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AuthPage()),
      (_) => false,
    );
  }

  void _onFireCourseResult(BuildContext context, CartState state) {
    if (state is! CartReady || state.fireCourseResult == null) {
      return;
    }
    final result = state.fireCourseResult!;
    final order = state.order;
    final firedIds = result.firedItems.map((i) => i.id).toSet();
    final lines = order.activeItems
        .where((l) => firedIds.contains(l.orderItem.id))
        .toList();
    if (lines.isEmpty) {
      return;
    }
    _printedKitchenItemIds.addAll(firedIds);
    unawaited(
      sl<PosPrintService>().printKitchenTickets(
        order: order,
        lines: lines,
        firedCourseNumber: result.courseNumber,
        isCourseClaim: result.courseNumber > 1,
      ),
    );
  }

  Future<void> _onProforma(CompleteOrder order) async {
    final bloc = context.read<CartBloc>();
    bloc.add(const CartProformaRequested());

    final cartState = await bloc.stream.firstWhere(
      (s) => s is CartReady || s is CartError,
    );
    if (!mounted) {
      return;
    }

    if (cartState is CartError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cartState.message)),
      );
      return;
    }

    final updated = (cartState as CartReady).order;
    final result = await sl<PosPrintService>().printProforma(updated);

    if (!mounted) {
      return;
    }

    final message = result.ok
        ? (result.simulated
            ? 'Proforma — simulation (console / logs)'
            : 'Note proforma imprimée — table verrouillée')
        : (result.error ?? 'Erreur impression proforma');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _openTreasury() async {
    final refreshed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => SessionHubPage(user: widget.user),
      ),
    );

    if (!mounted) {
      return;
    }

    if (refreshed == true) {
      context.read<CartBloc>().add(CartStarted(widget.user));
    }
  }

  void _openDashboard() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const AnalyticsDashboardPage(),
      ),
    );
  }

  Future<void> _onPay(CompleteOrder order) async {
    final paid = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => PaymentPage(
          orderId: order.order.id,
          user: widget.user,
        ),
      ),
    );

    if (!mounted || paid != true) {
      return;
    }

    context.read<CartBloc>().add(const CartReloadRequested());
    setState(() => _workspace = PosWorkspace.register);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande encaissée'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onSendToKitchen(CompleteOrder order) async {
    context.read<CartBloc>().add(const CartCourseFireRequested());
  }

  void _onClaimNextCourse() {
    context.read<CartBloc>().add(const CartCourseFireRequested());
  }

  Future<void> _onDiscount(CompleteOrder order) async {
    await runCartDiscountFlow(
      context: context,
      currentUser: widget.user,
      order: order,
      onApply: (event) => context.read<CartBloc>().add(event),
    );
  }

  Future<void> _onRemoveLine(
    OrderItemWithProduct line,
    CompleteOrder order,
  ) async {
    if (line.orderItem.isFired) {
      final reason = await showVoidItemReasonDialog(
        context,
        productName: line.product.name,
      );
      if (reason == null || !mounted) {
        return;
      }

      final manager = await resolveManagerAuthorization(context, widget.user);
      if (manager == null || !mounted) {
        return;
      }

      final bloc = context.read<CartBloc>();
      bloc.add(
        CartItemVoided(
          orderItemId: line.orderItem.id,
          managerUserId: manager.id,
          reason: reason,
          requestedByUserId:
              manager.id != widget.user.id ? widget.user.id : null,
        ),
      );

      final cartState = await bloc.stream.firstWhere(
        (s) => s is CartReady || s is CartError,
      );
      if (!mounted) {
        return;
      }

      if (cartState is CartError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(cartState.message)),
        );
        return;
      }

      final updated = (cartState as CartReady).order;
      sl<PosPrintService>().printKitchenVoidTickets(
        order: updated,
        lines: [line],
        reason: reason,
      );
      _printedKitchenItemIds.remove(line.orderItem.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article annulé — ticket VOID cuisine envoyé'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    _printedKitchenItemIds.remove(line.orderItem.id);
    context.read<CartBloc>().add(CartItemRemoved(line.orderItem.id));
  }

  @override
  Widget build(BuildContext context) {
    final server = AppBootstrap.instance.networkServer;

    return BlocListener<CartBloc, CartState>(
      listenWhen: (prev, curr) =>
          curr is CartError && curr.message.contains('session'),
      listener: (context, state) {
        if (state is CartError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              action: SnackBarAction(
                label: 'Ouvrir caisse',
                onPressed: _openTreasury,
              ),
            ),
          );
        }
      },
      child: BlocListener<CartBloc, CartState>(
        listenWhen: (prev, curr) =>
            curr is CartReady &&
            curr.feedbackMessage != null &&
            (prev is! CartReady ||
                prev.feedbackMessage != curr.feedbackMessage),
        listener: (context, state) {
          if (state is CartReady && state.feedbackMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.feedbackMessage!),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        },
        child: BlocListener<CartBloc, CartState>(
        listenWhen: (prev, curr) =>
            curr is CartReady &&
            curr.fireCourseResult != null &&
            (prev is! CartReady ||
                prev.fireCourseResult?.courseNumber !=
                    curr.fireCourseResult?.courseNumber),
        listener: _onFireCourseResult,
        child: Scaffold(
        backgroundColor: PosDesignTokens.shellBackground,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PosTopBar(
              lanOnline: server.isRunning,
              clientCount: server.clientRegistry.count,
              workspace: _workspace,
              onWorkspaceSelected: (w) => setState(() => _workspace = w),
              onSync: () {
                context.read<CatalogBloc>().add(const CatalogStarted());
                _loadCategoryCounts();
              },
              onPrint: () {
                final order = context.read<CartBloc>().state.orderOrNull;
                if (order != null) {
                  _onProforma(order);
                }
              },
              onHistory: _openTreasury,
              onSettings: _openDashboard,
              onLanguageToggle: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Basculer AR — catalogue bilingue actif')),
                );
              },
              onServiceModeChanged: _onServiceModeChanged,
            ),
            Expanded(
              child: BlocBuilder<CatalogBloc, CatalogState>(
                builder: (context, catalogState) {
                  if (catalogState is CatalogError) {
                    return _CatalogError(
                      message: catalogState.message,
                      onRetry: () => context
                          .read<CatalogBloc>()
                          .add(const CatalogStarted()),
                    );
                  }

                  if (catalogState is! CatalogReady) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final catalog = catalogState;
                  return BlocBuilder<CartBloc, CartState>(
                    builder: (context, cartState) {
                      final currentOrder = cartState.orderOrNull;
                      return Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 240,
                          child: _workspace == PosWorkspace.deliveries
                              ? DeliveryOrdersPanel(
                                  cashierId: widget.user.id,
                                  selectedOrderId: currentOrder?.order.id,
                                  onOrderSelected: _openDeliveryOrder,
                                  onNewDelivery: _startDeliveryOrder,
                                )
                              : CategoryBar(
                                  categories: catalog.categories,
                                  selectedCategoryId:
                                      catalog.selectedCategoryId,
                                  productCounts: _categoryCounts,
                                  onCategorySelected: _onCategorySelected,
                                  onShowAllCategories: catalog.categories.isNotEmpty
                                      ? () => _onCategorySelected(
                                            catalog.categories.first,
                                          )
                                      : null,
                                ),
                        ),
                        Expanded(
                          child: ColoredBox(
                            color: PosDesignTokens.shellBackground,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (_workspace == PosWorkspace.register)
                                  PosCatalogToolbar(
                                    searchController: _searchController,
                                    filter: _productFilter,
                                    onFilterChanged: (f) =>
                                        setState(() => _productFilter = f),
                                    onSort: () {},
                                  ),
                                Expanded(
                                  child: BlocBuilder<CartBloc, CartState>(
                                    buildWhen: (prev, curr) =>
                                        prev.orderTypeOrDefault !=
                                        curr.orderTypeOrDefault,
                                    builder: (context, cartState) {
                                      if (catalog.isLoadingProducts) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      final filtered =
                                          _filterProducts(catalog.products);
                                      return ProductsGrid(
                                        products: filtered,
                                        priceFor: (p) => _orderRepository
                                            .resolveUnitPrice(
                                          p,
                                          cartState.orderTypeOrDefault,
                                        ),
                                        onProductTap: _onProductTap,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 380,
                          child: CartPanel(
                                tableLabel: widget.tableLabel != null
                                    ? 'Table ${widget.tableLabel}'
                                    : null,
                                user: widget.user,
                                isOrderLocked: cartState.isOrderLocked,
                                isProforma: cartState.isProforma,
                                isDeliveryOrder: cartState.isDeliveryOrder,
                                deliveryLabel: cartState.deliveryDisplayLabel,
                                orderType: cartState.orderTypeOrDefault,
                                activeCourseNumber: cartState is CartReady
                                    ? cartState.activeCourseNumber
                                    : 1,
                                canClaimNextCourse: cartState is CartReady
                                    ? cartState.canClaimNextCourse
                                    : false,
                                onActiveCourseSelected: (course) => context
                                    .read<CartBloc>()
                                    .add(CartActiveCourseSelected(course)),
                                onItemCourseChanged: (line, course) => context
                                    .read<CartBloc>()
                                    .add(
                                      CartItemCourseChanged(
                                        orderItemId: line.orderItem.id,
                                        courseNumber: course,
                                      ),
                                    ),
                                onOrderTypeChanged: (type) => context
                                    .read<CartBloc>()
                                    .add(CartOrderTypeChanged(type)),
                                onLock: _lockRegister,
                                items: currentOrder?.activeItems ?? [],
                                subtotal: currentOrder?.displaySubtotal ?? 0,
                                taxAmount: currentOrder?.displayTaxAmount ?? 0,
                                discountAmount:
                                    currentOrder?.displayDiscountAmount ?? 0,
                                total: currentOrder?.displayGrandTotal ?? 0,
                                isLoading: cartState is CartLoading,
                                onIncrement: (line) => context
                                    .read<CartBloc>()
                                    .add(
                                      CartItemQuantityUpdated(
                                        orderItemId: line.orderItem.id,
                                        quantity: line.orderItem.quantity + 1,
                                      ),
                                    ),
                                onDecrement: (line) => context
                                    .read<CartBloc>()
                                    .add(
                                      CartItemQuantityUpdated(
                                        orderItemId: line.orderItem.id,
                                        quantity: line.orderItem.quantity - 1,
                                      ),
                                    ),
                                onRemove: currentOrder == null
                                    ? null
                                    : (line) =>
                                        _onRemoveLine(line, currentOrder),
                                onDiscount: currentOrder == null
                                    ? null
                                    : () => _onDiscount(currentOrder),
                                onSendToKitchen: currentOrder == null
                                    ? null
                                    : () => _onSendToKitchen(currentOrder),
                                onClaimNextCourse: currentOrder == null
                                    ? null
                                    : _onClaimNextCourse,
                                onProforma: currentOrder == null
                                    ? null
                                    : () => _onProforma(currentOrder),
                                onPay: currentOrder == null
                                    ? null
                                    : () => _onPay(currentOrder),
                              ),
                        ),
                      ],
                    );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      ),
      ),
    );
  }
}

class _CatalogError extends StatelessWidget {
  const _CatalogError({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.l),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSpacing.minTouchTarget,
              color: theme.colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.m),
            Text(
              'Impossible de charger le catalogue',
              style: theme.textTheme.titleMedium,
            ),
            const SizedBox(height: AppSpacing.s),
            Text(message, style: theme.textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.l),
            PosButton(
              label: 'Réessayer',
              icon: Icons.refresh,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
