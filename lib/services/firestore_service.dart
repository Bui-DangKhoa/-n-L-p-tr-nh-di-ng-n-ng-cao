import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Timeout cho các operations
  static const Duration _timeout = Duration(seconds: 10);

  /// Kiểm tra kết nối Firestore
  static Future<bool> checkConnection() async {
    try {
      await _firestore.enableNetwork().timeout(_timeout);
      return true;
    } catch (e) {
      print('🚨 Firestore connection error: $e');
      return false;
    }
  }

  /// Lấy user document từ Firestore với error handling
  static Future<UserModel?> getUserDocument(String uid) async {
    try {
      print('🔍 [Firestore] Getting user document for UID: $uid');

      // Kiểm tra kết nối trước
      final isConnected = await checkConnection();
      if (!isConnected) {
        print('⚠️ [Firestore] No connection - returning null');
        return null;
      }

      final docSnapshot = await _firestore
          .collection('users')
          .doc(uid)
          .get()
          .timeout(_timeout);

      if (docSnapshot.exists && docSnapshot.data() != null) {
        print('✅ [Firestore] User document found');
        final data = docSnapshot.data()!;
        data['id'] = uid; // Thêm uid vào data
        return UserModel.fromMap(data);
      } else {
        print('⚠️ [Firestore] User document not found');
        return null;
      }
    } on FirebaseException catch (e) {
      print('🚨 [Firestore] Firebase error: ${e.code} - ${e.message}');

      // Xử lý các lỗi cụ thể
      switch (e.code) {
        case 'permission-denied':
          print('❌ [Firestore] Permission denied - check security rules');
          break;
        case 'unavailable':
          print('❌ [Firestore] Service unavailable');
          break;
        case 'deadline-exceeded':
          print('❌ [Firestore] Request timeout');
          break;
        default:
          print('❌ [Firestore] Unknown error: ${e.code}');
      }
      return null;
    } catch (e) {
      print('🚨 [Firestore] General error: $e');
      return null;
    }
  }

  /// Tạo hoặc cập nhật user document
  static Future<bool> createOrUpdateUser(UserModel user) async {
    try {
      print('🔍 [Firestore] Creating/updating user: ${user.email}');

      // Kiểm tra kết nối trước
      final isConnected = await checkConnection();
      if (!isConnected) {
        print('⚠️ [Firestore] No connection - cannot save user');
        return false;
      }

      await _firestore
          .collection('users')
          .doc(user.id)
          .set(user.toMap(), SetOptions(merge: true))
          .timeout(_timeout);

      print('✅ [Firestore] User saved successfully');
      return true;
    } on FirebaseException catch (e) {
      print('🚨 [Firestore] Error saving user: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('🚨 [Firestore] General error saving user: $e');
      return false;
    }
  }

  /// Cập nhật thông tin user
  static Future<bool> updateUserInfo({
    required String uid,
    String? displayName,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      print('🔍 [Firestore] Updating user info for UID: $uid');

      // Kiểm tra kết nối trước
      final isConnected = await checkConnection();
      if (!isConnected) {
        print('⚠️ [Firestore] No connection - cannot update user');
        return false;
      }

      final Map<String, dynamic> updateData = {};

      if (displayName != null) updateData['displayName'] = displayName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (address != null) updateData['address'] = address;

      updateData['updatedAt'] = FieldValue.serverTimestamp();

      await _firestore
          .collection('users')
          .doc(uid)
          .update(updateData)
          .timeout(_timeout);

      print('✅ [Firestore] User info updated successfully');
      return true;
    } on FirebaseException catch (e) {
      print('🚨 [Firestore] Error updating user: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      print('🚨 [Firestore] General error updating user: $e');
      return false;
    }
  }

  /// Thiết lập Firestore settings cho web
  static void initializeForWeb() {
    try {
      // Cấu hình cho web
      _firestore.settings = const Settings(
        persistenceEnabled: false, // Tắt offline persistence cho web
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );
      print('✅ [Firestore] Web settings configured');
    } catch (e) {
      print('⚠️ [Firestore] Error configuring web settings: $e');
    }
  }
}
