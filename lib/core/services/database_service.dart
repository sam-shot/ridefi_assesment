import 'package:hive_flutter/hive_flutter.dart';
import 'package:injectable/injectable.dart';

abstract class DatabaseService {
  Future<void> init();
  Future<void> put(String boxName, String key, dynamic value);
  Future<dynamic> get(String boxName, String key);
  Future<List<dynamic>> getAll(String boxName);
  Future<void> delete(String boxName, String key);
  Future<void> clear(String boxName);
}

@LazySingleton(as: DatabaseService)
class DatabaseServiceImpl implements DatabaseService {
  @override
  Future<void> init() async {
    await Hive.initFlutter();
  }

  @override
  Future<void> put(String boxName, String key, dynamic value) async {
    final box = await Hive.openBox<dynamic>(boxName);
    await box.put(key, value);
  }

  @override
  Future<dynamic> get(String boxName, String key) async {
    final box = await Hive.openBox<dynamic>(boxName);
    return box.get(key);
  }

  @override
  Future<List<dynamic>> getAll(String boxName) async {
    final box = await Hive.openBox<dynamic>(boxName);
    return box.values.toList();
  }

  @override
  Future<void> delete(String boxName, String key) async {
    final box = await Hive.openBox<dynamic>(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clear(String boxName) async {
    final box = await Hive.openBox<dynamic>(boxName);
    await box.clear();
  }
}
