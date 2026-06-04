import 'dart:async';

import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:window_manager/window_manager.dart';

import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/cart/cart_event.dart';
import '../../blocs/cart/cart_state.dart';
import '../../di/app_bootstrap.dart';
import '../../di/service_locator.dart';
import '../../platform/desktop_window.dart';
import '../payment/payment_page.dart';
import '../../services/print/pos_print_service.dart';
import '../../theme/app_spacing.dart';
import '../../utils/discount_flow.dart';
import '../../utils/manager_auth.dart';
import '../../widgets/dialogs/void_item_dialog.dart';
import '../../widgets/widgets.dart';
import '../auth/auth_page.dart';
import '../session/session_hub_page.dart';
import 'modifiers/modifier_selection_dialog.dart';

/// Écran caisse principal — 3 colonnes (20 % / 50 % / 30 %).
class PosPage extends StatelessWidget {
  const PosPage({super.key, required this.user});

  final User user;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(
        orderRepository: sl<OrderRepository>(),
        cashSessionRepository: sl<CashSessionRepository>(),
      )..add(CartStarted(user)),
      child: _PosView(user: user),
    );
  }
}

class _PosView extends StatefulWidget {
  const _PosView({required this.user});

  final User user;

  @override
  State<_PosView> createState() => _PosViewState();
}

class _PosViewState extends State<_PosView> with WindowListener {
  final _productRepository = sl<ProductRepository>();
  final _orderRepository = sl<OrderRepository>();

  List<Category> _categories = [];
  List<Product> _products = [];
  String? _selectedCategoryId;
  bool _loadingCatalog = true;
  String? _catalogError;
  final Set<String> _printedKitchenItemIds = {};

  @override
  void initState() {
    super.initState();
    if (DesktopWindow.isKioskTarget) {
      windowManager.addListener(this);
    }
    _loadCatalog();
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

  Future<void> _loadCatalog() async {
    setState(() {
      _loadingCatalog = true;
      _catalogError = null;
    });

    try {
      final categories = await _productRepository.getActiveCategories();
      if (!mounted) {
        return;
      }

      if (categories.isEmpty) {
        setState(() {
          _categories = [];
          _products = [];
          _selectedCategoryId = null;
          _loadingCatalog = false;
        });
        return;
      }

      final selected = _selectedCategoryId ?? categories.first.id;
      final products =
          await _productRepository.getProductsByCategory(selected);

      setState(() {
        _categories = categories;
        _selectedCategoryId = selected;
        _products = products;
        _loadingCatalog = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _catalogError = e.toString();
        _loadingCatalog = false;
      });
    }
  }

  Future<void> _onCategorySelected(Category category) async {
    if (category.id == _selectedCategoryId) {
      return;
    }

    setState(() {
      _selectedCategoryId = category.id;
      _loadingCatalog = true;
    });

    try {
      final products =
          await _productRepository.getProductsByCategory(category.id);
      if (!mounted) {
        return;
      }
      setState(() {
        _products = products;
        _loadingCatalog = false;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }
      setState(() {
        _catalogError = e.toString();
        _loadingCatalog = false;
      });
    }
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
        listener: _onCartStateChanged,
        child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _PosTopBar(
              restaurantName: 'Ritagestion',
              cashierName: widget.user.name,
              lanOnline: server.isRunning,
              clientCount: server.clientRegistry.count,
              onTreasury: _openTreasury,
            ),
            Expanded(
              child: _catalogError != null
                  ? _CatalogError(
                      message: _catalogError!,
                      onRetry: _loadCatalog,
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          flex: 2,
                          child: ColoredBox(
                            color: scheme.surface,
                            child: CategoryBar(
                              categories: _categories,
                              selectedCategoryId: _selectedCategoryId,
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
                                return _loadingCatalog
                                    ? const Center(
                                        child: CircularProgressIndicator(),
                                      )
                                    : ProductsGrid(
                                        products: _products,
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
                          child: BlocBuilder<CartBloc, CartState>(
                            builder: (context, cartState) {
                              final order = cartState.orderOrNull;
                              final isLoading = cartState is CartLoading;

                              return CartPanel(
                                user: widget.user,
                                isOrderLocked: cartState.isOrderLocked,
                                isProforma: cartState.isProforma,
                                orderType: cartState.orderTypeOrDefault,
                                onOrderTypeChanged: (type) => context
                                    .read<CartBloc>()
                                    .add(CartOrderTypeChanged(type)),
                                onLock: _lockRegister,
                                items: order?.activeItems ?? [],
                                subtotal: order?.displaySubtotal ?? 0,
                                taxAmount: order?.displayTaxAmount ?? 0,
                                discountAmount: order?.displayDiscountAmount ?? 0,
                                total: order?.displayGrandTotal ?? 0,
                                isLoading: isLoading,
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
                                onRemove: order == null
                                    ? null
                                    : (line) => _onRemoveLine(line, order),
                                onDiscount: order == null
                                    ? null
                                    : () => _onDiscount(order),
                                onSendToKitchen: order == null
                                    ? null
                                    : () => _onSendToKitchen(order),
                                onProforma: order == null
                                    ? null
                                    : () => _onProforma(order),
                                onPay: order == null
                                    ? null
                                    : () => _onPay(order),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
          ],
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
    required this.lanOnline,
    required this.clientCount,
    required this.onTreasury,
  });

  final String restaurantName;
  final String cashierName;
  final bool lanOnline;
  final int clientCount;
  final VoidCallback onTreasury;

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
              const Spacer(),
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
