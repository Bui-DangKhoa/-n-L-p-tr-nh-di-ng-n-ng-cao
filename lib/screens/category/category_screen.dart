import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item_model.dart';
import '../product/product_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh mục: $categoryName"),
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getCategoryColor().withOpacity(0.8),
                      _getCategoryColor(),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(_getCategoryIcon(), size: 40, color: Colors.white),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                categoryName,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${_getProductsByCategory().length} sản phẩm",
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Products Grid
              Text(
                "Sản phẩm ${categoryName.toLowerCase()}",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              _getProductsByCategory().isEmpty
                  ? _buildEmptyCategory(context)
                  : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio:
                                0.65, // Adjusted for better proportion
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                      itemCount: _getProductsByCategory().length,
                      itemBuilder: (context, index) {
                        return _buildProductCard(context, index, cartProvider);
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyCategory(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 40),
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Chưa có sản phẩm nào trong danh mục này",
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Quay lại trang chủ"),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    int index,
    CartProvider cartProvider,
  ) {
    final products = _getProductsByCategory();
    final product = products[index];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with fixed aspect ratio
          AspectRatio(
            aspectRatio: 1.2, // Width : Height ratio for better proportion
            child: Container(
              width: double.infinity,
              height: 180,
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
                  height: 180,
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
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
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
                          productId: 'product_${categoryName}_${index + 1}',
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
                    onPressed: () async {
                      // Lấy CartProvider
                      final cartProvider = Provider.of<CartProvider>(
                        context,
                        listen: false,
                      );

                      // Tạo cart item từ dữ liệu
                      final firestore = FirebaseFirestore.instance;
                      final productId = 'product_${categoryName}_${index + 1}';
                      final cartItem = CartItemModel(
                        productRef: firestore
                            .collection('products')
                            .doc(productId),
                        productName: product["name"]!,
                        price: _parsePrice(product["price"]!),
                        imageUrl: product["image"]!,
                        quantity: 1,
                      );

                      // Thêm vào giỏ hàng
                      await cartProvider.addItem(cartItem);

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
                      backgroundColor: _getCategoryColor(),
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

  // Lấy màu sắc theo danh mục
  Color _getCategoryColor() {
    switch (categoryName) {
      case "Điện thoại":
        return Colors.blue;
      case "Laptop":
        return Colors.green;
      case "Thời trang":
        return Colors.purple;
      case "Sách":
        return Colors.orange;
      case "Đồ gia dụng":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // Lấy icon theo danh mục
  IconData _getCategoryIcon() {
    switch (categoryName) {
      case "Điện thoại":
        return Icons.phone_android;
      case "Laptop":
        return Icons.laptop;
      case "Thời trang":
        return Icons.checkroom;
      case "Sách":
        return Icons.book;
      case "Đồ gia dụng":
        return Icons.home;
      default:
        return Icons.category;
    }
  }

  // Lấy sản phẩm theo danh mục
  List<Map<String, String>> _getProductsByCategory() {
    switch (categoryName) {
      case "Điện thoại":
        return [
          {
            "name": "iPhone 15 Pro",
            "price": "30.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop",
          },
          {
            "name": "Samsung Galaxy S24",
            "price": "25.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop",
          },
          {
            "name": "Xiaomi 14",
            "price": "15.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=400&h=400&fit=crop",
          },
          {
            "name": "OPPO Find X7",
            "price": "20.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop",
          },
        ];
      case "Laptop":
        return [
          {
            "name": "MacBook Pro M3",
            "price": "50.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop",
          },
          {
            "name": "Dell XPS 13",
            "price": "35.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop",
          },
          {
            "name": "HP Spectre x360",
            "price": "40.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=400&fit=crop",
          },
          {
            "name": "Lenovo ThinkPad",
            "price": "30.000.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400&h=400&fit=crop",
          },
        ];
      case "Thời trang":
        return [
          {
            "name": "Áo thun nam",
            "price": "299.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop",
          },
          {
            "name": "Quần jeans",
            "price": "599.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=400&fit=crop",
          },
          {
            "name": "Giày sneaker",
            "price": "1.500.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop",
          },
          {
            "name": "Túi xách",
            "price": "800.000 ₫",
            "image":
                "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=400&fit=crop",
          },
        ];
      case "Sách":
        return [
          {
            "name": "Sách lập trình Flutter",
            "price": "250.000 ₫",
            "image":
                "https://th.bing.com/th/id/OIP.Bnk06V7NBApK-gv8u-PoBAHaD4?o=7&cb=12rm=3&rs=1&pid=ImgDetMain&o=7&rm=3",
          },
          {
            "name": "Tiểu thuyết",
            "price": "150.000 ₫",
            "image":
                "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lfgebc23iq9h5a",
          },
          {
            "name": "Sách kinh tế",
            "price": "200.000 ₫",
            "image":
                "https://cdn0.fahasa.com/media/catalog/product/9/7/9786043388121_1_1.jpg",
          },
          {
            "name": "Sách nấu ăn",
            "price": "180.000 ₫",
            "image":
                "https://tse4.mm.bing.net/th/id/OIP.UbK9ZMJCYgHcAcBVV3M1cQHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3",
          },
        ];
      case "Đồ gia dụng":
        return [
          {
            "name": "Nồi cơm điện",
            "price": "1.200.000 ₫",
            "image":
                "https://th.bing.com/th/id/R.501ba0576c42ba80b6148dc1c34790ec?rik=zBBfsGD0M0EdAg&pid=ImgRaw&r=0",
          },
          {
            "name": "Máy xay sinh tố",
            "price": "800.000 ₫",
            "image":
                "https://th.bing.com/th/id/R.ce36912d1d9dee47f683958ce4878101?rik=%2fs05e%2bIV0SL2VQ&pid=ImgRaw&r=0",
          },
          {
            "name": "Bàn ủi",
            "price": "500.000 ₫",
            "image":
                "https://th.bing.com/th/id/R.a9a3bce60645c41d6cbae70f6443c0b5?rik=myzbcsur2GHoag&pid=ImgRaw&r=0",
          },
          {
            "name": "Máy hút bụi",
            "price": "2.500.000 ₫",
            "image":
                "https://down-vn.img.susercontent.com/file/e61cd8c9eb802f6289f0cd62a4b2c818",
          },
        ];
      default:
        return [];
    }
  }

  // Helper method để parse giá từ string
  double _parsePrice(String priceString) {
    String cleanPrice = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}
