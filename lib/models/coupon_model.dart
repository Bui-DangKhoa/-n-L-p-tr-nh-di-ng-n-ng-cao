class CouponModel {
  final String id;
  final String code;
  final String title;
  final String description;
  final String type; // 'percentage', 'fixed'
  final double value; // percentage (0-100) or fixed amount
  final double minOrderAmount;
  final double? maxDiscountAmount; // For percentage coupons
  final int usageLimit; // 0 = unlimited
  final int usedCount;
  final DateTime startDate;
  final DateTime endDate;
  final bool isActive;
  final DateTime createdAt;

  CouponModel({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.type,
    required this.value,
    this.minOrderAmount = 0,
    this.maxDiscountAmount,
    this.usageLimit = 0,
    this.usedCount = 0,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    required this.createdAt,
  });

  bool get isValid {
    final now = DateTime.now();
    return isActive &&
        now.isAfter(startDate) &&
        now.isBefore(endDate) &&
        (usageLimit == 0 || usedCount < usageLimit);
  }

  double calculateDiscount(double orderAmount) {
    if (!isValid || orderAmount < minOrderAmount) {
      return 0;
    }

    if (type == 'percentage') {
      final discount = orderAmount * (value / 100);
      if (maxDiscountAmount != null && discount > maxDiscountAmount!) {
        return maxDiscountAmount!;
      }
      return discount;
    } else {
      // fixed
      return value;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'type': type,
      'value': value,
      'minOrderAmount': minOrderAmount,
      'maxDiscountAmount': maxDiscountAmount,
      'usageLimit': usageLimit,
      'usedCount': usedCount,
      'startDate': startDate.millisecondsSinceEpoch,
      'endDate': endDate.millisecondsSinceEpoch,
      'isActive': isActive,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory CouponModel.fromMap(Map<String, dynamic> map) {
    return CouponModel(
      id: map['id'] ?? '',
      code: map['code'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      type: map['type'] ?? 'percentage',
      value: map['value'] is int
          ? (map['value'] as int).toDouble()
          : (map['value'] ?? 0.0).toDouble(),
      minOrderAmount: map['minOrderAmount'] is int
          ? (map['minOrderAmount'] as int).toDouble()
          : (map['minOrderAmount'] ?? 0.0).toDouble(),
      maxDiscountAmount: map['maxDiscountAmount'] != null
          ? (map['maxDiscountAmount'] is int
                ? (map['maxDiscountAmount'] as int).toDouble()
                : map['maxDiscountAmount'].toDouble())
          : null,
      usageLimit: map['usageLimit'] ?? 0,
      usedCount: map['usedCount'] ?? 0,
      startDate: DateTime.fromMillisecondsSinceEpoch(
        map['startDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      endDate: DateTime.fromMillisecondsSinceEpoch(
        map['endDate'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
      isActive: map['isActive'] ?? true,
      createdAt: DateTime.fromMillisecondsSinceEpoch(
        map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
      ),
    );
  }

  CouponModel copyWith({
    String? code,
    String? title,
    String? description,
    String? type,
    double? value,
    double? minOrderAmount,
    double? maxDiscountAmount,
    int? usageLimit,
    int? usedCount,
    DateTime? startDate,
    DateTime? endDate,
    bool? isActive,
  }) {
    return CouponModel(
      id: id,
      code: code ?? this.code,
      title: title ?? this.title,
      description: description ?? this.description,
      type: type ?? this.type,
      value: value ?? this.value,
      minOrderAmount: minOrderAmount ?? this.minOrderAmount,
      maxDiscountAmount: maxDiscountAmount ?? this.maxDiscountAmount,
      usageLimit: usageLimit ?? this.usageLimit,
      usedCount: usedCount ?? this.usedCount,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
    );
  }
}
