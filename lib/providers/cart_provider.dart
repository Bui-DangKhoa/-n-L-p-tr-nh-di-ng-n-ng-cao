import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';
import '../models/coupon_model.dart';
import '../services/cart_service.dart';

class CartProvider with ChangeNotifier {
  final CartService _cartService = CartService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Map lưu trữ các sản phẩm trong giỏ hàng (cache local)
  // Key: productId, Value: CartItemModel
  final Map<String, CartItemModel> _items = {};

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Getter để lấy danh sách items
  Map<String, CartItemModel> get items => {..._items};

  // Số lượng sản phẩm trong giỏ
  int get itemCount => _items.length;

  // Tổng số lượng tất cả sản phẩm
  int get totalQuantity {
    return _items.values.fold(0, (sum, item) => sum + item.quantity);
  }

  // Tổng tiền giỏ hàng
  double get totalAmount {
    return _items.values.fold(0.0, (sum, item) => sum + item.totalPrice);
  }

  CouponModel? _selectedCoupon;
  double _discountAmount = 0;

  CouponModel? get selectedCoupon => _selectedCoupon;
  double get discountAmount => _discountAmount;
  double get payableAmount =>
      (totalAmount - _discountAmount).clamp(0, double.infinity);

  // Lấy userId hiện tại
  String? get _userId => _auth.currentUser?.uid;

  // Kiểm tra sản phẩm có trong giỏ không
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  // Load giỏ hàng từ Firebase khi khởi động
  Future<void> loadCart() async {
    if (_userId == null) {
      _items.clear();
      notifyListeners();
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      final cart = await _cartService.getCart(_userId!);
      _items.clear();

      if (cart != null) {
        for (var item in cart.items) {
          _items[item.productId] = item;
        }
      }
    } catch (e) {
      print('Error loading cart: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Thêm sản phẩm vào giỏ
  Future<void> addItem(CartItemModel product) async {
    if (_userId == null) {
      print('User not logged in');
      return;
    }

    try {
      // Cập nhật local cache trước
      if (_items.containsKey(product.productId)) {
        _items[product.productId]!.increment();
      } else {
        _items[product.productId] = product;
      }
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.addItem(_userId!, product);
    } catch (e) {
      print('Error adding item to cart: $e');
      // Rollback nếu có lỗi
      await loadCart();
    }
  }

  // Xóa sản phẩm khỏi giỏ
  Future<void> removeItem(String productId) async {
    if (_userId == null) return;

    try {
      // Cập nhật local cache
      _items.remove(productId);
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.removeItem(_userId!, productId);
    } catch (e) {
      print('Error removing item from cart: $e');
      await loadCart();
    }
  }

  // Giảm số lượng sản phẩm
  Future<void> decreaseQuantity(String productId) async {
    if (_userId == null) return;
    if (!_items.containsKey(productId)) return;

    try {
      // Cập nhật local cache
      if (_items[productId]!.quantity > 1) {
        _items[productId]!.decrement();
      } else {
        _items.remove(productId);
      }
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.decreaseQuantity(_userId!, productId);
    } catch (e) {
      print('Error decreasing quantity: $e');
      await loadCart();
    }
  }

  // Tăng số lượng sản phẩm
  Future<void> increaseQuantity(String productId) async {
    if (_userId == null) return;
    if (!_items.containsKey(productId)) return;

    try {
      // Cập nhật local cache
      _items[productId]!.increment();
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.increaseQuantity(_userId!, productId);
    } catch (e) {
      print('Error increasing quantity: $e');
      await loadCart();
    }
  }

  // Cập nhật số lượng trực tiếp
  Future<void> updateQuantity(String productId, int newQuantity) async {
    if (_userId == null) return;
    if (!_items.containsKey(productId)) return;

    try {
      // Cập nhật local cache
      if (newQuantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = newQuantity;
      }
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.updateQuantity(_userId!, productId, newQuantity);
    } catch (e) {
      print('Error updating quantity: $e');
      await loadCart();
    }
  }

  // Xóa toàn bộ giỏ hàng
  Future<void> clearCart() async {
    if (_userId == null) return;

    try {
      // Cập nhật local cache
      _items.clear();
      _selectedCoupon = null;
      _discountAmount = 0;
      notifyListeners();

      // Đồng bộ với Firebase
      await _cartService.clearCart(_userId!);
    } catch (e) {
      print('Error clearing cart: $e');
      await loadCart();
    }
  }

  // Lấy một sản phẩm cụ thể
  CartItemModel? getItem(String productId) {
    return _items[productId];
  }

  // Lấy số lượng của một sản phẩm
  int getItemQuantity(String productId) {
    return _items[productId]?.quantity ?? 0;
  }

  void applyCoupon(CouponModel coupon) {
    _selectedCoupon = coupon;
    _recalculateDiscount();
    notifyListeners();
  }

  void removeCoupon() {
    _selectedCoupon = null;
    _discountAmount = 0;
    notifyListeners();
  }

  void _recalculateDiscount() {
    if (_selectedCoupon == null) {
      _discountAmount = 0;
      return;
    }
    _discountAmount = _selectedCoupon!.calculateDiscount(totalAmount);
  }

  // Chuyển giỏ hàng thành đơn hàng
  Future<String?> checkout(
    String userName,
    String userPhone,
    String deliveryAddress,
  ) async {
    if (_userId == null) return null;

    try {
      final orderId = await _cartService.convertCartToOrder(
        _userId!,
        userName,
        userPhone,
        deliveryAddress,
      );

      // Xóa local cache
      _items.clear();
      _selectedCoupon = null;
      _discountAmount = 0;
      notifyListeners();

      return orderId;
    } catch (e) {
      print('Error during checkout: $e');
      return null;
    }
  }
}
