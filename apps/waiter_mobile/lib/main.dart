import 'package:flutter/material.dart';

void main() {
  runApp(const WaiterMobileApp());
}

class WaiterMobileApp extends StatelessWidget {
  const WaiterMobileApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritagestion — Serveur',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const Scaffold(
        body: Center(
          child: Text('Ritagestion Waiter — Sprint 0'),
        ),
      ),
    );
  }
}
