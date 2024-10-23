import 'package:flutter/material.dart';
import 'util/storage.dart';

import 'locator.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Storage.instance.initialize();
  await setupServiceLocator();

  runApp(const App());
}
