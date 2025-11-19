import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/cart_provider.dart';
import '../../models/cart_item_model.dart';
import '../../models/coupon_model.dart';
import '../../services/coupon_service.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Load giỏ hàng từ Firebase khi màn hình khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CartProvider>(context, listen: false).loadCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Giỏ hàng"),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: cartProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartProvider.items.isEmpty
          ? _buildEmptyCart(context)
          : _buildCartContent(context, cartProvider),
      bottomNavigationBar:
          cartProvider.items.isNotEmpty && !cartProvider.isLoading
          ? _buildCheckoutButton(context, cartProvider)
          : null,
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 100,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 20),
          Text(
            "Giỏ hàng của bạn đang trống",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Hãy thêm sản phẩm vào giỏ hàng để mua sắm",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text("Tiếp tục mua sắm"),
          ),
        ],
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cartProvider) {
    return Column(
      children: [
        // Header thông tin giỏ hàng
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            border: Border(bottom: BorderSide(color: Colors.grey.shade300)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Tổng cộng: ${cartProvider.totalQuantity} sản phẩm",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "${_formatPrice(cartProvider.totalAmount)} ₫",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),

        // Danh sách sản phẩm
        Expanded(
          child: ListView.builder(
            itemCount: cartProvider.items.length,
            itemBuilder: (context, index) {
              final cartItem = cartProvider.items.values.toList()[index];
              return _buildCartItem(context, cartItem, cartProvider);
            },
          ),
        ),
        _buildCouponSection(context, cartProvider),
      ],
    );
  }

  Widget _buildCartItem(
    BuildContext context,
    CartItemModel cartItem,
    CartProvider cartProvider,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Hình ảnh sản phẩm
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  cartItem.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Center(
                      child: Icon(
                        Icons.image_not_supported,
                        color: Colors.grey[400],
                        size: 32,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Thông tin sản phẩm
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.productName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${_formatPrice(cartItem.price)} ₫",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.blue,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Thành tiền: ${_formatPrice(cartItem.totalPrice)} ₫",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),

            // Điều khiển số lượng
            Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        if (cartItem.quantity > 1) {
                          await cartProvider.decreaseQuantity(
                            cartItem.productId,
                          );
                        } else {
                          _showRemoveDialog(context, cartItem, cartProvider);
                        }
                      },
                      icon: Icon(
                        cartItem.quantity > 1 ? Icons.remove : Icons.delete,
                        color: cartItem.quantity > 1
                            ? Colors.orange
                            : Colors.red,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '${cartItem.quantity}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () async {
                        await cartProvider.increaseQuantity(cartItem.productId);
                      },
                      icon: const Icon(Icons.add, color: Colors.green),
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.3),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (cartProvider.selectedCoupon != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Mã giảm giá (${cartProvider.selectedCoupon!.code}):",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "-${_formatPrice(cartProvider.discountAmount)} ₫",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Tổng thanh toán:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                "${_formatPrice(cartProvider.payableAmount)} ₫",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showCheckoutDialog(context, cartProvider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                "Thanh toán",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRemoveDialog(
    BuildContext context,
    CartItemModel cartItem,
    CartProvider cartProvider,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Xóa sản phẩm"),
          content: Text(
            "Bạn có muốn xóa '${cartItem.productName}' khỏi giỏ hàng?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
            TextButton(
              onPressed: () async {
                await cartProvider.removeItem(cartItem.productId);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      "Đã xóa ${cartItem.productName} khỏi giỏ hàng",
                    ),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              child: const Text("Xóa", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutDialog(BuildContext context, CartProvider cartProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Thanh toán"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Số lượng sản phẩm: ${cartProvider.totalQuantity}"),
              const SizedBox(height: 8),
              if (cartProvider.selectedCoupon != null) ...[
                Text(
                  "Mã giảm giá: ${cartProvider.selectedCoupon!.code}",
                  style: const TextStyle(color: Colors.green),
                ),
                Text(
                  "Giảm: ${_formatPrice(cartProvider.discountAmount)} ₫",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 8),
              ],
              Text(
                "Tổng tiền: ${_formatPrice(cartProvider.payableAmount)} ₫",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              const Text("Bạn có muốn tiến hành thanh toán?"),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Hủy"),
            ),
            ElevatedButton(
              onPressed: () async {
                await cartProvider.clearCart();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Trở về trang chủ
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Thanh toán thành công! Cảm ơn bạn đã mua sắm.",
                    ),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text("Thanh toán"),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCouponSection(BuildContext context, CartProvider cartProvider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: InkWell(
        onTap: () => _openCouponSelector(context, cartProvider),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.discount, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartProvider.selectedCoupon != null
                          ? 'Đã áp dụng mã: ${cartProvider.selectedCoupon!.code}'
                          : 'Chọn mã giảm giá',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (cartProvider.selectedCoupon != null)
                      Text(
                        cartProvider.selectedCoupon!.title,
                        style: const TextStyle(color: Colors.grey),
                      ),
                  ],
                ),
              ),
              Icon(
                cartProvider.selectedCoupon != null
                    ? Icons.edit
                    : Icons.arrow_forward_ios,
                size: 18,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openCouponSelector(BuildContext context, CartProvider cartProvider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) =>
          CouponSelectorBottomSheet(cartProvider: cartProvider),
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

class CouponSelectorBottomSheet extends StatelessWidget {
  final CartProvider cartProvider;
  final CouponService _couponService = CouponService();

  CouponSelectorBottomSheet({super.key, required this.cartProvider});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const Text(
                'Chọn mã giảm giá',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: StreamBuilder<List<CouponModel>>(
                  stream: _couponService.getActiveCoupons(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final coupons = snapshot.data ?? [];
                    if (coupons.isEmpty) {
                      return const Center(
                        child: Text('Hiện chưa có mã giảm giá nào'),
                      );
                    }
                    return ListView.builder(
                      controller: scrollController,
                      itemCount: coupons.length,
                      itemBuilder: (context, index) {
                        final coupon = coupons[index];
                        final isSelected =
                            cartProvider.selectedCoupon?.id == coupon.id;
                        final discountPreview = coupon.calculateDiscount(
                          cartProvider.totalAmount,
                        );
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.orange.shade50,
                              child: const Icon(
                                Icons.percent,
                                color: Colors.orange,
                              ),
                            ),
                            title: Text(
                              '${coupon.code} - ${coupon.title}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(coupon.description),
                                const SizedBox(height: 4),
                                Text(
                                  'Giảm ${_formatDiscount(coupon)} · Đơn tối thiểu ${_formatPrice(coupon.minOrderAmount)} ₫',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                ),
                                if (discountPreview > 0)
                                  Text(
                                    'Ước tính giảm: ${_formatPrice(discountPreview)} ₫',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                              ],
                            ),
                            trailing: isSelected
                                ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                : null,
                            onTap: () {
                              if (cartProvider.totalAmount <
                                  coupon.minOrderAmount) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Đơn tối thiểu ${_formatPrice(coupon.minOrderAmount)} ₫ để dùng mã này',
                                    ),
                                  ),
                                );
                                return;
                              }
                              cartProvider.applyCoupon(coupon);
                              Navigator.pop(context);
                            },
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              if (cartProvider.selectedCoupon != null)
                TextButton.icon(
                  onPressed: () {
                    cartProvider.removeCoupon();
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.close, color: Colors.red),
                  label: const Text(
                    'Bỏ chọn mã giảm giá',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  static String _formatDiscount(CouponModel coupon) {
    if (coupon.type == 'percentage') {
      return '${coupon.value.toStringAsFixed(0)}%';
    }
    return '${_formatPrice(coupon.value)} ₫';
  }

  static String _formatPrice(double price) {
    return price
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }
}
