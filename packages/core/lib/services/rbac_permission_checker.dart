/// RBAC permission matrix for WebSocket commands (security fix [HAUTE-A04]).
///
/// Based on `docs/architecture/07_security_and_auth.md` §2.
/// Roles: `WAITER`, `CASHIER`, `MANAGER`, `ADMIN`.
library;

/// Standardised user roles used across the WebSocket protocol.
final class UserRole {
  UserRole._();

  static const waiter = 'WAITER';
  static const cashier = 'CASHIER';
  static const manager = 'MANAGER';
  static const admin = 'ADMIN';

  /// All valid role strings.
  static const all = {waiter, cashier, manager, admin};

  /// Whether [role] is a known role string.
  static bool isValid(String? role) =>
      role != null && all.contains(role);
}

/// Checks whether a given role is allowed to perform a WebSocket action.
final class RbacPermissionChecker {
  RbacPermissionChecker() {
    // Allow overriding the matrix for tests, but keep a safe default.
    _matrix.addAll(_defaultMatrix);
  }

  final Map<String, Set<String>> _matrix = {};

  /// Default permission matrix — derived from doc 07.
  static final Map<String, Set<String>> _defaultMatrix = {
    // Read-only / standard waiter actions.
    WsCommands.createOrder: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.addItems: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.getOpenOrder: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.voidItem: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.requestBill: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.fireCourse: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.updateItemCourse: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.updateStock: const {UserRole.manager, UserRole.admin},
    // Manager-only / sensitive actions.
    WsCommands.applyDiscount: const {UserRole.manager, UserRole.admin},
    WsCommands.cancelOrder: const {UserRole.manager, UserRole.admin},
    WsCommands.closeCashSession: const {UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.voidPayment: const {UserRole.manager, UserRole.admin},
    WsCommands.payInPayout: const {UserRole.manager, UserRole.admin},
    // Heartbeat — always allowed.
    WsCommands.ping: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
    WsCommands.pong: const {UserRole.waiter, UserRole.cashier, UserRole.manager, UserRole.admin},
  };

  /// Returns `true` if [role] is allowed to execute [command].
  bool isAllowed(String command, String? role) {
    final allowed = _matrix[command];
    if (allowed == null) {
      // Unknown command — default deny.
      return false;
    }
    return role != null && allowed.contains(role);
  }

  /// Returns the set of roles allowed to run [command].
  Set<String>? rolesFor(String command) => _matrix[command];

  /// Whether [command] is known to the matrix.
  bool isKnownCommand(String command) => _matrix.containsKey(command);
}

/// Canonical WebSocket command names (mirrors WsAction constants).
final class WsCommands {
  WsCommands._();

  static const createOrder = 'CREATE_ORDER';
  static const addItems = 'ADD_ITEMS';
  static const getOpenOrder = 'GET_OPEN_ORDER';
  static const voidItem = 'VOID_ITEM';
  static const requestBill = 'REQUEST_BILL';
  static const fireCourse = 'FIRE_COURSE';
  static const updateItemCourse = 'UPDATE_ITEM_COURSE';
  static const updateStock = 'UPDATE_STOCK';
  static const applyDiscount = 'APPLY_DISCOUNT';
  static const cancelOrder = 'CANCEL_ORDER';
  static const closeCashSession = 'CLOSE_CASH_SESSION';
  static const voidPayment = 'VOID_PAYMENT';
  static const payInPayout = 'PAY_IN_PAYOUT';
  static const ack = 'ACK';
  static const ping = 'PING';
  static const pong = 'PONG';
}