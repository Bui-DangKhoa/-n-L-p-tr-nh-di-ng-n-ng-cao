import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone;
      _addressController.text = user.address;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final currentUser = authProvider.user;

      if (currentUser == null) {
        throw Exception('Không tìm thấy thông tin người dùng');
      }

      // Cập nhật thông tin trong Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.id)
          .update({
            'name': _nameController.text.trim(),
            'phone': _phoneController.text.trim(),
            'address': _addressController.text.trim(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      // Cập nhật UserModel trong AuthProvider
      final updatedUser = UserModel(
        id: currentUser.id,
        email: currentUser.email,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        role: currentUser.role,
        createdAt: currentUser.createdAt,
      );

      authProvider.updateUserModel(updatedUser);

      if (!mounted) return;

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Cập nhật thông tin thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Quay lại màn hình trước
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Lỗi cập nhật: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chỉnh sửa thông tin'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.edit, size: 64, color: Colors.blue[600]),
                    const SizedBox(height: 16),
                    Text(
                      'Cập nhật thông tin cá nhân',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Thay đổi thông tin tên, số điện thoại và địa chỉ',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Form fields
              _buildTextField(
                controller: _nameController,
                label: 'Tên đầy đủ',
                icon: Icons.person,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập tên';
                  }
                  if (value.trim().length < 2) {
                    return 'Tên phải có ít nhất 2 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _phoneController,
                label: 'Số điện thoại',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập số điện thoại';
                  }
                  if (!RegExp(r'^[0-9+\-\s()]+$').hasMatch(value.trim())) {
                    return 'Số điện thoại không hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _addressController,
                label: 'Địa chỉ',
                icon: Icons.location_on,
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập địa chỉ';
                  }
                  if (value.trim().length < 10) {
                    return 'Địa chỉ phải có ít nhất 10 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _isLoading
                          ? null
                          : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Hủy', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _updateProfile,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Đang cập nhật...'),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.save),
                                SizedBox(width: 8),
                                Text(
                                  'Cập nhật',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Info note
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.amber[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber[200]!),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.amber[700]),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Thông tin sẽ được cập nhật ngay lập tức và đồng bộ với tài khoản của bạn.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.amber[700],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.red, width: 2),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }
}
