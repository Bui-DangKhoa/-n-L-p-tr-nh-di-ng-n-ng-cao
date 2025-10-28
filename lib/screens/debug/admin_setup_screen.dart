import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSetupScreen extends StatefulWidget {
  const AdminSetupScreen({super.key});

  @override
  State<AdminSetupScreen> createState() => _AdminSetupScreenState();
}

class _AdminSetupScreenState extends State<AdminSetupScreen> {
  bool _isLoading = false;
  String _message = '';

  Future<void> _createAdminAccount() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang tạo tài khoản admin...';
    });

    try {
      // Tạo tài khoản admin
      final authService = AuthService();
      
      final error = await authService.createUserWithEmailAndPassword(
        email: 'admin@admin.com',
        password: '123456',
        name: 'Administrator',
        phone: '0123456789',
        address: 'Admin Office',
      );

      if (error == null) {
        // Cập nhật role thành admin
        await _updateUserRole('admin@admin.com', 'admin');
        setState(() {
          _message = '✅ Tạo tài khoản admin thành công!\nEmail: admin@admin.com\nPassword: 123456';
        });
      } else {
        setState(() {
          _message = '❌ Lỗi: $error';
        });
      }
    } catch (e) {
      setState(() {
        _message = '❌ Lỗi: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateExistingAdminRole() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang cập nhật role admin...';
    });

    try {
      await _updateUserRole('admin@admin.com', 'admin');
      setState(() {
        _message = '✅ Cập nhật role admin thành công!';
      });
    } catch (e) {
      setState(() {
        _message = '❌ Lỗi cập nhật role: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _updateUserRole(String email, String role) async {
    final firestore = FirebaseFirestore.instance;
    
    // Tìm user theo email
    final querySnapshot = await firestore
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final userDoc = querySnapshot.docs.first;
      await userDoc.reference.update({'role': role});
      print('✅ Updated role for user: $email to $role');
    } else {
      throw Exception('User not found with email: $email');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Setup'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '🔧 Admin Account Setup',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Tạo hoặc cập nhật tài khoản admin để có thể quản lý sản phẩm.',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    
                    // Create Admin Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _createAdminAccount,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Tạo tài khoản Admin mới'),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    // Update Role Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _updateExistingAdminRole,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text('Cập nhật role Admin (nếu đã tồn tại)'),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Loading indicator
                    if (_isLoading)
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                    
                    // Message
                    if (_message.isNotEmpty)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: _message.startsWith('✅') 
                              ? Colors.green.shade50 
                              : Colors.red.shade50,
                          border: Border.all(
                            color: _message.startsWith('✅') 
                                ? Colors.green 
                                : Colors.red,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          _message,
                          style: TextStyle(
                            color: _message.startsWith('✅') 
                                ? Colors.green.shade800 
                                : Colors.red.shade800,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 20),
            
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'ℹ️ Thông tin tài khoản Admin',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text('Email: admin@admin.com'),
                    const Text('Password: 123456'),
                    const Text('Role: admin'),
                    const SizedBox(height: 10),
                    const Text(
                      'Sau khi setup, đăng xuất và đăng nhập lại với tài khoản admin để thấy menu "Quản lý sản phẩm".',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}