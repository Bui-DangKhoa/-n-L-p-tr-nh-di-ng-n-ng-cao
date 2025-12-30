import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/cart_item_model.dart';

class ProductDetailScreen extends StatelessWidget {
  final Map<String, String> product;
  final String productId;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(product["name"] ?? "Chi tiết sản phẩm"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Wishlist Button
          if (authProvider.user != null)
            FutureBuilder<bool>(
              future: wishlistProvider.isInWishlist(
                authProvider.user!.id,
                productId,
              ),
              builder: (context, snapshot) {
                final isInWishlist = snapshot.data ?? false;
                return IconButton(
                  icon: Icon(
                    isInWishlist ? Icons.favorite : Icons.favorite_border,
                    color: isInWishlist ? Colors.pink : null,
                  ),
                  onPressed: () async {
                    if (authProvider.user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Vui lòng đăng nhập để sử dụng wishlist',
                          ),
                        ),
                      );
                      return;
                    }

                    await wishlistProvider.toggleWishlist(
                      authProvider.user!.id,
                      productId,
                    );

                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            isInWishlist
                                ? 'Đã xóa khỏi danh sách yêu thích'
                                : 'Đã thêm vào danh sách yêu thích',
                          ),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    }
                  },
                );
              },
            ),
          // Cart Icon
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            Container(
              width: double.infinity,
              height: 300,
              color: Colors.grey[100],
              child: Image.network(
                product["image"] ?? "",
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Không thể tải hình ảnh",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            // Thông tin sản phẩm
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm
                  Text(
                    product["name"] ?? "Tên sản phẩm",
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Giá sản phẩm
                  Text(
                    product["price"] ?? "Giá chưa có",
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Mô tả sản phẩm
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Mô tả sản phẩm",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getProductDescription(product["name"] ?? ""),
                          style: const TextStyle(fontSize: 14, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Thông tin bổ sung
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[100]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Thông tin bổ sung",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildInfoRow("✅", "Miễn phí vận chuyển"),
                        _buildInfoRow("🔄", "Đổi trả trong 30 ngày"),
                        _buildInfoRow("🛡️", "Bảo hành chính hãng"),
                        _buildInfoRow("📞", "Hỗ trợ 24/7"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Hiển thị trạng thái giỏ hàng
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (cartProvider.isInCart(productId))
                    Text(
                      "Đã có ${cartProvider.getItemQuantity(productId)} trong giỏ",
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  Text(
                    product["price"] ?? "Giá chưa có",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),

            // Nút thêm vào giỏ hàng
            SizedBox(
              width: 200,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Lấy CartProvider
                  final cartProvider = Provider.of<CartProvider>(
                    context,
                    listen: false,
                  );

                  final firestore = FirebaseFirestore.instance;
                  final cartItem = CartItemModel(
                    productRef: firestore.collection('products').doc(productId),
                    productName: product["name"]!,
                    price: _parsePrice(product["price"]!),
                    imageUrl: product["image"]!,
                    quantity: 1,
                  );

                  cartProvider.addItem(cartItem);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "Đã thêm ${cartItem.productName} vào giỏ hàng!",
                      ),
                      backgroundColor: Colors.green,
                      duration: const Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "Xem giỏ hàng",
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushNamed(context, '/cart');
                        },
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text("Thêm vào giỏ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  String _getProductDescription(String productName) {
    // Tạo mô tả dựa trên tên sản phẩm
    if (productName.toLowerCase().contains('iphone')) {
      return "iPhone 15 mới nhất với chip A17 Pro mạnh mẽ, camera 48MP chất lượng cao, màn hình Super Retina XDR 6.1 inch. Thiết kế titanium cao cấp, pin sử dụng cả ngày, hỗ trợ sạc không dây và sạc nhanh.";
    } else if (productName.toLowerCase().contains('macbook')) {
      return "MacBook Pro với chip M3 mạnh mẽ, màn hình Liquid Retina XDR 14 inch, thời lượng pin lên đến 18 giờ. Hoàn hảo cho công việc chuyên nghiệp, chỉnh sửa video 4K, lập trình và thiết kế đồ họa.";
    } else if (productName.toLowerCase().contains('airpods')) {
      return "AirPods Pro thế hệ mới với chip H2, chống ồn chủ động tiên tiến, âm thanh không gian được cá nhân hóa. Thiết kế thoải mái, pin sử dụng lên đến 6 giờ, case sạc MagSafe.";
    } else if (productName.toLowerCase().contains('ipad')) {
      return "iPad Air với chip M1 siêu nhanh, màn hình Liquid Retina 10.9 inch, hỗ trợ Apple Pencil và Magic Keyboard. Lý tưởng cho học tập, làm việc và giải trí.";
    } else {
      return "Sản phẩm chất lượng cao với thiết kế hiện đại, tính năng vượt trội và độ bền lâu dài. Được bảo hành chính hãng và hỗ trợ kỹ thuật tận tình.";
    }
  }

  double _parsePrice(String priceString) {
    // Loại bỏ ký tự không phải số
    String cleanPrice = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}
