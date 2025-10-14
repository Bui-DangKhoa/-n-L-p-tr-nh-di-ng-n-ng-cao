import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class LocalStorageService {
  static const String _userKey = 'user_data';
  static const String _cartKey = 'cart_data';

  // Lưu thông tin user vào local storage
  static Future<bool> saveUser(UserModel user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = json.encode(user.toMap());
      await prefs.setString(_userKey, userJson);
      print('✅ Đã lưu user vào local storage');
      return true;
    } catch (e) {
      print('❌ Lỗi lưu user vào local storage: $e');
      return false;
    }
  }

  // Lấy thông tin user từ local storage
  static Future<UserModel?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        final userMap = json.decode(userJson) as Map<String, dynamic>;
        return UserModel.fromMap(userMap);
      }
      return null;
    } catch (e) {
      print('❌ Lỗi đọc user từ local storage: $e');
      return null;
    }
  }

  // Xóa thông tin user khỏi local storage
  static Future<bool> removeUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userKey);
      print('✅ Đã xóa user khỏi local storage');
      return true;
    } catch (e) {
      print('❌ Lỗi xóa user khỏi local storage: $e');
      return false;
    }
  }

  // Alias cho removeUser (để consistency với API)
  static Future<bool> clearUser() async {
    return await removeUser();
  }

  // Lưu giỏ hàng vào local storage
  static Future<bool> saveCart(Map<String, dynamic> cartData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = json.encode(cartData);
      await prefs.setString(_cartKey, cartJson);
      return true;
    } catch (e) {
      print('❌ Lỗi lưu cart vào local storage: $e');
      return false;
    }
  }

  // Lấy giỏ hàng từ local storage
  static Future<Map<String, dynamic>?> getCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        return json.decode(cartJson) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('❌ Lỗi đọc cart từ local storage: $e');
      return null;
    }
  }

  // Xóa giỏ hàng khỏi local storage
  static Future<bool> removeCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_cartKey);
      return true;
    } catch (e) {
      print('❌ Lỗi xóa cart khỏi local storage: $e');
      return false;
    }
  }
}
