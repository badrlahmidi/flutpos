import 'package:flutter/material.dart';
import 'package:core/core.dart';

import 'app.dart';
import 'di/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ensureAppLocaleDateFormatting();
  await AppBootstrap.instance.initialize();
  runApp(const WaiterApp());
}
