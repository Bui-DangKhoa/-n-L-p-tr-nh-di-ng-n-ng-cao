import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _userModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _userModel != null;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    initAuthListener();
  }

  void initAuthListener() {
    _authService.authStateChanges.listen((firebaseUser) async {
      print("🔍 Auth state changed: ${firebaseUser?.email}");

      if (firebaseUser != null) {
        // Lấy user data (luôn có data nhờ fallback trong AuthService)
        _userModel = await _authService.getCurrentUserData();
        print("👤 User model: ${_userModel?.name} (${_userModel?.email})");
      } else {
        _userModel = null;
        print("👤 User logged out");
      }
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print("🔍 Đang đăng nhập với email: $email"); // Debug

    final error = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );

    if (error == null) {
      print("✅ Đăng nhập thành công!"); // Debug

      // Cập nhật ngay user data sau khi đăng nhập thành công
      _userModel = await _authService.getCurrentUserData();
      print(
        "👤 Đã cập nhật user data: ${_userModel?.name} (${_userModel?.email})",
      );

      _isLoading = false;
      _errorMessage = null;
      notifyListeners();
      return true;
    } else {
      print("❌ Đăng nhập thất bại: $error"); // Debug
      _isLoading = false;
      _errorMessage = error;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print("🔍 AuthProvider: Đang đăng ký với email: $email");

    try {
      final error = await _authService.createUserWithEmailAndPassword(
        email: email,
        password: password,
        name: name,
        phone: phone,
        address: address,
      );

      _isLoading = false;

      if (error == null) {
        print("✅ AuthProvider: Đăng ký thành công!");
        _errorMessage = null;

        // Force refresh user data sau khi đăng ký
        await _refreshUserData();

        notifyListeners();
        return true;
      } else {
        print("❌ AuthProvider: Đăng ký thất bại: $error");
        _errorMessage = error;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi không xác định: ${e.toString()}';
      print("🚨 AuthProvider: Exception: $e");
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userModel = null;
    notifyListeners();
  }

  // Phương thức cập nhật user model
  void updateUserModel(UserModel user) {
    _userModel = user;
    notifyListeners();
    print("👤 Đã cập nhật user model: ${user.name} (${user.email})");
  }

  // Phương thức cập nhật thông tin user với Firestore
  Future<bool> updateUserInfo({
    String? displayName,
    String? phoneNumber,
    String? address,
  }) async {
    if (_userModel == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Cập nhật trên Firestore
      final success = await FirestoreService.updateUserInfo(
        uid: _userModel!.id,
        displayName: displayName,
        phoneNumber: phoneNumber,
        address: address,
      );

      if (success) {
        // Cập nhật local model
        _userModel = _userModel!.copyWith(
          name: displayName ?? _userModel!.name,
          phone: phoneNumber ?? _userModel!.phone,
          address: address ?? _userModel!.address,
        );
        print("✅ Cập nhật thông tin thành công!");
      } else {
        _errorMessage = "Không thể cập nhật thông tin";
        print("❌ Cập nhật thông tin thất bại");
      }

      _isLoading = false;
      notifyListeners();
      return success;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi cập nhật: ${e.toString()}';
      print("🚨 AuthProvider updateUserInfo error: $e");
      notifyListeners();
      return false;
    }
  }

  // Method để refresh user data
  Future<void> _refreshUserData() async {
    try {
      _userModel = await _authService.getCurrentUserData();
      print("🔄 Đã refresh user data: ${_userModel?.name}");
    } catch (e) {
      print("⚠️ Lỗi khi refresh user data: $e");
    }
  }
}
