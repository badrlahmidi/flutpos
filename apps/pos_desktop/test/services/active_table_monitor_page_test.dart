import 'package:core/core.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pos_desktop/di/service_locator.dart';
import 'package:pos_desktop/pages/floor_plan/active_table_monitor_page.dart';
import 'package:drift/drift.dart' show Value;

void main() {
  late AppDatabase db;
  late OrderRepository orders;
  late User user;

  setUp(() async {
    db = AppDatabase(NativeDatabase.memory());
    orders = OrderRepositoryImpl(db, AuditRepositoryImpl(db));
    
    // Register in GetIt service locator
    sl.registerSingleton<AppDatabase>(db);
    sl.registerSingleton<OrderRepository>(orders);

    user = User(
      id: 'waiter-1',
      name: 'Serveur Test',
      pinHash: 'hash',
      role: 'WAITER',
      accessLevel: 3,
      isActive: true,
      failedAttempts: 0,
      createdAt: DateTime.now(),
    );

    await db.into(db.users).insert(
          UsersCompanion.insert(
            id: const Value('waiter-1'),
            name: 'Serveur Test',
            pinHash: 'hash',
            role: 'WAITER',
          ),
        );
  });

  tearDown(() async {
    await db.close();
    await sl.reset();
  });

  testWidgets('ActiveTableMonitorPage displays empty state when no tables are active', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ActiveTableMonitorPage(user: user, startTimer: false),
      ),
    );

    await tester.pump(); // Start loading
    await tester.pump(const Duration(milliseconds: 100)); // Finish loading

    expect(find.text('Aucune table occupée'), findsOneWidget);
    expect(find.text('Toutes les tables sont disponibles'), findsOneWidget);

    // Unmount to trigger dispose and cancel active timers
    await tester.pumpWidget(const SizedBox());
    await tester.idle();
  });
}
