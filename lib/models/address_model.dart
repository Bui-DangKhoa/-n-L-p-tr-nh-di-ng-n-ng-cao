import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id;
  final DocumentReference userRef; // ✅ Liên kết thực sự với users collection
  final String recipientName;
  final String phoneNumber;
  final String street;
  final String ward;
  final String district;
  final String city;
  final String zipCode;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.userRef,
    required this.recipientName,
    required this.phoneNumber,
    required this.street,
    required this.ward,
    required this.district,
    required this.city,
    this.zipCode = '',
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  String get fullAddress {
    return '$street, $ward, $district, $city${zipCode.isNotEmpty ? ', $zipCode' : ''}';
  }

  // ✅ Helper: Lấy userId từ reference
  String get userId => userRef.id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userRef': userRef, // ✅ Lưu DocumentReference thay vì String
      'recipientName': recipientName,
      'phoneNumber': phoneNumber,
      'street': street,
      'ward': ward,
      'district': district,
      'city': city,
      'zipCode': zipCode,
      'isDefault': isDefault,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt?.millisecondsSinceEpoch,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      id: map['id'] ?? '',
      userRef: map['userRef'] as DocumentReference, // ✅ Đọc DocumentReference
      recipientName: map['recipientName'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      street: map['street'] ?? '',
      ward: map['ward'] ?? '',
      district: map['district'] ?? '',
      city: map['city'] ?? '',
      zipCode: map['zipCode'] ?? '',
      isDefault: map['isDefault'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      updatedAt: map['updatedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updatedAt'])
          : null,
    );
  }

  AddressModel copyWith({
    String? recipientName,
    String? phoneNumber,
    String? street,
    String? ward,
    String? district,
    String? city,
    String? zipCode,
    bool? isDefault,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id,
      userRef: userRef, // ✅ Giữ nguyên reference
      recipientName: recipientName ?? this.recipientName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      street: street ?? this.street,
      ward: ward ?? this.ward,
      district: district ?? this.district,
      city: city ?? this.city,
      zipCode: zipCode ?? this.zipCode,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
