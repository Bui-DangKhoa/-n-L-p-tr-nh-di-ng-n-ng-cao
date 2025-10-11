import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import 'local_storage_service.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;

    print("👤 Đang lấy user data cho: ${user.email}");

    try {
      // Thử lấy từ Firestore trước
      final firestoreUser = await FirestoreService.getUserDocument(user.uid);
      if (firestoreUser != null) {
        print("✅ Lấy user data từ Firestore thành công");
        return firestoreUser;
      }
    } catch (e) {
      print("⚠️ Lỗi khi lấy từ Firestore: $e");
    }

    try {
      // Thử lấy từ Local Storage
      final localUser = await LocalStorageService.getUser();
      if (localUser != null && localUser.id == user.uid) {
        print("✅ Lấy user data từ Local Storage thành công");
        return localUser;
      }
    } catch (e) {
      print("⚠️ Lỗi khi lấy từ Local Storage: $e");
    }

    // Fallback: Tạo user data từ Firebase Auth
    print("📱 Fallback: Sử dụng Firebase Auth data");
    return UserModel(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      phone: '',
      address: '',
      role: 'customer',
      createdAt: DateTime.now(),
    );
  }

  Future<String?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return null;
    } on FirebaseAuthException catch (e) {
      print('🔥 Firebase Auth Error: ${e.code} - ${e.message}');
      switch (e.code) {
        case 'user-not-found':
          return 'Không tìm thấy tài khoản với email này.';
        case 'wrong-password':
          return 'Mật khẩu không đúng.';
        case 'invalid-email':
          return 'Email không hợp lệ.';
        case 'user-disabled':
          return 'Tài khoản đã bị vô hiệu hóa.';
        case 'too-many-requests':
          return 'Quá nhiều yêu cầu. Vui lòng thử lại sau.';
        default:
          return e.message ?? 'Đăng nhập thất bại.';
      }
    } catch (e) {
      print('🚨 General Error: $e');
      return 'Lỗi kết nối. Vui lòng kiểm tra internet và thử lại.';
    }
  }

  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
    required String name,
    required String phone,
    required String address,
  }) async {
    try {
      print('🚀 Bắt đầu đăng ký với email: $email');

      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ Tạo Firebase Auth thành công: ${credential.user!.uid}');

      // Cập nhật displayName cho Firebase User
      await credential.user!.updateDisplayName(name);
      await credential.user!.reload();
      print('✅ Đã cập nhật displayName: $name');

      final user = UserModel(
        id: credential.user!.uid,
        email: email,
        name: name,
        phone: phone,
        address: address,
        role: 'customer',
        createdAt: DateTime.now(),
      );

      print('💾 Đang lưu user data vào Firestore...');

      // Thử lưu với timeout và retry, nếu lỗi thì vẫn cho đăng ký thành công
      try {
        await _saveUserDataWithRetry(user);
        print('✅ Đăng ký hoàn tất thành công!');
      } catch (firestoreError) {
        print(
          '⚠️ Lưu Firestore thất bại, thử lưu local storage: $firestoreError',
        );
        // Fallback: lưu vào local storage
        final localSaved = await LocalStorageService.saveUser(user);
        if (localSaved) {
          print('✅ Đã lưu user vào local storage thành công!');
        } else {
          print('❌ Lưu local storage cũng thất bại');
        }
      }

      return null;
    } on FirebaseAuthException catch (e) {
      print('🔥 Firebase Auth Error (Register): ${e.code} - ${e.message}');

      // Cleanup nếu có user được tạo nhưng lưu data thất bại
      try {
        if (_auth.currentUser != null) {
          await _auth.currentUser!.delete();
          print('🗑️ Đã xóa user Auth do lỗi');
        }
      } catch (deleteError) {
        print('⚠️ Không thể xóa user Auth: $deleteError');
      }

      switch (e.code) {
        case 'weak-password':
          return 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.';
        case 'email-already-in-use':
          return 'Email này đã được sử dụng. Vui lòng sử dụng email khác.';
        case 'invalid-email':
          return 'Email không hợp lệ.';
        case 'operation-not-allowed':
          return 'Đăng ký bằng email/mật khẩu chưa được kích hoạt.';
        case 'network-request-failed':
          return 'Lỗi mạng. Vui lòng kiểm tra kết nối internet.';
        default:
          return e.message ?? 'Đăng ký thất bại.';
      }
    } catch (e) {
      print('🚨 General Error (Register): $e');
      return 'Lỗi kết nối. Vui lòng kiểm tra internet và thử lại.';
    }
  }

  // Helper method để lưu user data với retry mechanism
  Future<void> _saveUserDataWithRetry(
    UserModel user, {
    int maxRetries = 2,
  }) async {
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      try {
        print('📝 Lần thử $attempt/$maxRetries: Lưu user data...');

        await _firestore
            .collection('users')
            .doc(user.id)
            .set(user.toMap())
            .timeout(const Duration(seconds: 8)); // Giảm timeout

        print('✅ Lưu user data thành công!');
        return; // Success, exit the retry loop
      } catch (e) {
        print('❌ Lần thử $attempt failed: $e');

        if (attempt == maxRetries) {
          // Last attempt failed, throw warning not error
          print(
            '⚠️ Không thể lưu thông tin người dùng sau $maxRetries lần thử. User vẫn được tạo với Auth.',
          );
          throw Exception(
            'Tài khoản đã được tạo nhưng một số thông tin có thể chưa được lưu. Bạn vẫn có thể đăng nhập.',
          );
        }

        // Wait before retrying (shorter delay)
        await Future.delayed(Duration(milliseconds: 500 * attempt));
      }
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
