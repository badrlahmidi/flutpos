import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;
import '../../di/service_locator.dart';
import '../../theme/app_spacing.dart';
import '../../widgets/organisms/top_bar.dart';

/// Statut agrégé d'une table active pour le tableau de bord.
class ActiveTableStatus {
  const ActiveTableStatus({
    required this.table,
    required this.order,
    required this.waiterName,
    required this.items,
  });

  final RestaurantTable table;
  final Order order;
  final String waiterName;
  final List<OrderItemWithProduct> items;

  /// Retourne les articles groupés par numéro de course.
  Map<int, List<OrderItemWithProduct>> get itemsByCourse {
    final Map<int, List<OrderItemWithProduct>> grouped = {};
    for (final item in items) {
      final courseNum = item.orderItem.courseNumber;
      grouped.putIfAbsent(courseNum, () => []).add(item);
    }
    return grouped;
  }
}

/// Tableau de Bord de Suivi des Tables Actives (Active Table Monitor).
class ActiveTableMonitorPage extends StatefulWidget {
  const ActiveTableMonitorPage({super.key, required this.user, this.startTimer = true});

  final User user;
  final bool startTimer;

  @override
  State<ActiveTableMonitorPage> createState() => _ActiveTableMonitorPageState();
}

class _ActiveTableMonitorPageState extends State<ActiveTableMonitorPage> {
  List<ActiveTableStatus> _activeTables = [];
  bool _loading = true;
  String? _error;
  StreamSubscription? _subscription;
  Timer? _durationRefreshTimer;

  @override
  void initState() {
    super.initState();
    _startWatching();
    // Rafraîchir les compteurs de temps toutes les minutes
    if (widget.startTimer) {
      _durationRefreshTimer = Timer.periodic(const Duration(minutes: 1), (_) {
        if (mounted) setState(() {});
      });
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _durationRefreshTimer?.cancel();
    super.dispose();
  }

  void _startWatching() {
    final db = sl<AppDatabase>();
    _loadData();
    // Écoute réactive aux changements (lignes de commandes, commandes, tables)
    final streams = [
      db.select(db.orderItems).watch(),
      db.select(db.orders).watch(),
      db.select(db.restaurantTables).watch(),
    ];
    
    _subscription = Stream.multi((controller) {
      final subs = streams.map((s) => s.listen((_) => controller.add(null))).toList();
      controller.onCancel = () {
        for (final sub in subs) {
          sub.cancel();
        }
      };
    }).listen((_) {
      _loadData();
    });
  }

  Future<void> _loadData() async {
    try {
      final db = sl<AppDatabase>();
      final ordersRepo = sl<OrderRepository>();

      final tables = await (db.select(db.restaurantTables)
            ..where((t) => t.status.equals('OCCUPIED')))
          .get();

      final List<ActiveTableStatus> loaded = [];

      for (final table in tables) {
        final activeOrder = await (db.select(db.orders)
              ..where((o) => o.tableId.equals(table.id) & o.status.equals('OPEN')))
            .getSingleOrNull();

        if (activeOrder == null) continue;

        final completeOrder = await ordersRepo.getCompleteOrder(activeOrder.id);
        if (completeOrder != null) {
          loaded.add(ActiveTableStatus(
            table: table,
            order: completeOrder.order,
            waiterName: completeOrder.waiter.name,
            items: completeOrder.items,
          ));
        }
      }

      if (mounted) {
        setState(() {
          _activeTables = loaded;
          _loading = false;
          _error = null;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.toString();
        });
      }
    }
  }

  Future<void> _fireNextCourse(String orderId) async {
    try {
      final result = await sl<OrderRepository>().fireNextPendingCourse(orderId);
      if (result != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Course ${result.courseNumber} envoyée en cuisine ! (${result.firedItems.length} articles)',
            ),
            backgroundColor: const Color(0xFF16A34A),
          ),
        );
        _loadData();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur envoi cuisine : $e')),
        );
      }
    }
  }

  Future<void> _markItemServed(String orderItemId) async {
    try {
      final db = sl<AppDatabase>();
      await (db.update(db.orderItems)..where((i) => i.id.equals(orderItemId)))
          .write(const OrderItemsCompanion(status: Value('SERVED')));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Article marqué servi ✓'),
            backgroundColor: Colors.blueGrey,
          ),
        );
      }
      _loadData();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur de mise à jour : $e')),
        );
      }
    }
  }

  String _formatDuration(DateTime openedAt) {
    final diff = DateTime.now().difference(openedAt.toLocal());
    if (diff.inHours > 0) {
      return '${diff.inHours}h ${diff.inMinutes.remainder(60)}m';
    }
    return '${diff.inMinutes} min';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0D1117) : scheme.surfaceContainerLowest,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TopBar(
            title: 'Suivi des Tables Actives',
            icon: Icons.monitor_heart_outlined,
            onHome: () => context.go('/menu'),
            actions: [
              IconButton(
                tooltip: 'Actualiser',
                onPressed: _loadData,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                    ? Center(
                        child: Text(
                          'Erreur : $_error',
                          style: TextStyle(color: scheme.error),
                        ),
                      )
                    : _activeTables.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.table_restaurant_outlined,
                                  size: 64,
                                  color: scheme.onSurfaceVariant.withValues(alpha: 0.5),
                                ),
                                const SizedBox(height: AppSpacing.m),
                                Text(
                                  'Aucune table occupée',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                Text(
                                  'Toutes les tables sont disponibles',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: scheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(AppSpacing.m),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: AppSpacing.m,
                              crossAxisSpacing: AppSpacing.m,
                              childAspectRatio: 1.15,
                            ),
                            itemCount: _activeTables.length,
                            itemBuilder: (context, index) {
                              return _TableMonitorCard(
                                status: _activeTables[index],
                                formatDuration: _formatDuration,
                                onFireNext: _fireNextCourse,
                                onMarkServed: _markItemServed,
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}

class _TableMonitorCard extends StatelessWidget {
  const _TableMonitorCard({
    required this.status,
    required this.formatDuration,
    required this.onFireNext,
    required this.onMarkServed,
  });

  final ActiveTableStatus status;
  final String Function(DateTime) formatDuration;
  final ValueChanged<String> onFireNext;
  final ValueChanged<String> onMarkServed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    final durationStr = formatDuration(status.order.createdAt);
    final guestCount = status.order.guestCount;

    // Calcul des statuts des articles
    final items = status.items.where((i) => i.orderItem.status != 'VOIDED').toList();
    final readyCount = items.where((i) => i.orderItem.status == 'PREPARING').length;
    final heldCount = items.where((i) => !i.orderItem.isFired).length;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: readyCount > 0
              ? Colors.green.withValues(alpha: 0.5)
              : scheme.outlineVariant.withValues(alpha: 0.5),
          width: readyCount > 0 ? 2 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: Nom Table & Durée
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.s,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: readyCount > 0 ? Colors.green : scheme.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Table ${status.table.name}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '$guestCount convive(s)',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      durationStr,
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: scheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.s),
            // Serveur responsable
            Row(
              children: [
                Icon(Icons.person_outline, size: 16, color: scheme.onSurfaceVariant),
                const SizedBox(width: 4),
                Text(
                  'Serveur : ${status.waiterName}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            const Divider(height: AppSpacing.m),
            // Synthèse des Plats par Course
            Expanded(
              child: ListView(
                shrinkWrap: true,
                children: status.itemsByCourse.entries.map((entry) {
                  final courseNum = entry.key;
                  final courseItems = entry.value.where((i) => i.orderItem.status != 'VOIDED').toList();
                  if (courseItems.isEmpty) return const SizedBox.shrink();

                  final courseName = _courseLabel(courseNum);

                  // Statut global de la course
                  Widget statusBadge;
                  if (courseItems.every((i) => i.orderItem.status == 'SERVED')) {
                    statusBadge = const Text('Servi ✓', style: TextStyle(color: Colors.grey, fontSize: 12));
                  } else if (courseItems.any((i) => i.orderItem.status == 'PREPARING')) {
                    statusBadge = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'PRÊT 🔔',
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  } else if (courseItems.any((i) => i.orderItem.status == 'PENDING' && i.orderItem.isFired)) {
                    statusBadge = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'CUISINE 🍳',
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  } else {
                    statusBadge = Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'ATTENTE ⏳',
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 11),
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '$courseName (${courseItems.length})',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        statusBadge,
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _showDetailsDialog(context),
                    child: const Text('Détails'),
                  ),
                ),
                if (heldCount > 0) ...[
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => onFireNext(status.order.id),
                      icon: const Icon(Icons.soup_kitchen, size: 14),
                      label: const Text('Suite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: scheme.secondaryContainer,
                        foregroundColor: scheme.onSecondaryContainer,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _courseLabel(int number) {
    switch (number) {
      case 1:
        return 'Entrées';
      case 2:
        return 'Plats';
      case 3:
        return 'Desserts';
      case 4:
        return 'Boissons';
      default:
        return 'Course $number';
    }
  }

  void _showDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        final theme = Theme.of(context);
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Table ${status.table.name} — Détails'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          content: SizedBox(
            width: 500,
            child: ListView(
              shrinkWrap: true,
              children: status.itemsByCourse.entries.map((entry) {
                final courseNum = entry.key;
                final courseItems = entry.value.where((i) => i.orderItem.status != 'VOIDED').toList();
                if (courseItems.isEmpty) return const SizedBox.shrink();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        _courseLabel(courseNum).toUpperCase(),
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                    ...courseItems.map((item) {
                      final name = item.product.name;
                      final nameAr = item.product.nameAr;
                      final qty = item.orderItem.quantity;
                      final isFired = item.orderItem.isFired;
                      final statusStr = item.orderItem.status;

                      Widget statusTrailing;
                      if (statusStr == 'SERVED') {
                        statusTrailing = const Text('Servi ✓', style: TextStyle(color: Colors.grey));
                      } else if (statusStr == 'PREPARING') {
                        statusTrailing = TextButton.icon(
                          onPressed: () {
                            Navigator.pop(context);
                            onMarkServed(item.orderItem.id);
                          },
                          icon: const Icon(Icons.check, size: 16, color: Colors.green),
                          label: const Text('Servir', style: TextStyle(color: Colors.green)),
                        );
                      } else if (isFired && statusStr == 'PENDING') {
                        statusTrailing = const Chip(
                          label: Text('Cuisine 🍳', style: TextStyle(fontSize: 11)),
                          backgroundColor: Colors.orangeAccent,
                        );
                      } else {
                        statusTrailing = const Chip(
                          label: Text('Attente ⏳', style: TextStyle(fontSize: 11)),
                          backgroundColor: Colors.blueAccent,
                        );
                      }

                      return ListTile(
                        title: Text('$qty x $name'),
                        subtitle: nameAr != null ? Text(nameAr) : null,
                        trailing: statusTrailing,
                      );
                    }),
                    const Divider(),
                  ],
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
