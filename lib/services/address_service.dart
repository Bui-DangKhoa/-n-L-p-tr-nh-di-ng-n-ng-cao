import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/address_model.dart';

class AddressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Tạo địa chỉ mới
  Future<void> createAddress(AddressModel address) async {
    try {
      print('🏠 AddressService: Tạo địa chỉ mới cho userId: ${address.userId}');

      // Tạo ID mới nếu chưa có
      final docRef = address.id.isEmpty
          ? _firestore.collection('addresses').doc()
          : _firestore.collection('addresses').doc(address.id);

      final newAddress = AddressModel(
        id: docRef.id,
        userId: address.userId,
        recipientName: address.recipientName,
        phoneNumber: address.phoneNumber,
        street: address.street,
        ward: address.ward,
        district: address.district,
        city: address.city,
        zipCode: address.zipCode,
        isDefault: address.isDefault,
        createdAt: address.createdAt,
      );

      // Nếu địa chỉ mới là default, remove default của các địa chỉ khác
      if (newAddress.isDefault) {
        print('🏠 AddressService: Đang xóa default của địa chỉ khác...');
        await _removeDefaultFromOthers(newAddress.userId, newAddress.id);
      }

      print('🏠 AddressService: Lưu địa chỉ vào Firestore...');
      await docRef.set(newAddress.toMap());
      print('✅ AddressService: Tạo địa chỉ thành công - ID: ${newAddress.id}');
    } catch (e) {
      print('❌ AddressService: Lỗi tạo địa chỉ - $e');
      throw Exception('Không thể tạo địa chỉ: $e');
    }
  }

  // Lấy địa chỉ của user
  Stream<List<AddressModel>> getUserAddresses(String userId) {
    return _firestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .orderBy('isDefault', descending: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => AddressModel.fromMap(doc.data()))
              .toList(),
        );
  }

  // Lấy địa chỉ mặc định
  Future<AddressModel?> getDefaultAddress(String userId) async {
    final snapshot = await _firestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      return AddressModel.fromMap(snapshot.docs.first.data());
    }
    return null;
  }

  // Cập nhật địa chỉ
  Future<void> updateAddress(AddressModel address) async {
    try {
      print('🏠 AddressService: Cập nhật địa chỉ ID: ${address.id}');

      // Nếu set làm default, remove default của các địa chỉ khác
      if (address.isDefault) {
        print('🏠 AddressService: Đang xóa default của địa chỉ khác...');
        await _removeDefaultFromOthers(address.userId, address.id);
      }

      await _firestore.collection('addresses').doc(address.id).update({
        'recipientName': address.recipientName,
        'phoneNumber': address.phoneNumber,
        'street': address.street,
        'ward': address.ward,
        'district': address.district,
        'city': address.city,
        'zipCode': address.zipCode,
        'isDefault': address.isDefault,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      print('✅ AddressService: Cập nhật địa chỉ thành công');
    } catch (e) {
      print('❌ AddressService: Lỗi cập nhật địa chỉ - $e');
      throw Exception('Không thể cập nhật địa chỉ: $e');
    }
  }

  // Set địa chỉ làm mặc định
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      print('🏠 AddressService: Đặt địa chỉ mặc định - ID: $addressId');

      // Remove default từ tất cả
      await _removeDefaultFromOthers(userId, addressId);

      // Set địa chỉ này làm default
      await _firestore.collection('addresses').doc(addressId).update({
        'isDefault': true,
        'updatedAt': DateTime.now().millisecondsSinceEpoch,
      });

      print('✅ AddressService: Đặt địa chỉ mặc định thành công');
    } catch (e) {
      print('❌ AddressService: Lỗi đặt địa chỉ mặc định - $e');
      throw Exception('Không thể đặt địa chỉ mặc định: $e');
    }
  }

  // Xóa địa chỉ
  Future<void> deleteAddress(String id) async {
    try {
      print('🏠 AddressService: Xóa địa chỉ ID: $id');
      await _firestore.collection('addresses').doc(id).delete();
      print('✅ AddressService: Xóa địa chỉ thành công');
    } catch (e) {
      print('❌ AddressService: Lỗi xóa địa chỉ - $e');
      throw Exception('Không thể xóa địa chỉ: $e');
    }
  }

  // Remove default flag từ các địa chỉ khác
  Future<void> _removeDefaultFromOthers(String userId, String exceptId) async {
    final snapshot = await _firestore
        .collection('addresses')
        .where('userId', isEqualTo: userId)
        .where('isDefault', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    for (var doc in snapshot.docs) {
      if (doc.id != exceptId) {
        batch.update(doc.reference, {'isDefault': false});
      }
    }
    await batch.commit();
  }

  // Lấy địa chỉ theo ID
  Future<AddressModel?> getAddressById(String id) async {
    final doc = await _firestore.collection('addresses').doc(id).get();
    if (doc.exists) {
      return AddressModel.fromMap(doc.data()!);
    }
    return null;
  }
}
