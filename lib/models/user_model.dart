class UserModel {
  final String id;
  final String email;
  final String name;
  final String phone;
  final String address;
  final String role; // 'admin' hoặc 'customer'
  final DateTime createdAt;

  UserModel({
    this.id = '',
    required this.email,
    required this.name,
    required this.phone,
    required this.address,
    this.role = 'customer',
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Chuyển UserModel thành Map để lưu Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'phone': phone,
      'address': address,
      'role': role,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Tạo UserModel từ Map Firestore
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      address: map['address'] ?? '',
      role: map['role'] ?? 'customer',
      createdAt: map['createdAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['createdAt'])
          : DateTime.now(),
    );
  }

  /// Tạo bản sao với khả năng cập nhật một số trường
  UserModel copyWith({
    String? name,
    String? phone,
    String? address,
    String? role,
  }) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      role: role ?? this.role,
      createdAt: createdAt,
    );
  }
}
