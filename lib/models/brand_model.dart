import 'package:cloud_firestore/cloud_firestore.dart';

class BrandModel {
  final String id;
  final String name;
  final String description;
  final String logoUrl;
  final bool isActive;
  final DateTime createdAt;

  BrandModel({
    required this.id,
    required this.name,
    this.description = '',
    this.logoUrl = '',
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  BrandModel copyWith({
    String? id,
    String? name,
    String? description,
    String? logoUrl,
    bool? isActive,
  }) {
    return BrandModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'logoUrl': logoUrl,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BrandModel.fromMap(Map<String, dynamic> map) {
    DateTime _parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is int) {
        return DateTime.fromMillisecondsSinceEpoch(value);
      }
      if (value is String) {
        final millis = int.tryParse(value);
        if (millis != null) {
          return DateTime.fromMillisecondsSinceEpoch(millis);
        }
      }
      return DateTime.now();
    }

    return BrandModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      logoUrl: map['logoUrl'] ?? '',
      isActive: map['isActive'] ?? true,
      createdAt: _parseDate(map['createdAt']),
    );
  }
}

