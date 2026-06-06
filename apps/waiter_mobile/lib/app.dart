import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/connection_page.dart';

class WaiterApp extends StatelessWidget {
  const WaiterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ritagestion Waiter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      home: const ConnectionPage(),
    );
  }
}
