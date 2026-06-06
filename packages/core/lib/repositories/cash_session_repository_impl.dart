import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../entities/cash_session_report.dart';
import '../enums/audit_action.dart';
import '../enums/audit_target_type.dart';
import '../enums/payment_method.dart';
import '../usecases/money_math.dart';
import '../utils/uuid_generator.dart';
import 'audit_repository.dart';
import 'cash_session_repository.dart';

class CashSessionRepositoryImpl implements CashSessionRepository {
  CashSessionRepositoryImpl(this._db, this._audit);

  final AppDatabase _db;
  final AuditRepository _audit;

  @override
  Future<CashSession?> getOpenSessionForCashier(String cashierId) {
    return (_db.select(_db.cashSessions)
          ..where(
            (s) =>
                s.cashierId.equals(cashierId) & s.status.equals('OPEN'),
          )
          ..orderBy([(s) => OrderingTerm.desc(s.openedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<CashSession?> getAnyOpenSession() {
    return (_db.select(_db.cashSessions)
          ..where((s) => s.status.equals('OPEN'))
          ..orderBy([(s) => OrderingTerm.desc(s.openedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  @override
  Future<CashSessionReport> buildSessionReport(String sessionId) async {
    final session = await (_db.select(_db.cashSessions)
          ..where((s) => s.id.equals(sessionId)))
        .getSingleOrNull();
    if (session == null) {
      throw StateError('Session introuvable');
    }

    final cashier = await (_db.select(_db.users)
          ..where((u) => u.id.equals(session.cashierId)))
        .getSingle();

    final orders = await (_db.select(_db.orders)
          ..where((o) => o.sessionId.equals(sessionId)))
        .get();

    var cashSales = 0.0;
    var cardSales = 0.0;
    var otherSales = 0.0;
    var paidOrdersCount = 0;
    var openOrdersCount = 0;
    final salesByMethod = <String, double>{};

    for (final order in orders) {
      if (order.status == 'PAID') {
        paidOrdersCount++;
      } else if (order.status != 'CANCELLED' && order.status != 'VOID') {
        openOrdersCount++;
      }

      if (order.status != 'PAID') {
        continue;
      }

      final payments = await (_db.select(_db.payments)
            ..where((p) => p.orderId.equals(order.id)))
          .get();

      for (final payment in payments) {
        final amount = payment.amount;
        totalAdd(salesByMethod, payment.paymentMethod, amount);

        final method = PaymentMethod.fromDb(payment.paymentMethod);
        switch (method) {
          case PaymentMethod.cash:
            cashSales += amount;
          case PaymentMethod.tpe:
          case PaymentMethod.card:
            cardSales += amount;
          case PaymentMethod.cheque:
          case PaymentMethod.voucher:
          case PaymentMethod.employeeMeal:
          case null:
            otherSales += amount;
        }
      }
    }

    final movements = await getMovementsForSession(sessionId);
    var payInTotal = 0.0;
    var payOutTotal = 0.0;
    for (final movement in movements) {
      if (movement.type == 'PAY_IN') {
        payInTotal += movement.amount;
      } else if (movement.type == 'PAY_OUT') {
        payOutTotal += movement.amount;
      }
    }

    cashSales = roundMoney(cashSales);
    cardSales = roundMoney(cardSales);
    otherSales = roundMoney(otherSales);
    payInTotal = roundMoney(payInTotal);
    payOutTotal = roundMoney(payOutTotal);

    final expectedCashBalance = roundMoney(
      session.openingBalance + cashSales + payInTotal - payOutTotal,
    );

    return CashSessionReport(
      session: session,
      cashierName: cashier.name,
      openingBalance: session.openingBalance,
      cashSales: cashSales,
      cardSales: cardSales,
      otherSales: otherSales,
      totalSales: roundMoney(cashSales + cardSales + otherSales),
      payInTotal: payInTotal,
      payOutTotal: payOutTotal,
      expectedCashBalance: expectedCashBalance,
      paidOrdersCount: paidOrdersCount,
      openOrdersCount: openOrdersCount,
      movements: movements,
      salesByMethod: salesByMethod.map(
        (key, value) => MapEntry(key, roundMoney(value)),
      ),
    );
  }

  @override
  Future<List<CashMovement>> getMovementsForSession(String sessionId) {
    return (_db.select(_db.cashMovements)
          ..where((m) => m.sessionId.equals(sessionId))
          ..orderBy([(m) => OrderingTerm.desc(m.createdAt)]))
        .get();
  }

  @override
  Future<CashSession> openSession({
    required String userId,
    required double openingBalance,
  }) async {
    final existing = await getOpenSessionForCashier(userId);
    if (existing != null) {
      return existing;
    }

    final id = newUuid();
    await _db.into(_db.cashSessions).insert(
          CashSessionsCompanion.insert(
            id: Value(id),
            cashierId: userId,
            openedAt: DateTime.now().toUtc(),
            openingBalance: openingBalance,
          ),
        );
    return (_db.select(_db.cashSessions)..where((s) => s.id.equals(id)))
        .getSingle();
  }

  @override
  Future<CashMovement> payIn({
    required String userId,
    required String sessionId,
    required double amount,
    required String reason,
  }) async {
    await _audit.logActionTyped(
      userId: userId,
      action: AuditAction.payIn,
      targetType: AuditTargetType.cashSession,
      targetId: sessionId,
      details: {
        'amount': amount,
        'reason': reason,
        'type': 'PAY_IN',
      },
    );

    return _insertMovement(
      sessionId: sessionId,
      userId: userId,
      type: 'PAY_IN',
      amount: amount,
      reason: reason,
    );
  }

  @override
  Future<CashMovement> payOut({
    required String userId,
    required String sessionId,
    required double amount,
    required String reason,
  }) async {
    await _audit.logActionTyped(
      userId: userId,
      action: AuditAction.payOut,
      targetType: AuditTargetType.cashSession,
      targetId: sessionId,
      details: {
        'amount': amount,
        'reason': reason,
        'type': 'PAY_OUT',
      },
    );

    return _insertMovement(
      sessionId: sessionId,
      userId: userId,
      type: 'PAY_OUT',
      amount: amount,
      reason: reason,
    );
  }

  @override
  Future<CashSession> closeSession({
    required String userId,
    required String sessionId,
    required double closingBalance,
    required double expectedBalance,
    String? closingNote,
  }) async {
    final variance = closingBalance - expectedBalance;

    await _audit.logActionTyped(
      userId: userId,
      action: AuditAction.closeSession,
      targetType: AuditTargetType.cashSession,
      targetId: sessionId,
      details: {
        'closingBalance': closingBalance,
        'expectedBalance': expectedBalance,
        'variance': variance,
        if (closingNote != null) 'closingNote': closingNote,
      },
    );

    final now = DateTime.now().toUtc();
    await (_db.update(_db.cashSessions)..where((s) => s.id.equals(sessionId)))
        .write(
      CashSessionsCompanion(
        closedAt: Value(now),
        closingBalance: Value(closingBalance),
        expectedBalance: Value(expectedBalance),
        closingNote: Value(closingNote),
        status: const Value('CLOSED'),
      ),
    );

    return (_db.select(_db.cashSessions)..where((s) => s.id.equals(sessionId)))
        .getSingle();
  }

  Future<CashMovement> _insertMovement({
    required String sessionId,
    required String userId,
    required String type,
    required double amount,
    required String reason,
  }) async {
    final id = newUuid();
    await _db.into(_db.cashMovements).insert(
          CashMovementsCompanion.insert(
            id: Value(id),
            sessionId: sessionId,
            userId: userId,
            type: type,
            amount: amount,
            reason: reason,
            createdAt: DateTime.now().toUtc(),
          ),
        );
    return (_db.select(_db.cashMovements)..where((m) => m.id.equals(id)))
        .getSingle();
  }

  void totalAdd(Map<String, double> map, String key, double amount) {
    map[key] = (map[key] ?? 0) + amount;
  }
}
