import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppSettings extends ChangeNotifier {
  Future<String> get appVersion =>
      PackageInfo.fromPlatform().then((value) => value.version);
}
