import 'package:cloud_firestore/cloud_firestore.dart';

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
    double _parsePrice(dynamic value) {
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    List<String> _parseImageUrls(dynamic value) {
      if (value is List) {
        return value.map((e) => e.toString()).toList();
      }
      if (value is String && value.isNotEmpty) {
        return [value];
      }
      return [];
    }

    DateTime _parseDate(dynamic value) {
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      if (value is String) {
        final millis = int.tryParse(value);
        if (millis != null) {
          return DateTime.fromMillisecondsSinceEpoch(millis);
        }
      }
      if (value is Timestamp) {
        return value.toDate();
      }
      return DateTime.now();
    }

    return ProductModel(
      id: map['id']?.toString() ?? '',
      name: map['name']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: _parsePrice(map['price']),
      category: map['category']?.toString() ?? '',
      imageUrls: _parseImageUrls(map['imageUrls'] ?? map['imageUrl']),
      stock: (map['stock'] is num) ? (map['stock'] as num).toInt() : 0,
      createdAt: _parseDate(map['createdAt']),
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
