import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';

class AuthProviderOffline with ChangeNotifier {
  final AuthService _authService = AuthService();
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get user => _userModel;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _userModel != null;
  String? get errorMessage => _errorMessage;

  AuthProviderOffline() {
    initAuthListener();
  }

  void initAuthListener() {
    _authService.authStateChanges.listen((firebaseUser) async {
      print("🔍 [OFFLINE] Auth state changed: ${firebaseUser?.email}");

      if (firebaseUser != null) {
        // Chỉ dùng Firebase Auth, không dùng Firestore
        _userModel = UserModel(
          id: firebaseUser.uid,
          email: firebaseUser.email ?? '',
          name: firebaseUser.displayName ?? 'User',
          phone: '',
          address: '',
          role: 'customer',
          createdAt: DateTime.now(),
        );
        print(
          "👤 [OFFLINE] User model: ${_userModel?.name} (${_userModel?.email})",
        );
      } else {
        _userModel = null;
        print("👤 [OFFLINE] User logged out");
      }
      notifyListeners();
    });
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    print("🔍 [OFFLINE] Đang đăng nhập với email: $email");

    final error = await _authService.signInWithEmailAndPassword(
      email,
      password,
    );

    if (error == null) {
      print("✅ [OFFLINE] Đăng nhập thành công!");
      _errorMessage = null;
    } else {
      print("❌ [OFFLINE] Đăng nhập thất bại: $error");
      _errorMessage = error;
    }

    _isLoading = false;
    notifyListeners();
    return error == null;
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

    print("🔍 [OFFLINE] Đang đăng ký với email: $email");

    try {
      // Chỉ tạo Firebase Auth, không lưu Firestore
      final auth = FirebaseAuth.instance;
      final result = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Cập nhật displayName
      await result.user?.updateDisplayName(name);

      _isLoading = false;
      print("✅ [OFFLINE] Đăng ký thành công!");
      _errorMessage = null;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _isLoading = false;
      String errorMessage = "";

      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = "Email đã được sử dụng";
          break;
        case 'weak-password':
          errorMessage = "Mật khẩu quá yếu";
          break;
        case 'invalid-email':
          errorMessage = "Email không hợp lệ";
          break;
        default:
          errorMessage = e.message ?? "Đăng ký thất bại";
      }

      _errorMessage = errorMessage;
      print("❌ [OFFLINE] Đăng ký thất bại: $errorMessage");
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi không xác định: ${e.toString()}';
      print("🚨 [OFFLINE] Exception: $e");
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    _userModel = null;
    notifyListeners();
  }

  // Phương thức cập nhật user model (chỉ local)
  void updateUserModel(UserModel user) {
    _userModel = user;
    notifyListeners();
    print("👤 [OFFLINE] Đã cập nhật user model: ${user.name} (${user.email})");
  }

  // Phương thức cập nhật thông tin user (chỉ local)
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
      // Chỉ cập nhật local model, không dùng Firestore
      _userModel = _userModel!.copyWith(
        name: displayName ?? _userModel!.name,
        phone: phoneNumber ?? _userModel!.phone,
        address: address ?? _userModel!.address,
      );

      // Cập nhật Firebase Auth displayName nếu có
      if (displayName != null) {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(displayName);
      }

      print("✅ [OFFLINE] Cập nhật thông tin thành công!");
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Lỗi cập nhật: ${e.toString()}';
      print("🚨 [OFFLINE] updateUserInfo error: $e");
      notifyListeners();
      return false;
    }
  }
}
