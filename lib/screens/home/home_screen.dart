import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // ✅ Import từ package provider (không phải file local)
import '../../providers/auth_provider.dart'; // ✅ Import file auth_provider của bạn
import '../../providers/cart_provider.dart'; // ✅ Import cart provider
import '../../models/cart_item_model.dart'; // ✅ Import cart item model
import '../product/product_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping App"),
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
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await authProvider.logout();
              if (!context.mounted) return;
              Navigator.pushReplacementNamed(context, "/login");
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Banner
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.blue, Colors.blueAccent],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authProvider.user != null
                          ? "Xin chào, ${authProvider.user!.name}!"
                          : "Chào mừng đến với Shopping App!",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Khám phá hàng ngàn sản phẩm chất lượng",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/search');
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.search, color: Colors.grey[500]),
                      const SizedBox(width: 12),
                      Text(
                        "Tìm kiếm sản phẩm...",
                        style: TextStyle(color: Colors.grey[500], fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Danh mục sản phẩm",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 120,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        _buildCategoryCard(
                          context,
                          "Điện thoại",
                          Icons.phone_android,
                          Colors.blue,
                        ),
                        _buildCategoryCard(
                          context,
                          "Laptop",
                          Icons.laptop,
                          Colors.green,
                        ),
                        _buildCategoryCard(
                          context,
                          "Thời trang",
                          Icons.checkroom,
                          Colors.purple,
                        ),
                        _buildCategoryCard(
                          context,
                          "Sách",
                          Icons.book,
                          Colors.orange,
                        ),
                        _buildCategoryCard(
                          context,
                          "Đồ gia dụng",
                          Icons.home,
                          Colors.red,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Featured Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Sản phẩm nổi bật",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                    itemCount: 4,
                    itemBuilder: (context, index) {
                      return _buildProductCard(context, index, cartProvider);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // User Info Section (if logged in)
            if (authProvider.user != null)
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin tài khoản",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListTile(
                          leading: const Icon(Icons.email, color: Colors.blue),
                          title: const Text("Email"),
                          subtitle: Text(authProvider.user!.email),
                        ),
                        ListTile(
                          leading: const Icon(Icons.phone, color: Colors.green),
                          title: const Text("Số điện thoại"),
                          subtitle: Text(authProvider.user!.phone),
                        ),
                        ListTile(
                          leading: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                          ),
                          title: const Text("Địa chỉ"),
                          subtitle: Text(authProvider.user!.address),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Tìm kiếm"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Đang ở trang chủ
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Đang ở trang chủ")));
              break;
            case 1:
              // Chuyển đến trang tìm kiếm
              Navigator.pushNamed(context, '/search');
              break;
            case 2:
              // Chuyển đến giỏ hàng
              Navigator.pushNamed(context, '/cart');
              break;
            case 3:
              // Chuyển đến trang tài khoản
              Navigator.pushNamed(context, '/account');
              break;
          }
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/category/$title');
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    int index,
    CartProvider cartProvider,
  ) {
    final products = _getProducts();
    final product = products[index];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: Image.network(
                  product["image"]!,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[200],
                      child: const Icon(
                        Icons.image_not_supported,
                        size: 48,
                        color: Colors.grey,
                      ),
                    );
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      color: Colors.grey[100],
                      child: const Center(child: CircularProgressIndicator()),
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    // Navigate to product detail screen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                          productId: 'product_${index + 1}',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    product["name"]!,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  product["price"]!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.blue,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Tạo cart item từ dữ liệu
                      final cartItem = CartItemModel(
                        productId: 'product_${index + 1}',
                        productName: product["name"]!,
                        price: _parsePrice(product["price"]!),
                        imageUrl: product["image"]!,
                        quantity: 1,
                      );

                      // Thêm vào giỏ hàng
                      cartProvider.addItem(cartItem);

                      // Hiển thị thông báo
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            "Đã thêm ${cartItem.productName} vào giỏ hàng!",
                          ),
                          backgroundColor: Colors.green,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text("Thêm vào giỏ"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Helper method để lấy danh sách sản phẩm
  List<Map<String, String>> _getProducts() {
    return [
      {
        "name": "iPhone 15",
        "price": "25.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop",
      },
      {
        "name": "MacBook Pro",
        "price": "45.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop",
      },
      {
        "name": "AirPods Pro",
        "price": "6.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1606220588913-b3aacb4d2f46?w=400&h=400&fit=crop",
      },
      {
        "name": "iPad Air",
        "price": "18.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0?w=400&h=400&fit=crop",
      },
    ];
  }

  // Helper method để parse giá từ string
  double _parsePrice(String priceString) {
    // Loại bỏ ký tự không phải số
    String cleanPrice = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}
