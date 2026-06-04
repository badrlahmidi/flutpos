import '../database/app_database.dart';
import '../entities/kds_order_ticket.dart';

/// Tickets cuisine en attente sur le KDS.
abstract class KdsRepository {
  Future<List<KdsOrderTicket>> loadPendingTickets();

  Stream<List<KdsOrderTicket>> watchPendingTickets();

  /// Marque une ligne prête (`PREPARING`) pour retrait serveur.
  Future<OrderItem> markOrderItemReady(String orderItemId);
}
