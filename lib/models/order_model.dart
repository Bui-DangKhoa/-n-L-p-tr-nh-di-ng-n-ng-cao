import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final String userName;
  final String userPhone;
  final String deliveryAddress;
  final List<CartItemModel> items;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'shipping', 'delivered', 'cancelled'
  final DateTime createdAt;
  final DateTime? updatedAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userPhone,
    required this.deliveryAddress,
    required this.items,
    required this.totalAmount,
    this.status = 'pending',
    required this.createdAt,
    this.updatedAt,
  });

  /// Chuyển OrderModel thành Map (dùng lưu Firestore)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userPhone': userPhone,
      'deliveryAddress': deliveryAddress,
      'items': items.map((item) => item.toMap()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  /// Tạo OrderModel từ Map
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userPhone: map['userPhone'] ?? '',
      deliveryAddress: map['deliveryAddress'] ?? '',
      items: map['items'] != null
          ? List<CartItemModel>.from(
          map['items'].map((x) => CartItemModel.fromMap(x)))
          : [],
      totalAmount: map['totalAmount'] is int
          ? (map['totalAmount'] as int).toDouble()
          : (map['totalAmount'] ?? 0.0).toDouble(),
      status: map['status'] ?? 'pending',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
          map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  /// Cập nhật trạng thái order và trả về bản mới
  OrderModel copyWith({
    String? status,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id,
      userId: userId,
      userName: userName,
      userPhone: userPhone,
      deliveryAddress: deliveryAddress,
      items: items,
      totalAmount: totalAmount,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
