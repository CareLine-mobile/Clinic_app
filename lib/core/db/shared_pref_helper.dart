import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../features/user_data/user_model.dart';
import '../utils/app_constans.dart';

class SharedPrefHelper {
  static const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  // ── Write ─────────────────────────────────────────────────

  static Future<bool> saveJson({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      await storage.write(key: key, value: jsonEncode(value));
      return true;
    } catch (e) {
      return false;
    }
  }

  // ── Read ──────────────────────────────────────────────────

  /// Returns raw String (token, simple values)
  static Future<String?> getString({required String key}) async {
    try {
      return await storage.read(key: key);
    } catch (e) {
      return null;
    }
  }

  /// Returns decoded JSON map
  static Future<Map<String, dynamic>?> getJson({required String key}) async {
    try {
      final jsonString = await storage.read(key: key);
      if (jsonString != null && jsonString.isNotEmpty) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Returns the persisted user (uses auth UserModel)
  static Future<UserModel?> getUserData() async {
    try {
      final json = await getJson(key: AppConstants.userKey);
      if (json != null) return UserModel.fromJson(json);
      return null;
    } catch (e) {
      return null;
    }
  }

  // ── Delete ────────────────────────────────────────────────

  static Future<void> delete({required String key}) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      return;
    }
  }

  static Future<void> clearAll() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      return;
    }
  }

  // ── Utils ─────────────────────────────────────────────────

  static Future<bool> containsKey({required String key}) async {
    try {
      return await storage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }
}