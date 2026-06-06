import 'package:flutter/material.dart';

import 'app.dart';
import 'di/app_bootstrap.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppBootstrap.instance.initialize();
  runApp(const WaiterApp());
}
