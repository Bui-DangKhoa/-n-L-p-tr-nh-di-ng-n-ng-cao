import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';

import '../models/coupon_model.dart';

class CartProvider with ChangeNotifier {
  // Map lưu trữ các sản phẩm trong giỏ hàng
  // Key: productId, Value: CartItemModel
  final Map<String, CartItemModel> _items = {};

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

  // Kiểm tra sản phẩm có trong giỏ không
  bool isInCart(String productId) {
    return _items.containsKey(productId);
  }

  // Thêm sản phẩm vào giỏ
  void addItem(CartItemModel product) {
    if (_items.containsKey(product.productId)) {
      // Nếu sản phẩm đã có trong giỏ => tăng số lượng
      _items[product.productId]!.increment();
    } else {
      // Nếu chưa có => thêm mới
      _items[product.productId] = product;
    }
    notifyListeners();
  }

  // Xóa sản phẩm khỏi giỏ
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  // Giảm số lượng sản phẩm
  void decreaseQuantity(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.decrement();
    } else {
      // Nếu số lượng = 1, xóa luôn khỏi giỏ
      _items.remove(productId);
    }
    notifyListeners();
  }

  // Tăng số lượng sản phẩm
  void increaseQuantity(String productId) {
    if (_items.containsKey(productId)) {
      _items[productId]!.increment();
      notifyListeners();
    }
  }

  // Cập nhật số lượng trực tiếp
  void updateQuantity(String productId, int newQuantity) {
    if (_items.containsKey(productId)) {
      if (newQuantity <= 0) {
        _items.remove(productId);
      } else {
        _items[productId]!.quantity = newQuantity;
      }
      notifyListeners();
    }
  }

  // Xóa toàn bộ giỏ hàng
  void clearCart() {
    _items.clear();
    _selectedCoupon = null;
    _discountAmount = 0;
    notifyListeners();
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
}