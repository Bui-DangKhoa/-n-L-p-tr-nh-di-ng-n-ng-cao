import 'package:cloud_firestore/cloud_firestore.dart';

class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String? link;
  final int displayOrder;
  final bool isActive;
  final DateTime createdAt;

  BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    this.link,
    this.displayOrder = 0,
    this.isActive = true,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  BannerModel copyWith({
    String? id,
    String? title,
    String? imageUrl,
    String? link,
    int? displayOrder,
    bool? isActive,
  }) {
    return BannerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      link: link ?? this.link,
      displayOrder: displayOrder ?? this.displayOrder,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imageUrl': imageUrl,
      'link': link,
      'displayOrder': displayOrder,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory BannerModel.fromMap(Map<String, dynamic> map) {
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

    return BannerModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      link: map['link'],
      displayOrder: map['displayOrder'] ?? 0,
      isActive: map['isActive'] ?? true,
      createdAt: _parseDate(map['createdAt']),
    );
  }
}

