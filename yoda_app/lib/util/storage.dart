import 'package:hive_flutter/hive_flutter.dart';

class Storage {
  late Box box;

  static Storage instance = Storage._();
  Storage._();

  Future initialize() async {
    await Hive.initFlutter();
    box = await Hive.openBox("general");
  }

  Future<Map?> read(String key) async {
    return await box.get(key);
  }

  Future write(String key, dynamic value) async {
    await box.put(key, value);
  }

  Future delete(String key) async {
    await box.delete(key);
  }
}
