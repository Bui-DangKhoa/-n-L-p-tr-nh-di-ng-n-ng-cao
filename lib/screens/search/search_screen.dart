import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item_model.dart';
import '../product/product_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  final String? initialQuery;

  const SearchScreen({super.key, this.initialQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _searchResults = [];
  bool _isSearching = false;
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    if (widget.initialQuery != null && widget.initialQuery!.isNotEmpty) {
      _searchController.text = widget.initialQuery!;
      _performSearch(widget.initialQuery!);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        _searchResults = [];
        _isSearching = false;
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _currentQuery = query.trim().toLowerCase();
    });

    // Simulate search delay
    Future.delayed(const Duration(milliseconds: 500), () {
      final results = _getAllProducts()
          .where(
            (product) =>
                product["name"]!.toLowerCase().contains(_currentQuery) ||
                product["category"]!.toLowerCase().contains(_currentQuery),
          )
          .toList();

      setState(() {
        _searchResults = results;
        _isSearching = false;
      });
    });
  }

  List<Map<String, String>> _getAllProducts() {
    return [
      // Điện thoại
      {
        "name": "iPhone 15 Pro",
        "price": "30.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=400&h=400&fit=crop",
        "category": "điện thoại",
      },
      {
        "name": "Samsung Galaxy S24",
        "price": "25.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?w=400&h=400&fit=crop",
        "category": "điện thoại",
      },
      {
        "name": "Xiaomi 14",
        "price": "15.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1574944985070-8f3ebc6b79d2?w=400&h=400&fit=crop",
        "category": "điện thoại",
      },
      {
        "name": "OPPO Find X7",
        "price": "20.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=400&h=400&fit=crop",
        "category": "điện thoại",
      },
      // Laptop
      {
        "name": "MacBook Pro M3",
        "price": "50.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=400&h=400&fit=crop",
        "category": "laptop",
      },
      {
        "name": "Dell XPS 13",
        "price": "35.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1496181133206-80ce9b88a853?w=400&h=400&fit=crop",
        "category": "laptop",
      },
      {
        "name": "HP Spectre x360",
        "price": "40.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=400&h=400&fit=crop",
        "category": "laptop",
      },
      {
        "name": "Lenovo ThinkPad",
        "price": "30.000.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1588872657578-7efd1f1555ed?w=400&h=400&fit=crop",
        "category": "laptop",
      },
      // Thời trang
      {
        "name": "Áo thun nam",
        "price": "299.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?w=400&h=400&fit=crop",
        "category": "thời trang",
      },
      {
        "name": "Quần jeans",
        "price": "599.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1542272604-787c3835535d?w=400&h=400&fit=crop",
        "category": "thời trang",
      },
      {
        "name": "Giày sneaker",
        "price": "1.500.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1549298916-b41d501d3772?w=400&h=400&fit=crop",
        "category": "thời trang",
      },
      {
        "name": "Túi xách",
        "price": "800.000 ₫",
        "image":
            "https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400&h=400&fit=crop",
        "category": "thời trang",
      },
      // Sách
      {
        "name": "Sách lập trình Flutter",
        "price": "250.000 ₫",
        "image":
            "https://th.bing.com/th/id/OIP.Bnk06V7NBApK-gv8u-PoBAHaD4?o=7&cb=12rm=3&rs=1&pid=ImgDetMain&o=7&rm=3",
        "category": "sách",
      },
      {
        "name": "Tiểu thuyết",
        "price": "150.000 ₫",
        "image":
            "https://down-vn.img.susercontent.com/file/vn-11134207-7qukw-lfgebc23iq9h5a",
        "category": "sách",
      },
      {
        "name": "Sách kinh tế",
        "price": "200.000 ₫",
        "image":
            "https://cdn0.fahasa.com/media/catalog/product/9/7/9786043388121_1_1.jpg",
        "category": "sách",
      },
      {
        "name": "Sách nấu ăn",
        "price": "180.000 ₫",
        "image":
            "https://tse4.mm.bing.net/th/id/OIP.UbK9ZMJCYgHcAcBVV3M1cQHaHa?cb=12&rs=1&pid=ImgDetMain&o=7&rm=3",
        "category": "sách",
      },
      // Đồ gia dụng
      {
        "name": "Nồi cơm điện",
        "price": "1.200.000 ₫",
        "image":
            "https://th.bing.com/th/id/R.501ba0576c42ba80b6148dc1c34790ec?rik=zBBfsGD0M0EdAg&pid=ImgRaw&r=0",
        "category": "đồ gia dụng",
      },
      {
        "name": "Máy xay sinh tố",
        "price": "800.000 ₫",
        "image":
            "https://th.bing.com/th/id/R.ce36912d1d9dee47f683958ce4878101?rik=%2fs05e%2bIV0SL2VQ&pid=ImgRaw&r=0",
        "category": "đồ gia dụng",
      },
      {
        "name": "Bàn ủi",
        "price": "500.000 ₫",
        "image":
            "https://th.bing.com/th/id/R.a9a3bce60645c41d6cbae70f6443c0b5?rik=myzbcsur2GHoag&pid=ImgRaw&r=0",
        "category": "đồ gia dụng",
      },
      {
        "name": "Máy hút bụi",
        "price": "2.500.000 ₫",
        "image":
            "https://down-vn.img.susercontent.com/file/e61cd8c9eb802f6289f0cd62a4b2c818",
        "category": "đồ gia dụng",
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tìm kiếm sản phẩm"),
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
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 3,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              onChanged: _performSearch,
              onSubmitted: _performSearch,
              decoration: InputDecoration(
                hintText: "Tìm kiếm sản phẩm, danh mục...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _performSearch('');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Search Results
          Expanded(child: _buildSearchResults(cartProvider)),
        ],
      ),
    );
  }

  Widget _buildSearchResults(CartProvider cartProvider) {
    if (_currentQuery.isEmpty) {
      return _buildSearchSuggestions();
    }

    if (_isSearching) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Đang tìm kiếm..."),
          ],
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildNoResults();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            "Tìm thấy ${_searchResults.length} sản phẩm cho '$_currentQuery'",
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.65, // Adjusted for better proportion
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: _searchResults.length,
            itemBuilder: (context, index) {
              return _buildProductCard(context, index, cartProvider);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSearchSuggestions() {
    final suggestions = [
      "iPhone",
      "Samsung",
      "MacBook",
      "Laptop",
      "Áo thun",
      "Giày",
      "Sách",
      "Nồi cơm",
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Tìm kiếm phổ biến",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: suggestions.map((suggestion) {
              return ActionChip(
                label: Text(suggestion),
                onPressed: () {
                  _searchController.text = suggestion;
                  _performSearch(suggestion);
                },
                backgroundColor: Colors.blue.shade50,
                labelStyle: TextStyle(color: Colors.blue.shade700),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),
          const Text(
            "Danh mục",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildCategoryGrid(),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    final categories = [
      {"name": "Điện thoại", "icon": Icons.phone_android, "color": Colors.blue},
      {"name": "Laptop", "icon": Icons.laptop, "color": Colors.green},
      {"name": "Thời trang", "icon": Icons.checkroom, "color": Colors.purple},
      {"name": "Sách", "icon": Icons.book, "color": Colors.orange},
      {"name": "Đồ gia dụng", "icon": Icons.home, "color": Colors.red},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/category/${category["name"]}');
          },
          child: Container(
            decoration: BoxDecoration(
              color: (category["color"] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: (category["color"] as Color).withOpacity(0.3),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  category["icon"] as IconData,
                  size: 32,
                  color: category["color"] as Color,
                ),
                const SizedBox(height: 8),
                Text(
                  category["name"] as String,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: category["color"] as Color,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoResults() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            "Không tìm thấy sản phẩm nào",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "Thử tìm kiếm với từ khóa khác",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _searchController.clear();
              _performSearch('');
            },
            child: const Text("Xóa tìm kiếm"),
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
    final product = _searchResults[index];

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
                          productId: 'search_product_$index',
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
                    maxLines: 2,
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
                      final cartItem = CartItemModel(
                        productId: 'search_product_$index',
                        productName: product["name"]!,
                        price: _parsePrice(product["price"]!),
                        imageUrl: product["image"]!,
                        quantity: 1,
                      );

                      await cartProvider.addItem(cartItem);

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

  double _parsePrice(String priceString) {
    String cleanPrice = priceString.replaceAll(RegExp(r'[^\d]'), '');
    return double.tryParse(cleanPrice) ?? 0.0;
  }
}
