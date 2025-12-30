import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/wishlist_model.dart';
import '../models/product_model.dart';
import '../services/wishlist_service.dart';
import '../services/product_service.dart';

class WishlistProvider with ChangeNotifier {
  final WishlistService _wishlistService = WishlistService();
  final ProductService _productService = ProductService();

  List<WishlistModel> _wishlistItems = [];
  List<ProductModel> _wishlistProducts = [];
  bool _isLoading = false;
  String? _currentUserId;

  List<WishlistModel> get wishlistItems => _wishlistItems;
  List<ProductModel> get wishlistProducts => _wishlistProducts;
  bool get isLoading => _isLoading;
  int get wishlistCount => _wishlistItems.length;

  // Load wishlist của user
  void loadWishlist(String userId) {
    _currentUserId = userId;
    print('🔍 Loading wishlist for userId: $userId');
    _wishlistService.getUserWishlist(userId).listen((items) {
      print('📦 Received ${items.length} wishlist items');
      _wishlistItems = items;
      _loadWishlistProducts();
      notifyListeners();
    });
  }

  // Load thông tin sản phẩm trong wishlist
  Future<void> _loadWishlistProducts() async {
    print('📦 Loading products for ${_wishlistItems.length} wishlist items');
    _wishlistProducts.clear();
    for (var item in _wishlistItems) {
      print('🔍 Loading product: ${item.productId}');
      final product = await _productService.getProduct(item.productId);
      if (product != null) {
        print('✅ Product loaded: ${product.name}');
        _wishlistProducts.add(product);
      } else {
        print('❌ Product not found: ${item.productId}');
      }
    }
    print('✅ Total products loaded: ${_wishlistProducts.length}');
    notifyListeners();
  }

  // Thêm vào wishlist
  Future<void> addToWishlist(String userId, String productId) async {
    try {
      print('➕ Adding to wishlist: userId=$userId, productId=$productId');
      _isLoading = true;
      notifyListeners();

      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final firestore = FirebaseFirestore.instance;
      final wishlist = WishlistModel(
        id: id,
        userRef: firestore.collection('users').doc(userId),
        productRef: firestore.collection('products').doc(productId),
        createdAt: DateTime.now(),
      );

      await _wishlistService.addToWishlist(wishlist);
      print('✅ Added to wishlist successfully');

      _wishlistItems.add(wishlist);
      final product = await _productService.getProduct(productId);
      if (product != null) {
        _wishlistProducts.add(product);
      }

      _isLoading = false;

      // Reload wishlist để cập nhật UI ngay lập tức
      if (_currentUserId != null) {
        print('🔄 Reloading wishlist...');
        loadWishlist(_currentUserId!);
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error adding to wishlist: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Xóa khỏi wishlist
  Future<void> removeFromWishlist(String userId, String productId) async {
    try {
      print('➖ Removing from wishlist: userId=$userId, productId=$productId');
      _isLoading = true;
      notifyListeners();

      final item = await _wishlistService.getWishlistItem(userId, productId);
      if (item != null) {
        await _wishlistService.removeFromWishlist(item.id);
        print('✅ Removed from wishlist successfully');

        _wishlistItems.removeWhere(
          (wishlistItem) => wishlistItem.id == item.id,
        );
        _wishlistProducts.removeWhere(
          (product) => product.id == item.productId,
        );
      } else {
        print('⚠️ Wishlist item not found');
      }

      _isLoading = false;

      // Reload wishlist để cập nhật UI ngay lập tức
      if (_currentUserId != null) {
        print('🔄 Reloading wishlist...');
        loadWishlist(_currentUserId!);
      }

      notifyListeners();
    } catch (e) {
      print('❌ Error removing from wishlist: $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Kiểm tra sản phẩm có trong wishlist không
  Future<bool> isInWishlist(String userId, String productId) async {
    return await _wishlistService.isInWishlist(userId, productId);
  }

  // Toggle wishlist (thêm nếu chưa có, xóa nếu đã có)
  Future<void> toggleWishlist(String userId, String productId) async {
    final inWishlist = await isInWishlist(userId, productId);
    if (inWishlist) {
      await removeFromWishlist(userId, productId);
    } else {
      await addToWishlist(userId, productId);
    }
  }
}
