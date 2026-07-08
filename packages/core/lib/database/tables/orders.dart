import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'cash_sessions.dart';
import 'restaurant_tables.dart';
import 'users.dart';

class Orders extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get sessionId =>
      text().references(CashSessions, #id)();
  @ReferenceName('order_waiter')
  TextColumn get waiterId => text().references(Users, #id)();
  TextColumn get tableId =>
      text().nullable().references(RestaurantTables, #id)();
  TextColumn get customerId =>
      text().nullable()(); // No hard FK to avoid circular dependencies for now, or we can use references
  TextColumn get orderType => text()();
  TextColumn get source =>
      text().withDefault(const Constant('MANUAL'))();
  TextColumn get externalRef => text().nullable()();
  TextColumn get status =>
      text().withDefault(const Constant('OPEN'))();
  TextColumn get discountType => text().nullable()();
  RealColumn get discountValue => real().nullable()();
  TextColumn get discountReason => text().nullable()();
  @ReferenceName('order_discount_authorizer')
  TextColumn get discountAuthorizedBy =>
      text().nullable().references(Users, #id)();
  IntColumn get guestCount =>
      integer().withDefault(const Constant(1))();
  /// Instructions globales (allergies, événement, etc.).
  TextColumn get notes => text().nullable()();
  /// Facture entreprise (scénario #34 / étape 7 Sprint 3).
  TextColumn get companyName => text().nullable()();
  TextColumn get companyIce => text().nullable()();
  IntColumn get invoiceNumber => integer().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
