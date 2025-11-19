import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/address_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/address_model.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final addressProvider = Provider.of<AddressProvider>(
        context,
        listen: false,
      );
      if (authProvider.user != null) {
        addressProvider.loadAddresses(authProvider.user!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final addressProvider = Provider.of<AddressProvider>(context);

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Địa chỉ giao hàng')),
        body: const Center(child: Text('Vui lòng đăng nhập')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Địa chỉ giao hàng'), elevation: 0),
      body: addressProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : addressProvider.addresses.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.location_off, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Chưa có địa chỉ nào',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nhấn nút + để thêm địa chỉ mới',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: addressProvider.addresses.length,
              itemBuilder: (context, index) {
                final address = addressProvider.addresses[index];
                return _buildAddressCard(address, authProvider.user!.id);
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAddressDialog(authProvider.user!.id),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildAddressCard(AddressModel address, String userId) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    address.recipientName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (address.isDefault)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text(
                      'Mặc định',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              address.phoneNumber,
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 4),
            Text(
              '${address.street}, ${address.ward}, ${address.district}, ${address.city}',
              style: TextStyle(color: Colors.grey[700]),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!address.isDefault)
                  TextButton.icon(
                    onPressed: () => _setDefaultAddress(address, userId),
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Đặt mặc định'),
                  ),
                TextButton.icon(
                  onPressed: () => _showEditAddressDialog(address, userId),
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text('Sửa'),
                ),
                TextButton.icon(
                  onPressed: () => _deleteAddress(address, userId),
                  icon: const Icon(Icons.delete, size: 18, color: Colors.red),
                  label: const Text('Xóa', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showAddAddressDialog(String userId) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final streetController = TextEditingController();
    final wardController = TextEditingController();
    final districtController = TextEditingController();
    final cityController = TextEditingController();
    bool isDefault = false;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Thêm địa chỉ mới'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên người nhận *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập SĐT' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ cụ thể *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập địa chỉ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: wardController,
                  decoration: const InputDecoration(
                    labelText: 'Phường/Xã *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập phường/xã' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    labelText: 'Quận/Huyện *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Vui lòng nhập quận/huyện'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Tỉnh/Thành phố *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập tỉnh/TP' : null,
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setState) => CheckboxListTile(
                    title: const Text('Đặt làm địa chỉ mặc định'),
                    value: isDefault,
                    onChanged: (value) =>
                        setState(() => isDefault = value ?? false),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final address = AddressModel(
                  id: '',
                  userId: userId,
                  recipientName: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  street: streetController.text.trim(),
                  ward: wardController.text.trim(),
                  district: districtController.text.trim(),
                  city: cityController.text.trim(),
                  isDefault: isDefault,
                  createdAt: DateTime.now(),
                );

                try {
                  print('🔄 Đang thêm địa chỉ mới...');
                  await Provider.of<AddressProvider>(
                    context,
                    listen: false,
                  ).addAddress(address);
                  if (mounted) {
                    print('✅ Thêm địa chỉ thành công');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Thêm địa chỉ thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('❌ Lỗi khi thêm địa chỉ: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Lỗi: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'Đóng',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Thêm'),
          ),
        ],
      ),
    );
  }

  void _showEditAddressDialog(AddressModel address, String userId) {
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: address.recipientName);
    final phoneController = TextEditingController(text: address.phoneNumber);
    final streetController = TextEditingController(text: address.street);
    final wardController = TextEditingController(text: address.ward);
    final districtController = TextEditingController(text: address.district);
    final cityController = TextEditingController(text: address.city);
    bool isDefault = address.isDefault;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa địa chỉ'),
        content: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên người nhận *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập tên' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: 'Số điện thoại *',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập SĐT' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: streetController,
                  decoration: const InputDecoration(
                    labelText: 'Địa chỉ cụ thể *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập địa chỉ' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: wardController,
                  decoration: const InputDecoration(
                    labelText: 'Phường/Xã *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập phường/xã' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: districtController,
                  decoration: const InputDecoration(
                    labelText: 'Quận/Huyện *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Vui lòng nhập quận/huyện'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: cityController,
                  decoration: const InputDecoration(
                    labelText: 'Tỉnh/Thành phố *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Vui lòng nhập tỉnh/TP' : null,
                ),
                const SizedBox(height: 12),
                StatefulBuilder(
                  builder: (context, setState) => CheckboxListTile(
                    title: const Text('Đặt làm địa chỉ mặc định'),
                    value: isDefault,
                    onChanged: (value) =>
                        setState(() => isDefault = value ?? false),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final updatedAddress = AddressModel(
                  id: address.id,
                  userId: userId,
                  recipientName: nameController.text.trim(),
                  phoneNumber: phoneController.text.trim(),
                  street: streetController.text.trim(),
                  ward: wardController.text.trim(),
                  district: districtController.text.trim(),
                  city: cityController.text.trim(),
                  isDefault: isDefault,
                  createdAt: address.createdAt,
                );

                try {
                  print('🔄 Đang cập nhật địa chỉ...');
                  await Provider.of<AddressProvider>(
                    context,
                    listen: false,
                  ).updateAddress(updatedAddress);
                  if (mounted) {
                    print('✅ Cập nhật địa chỉ thành công');
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Cập nhật địa chỉ thành công'),
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  print('❌ Lỗi khi cập nhật địa chỉ: $e');
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('❌ Lỗi: $e'),
                        backgroundColor: Colors.red,
                        duration: const Duration(seconds: 4),
                        action: SnackBarAction(
                          label: 'Đóng',
                          textColor: Colors.white,
                          onPressed: () {},
                        ),
                      ),
                    );
                  }
                }
              }
            },
            child: const Text('Lưu'),
          ),
        ],
      ),
    );
  }

  void _setDefaultAddress(AddressModel address, String userId) async {
    try {
      print('🔄 Đang đặt địa chỉ mặc định...');
      await Provider.of<AddressProvider>(
        context,
        listen: false,
      ).setDefaultAddress(userId, address.id);
      if (mounted) {
        print('✅ Đã đặt địa chỉ mặc định');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Đã đặt làm địa chỉ mặc định'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('❌ Lỗi khi đặt địa chỉ mặc định: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Lỗi: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    }
  }

  void _deleteAddress(AddressModel address, String userId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc muốn xóa địa chỉ này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                print('🔄 Đang xóa địa chỉ...');
                await Provider.of<AddressProvider>(
                  context,
                  listen: false,
                ).deleteAddress(address.id);
                if (mounted) {
                  print('✅ Xóa địa chỉ thành công');
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('✅ Xóa địa chỉ thành công'),
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              } catch (e) {
                print('❌ Lỗi khi xóa địa chỉ: $e');
                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('❌ Lỗi: $e'),
                      backgroundColor: Colors.red,
                      duration: const Duration(seconds: 4),
                      action: SnackBarAction(
                        label: 'Đóng',
                        textColor: Colors.white,
                        onPressed: () {},
                      ),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
