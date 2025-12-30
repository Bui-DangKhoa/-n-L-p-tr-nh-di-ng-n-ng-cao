import 'package:cloud_firestore/cloud_firestore.dart';

class ReviewModel {
  final String id;
  final DocumentReference
  productRef; // ✅ Liên kết thực sự với products collection
  final DocumentReference userRef; // ✅ Liên kết thực sự với users collection
  final String userName;
  final double rating; // 1-5 stars
  final String comment;
  final List<String> images; // URLs of review images
  final DateTime createdAt;
  final DateTime? updatedAt;

  ReviewModel({
    required this.id,
    required this.productRef,
    required this.userRef,
    required this.userName,
    required this.rating,
    required this.comment,
    this.images = const [],
    required this.createdAt,
    this.updatedAt,
  });

  // ✅ Helper: Lấy productId và userId từ references
  String get productId => productRef.id;
  String get userId => userRef.id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productRef': productRef, // ✅ Lưu DocumentReference
      'userRef': userRef, // ✅ Lưu DocumentReference
      'userName': userName,
      'rating': rating,
      'comment': comment,
      'images': images,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      productRef:
          map['productRef'] as DocumentReference, // ✅ Đọc DocumentReference
      userRef: map['userRef'] as DocumentReference, // ✅ Đọc DocumentReference
      userName: map['userName'] ?? '',
      rating: map['rating'] is int
          ? (map['rating'] as int).toDouble()
          : (map['rating'] ?? 5.0).toDouble(),
      comment: map['comment'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  ReviewModel copyWith({
    double? rating,
    String? comment,
    List<String>? images,
    DateTime? updatedAt,
  }) {
    return ReviewModel(
      id: id,
      productRef: productRef, // ✅ Giữ nguyên reference
      userRef: userRef, // ✅ Giữ nguyên reference
      userName: userName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      images: images ?? this.images,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
