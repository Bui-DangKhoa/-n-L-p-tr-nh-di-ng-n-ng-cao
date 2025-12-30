import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/coupon_model.dart';

class CouponService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo coupon mới (Admin)
  Future<void> createCoupon(CouponModel coupon) async {
    await _firestore.collection('coupons').doc(coupon.id).set(coupon.toMap());
  }

  // Lấy tất cả coupons (Admin)
  Stream<List<CouponModel>> getAllCoupons() {
    return _firestore
        .collection('coupons')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CouponModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy coupons đang hoạt động
  Stream<List<CouponModel>> getActiveCoupons() {
    return _firestore
        .collection('coupons')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => CouponModel.fromMap(doc.data()))
              .where((coupon) => coupon.isValid)
              .toList(),
        );
  }

  // Lấy coupon theo code
  Future<CouponModel?> getCouponByCode(String code) async {
    final snapshot = await _firestore
        .collection('coupons')
        .where('code', isEqualTo: code.toUpperCase())
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return CouponModel.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  // Cập nhật coupon (Admin)
  Future<void> updateCoupon(CouponModel coupon) async {
    await _firestore.collection('coupons').doc(coupon.id).update({
      'code': coupon.code,
      'title': coupon.title,
      'description': coupon.description,
      'type': coupon.type,
      'value': coupon.value,
      'minOrderAmount': coupon.minOrderAmount,
      'maxDiscountAmount': coupon.maxDiscountAmount,
      'usageLimit': coupon.usageLimit,
      'startDate': coupon.startDate.millisecondsSinceEpoch,
      'endDate': coupon.endDate.millisecondsSinceEpoch,
      'isActive': coupon.isActive,
    });
  }

  // Xóa coupon (Admin)
  Future<void> deleteCoupon(String id) async {
    await _firestore.collection('coupons').doc(id).delete();
  }

  // Tăng số lần sử dụng
  Future<void> incrementUsageCount(String couponId) async {
    await _firestore.collection('coupons').doc(couponId).update({
      'usedCount': FieldValue.increment(1),
    });
  }

  // Validate coupon
  Future<Map<String, dynamic>> validateCoupon(
    String code,
    double orderAmount,
  ) async {
    final coupon = await getCouponByCode(code);

    if (coupon == null) {
      return {'valid': false, 'message': 'Mã giảm giá không tồn tại'};
    }

    if (!coupon.isValid) {
      return {
        'valid': false,
        'message': 'Mã giảm giá đã hết hạn hoặc đã hết lượt sử dụng',
      };
    }

    if (orderAmount < coupon.minOrderAmount) {
      return {
        'valid': false,
        'message':
            'Đơn hàng tối thiểu ${coupon.minOrderAmount.toStringAsFixed(0)}đ để sử dụng mã này',
      };
    }

    final discount = coupon.calculateDiscount(orderAmount);
    return {
      'valid': true,
      'message': 'Mã giảm giá hợp lệ',
      'discount': discount,
      'coupon': coupon,
    };
  }

  // Toggle active status (Admin)
  Future<void> toggleCouponStatus(String couponId, bool isActive) async {
    await _firestore.collection('coupons').doc(couponId).update({
      'isActive': isActive,
    });
  }
}
