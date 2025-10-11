import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Người dùng chưa đăng nhập');
      }

      // Xác thực lại với mật khẩu hiện tại
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _currentPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Đổi mật khẩu
      await user.updatePassword(_newPasswordController.text);

      if (!mounted) return;

      // Hiển thị thông báo thành công
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Đổi mật khẩu thành công!'),
          backgroundColor: Colors.green,
        ),
      );

      // Quay lại màn hình trước
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String errorMessage;
      switch (e.code) {
        case 'wrong-password':
          errorMessage = 'Mật khẩu hiện tại không đúng';
          break;
        case 'weak-password':
          errorMessage = 'Mật khẩu mới quá yếu';
          break;
        case 'requires-recent-login':
          errorMessage = 'Vui lòng đăng nhập lại và thử lại';
          break;
        default:
          errorMessage = 'Lỗi: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ $errorMessage'), backgroundColor: Colors.red),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ Lỗi không xác định: $e'),
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
        title: const Text('Đổi mật khẩu'),
        backgroundColor: Colors.orange,
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
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange[200]!),
                ),
                child: Column(
                  children: [
                    Icon(Icons.security, size: 64, color: Colors.orange[600]),
                    const SizedBox(height: 16),
                    Text(
                      'Thay đổi mật khẩu',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Đảm bảo tài khoản an toàn với mật khẩu mạnh',
                      style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Mật khẩu hiện tại
              _buildPasswordField(
                controller: _currentPasswordController,
                label: 'Mật khẩu hiện tại',
                isVisible: _showCurrentPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _showCurrentPassword = !_showCurrentPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Mật khẩu mới
              _buildPasswordField(
                controller: _newPasswordController,
                label: 'Mật khẩu mới',
                isVisible: _showNewPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _showNewPassword = !_showNewPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập mật khẩu mới';
                  }
                  if (value.length < 6) {
                    return 'Mật khẩu phải có ít nhất 6 ký tự';
                  }
                  if (value == _currentPasswordController.text) {
                    return 'Mật khẩu mới phải khác mật khẩu hiện tại';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Xác nhận mật khẩu mới
              _buildPasswordField(
                controller: _confirmPasswordController,
                label: 'Xác nhận mật khẩu mới',
                isVisible: _showConfirmPassword,
                onVisibilityToggle: () {
                  setState(() {
                    _showConfirmPassword = !_showConfirmPassword;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng xác nhận mật khẩu mới';
                  }
                  if (value != _newPasswordController.text) {
                    return 'Mật khẩu xác nhận không khớp';
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
                      onPressed: _isLoading ? null : _changePassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
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
                                Text('Đang đổi...'),
                              ],
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.vpn_key),
                                SizedBox(width: 8),
                                Text(
                                  'Đổi mật khẩu',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Security tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.security, color: Colors.blue[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Mẹo bảo mật',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTip('• Sử dụng ít nhất 8 ký tự'),
                    _buildTip(
                      '• Kết hợp chữ hoa, chữ thường, số và ký tự đặc biệt',
                    ),
                    _buildTip('• Không sử dụng thông tin cá nhân dễ đoán'),
                    _buildTip('• Thay đổi mật khẩu định kỳ'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool isVisible,
    required VoidCallback onVisibilityToggle,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !isVisible,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(isVisible ? Icons.visibility : Icons.visibility_off),
          onPressed: onVisibilityToggle,
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.orange, width: 2),
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

  Widget _buildTip(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
      ),
    );
  }
}
