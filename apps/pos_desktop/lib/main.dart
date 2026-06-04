import 'package:flutter/material.dart';

import 'app.dart';
import 'di/app_bootstrap.dart';
import 'platform/desktop_window.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DesktopWindow.configureKiosk();
  await AppBootstrap.instance.initialize();
  runApp(const RitagestionPosApp());
}
