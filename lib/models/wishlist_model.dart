import 'package:cloud_firestore/cloud_firestore.dart';

class WishlistModel {
  final String id;
  final DocumentReference userRef; // ✅ Liên kết thực sự với users collection
  final DocumentReference
  productRef; // ✅ Liên kết thực sự với products collection
  final DateTime createdAt;

  WishlistModel({
    required this.id,
    required this.userRef,
    required this.productRef,
    required this.createdAt,
  });

  // ✅ Helper: Lấy userId và productId từ references
  String get userId => userRef.id;
  String get productId => productRef.id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userRef': userRef, // ✅ Lưu DocumentReference
      'productRef': productRef, // ✅ Lưu DocumentReference
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      id: map['id'] ?? '',
      userRef: map['userRef'] as DocumentReference, // ✅ Đọc DocumentReference
      productRef:
          map['productRef'] as DocumentReference, // ✅ Đọc DocumentReference
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
