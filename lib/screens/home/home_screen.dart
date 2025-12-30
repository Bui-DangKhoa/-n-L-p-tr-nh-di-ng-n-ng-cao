import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart'; // ✅ Import từ package provider (không phải file local)
import '../../providers/auth_provider.dart'; // ✅ Import file auth_provider của bạn
import '../../providers/cart_provider.dart'; // ✅ Import cart provider
import '../../providers/wishlist_provider.dart'; // 🆕 Import wishlist provider
import '../../providers/banner_provider.dart';
import '../../providers/brand_provider.dart';
import '../../models/cart_item_model.dart'; // ✅ Import cart item model
import '../../models/category_model.dart'; // 🆕 Import category model
import '../../services/product_service.dart'; // ✅ Import product service
import '../../services/category_service.dart'; // 🆕 Import category service
import '../product/product_detail_screen.dart';
import '../category/category_products_screen.dart'; // 🆕 Import category products screen

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final CategoryService _categoryService = CategoryService(); // 🆕 Category service
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  String? _loadedWishlistUserId;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _ensureWishlistLoaded();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _productService.getAllProducts();
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading products: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
    ); // 🆕 Wishlist provider
    final bannerProvider = Provider.of<BannerProvider>(context);
    final brandProvider = Provider.of<BrandProvider>(context);
    final role = (authProvider.user?.role ?? '').trim().toLowerCase();
    final email = (authProvider.user?.email ?? '').trim().toLowerCase();
    final isAdmin = role == 'admin' || email == 'admin@admin.com';

    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopping App"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Admin Menu (only for admin users)
          if (isAdmin)
            PopupMenuButton<String>(
              icon: const Icon(Icons.admin_panel_settings),
              onSelected: (value) {
                switch (value) {
                  case 'manage_products':
                    Navigator.pushNamed(context, '/admin/products');
                    break;
                  case 'manage_coupons':
                    Navigator.pushNamed(context, '/admin/coupons');
                    break;
                  case 'manage_brands':
                    Navigator.pushNamed(context, '/admin/brands');
                    break;
                  case 'manage_banners':
                    Navigator.pushNamed(context, '/admin/banners');
                    break;
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(
                  value: 'manage_products',
                  child: Row(
                    children: [
                      Icon(Icons.inventory, color: Colors.blue),
                      SizedBox(width: 8),
                      Text('Quản lý sản phẩm'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'manage_coupons',
                  child: Row(
                    children: [
                      Icon(Icons.discount, color: Colors.purple),
                      SizedBox(width: 8),
                      Text('Quản lý mã giảm giá'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'manage_brands',
                  child: Row(
                    children: [
                      Icon(Icons.business_center, color: Colors.green),
                      SizedBox(width: 8),
                      Text('Quản lý thương hiệu'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'manage_banners',
                  child: Row(
                    children: [
                      Icon(Icons.photo_library, color: Colors.orange),
                      SizedBox(width: 8),
                      Text('Quản lý banner'),
                    ],
                  ),
                ),
              ],
            ),
          // 🆕 Wishlist Icon
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.pushNamed(context, '/wishlist');
                },
              ),
              if (wishlistProvider.wishlistCount > 0)
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.pink,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${wishlistProvider.wishlistCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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
            _buildHeroArea(authProvider, bannerProvider),

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

            // Categories Section - Dynamic from Firebase
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Danh mục sản phẩm",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      if (isAdmin)
                        TextButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/category-management');
                          },
                          icon: const Icon(Icons.settings, size: 16),
                          label: const Text('Quản lý'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.blue,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<CategoryModel>>(
                    stream: _categoryService.getCategories(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const SizedBox(
                          height: 120,
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (snapshot.hasError) {
                        return SizedBox(
                          height: 120,
                          child: Center(
                            child: Text(
                              'Lỗi: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          ),
                        );
                      }

                      final categories = snapshot.data ?? [];

                      if (categories.isEmpty) {
                        return SizedBox(
                          height: 120,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.category_outlined, 
                                  size: 40, 
                                  color: Colors.grey[400]
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Chưa có danh mục',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                                if (isAdmin) ...[
                                  const SizedBox(height: 4),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pushNamed(context, '/category-management');
                                    },
                                    child: const Text('Thêm danh mục'),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: categories.length,
                          itemBuilder: (context, index) {
                            final category = categories[index];
                            return _buildDynamicCategoryCard(context, category, index);
                          },
                        ),
                      );
                    },
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
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _products.isEmpty
                      ? const Center(
                          child: Text(
                            'Chưa có sản phẩm nào',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.65,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return _buildProductCard(
                              context,
                              index,
                              cartProvider,
                            );
                          },
                        ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            if (brandProvider.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (brandProvider.brands.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Thương hiệu nổi bật",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 90,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: brandProvider.brands.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (context, index) {
                          final brand = brandProvider.brands[index];
                          return Container(
                            width: 120,
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.blue.shade50,
                                  backgroundImage: brand.logoUrl.isNotEmpty
                                      ? NetworkImage(brand.logoUrl)
                                      : null,
                                  child: brand.logoUrl.isEmpty
                                      ? Text(
                                          brand.name.isNotEmpty
                                              ? brand.name[0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.blue,
                                          ),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  brand.name,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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

  // Dynamic category card from Firebase
  Widget _buildDynamicCategoryCard(
    BuildContext context,
    CategoryModel category,
    int index,
  ) {
    // Rotate colors for visual variety
    final colors = [
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.red,
      Colors.teal,
      Colors.pink,
      Colors.indigo,
    ];
    final color = colors[index % colors.length];

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryProductsScreen(category: category),
          ),
        );
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
            // Try to load image if available, otherwise use icon
            if (category.imageUrl.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  category.imageUrl,
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.category, size: 40, color: color);
                  },
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return SizedBox(
                      width: 50,
                      height: 50,
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: color,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Icon(Icons.category, size: 40, color: color),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                category.name,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroArea(
    AuthProvider authProvider,
    BannerProvider bannerProvider,
  ) {
    return Column(
      children: [
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
        if (bannerProvider.isLoading)
          const SizedBox(
            height: 180,
            child: Center(child: CircularProgressIndicator()),
          )
        else if (bannerProvider.banners.isNotEmpty)
          SizedBox(
            height: 200,
            child: PageView.builder(
              controller: PageController(viewportFraction: 0.9),
              itemCount: bannerProvider.banners.length,
              itemBuilder: (context, index) {
                final banner = bannerProvider.banners[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 12,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          banner.imageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                color: Colors.grey[200],
                                child: const Icon(Icons.image, size: 48),
                              ),
                        ),
                        if (banner.title.isNotEmpty)
                          Positioned(
                            left: 16,
                            right: 16,
                            bottom: 16,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    int index,
    CartProvider cartProvider,
  ) {
    final product = _products[index];
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final wishlistProvider = Provider.of<WishlistProvider>(
      context,
      listen: false,
    );
    final productId = product["id"]?.toString() ?? 'product_${index + 1}';

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image with fixed aspect ratio and wishlist button
          Stack(
            children: [
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
                      product["imageUrl"] ?? product["image"] ?? '',
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
              // Wishlist Button
              if (authProvider.user != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: FutureBuilder<bool>(
                    future: wishlistProvider.isInWishlist(
                      authProvider.user!.id,
                      productId,
                    ),
                    builder: (context, snapshot) {
                      final isInWishlist = snapshot.data ?? false;
                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: IconButton(
                          icon: Icon(
                            isInWishlist
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: isInWishlist
                                ? Colors.pink
                                : Colors.grey[600],
                            size: 20,
                          ),
                          onPressed: () async {
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
                                  duration: const Duration(seconds: 1),
                                ),
                              );
                            }
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      );
                    },
                  ),
                ),
            ],
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
                          product: {
                            'name': product["name"]?.toString() ?? '',
                            'price': _formatPrice(product["price"]),
                            'image':
                                product["imageUrl"]?.toString() ??
                                product["image"]?.toString() ??
                                '',
                          },
                          productId:
                              product["id"]?.toString() ??
                              'product_${index + 1}',
                        ),
                      ),
                    );
                  },
                  child: Text(
                    product["name"]?.toString() ?? 'Unknown',
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
                  _formatPrice(product["price"]),
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
                      final productId =
                          product["id"]?.toString() ?? 'product_${index + 1}';
                      final cartItem = CartItemModel(
                        productRef: firestore
                            .collection('products')
                            .doc(productId),
                        productName: product["name"]?.toString() ?? 'Unknown',
                        price: (product["price"] is num)
                            ? (product["price"] as num).toDouble()
                            : 0.0,
                        imageUrl:
                            product["imageUrl"]?.toString() ??
                            product["image"]?.toString() ??
                            '',
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

  void _ensureWishlistLoaded() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final user = authProvider.user;

    if (user == null) {
      _loadedWishlistUserId = null;
      return;
    }

    if (_loadedWishlistUserId == user.id) {
      return;
    }

    Provider.of<WishlistProvider>(context, listen: false).loadWishlist(user.id);
    _loadedWishlistUserId = user.id;
  }

  // Helper method để format giá
  String _formatPrice(dynamic price) {
    if (price == null) return '0 ₫';
    double priceValue = 0.0;
    if (price is num) {
      priceValue = price.toDouble();
    } else if (price is String) {
      priceValue = double.tryParse(price) ?? 0.0;
    }
    return '${priceValue.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')} ₫';
  }
}
