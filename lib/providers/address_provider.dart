import 'package:flutter/material.dart';
import '../models/address_model.dart';
import '../services/address_service.dart';

class AddressProvider with ChangeNotifier {
  final AddressService _addressService = AddressService();

  List<AddressModel> _addresses = [];
  AddressModel? _defaultAddress;
  bool _isLoading = false;

  List<AddressModel> get addresses => _addresses;
  AddressModel? get defaultAddress => _defaultAddress;
  bool get isLoading => _isLoading;

  // Load addresses của user
  void loadAddresses(String userId) {
    _addressService.getUserAddresses(userId).listen((addresses) {
      _addresses = addresses;
      _defaultAddress = addresses.firstWhere(
        (addr) => addr.isDefault,
        orElse: () => addresses.isNotEmpty
            ? addresses.first
            : AddressModel(
                id: '',
                userId: '',
                recipientName: '',
                phoneNumber: '',
                street: '',
                ward: '',
                district: '',
                city: '',
                createdAt: DateTime.now(),
              ),
      );
      notifyListeners();
    });
  }

  // Thêm địa chỉ mới
  Future<void> addAddress(AddressModel address) async {
    try {
      print('📍 AddressProvider: Bắt đầu thêm địa chỉ...');
      _isLoading = true;
      notifyListeners();

      await _addressService.createAddress(address);

      print('✅ AddressProvider: Thêm địa chỉ thành công');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ AddressProvider: Lỗi thêm địa chỉ - $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Cập nhật địa chỉ
  Future<void> updateAddress(AddressModel address) async {
    try {
      print('📍 AddressProvider: Bắt đầu cập nhật địa chỉ...');
      _isLoading = true;
      notifyListeners();

      await _addressService.updateAddress(address);

      print('✅ AddressProvider: Cập nhật địa chỉ thành công');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ AddressProvider: Lỗi cập nhật địa chỉ - $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Xóa địa chỉ
  Future<void> deleteAddress(String addressId) async {
    try {
      print('📍 AddressProvider: Bắt đầu xóa địa chỉ...');
      _isLoading = true;
      notifyListeners();

      await _addressService.deleteAddress(addressId);

      print('✅ AddressProvider: Xóa địa chỉ thành công');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ AddressProvider: Lỗi xóa địa chỉ - $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }

  // Set địa chỉ mặc định
  Future<void> setDefaultAddress(String userId, String addressId) async {
    try {
      print('📍 AddressProvider: Bắt đầu đặt địa chỉ mặc định...');
      _isLoading = true;
      notifyListeners();

      await _addressService.setDefaultAddress(userId, addressId);

      print('✅ AddressProvider: Đặt địa chỉ mặc định thành công');
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      print('❌ AddressProvider: Lỗi đặt địa chỉ mặc định - $e');
      _isLoading = false;
      notifyListeners();
      rethrow;
    }
  }
}
