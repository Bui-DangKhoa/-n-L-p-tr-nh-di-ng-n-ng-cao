class WishlistModel {
  final String id;
  final String userId;
  final String productId;
  final DateTime createdAt;

  WishlistModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'productId': productId,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory WishlistModel.fromMap(Map<String, dynamic> map) {
    return WishlistModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      productId: map['productId'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }
}
