class ProductModel {
  String id;
  final String name;
  final String description;
  final double price;
  final String category; // 'table' or 'chair'
  final List<String> imageUrls;
  final int stock;
  final DateTime createdAt;
  final bool isActive;

  ProductModel({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrls,
    required this.stock,
    DateTime? createdAt,
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Chuyển ProductModel thành Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrls': imageUrls,
      'stock': stock,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'isActive': isActive,
    };
  }

  /// Tạo ProductModel từ Map Firestore
  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: map['price'] is int
          ? (map['price'] as int).toDouble()
          : (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      imageUrls: map['imageUrls'] != null
          ? List<String>.from(map['imageUrls'])
          : [],
      stock: map['stock'] ?? 0,
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
      isActive: map['isActive'] ?? true,
    );
  }

  /// Cập nhật stock hoặc trạng thái sản phẩm
  ProductModel copyWith({
    int? stock,
    bool? isActive,
  }) {
    return ProductModel(
      id: id,
      name: name,
      description: description,
      price: price,
      category: category,
      imageUrls: imageUrls,
      stock: stock ?? this.stock,
      createdAt: createdAt,
      isActive: isActive ?? this.isActive,
    );
  }
}
