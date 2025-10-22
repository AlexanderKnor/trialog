import 'package:shared_preferences/shared_preferences.dart';
import 'package:trialog/core/errors/exceptions.dart';

/// Local storage service using SharedPreferences
class StorageService {
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  /// Save string value
  Future<void> saveString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save string: $e',
        details: {'key': key},
      );
    }
  }

  /// Get string value
  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get string: $e',
        details: {'key': key},
      );
    }
  }

  /// Save integer value
  Future<void> saveInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save int: $e',
        details: {'key': key},
      );
    }
  }

  /// Get integer value
  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get int: $e',
        details: {'key': key},
      );
    }
  }

  /// Save boolean value
  Future<void> saveBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save bool: $e',
        details: {'key': key},
      );
    }
  }

  /// Get boolean value
  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get bool: $e',
        details: {'key': key},
      );
    }
  }

  /// Save double value
  Future<void> saveDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save double: $e',
        details: {'key': key},
      );
    }
  }

  /// Get double value
  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get double: $e',
        details: {'key': key},
      );
    }
  }

  /// Save string list
  Future<void> saveStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException(
        message: 'Failed to save string list: $e',
        details: {'key': key},
      );
    }
  }

  /// Get string list
  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to get string list: $e',
        details: {'key': key},
      );
    }
  }

  /// Remove value
  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException(
        message: 'Failed to remove value: $e',
        details: {'key': key},
      );
    }
  }

  /// Clear all values
  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw const CacheException(
        message: 'Failed to clear storage',
      );
    }
  }

  /// Check if key exists
  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  /// Get all keys
  Set<String> getKeys() {
    return _prefs.getKeys();
  }
}
