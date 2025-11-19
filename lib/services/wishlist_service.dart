import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_model.dart';

class WishlistService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Thêm sản phẩm vào wishlist
  Future<void> addToWishlist(WishlistModel wishlist) async {
    print(
      '💖 WishlistService: Adding to wishlist - userId: ${wishlist.userId}, productId: ${wishlist.productId}',
    );
    await _firestore
        .collection('wishlist')
        .doc(wishlist.id)
        .set(wishlist.toMap());
    print('✅ WishlistService: Added successfully');
  }

  // Xóa sản phẩm khỏi wishlist
  Future<void> removeFromWishlist(String id) async {
    print('💖 WishlistService: Removing from wishlist - id: $id');
    await _firestore.collection('wishlist').doc(id).delete();
    print('✅ WishlistService: Removed successfully');
  }

  // Lấy wishlist của user
  Stream<List<WishlistModel>> getUserWishlist(String userId) {
    print('💖 WishlistService: Getting wishlist for userId: $userId');
    return _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          print(
            '💖 WishlistService: Received ${snapshot.docs.length} wishlist items',
          );
          return snapshot.docs.map((doc) {
            print(
              '   - Item: ${doc.id} -> productId: ${doc.data()['productId']}',
            );
            return WishlistModel.fromMap(doc.data());
          }).toList();
        });
  }

  // Kiểm tra sản phẩm có trong wishlist không
  Future<bool> isInWishlist(String userId, String productId) async {
    print(
      '💖 WishlistService: Checking if in wishlist - userId: $userId, productId: $productId',
    );
    final snapshot = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    final result = snapshot.docs.isNotEmpty;
    print('💖 WishlistService: Is in wishlist? $result');
    return result;
  }

  // Lấy wishlist item theo userId và productId
  Future<WishlistModel?> getWishlistItem(
    String userId,
    String productId,
  ) async {
    print(
      '💖 WishlistService: Getting wishlist item - userId: $userId, productId: $productId',
    );
    final snapshot = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .where('productId', isEqualTo: productId)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      print('✅ WishlistService: Found wishlist item');
      return WishlistModel.fromMap(snapshot.docs.first.data());
    }
    print('⚠️ WishlistService: Wishlist item not found');
    return null;
  }

  // Đếm số lượng wishlist của user
  Future<int> getWishlistCount(String userId) async {
    final snapshot = await _firestore
        .collection('wishlist')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs.length;
  }
}
