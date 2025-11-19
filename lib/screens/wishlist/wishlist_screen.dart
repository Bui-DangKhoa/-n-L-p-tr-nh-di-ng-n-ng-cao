import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wishlist_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item_model.dart';
import '../product/product_detail_screen.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  @override
  void initState() {
    super.initState();
    print('🔧 WishlistScreen: initState called');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      print('🔧 WishlistScreen: User = ${authProvider.user?.email}');
      if (authProvider.user != null) {
        print(
          '🔧 WishlistScreen: Loading wishlist for userId: ${authProvider.user!.id}',
        );
        Provider.of<WishlistProvider>(
          context,
          listen: false,
        ).loadWishlist(authProvider.user!.id);
      } else {
        print('⚠️ WishlistScreen: User is null, cannot load wishlist');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    print('🔧 WishlistScreen build:');
    print('   - isLoading: ${wishlistProvider.isLoading}');
    print('   - wishlistItems: ${wishlistProvider.wishlistItems.length}');
    print('   - wishlistProducts: ${wishlistProvider.wishlistProducts.length}');

    if (authProvider.user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Danh sach yeu thich')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite_border, size: 100, color: Colors.grey[400]),
              const SizedBox(height: 16),
              const Text(
                'Vui long dang nhap de xem danh sach yeu thich',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Dang nhap'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sach yeu thich'),
        actions: [
          if (wishlistProvider.wishlistProducts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              tooltip: 'Xoa tat ca',
              onPressed: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Xoa tat ca'),
                    content: const Text(
                      'Ban co chac muon xoa tat ca san pham?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Huy'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Xoa'),
                      ),
                    ],
                  ),
                );

                if (confirm == true && mounted) {
                  for (var product in wishlistProvider.wishlistProducts) {
                    await wishlistProvider.removeFromWishlist(
                      authProvider.user!.id,
                      product.id,
                    );
                  }

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Da xoa tat ca san pham')),
                    );
                  }
                }
              },
            ),
        ],
      ),
      body: wishlistProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistProvider.wishlistProducts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 100,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Danh sach yeu thich trong',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Them san pham yeu thich de xem o day',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: wishlistProvider.wishlistProducts.length,
              padding: const EdgeInsets.all(8),
              itemBuilder: (context, index) {
                final product = wishlistProvider.wishlistProducts[index];

                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(
                            productId: product.id,
                            product: {
                              'id': product.id,
                              'name': product.name,
                              'price': product.price.toString(),
                              'imageUrl': product.imageUrls.isNotEmpty
                                  ? product.imageUrls[0]
                                  : '',
                              'description': product.description,
                              'category': product.category,
                            },
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              product.imageUrls.isNotEmpty
                                  ? product.imageUrls[0]
                                  : '',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${product.price.toStringAsFixed(0)} d',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ElevatedButton.icon(
                                      onPressed: () async {
                                        final cartItem = CartItemModel(
                                          productId: product.id,
                                          productName: product.name,
                                          price: product.price,
                                          imageUrl: product.imageUrls.isNotEmpty
                                              ? product.imageUrls[0]
                                              : '',
                                          quantity: 1,
                                        );

                                        await cartProvider.addItem(cartItem);

                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Da them ${product.name} vao gio hang',
                                              ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.shopping_cart,
                                        size: 18,
                                      ),
                                      label: const Text('Them'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      onPressed: () async {
                                        await wishlistProvider
                                            .removeFromWishlist(
                                              authProvider.user!.id,
                                              product.id,
                                            );

                                        if (mounted) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Da xoa ${product.name}',
                                              ),
                                              duration: const Duration(
                                                seconds: 2,
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      icon: const Icon(Icons.delete),
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
