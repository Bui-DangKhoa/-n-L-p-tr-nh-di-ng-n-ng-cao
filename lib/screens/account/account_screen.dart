import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    // Debug trạng thái đăng nhập
    print("🔍 AccountScreen: authProvider.user = ${authProvider.user}");
    print(
      "🔍 AccountScreen: authProvider.isLoggedIn = ${authProvider.isLoggedIn}",
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tài khoản"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.pushNamed(context, '/cart');
                },
              ),
              if (cartProvider.totalQuantity > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${cartProvider.totalQuantity}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: authProvider.user == null
          ? _buildNotLoggedIn(context)
          : _buildLoggedInContent(context, authProvider, cartProvider),
    );
  }

  Widget _buildNotLoggedIn(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_outline, size: 100, color: Colors.grey[400]),
            const SizedBox(height: 24),
            const Text(
              "Chưa đăng nhập",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Đăng nhập để xem thông tin tài khoản và quản lý đơn hàng",
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login',
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Đăng nhập",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                "Tạo tài khoản mới",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedInContent(
    BuildContext context,
    AuthProvider authProvider,
    CartProvider cartProvider,
  ) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Profile Header
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.blue, Colors.blueAccent],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.white,
                    child: Text(
                      authProvider.user!.name.isNotEmpty
                          ? authProvider.user!.name[0].toUpperCase()
                          : "U",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    authProvider.user!.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    authProvider.user!.email,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),

          // Account Info
          const SizedBox(height: 24),
          _buildSection(
            title: "Thông tin tài khoản",
            children: [
              _buildInfoTile(
                icon: Icons.person,
                title: "Họ và tên",
                subtitle: authProvider.user!.name,
                color: Colors.blue,
              ),
              _buildInfoTile(
                icon: Icons.email,
                title: "Email",
                subtitle: authProvider.user!.email,
                color: Colors.green,
              ),
              _buildInfoTile(
                icon: Icons.phone,
                title: "Số điện thoại",
                subtitle: authProvider.user!.phone,
                color: Colors.orange,
              ),
              _buildInfoTile(
                icon: Icons.location_on,
                title: "Địa chỉ",
                subtitle: authProvider.user!.address,
                color: Colors.red,
              ),
            ],
          ),

          // Shopping Info
          const SizedBox(height: 24),
          _buildSection(
            title: "Thông tin mua sắm",
            children: [
              _buildInfoTile(
                icon: Icons.shopping_bag,
                title: "Sản phẩm trong giỏ",
                subtitle: "${cartProvider.totalQuantity} sản phẩm",
                color: Colors.purple,
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
              _buildInfoTile(
                icon: Icons.attach_money,
                title: "Tổng giá trị giỏ hàng",
                subtitle: "${_formatPrice(cartProvider.totalAmount)} ₫",
                color: Colors.green,
                onTap: () => Navigator.pushNamed(context, '/cart'),
              ),
            ],
          ),

          // Settings
          const SizedBox(height: 24),
          _buildSection(
            title: "Cài đặt",
            children: [
              _buildActionTile(
                icon: Icons.edit,
                title: "Chỉnh sửa thông tin",
                subtitle: "Cập nhật thông tin cá nhân",
                color: Colors.blue,
                onTap: () {
                  Navigator.pushNamed(context, '/edit-profile');
                },
              ),
              _buildActionTile(
                icon: Icons.security,
                title: "Đổi mật khẩu",
                subtitle: "Thay đổi mật khẩu tài khoản",
                color: Colors.orange,
                onTap: () {
                  Navigator.pushNamed(context, '/change-password');
                },
              ),
              _buildActionTile(
                icon: Icons.notifications,
                title: "Thông báo",
                subtitle: "Quản lý thông báo",
                color: Colors.purple,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Chức năng đang phát triển")),
                  );
                },
              ),
            ],
          ),

          // Logout
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context, authProvider);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout),
                    SizedBox(width: 8),
                    Text(
                      "Đăng xuất",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: onTap != null
          ? const Icon(Icons.arrow_forward_ios, size: 16)
          : null,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: color),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  void _showLogoutDialog(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Đăng xuất"),
          content: const Text("Bạn có chắc chắn muốn đăng xuất?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                await authProvider.logout();
                if (!context.mounted) return;
                Navigator.of(context).pop(); // Close dialog
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/login',
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text("Đăng xuất"),
            ),
          ],
        );
      },
    );
  }

  String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
