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
import '../../services/pos_service_mode.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/molecules/service_mode_toggle.dart';
import '../../utils/discount_flow.dart';
import '../../utils/manager_auth.dart';
import '../../widgets/dialogs/void_item_dialog.dart';
import '../../widgets/widgets.dart';
import '../auth/auth_page.dart';
import '../floor_plan/floor_plan_page.dart';
import '../kds/kds_page.dart';
import '../session/session_hub_page.dart';
import '../backoffice/analytics_dashboard_page.dart';
import 'delivery/delivery_orders_panel.dart';
import 'delivery/delivery_start_dialog.dart';
import 'modifiers/modifier_selection_dialog.dart';

enum _PosWorkspace { register, deliveries }

/// Écran caisse principal — 3 colonnes (20 % / 50 % / 30 %).
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

  final Set<String> _printedKitchenItemIds = {};
  _PosWorkspace _workspace = _PosWorkspace.register;

  @override
  void initState() {
    super.initState();
    if (DesktopWindow.isKioskTarget) {
      windowManager.addListener(this);
    }
  }

  @override
  void dispose() {
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
              options: selected,
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
    setState(() => _workspace = _PosWorkspace.deliveries);
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
    setState(() => _workspace = _PosWorkspace.deliveries);
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

  void _printKitchenLines(CompleteOrder order, List<OrderItemWithProduct> lines) {
    if (lines.isEmpty) {
      return;
    }
    sl<PosPrintService>().printKitchenTickets(order: order, lines: lines);
  }

  Future<void> _markAndPrintKitchen(
    CompleteOrder order,
    List<OrderItemWithProduct> lines,
  ) async {
    if (lines.isEmpty) {
      return;
    }
    final ids = lines.map((l) => l.orderItem.id).toList();
    await sl<OrderRepository>().markOrderItemsFired(ids);
    _printedKitchenItemIds.addAll(ids);
    _printKitchenLines(order, lines);
  }

  void _onCartStateChanged(BuildContext context, CartState state) {
    if (state is CartError) {
      if (state.message.contains('session')) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    if (state is CartReady) {
      final newLines = state.order.activeItems
          .where(
            (l) =>
                !l.orderItem.isFired &&
                !_printedKitchenItemIds.contains(l.orderItem.id),
          )
          .toList();
      if (newLines.isEmpty) {
        return;
      }
      unawaited(_markAndPrintKitchen(state.order, newLines));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Ticket cuisine envoyé (${newLines.length} ligne(s))',
          ),
          duration: const Duration(seconds: 2),
        ),
      );
    }
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
    setState(() => _workspace = _PosWorkspace.register);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Commande encaissée'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _onSendToKitchen(CompleteOrder order) async {
    final lines = order.activeItems
        .where((l) => !l.orderItem.isFired)
        .toList();
    await _markAndPrintKitchen(order, lines);
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          lines.isEmpty
              ? 'Aucune ligne à envoyer'
              : 'Cuisine — ${lines.length} ligne(s)',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
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
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
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
        listener: _onCartStateChanged,
        child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PosTopBar(
              restaurantName: 'Ritagestion',
              cashierName: widget.user.name,
              tableLabel: widget.tableLabel,
              workspace: _workspace,
              lanOnline: server.isRunning,
              clientCount: server.clientRegistry.count,
              onWorkspaceChanged: (w) => setState(() => _workspace = w),
              onNewDelivery: () async {
                final data = await showDeliveryStartDialog(context);
                if (data != null && mounted) {
                  await _startDeliveryOrder(data.source, data.externalRef);
                }
              },
              onFloorPlan: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(
                    builder: (_) => FloorPlanPage(user: widget.user),
                  ),
                );
              },
              onTreasury: _openTreasury,
              onDashboard: _openDashboard,
              onServiceModeChanged: _onServiceModeChanged,
              onKds: () {
                Navigator.of(context).push<void>(
                  MaterialPageRoute<void>(builder: (_) => const KdsPage()),
                );
              },
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
                        Expanded(
                          flex: 2,
                          child: _workspace == _PosWorkspace.deliveries
                              ? DeliveryOrdersPanel(
                                  cashierId: widget.user.id,
                                  selectedOrderId: currentOrder?.order.id,
                                  onOrderSelected: _openDeliveryOrder,
                                  onNewDelivery: _startDeliveryOrder,
                                )
                              : ColoredBox(
                                  color: scheme.surface,
                                  child: CategoryBar(
                                    categories: catalog.categories,
                                    selectedCategoryId:
                                        catalog.selectedCategoryId,
                                    onCategorySelected: _onCategorySelected,
                                  ),
                                ),
                        ),
                        VerticalDivider(
                          width: 1,
                          color: scheme.outlineVariant,
                        ),
                        Expanded(
                          flex: 5,
                          child: ColoredBox(
                            color: theme.scaffoldBackgroundColor,
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
                                return ProductsGrid(
                                  products: catalog.products,
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
                        ),
                        VerticalDivider(
                          width: 1,
                          color: scheme.outlineVariant,
                        ),
                        Expanded(
                          flex: 3,
                          child: CartPanel(
                                user: widget.user,
                                isOrderLocked: cartState.isOrderLocked,
                                isProforma: cartState.isProforma,
                                isDeliveryOrder: cartState.isDeliveryOrder,
                                deliveryLabel: cartState.deliveryDisplayLabel,
                                orderType: cartState.orderTypeOrDefault,
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

class _PosTopBar extends StatelessWidget {
  const _PosTopBar({
    required this.restaurantName,
    required this.cashierName,
    this.tableLabel,
    required this.workspace,
    required this.lanOnline,
    required this.clientCount,
    required this.onWorkspaceChanged,
    required this.onNewDelivery,
    required this.onFloorPlan,
    required this.onTreasury,
    required this.onDashboard,
    required this.onServiceModeChanged,
    required this.onKds,
  });

  final String restaurantName;
  final String cashierName;
  final String? tableLabel;
  final _PosWorkspace workspace;
  final bool lanOnline;
  final int clientCount;
  final ValueChanged<_PosWorkspace> onWorkspaceChanged;
  final VoidCallback onNewDelivery;
  final VoidCallback onFloorPlan;
  final VoidCallback onTreasury;
  final VoidCallback onDashboard;
  final ValueChanged<ServiceMode> onServiceModeChanged;
  final VoidCallback onKds;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final statusColor = lanOnline ? scheme.primary : scheme.error;

    return Material(
      color: scheme.surface,
      elevation: 1,
      child: SizedBox(
        height: AppSpacing.minTouchTarget,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
          child: Row(
            children: [
              Icon(Icons.storefront, color: scheme.primary),
              const SizedBox(width: AppSpacing.s),
              Text(restaurantName, style: theme.textTheme.titleMedium),
              const SizedBox(width: AppSpacing.m),
              Text(
                cashierName,
                style: theme.textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
              if (tableLabel != null) ...[
                const SizedBox(width: AppSpacing.m),
                Chip(
                  label: Text('Table $tableLabel'),
                  visualDensity: VisualDensity.compact,
                ),
              ],
              const Spacer(),
              ServiceModeToggle(onModeChanged: onServiceModeChanged),
              const SizedBox(width: AppSpacing.s),
              SizedBox(
                height: AppSpacing.minTouchTarget,
                child: SegmentedButton<_PosWorkspace>(
                  segments: const [
                    ButtonSegment(
                      value: _PosWorkspace.register,
                      label: Text('Caisse'),
                      icon: Icon(Icons.point_of_sale),
                    ),
                    ButtonSegment(
                      value: _PosWorkspace.deliveries,
                      label: Text('Livraisons'),
                      icon: Icon(Icons.delivery_dining),
                    ),
                  ],
                  selected: {workspace},
                  onSelectionChanged: (set) {
                    if (set.isNotEmpty) {
                      onWorkspaceChanged(set.first);
                    }
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.s),
              IconButton(
                tooltip: 'Écran cuisine (KDS)',
                onPressed: onKds,
                icon: const Icon(Icons.soup_kitchen_outlined),
              ),
              IconButton(
                tooltip: 'Nouvelle livraison',
                onPressed: onNewDelivery,
                icon: const Icon(Icons.add_box_outlined),
              ),
              if (PosServiceMode.instance.isTableService)
                IconButton(
                  tooltip: 'Plan de salle',
                  onPressed: onFloorPlan,
                  icon: const Icon(Icons.table_restaurant_outlined),
                ),
              IconButton(
                tooltip: 'Dashboard analytique',
                onPressed: onDashboard,
                icon: const Icon(Icons.insights_outlined),
              ),
              IconButton(
                tooltip: 'Trésorerie (X / Z / Pay-in-out)',
                onPressed: onTreasury,
                icon: const Icon(Icons.account_balance_wallet_outlined),
              ),
              Icon(Icons.lan, size: 20, color: statusColor),
              const SizedBox(width: AppSpacing.s),
              Text(
                lanOnline ? 'LAN · $clientCount' : 'LAN hors ligne',
                style: theme.textTheme.labelSmall?.copyWith(color: statusColor),
              ),
            ],
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
