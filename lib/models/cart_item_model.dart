class CartItemModel {
  final String productId;
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  CartItemModel({
    required this.productId,
    required this.productName,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });

  /// Tổng tiền của sản phẩm trong giỏ
  double get totalPrice => price * quantity;

  /// Chuyển CartItemModel thành Map (dùng lưu Firestore hoặc local storage)
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'imageUrl': imageUrl,
      'quantity': quantity,
    };
  }

  /// Tạo CartItemModel từ Map
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      quantity: map['quantity'] ?? 1,
    );
  }

  /// Tăng số lượng
  void increment() => quantity++;

  /// Giảm số lượng (vẫn tối thiểu 1)
  void decrement() {
    if (quantity > 1) quantity--;
  }
}
