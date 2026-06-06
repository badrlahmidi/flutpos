/// Actions WebSocket supportées par le protocole RitajPOS.
///
/// Voir `docs/architecture/03_network_protocol.md` §5.
abstract final class WsAction {
  /// Mobile → PC : ouverture d'une nouvelle commande / table.
  static const createOrder = 'CREATE_ORDER';

  /// Mobile → PC : ajout d'articles à une commande existante.
  static const addItems = 'ADD_ITEMS';

  /// Mobile → PC : récupère le ticket ouvert d'une table (sync miroir).
  static const getOpenOrder = 'GET_OPEN_ORDER';

  /// Mobile → PC : annulation d'un article (void).
  static const voidItem = 'VOID_ITEM';

  /// Mobile → PC : demande d'addition / facture proforma.
  static const requestBill = 'REQUEST_BILL';

  /// Mobile → PC : réclamer la suite (fire course).
  static const fireCourse = 'FIRE_COURSE';

  /// Mobile → PC : changer la course d'une ligne.
  static const updateItemCourse = 'UPDATE_ITEM_COURSE';

  /// Mobile → PC : mise à jour stock temps réel.
  static const updateStock = 'UPDATE_STOCK';

  /// PC → Mobile : accusé de réception idempotent.
  static const ack = 'ACK';

  /// PC → Mobile : alerte rupture de stock.
  static const stockAlert = 'STOCK_ALERT';

  /// PC → Mobile : changement de statut commande (KDS prêt).
  static const orderStatusChanged = 'ORDER_STATUS_CHANGED';

  /// Bidirectionnel : heartbeat serveur → client.
  static const ping = 'PING';

  /// Bidirectionnel : réponse heartbeat client → serveur.
  static const pong = 'PONG';
}
