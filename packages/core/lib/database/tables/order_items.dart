import 'package:drift/drift.dart';
import '../../utils/uuid_generator.dart';

import 'orders.dart';
import 'products.dart';
import 'users.dart';

class OrderItems extends Table {
  TextColumn get id => text().clientDefault(newUuid)();
  TextColumn get orderId => text().references(Orders, #id)();
  TextColumn get productId =>
      text().references(Products, #id)();
  RealColumn get quantity => real()();
  RealColumn get unitPrice => real()();
  RealColumn get taxRate => real()();
  TextColumn get customNotes => text().nullable()();
  IntColumn get courseNumber =>
      integer().withDefault(const Constant(1))();
  BoolColumn get isFired =>
      boolean().withDefault(const Constant(false))();
  TextColumn get status =>
      text().withDefault(const Constant('PENDING'))();
  TextColumn get voidReason => text().nullable()();
  @ReferenceName('order_item_void_authorizer')
  TextColumn get voidAuthorizedBy =>
      text().nullable().references(Users, #id)();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
