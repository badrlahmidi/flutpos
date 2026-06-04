import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';

/// Configuration fenêtre caisse Windows (plein écran, fermeture bloquée).
abstract final class DesktopWindow {
  DesktopWindow._();

  static bool get isKioskTarget =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.windows;

  static Future<void> configureKiosk() async {
    if (!isKioskTarget) {
      return;
    }

    await windowManager.ensureInitialized();

    const options = WindowOptions(
      size: Size(1280, 720),
      center: true,
      title: 'Ritagestion — Caisse',
      titleBarStyle: TitleBarStyle.hidden,
      fullScreen: true,
    );

    windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      await windowManager.focus();
      await windowManager.setFullScreen(true);
    });

    await windowManager.setPreventClose(true);
  }
}
