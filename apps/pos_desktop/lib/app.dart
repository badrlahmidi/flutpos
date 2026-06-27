import 'package:flutter/material.dart';

import 'di/app_bootstrap.dart';
import 'navigation/app_router.dart';
import 'theme/app_theme.dart';

/// Racine MaterialApp — démarre sur l'écran PIN.
class RitagestionPosApp extends StatefulWidget {
  const RitagestionPosApp({super.key});

  @override
  State<RitagestionPosApp> createState() => _RitagestionPosAppState();
}

class _RitagestionPosAppState extends State<RitagestionPosApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    AppBootstrap.instance.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.detached) {
      AppBootstrap.instance.dispose();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ritagestion — Caisse',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}