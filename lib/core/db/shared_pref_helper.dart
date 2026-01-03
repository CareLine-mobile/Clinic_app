import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../features/user_data/user_model.dart';
import '../utils/app_constans.dart';




class SharedPrefHelper {
  static const FlutterSecureStorage storage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );



  // Save an object as JSON string
  static Future<bool> saveJson({
    required String key,
    required Map<String, dynamic> value,
  }) async {
    try {
      final jsonString = jsonEncode(value);
      await storage.write(key: key, value: jsonString);
   //   DebuggerHelper.success('JSON saved successfully');
      return true;
    } catch (e,s) {
    //  DebuggerHelper.error('Error saving JSON: $e',stackTrace: s);
      return false;
    }
  }

  // Retrieve data as string
  static Future<String?> getData({required String key}) async {
    try {
      return await storage.read(key: key);
    } catch (e,s) {
    //  DebuggerHelper.error('ErrorgetData : $e',stackTrace: s);
      return null;
    }
  }



  // Retrieve JSON object
  static Future<Map<String, dynamic>?> getJson({required String key}) async {
    try {
      final jsonString = await storage.read(key: key);
      if (jsonString != null && jsonString.isNotEmpty) {
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e,s) {
   //   DebuggerHelper.error('Error getJson : $e',stackTrace: s);
      return null;
    }
  }
  static Future<UserModel?> getUserData() async {
    try {
      final jsonString = await storage.read(key: AppConst.userKey);
      if (jsonString != null && jsonString.isNotEmpty) {
        return UserModel.fromJson(jsonDecode(jsonString));
      }
      return null;
    } catch (e,s) {
 //     DebuggerHelper.error('Error getUserData : $e',stackTrace: s);

      return null;
    }
  }



  // Delete specific key
  static Future<void> delete({required String key}) async {
    try {
      await storage.delete(key: key);
    } catch (e) {
      print('Error deleting key: $e');
    }
  }

  // Clear all data
  static Future<void> clearAll() async {
    try {
      await storage.deleteAll();
    } catch (e) {
      print('Error clearing all data: $e');
    }
  }

  // Check if key exists
  static Future<bool> containsKey({required String key}) async {
    try {
      final value = await storage.read(key: key);
      return value != null;
    } catch (e) {
      print('Error checking key: $e');
      return false;
    }
  }
}