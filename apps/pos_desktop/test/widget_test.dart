// Smoke test — vérifie que Flutter peut exécuter un test sans crash.
//
// Ce test est volontairement minimal car l'application dépend de packages
// natifs (Drift/SQLite, window_manager, google_fonts) qui ne compilent pas
// dans l'environnement de test Flutter standard.
//
// Les vrais tests BLoC sont dans test/blocs/.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Smoke test — MaterialApp se construit', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        title: 'Ritagestion — Caisse',
        home: Scaffold(
          body: Center(child: Text('Ritagestion POS')),
        ),
      ),
    );

    expect(find.text('Ritagestion POS'), findsOneWidget);
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
