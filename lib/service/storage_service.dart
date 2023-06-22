import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  SharedPreferences? _preferences;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static final StorageService _instance = StorageService._internal();

  StorageService._internal();

  static final StorageService shared = _instance;

  Future<bool> setString(String key, String value) async {
    return _preferences?.setString(key, value) ?? Future.value(false);
  }

  String? getString(String key) {
    return _preferences?.getString(key);
  }

  Future<bool>? deleteString(String key) {
    return _preferences?.remove(key);
  }

  Future setSecureData(String key, String value) async {
    return _secureStorage.write(key: key, value: value);
  }

  Future<String?> readSecureData(String key) {
    return _secureStorage.read(key: key);
  }

  void removeSecureData(String key) {
    _secureStorage.delete(key: key);
  }
}
