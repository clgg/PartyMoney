import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/app_data.dart';

class StorageService {
  static const String _key = 'app_data_json_v1';

  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  SharedPreferences? _prefs;
  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  Future<AppData> loadData() async {
    await init();
    final s = _prefs!.getString(_key);
    if (s == null || s.isEmpty) return AppData();
    try {
      return AppData.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return AppData();
    }
  }

  Future<void> saveData(AppData data) async {
    await init();
    await _prefs!.setString(_key, jsonEncode(data.toJson()));
  }

  String generateId() {
    return const Uuid().v4();
  }
}
