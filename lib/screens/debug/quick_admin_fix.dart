import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuickAdminFix extends StatefulWidget {
  const QuickAdminFix({super.key});

  @override
  State<QuickAdminFix> createState() => _QuickAdminFixState();
}

class _QuickAdminFixState extends State<QuickAdminFix> {
  String _message = '';
  bool _isLoading = false;

  Future<void> _fixAdminRole() async {
    setState(() {
      _isLoading = true;
      _message = 'Đang cập nhật role admin...';
    });

    try {
      final firestore = FirebaseFirestore.instance;

      // Update tất cả user có email admin@admin.com thành role admin
      final query = await firestore
          .collection('users')
          .where('email', isEqualTo: 'admin@admin.com')
          .get();

      if (query.docs.isNotEmpty) {
        // Update role
        for (var doc in query.docs) {
          await doc.reference.update({
            'role': 'admin',
            'updatedAt': FieldValue.serverTimestamp(),
          });
        }

        setState(() {
          _message =
              '✅ Đã cập nhật ${query.docs.length} tài khoản admin!\n\nBây giờ hãy:\n1. Đăng xuất\n2. Đăng nhập lại với admin@admin.com\n3. Kiểm tra icon admin ở AppBar';
        });
      } else {
        setState(() {
          _message =
              '❌ Không tìm thấy tài khoản admin@admin.com\n\nVui lòng đăng ký tài khoản này trước!';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quick Admin Fix'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Card(
              color: Colors.orange.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.warning, size: 48, color: Colors.orange),
                    const SizedBox(height: 16),
                    const Text(
                      'Không thấy menu Admin?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Nhấn nút bên dưới để fix role admin và làm theo hướng dẫn.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _fixAdminRole,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const Text(
                                'FIX ADMIN ROLE',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            if (_message.isNotEmpty)
              Card(
                color: _message.startsWith('✅')
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _message,
                    style: TextStyle(
                      fontSize: 14,
                      color: _message.startsWith('✅')
                          ? Colors.green.shade700
                          : Colors.red.shade700,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            Card(
              color: Colors.blue.shade50,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    Icon(Icons.info, color: Colors.blue, size: 40),
                    SizedBox(height: 10),
                    Text(
                      'Hướng dẫn',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '1. Đăng ký tài khoản admin@admin.com (nếu chưa có)\n'
                      '2. Nhấn "FIX ADMIN ROLE"\n'
                      '3. Đăng xuất khỏi app\n'
                      '4. Đăng nhập lại với admin@admin.com\n'
                      '5. Kiểm tra icon ⚙️ ở góc phải AppBar\n'
                      '6. Nhấn icon → "Quản lý sản phẩm"',
                      style: TextStyle(fontSize: 14),
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
