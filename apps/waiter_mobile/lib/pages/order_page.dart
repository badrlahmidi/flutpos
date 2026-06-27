import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:network/network.dart' hide ConnectionState;
import 'package:uuid/uuid.dart';

import '../di/app_bootstrap.dart';
import '../widgets/auto_direction_text_field.dart';

const _uuid = Uuid();
const _waiterId = '00000000-0000-4000-8000-000000000012';
const _ackSuccess = 'SUCCESS';

class OrderPage extends StatefulWidget {
  const OrderPage({super.key, required this.table});
  final RestaurantTable table;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final _client = AppBootstrap.instance.networkClient;
  final _orderRepo = GetIt.instance<OrderRepository>();
  final _productRepo = GetIt.instance<ProductRepository>();
  final _cashRepo = GetIt.instance<CashSessionRepository>();

  int _activeCourse = 1;
  String? _selectedCategoryId;
  List<Category> _categories = const [];
  List<Product> _products = const [];
  CompleteOrder? _order;
  bool _loading = true;
  bool _posSessionOpen = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await _ensureLocalSession();
      _posSessionOpen = await _checkPosSession();
      _categories = await _productRepo.getActiveCategories();
      if (_categories.isNotEmpty) {
        _selectedCategoryId ??= _categories.first.id;
        _products = await _productRepo.getProductsByCategory(
          _selectedCategoryId!,
        );
      }
      if (_posSessionOpen) {
        await _syncFromPos();
      } else {
        await _refreshOrderLocal();
      }
    } catch (e) {
      _error = '$e';
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _ensureLocalSession() async {
    final existing = await _cashRepo.getAnyOpenSession();
    if (existing == null) {
      await _cashRepo.openSession(userId: _waiterId, openingBalance: 0);
    }
  }

  Future<bool> _checkPosSession() async {
    final status = await _client.fetchPosStatus();
    return status?.hasOpenSession ?? false;
  }

  Future<void> _requirePosSession() async {
    _posSessionOpen = await _checkPosSession();
    if (!_posSessionOpen) {
      throw StateError(
        'Ouvrez la caisse sur le PC (Trésorerie → Ouvrir la caisse)',
      );
    }
  }

  Future<void> _syncFromPos() async {
    if (!_client.isConnected) {
      await _refreshOrderLocal();
      return;
    }

    final ack = await _client.sendAndAwaitAck(
      EventEnvelope.create(
        action: WsAction.getOpenOrder,
        deviceId: _client.deviceId,
        payload: {'tableId': widget.table.id},
      ),
    );
    _assertAckSuccess(ack, 'Synchronisation table');

    final snapshot = OrderSnapshotCodec.decodePayload(ack.payload);
    if (snapshot == null) {
      await _orderRepo.clearLocalOpenOrderForTable(widget.table.id);
      _order = null;
      return;
    }

    final session = await _cashRepo.getAnyOpenSession();
    if (session == null) {
      throw StateError('Session locale indisponible');
    }

    _order = await _orderRepo.mirrorOrderSnapshot(
      localSessionId: session.id,
      snapshot: snapshot,
    );
  }

  Future<void> _refreshOrderLocal() async {
    final open = await _orderRepo.getOpenOrderForTable(widget.table.id);
    if (open == null) {
      _order = null;
      return;
    }
    _order = await _orderRepo.getCompleteOrder(open.id);
  }

  void _assertAckSuccess(EventEnvelope ack, String action) {
    if (ack.payload['status'] != _ackSuccess) {
      final message = ack.payload['message'] as String? ?? '$action refusé';
      throw StateError(message);
    }
  }

  Future<void> _selectCategory(String categoryId) async {
    setState(() {
      _selectedCategoryId = categoryId;
      _products = const [];
    });
    final products = await _productRepo.getProductsByCategory(categoryId);
    if (mounted) {
      setState(() => _products = products);
    }
  }

  Future<void> _openNewOrder() async {
    await _requirePosSession();
    final orderId = _uuid.v4();
    final ack = await _client.sendAndAwaitAck(
      EventEnvelope.create(
        action: WsAction.createOrder,
        deviceId: _client.deviceId,
        payload: {
          'tableId': widget.table.id,
          'guestCount': 2,
          'waiterId': _waiterId,
          'orderId': orderId,
        },
      ),
    );
    _assertAckSuccess(ack, 'Ouverture commande');
    await _syncFromPos();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _addProduct(Product product) async {
    try {
      await _requirePosSession();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
      return;
    }

    if (_order == null) {
      await _openNewOrder();
    }
    if (_order == null) {
      return;
    }

    if (!mounted) return;
    final notes = await _promptNotes(context, product.name);
    if (!mounted) {
      return;
    }

    final orderItemId = _uuid.v4();
    final ack = await _client.sendAndAwaitAck(
      EventEnvelope.create(
        action: WsAction.addItems,
        deviceId: _client.deviceId,
        payload: {
          'orderId': _order!.order.id,
          'productId': product.id,
          'orderItemId': orderItemId,
          'courseNumber': _activeCourse,
          'quantity': 1,
          if (notes != null) 'customNotes': notes,
        },
      ),
    );
    _assertAckSuccess(ack, 'Ajout article');
    await _syncFromPos();
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _changeItemCourse(OrderItemWithProduct line, int course) async {
    if (line.orderItem.isFired) {
      return;
    }
    try {
      await _requirePosSession();
      final ack = await _client.sendAndAwaitAck(
        EventEnvelope.create(
          action: WsAction.updateItemCourse,
          deviceId: _client.deviceId,
          payload: {
            'orderItemId': line.orderItem.id,
            'courseNumber': course,
          },
        ),
      );
      _assertAckSuccess(ack, 'Changement course');
      await _syncFromPos();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<void> _fireNextCourse() async {
    try {
      await _requirePosSession();
      final orderId = _order?.order.id ??
          (await _orderRepo.getOpenOrderForTable(widget.table.id))?.id;
      if (orderId == null) {
        return;
      }
      final ack = await _client.sendAndAwaitAck(
        EventEnvelope.create(
          action: WsAction.fireCourse,
          deviceId: _client.deviceId,
          payload: {'orderId': orderId},
        ),
      );
      _assertAckSuccess(ack, 'Réclamation suite');
      await _syncFromPos();
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
    }
  }

  Future<String?> _promptNotes(BuildContext context, String productName) async {
    final controller = TextEditingController();
    final result = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Note — $productName'),
        content: AutoDirectionTextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Note cuisine (FR / AR)',
            hintText: 'Ex: بدون بصل',
            border: OutlineInputBorder(),
          ),
          maxLines: 2,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () {
              final text = controller.text.trim();
              Navigator.pop(ctx, text.isEmpty ? null : text);
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
    controller.dispose();
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Table ${widget.table.name}'),
        actions: [
          IconButton(
            tooltip: 'Synchroniser',
            icon: const Icon(Icons.sync),
            onPressed: _loading ? null : _bootstrap,
          ),
          IconButton(
            tooltip: 'Réclamer la suite',
            icon: const Icon(Icons.restaurant_menu),
            onPressed: _posSessionOpen ? _fireNextCourse : null,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  children: [
                    if (!_posSessionOpen)
                      MaterialBanner(
                        content: const Text(
                          'Caisse PC fermée — ouvrez une session sur le poste '
                          'caisse (Trésorerie) avant de commander.',
                        ),
                        leading: const Icon(Icons.warning_amber),
                        backgroundColor: Colors.orange.shade100,
                        actions: [
                          TextButton(
                            onPressed: _bootstrap,
                            child: const Text('Revérifier'),
                          ),
                        ],
                      ),
                    _CourseSelector(
                      activeCourse: _activeCourse,
                      onChanged: (c) => setState(() => _activeCourse = c),
                    ),
                    Expanded(
                      flex: 2,
                      child: _order == null
                          ? Center(
                              child: ElevatedButton.icon(
                                onPressed:
                                    _posSessionOpen ? _openNewOrder : null,
                                icon: const Icon(Icons.add),
                                label: const Text('Ouvrir une commande'),
                              ),
                            )
                          : _CartList(
                              order: _order!,
                              onCourseChanged: _changeItemCourse,
                            ),
                    ),
                    const Divider(height: 1),
                    Expanded(
                      flex: 3,
                      child: _ProductCatalog(
                        categories: _categories,
                        products: _products,
                        selectedCategoryId: _selectedCategoryId,
                        enabled: _posSessionOpen,
                        onCategorySelected: _selectCategory,
                        onProductTap: _addProduct,
                      ),
                    ),
                    if (_order != null)
                      _OrderTotalBar(total: _order!.displayGrandTotal),
                  ],
                ),
    );
  }
}

class _CourseSelector extends StatelessWidget {
  const _CourseSelector({
    required this.activeCourse,
    required this.onChanged,
  });

  final int activeCourse;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SegmentedButton<int>(
        segments: [
          for (var c = 1; c <= 3; c++)
            ButtonSegment(
              value: c,
              label: Text(
                '${CourseHelpers.emojiForCourse(c)} ${CourseHelpers.labelForCourse(c)}',
              ),
            ),
        ],
        selected: {activeCourse},
        onSelectionChanged: (set) => onChanged(set.first),
      ),
    );
  }
}

class _CartList extends StatelessWidget {
  const _CartList({
    required this.order,
    required this.onCourseChanged,
  });

  final CompleteOrder order;
  final Future<void> Function(OrderItemWithProduct line, int course)
      onCourseChanged;

  @override
  Widget build(BuildContext context) {
    if (order.items.isEmpty) {
      return const Center(child: Text('Panier vide — ajoutez un produit'));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      itemCount: order.items.length,
      itemBuilder: (context, index) {
        final item = order.items[index];
        final course = item.orderItem.courseNumber;
        final fired = item.orderItem.isFired;
        return ListTile(
          title: Text(item.product.name),
          subtitle: Text(
            '${CourseHelpers.badgeLabel(course)} · '
            '${fired ? 'Envoyé' : 'À suivre'}',
          ),
          trailing: fired
              ? Text('${item.orderItem.unitPrice} DH')
              : PopupMenuButton<int>(
                  tooltip: 'Changer de course',
                  icon: const Icon(Icons.more_vert),
                  onSelected: (c) => onCourseChanged(item, c),
                  itemBuilder: (_) => [
                    for (var c = 1; c <= 3; c++)
                      PopupMenuItem(
                        value: c,
                        child: Text(CourseHelpers.labelForCourse(c)),
                      ),
                  ],
                ),
        );
      },
    );
  }
}

class _ProductCatalog extends StatelessWidget {
  const _ProductCatalog({
    required this.categories,
    required this.products,
    required this.selectedCategoryId,
    required this.enabled,
    required this.onCategorySelected,
    required this.onProductTap,
  });

  final List<Category> categories;
  final List<Product> products;
  final String? selectedCategoryId;
  final bool enabled;
  final ValueChanged<String> onCategorySelected;
  final ValueChanged<Product> onProductTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 48,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: categories.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final cat = categories[index];
              final selected = cat.id == selectedCategoryId;
              return FilterChip(
                label: Text(cat.name),
                selected: selected,
                onSelected: (_) => onCategorySelected(cat.id),
              );
            },
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              childAspectRatio: 1.1,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Material(
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: enabled ? () => onProductTap(product) : null,
                  child: Opacity(
                    opacity: enabled ? 1 : 0.45,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            product.name,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${product.priceDineIn.toStringAsFixed(0)} DH',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _OrderTotalBar extends StatelessWidget {
  const _OrderTotalBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Total', style: TextStyle(fontSize: 20)),
          Text(
            '${total.toStringAsFixed(2)} DH',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
