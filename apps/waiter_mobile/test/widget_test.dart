// Smoke test — minimal, sans bootstrap natif (Drift/SQLite, path_provider).
//
// L'intégration réseau mobile ↔ PC se valide manuellement ou via test E2E dédié.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test — MaterialApp se construit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Ritagestion Waiter',
        home: Scaffold(
          body: Center(child: Text('Ritagestion Waiter')),
        ),
      ),
    );

    expect(find.text('Ritagestion Waiter'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
