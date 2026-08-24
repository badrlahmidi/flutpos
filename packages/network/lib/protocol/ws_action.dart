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

  /// Mobile → PC : demande de couplage terminal (security fix [HAUTE-N02]).
  static const pairingRequest = 'PAIRING_REQUEST';

  /// PC → Mobile : réponse au couplage (succès/échec).
  static const pairingResponse = 'PAIRING_RESPONSE';

  /// Mobile → PC : appliquer une remise (manager-only).
  static const applyDiscount = 'APPLY_DISCOUNT';

  /// Mobile → PC : annuler une commande (manager-only).
  static const cancelOrder = 'CANCEL_ORDER';

  /// Mobile → PC : clôturer une session de caisse (manager/cashier).
  static const closeCashSession = 'CLOSE_CASH_SESSION';

  /// Mobile → PC : annuler un paiement (manager-only).
  static const voidPayment = 'VOID_PAYMENT';

  /// Mobile → PC : mouvement de caisse (apport/retrait, manager-only).
  static const payInPayout = 'PAY_IN_PAYOUT';

  /// PC → Mobile : erreur de validation payload (security fix [HAUTE-N03]).
  static const error = 'ERROR';

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
