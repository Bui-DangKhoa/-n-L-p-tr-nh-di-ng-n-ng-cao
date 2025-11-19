import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/review_model.dart';

class ReviewService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo review mới
  Future<void> createReview(ReviewModel review) async {
    await _firestore.collection('reviews').doc(review.id).set(review.toMap());
  }

  // Lấy reviews của sản phẩm
  Stream<List<ReviewModel>> getProductReviews(String productId) {
    return _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy reviews của user
  Stream<List<ReviewModel>> getUserReviews(String userId) {
    return _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ReviewModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Cập nhật review
  Future<void> updateReview(ReviewModel review) async {
    await _firestore.collection('reviews').doc(review.id).update({
      'rating': review.rating,
      'comment': review.comment,
      'images': review.images,
      'updatedAt': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Xóa review
  Future<void> deleteReview(String id) async {
    await _firestore.collection('reviews').doc(id).delete();
  }

  // Tính rating trung bình của sản phẩm
  Future<Map<String, dynamic>> getProductRatingStats(String productId) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('productId', isEqualTo: productId)
        .get();

    if (snapshot.docs.isEmpty) {
      return {'averageRating': 0.0, 'totalReviews': 0};
    }

    double totalRating = 0;
    for (var doc in snapshot.docs) {
      totalRating += (doc.data()['rating'] ?? 0.0).toDouble();
    }

    return {
      'averageRating': totalRating / snapshot.docs.length,
      'totalReviews': snapshot.docs.length,
    };
  }

  // Kiểm tra user đã review sản phẩm chưa
  Future<ReviewModel?> getUserReviewForProduct(
    String userId,
    String productId,
  ) async {
    final snapshot = await _firestore
        .collection('reviews')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return ReviewModel.fromMap(snapshot.docs.first.data());
    }
    return null;
  }
}
