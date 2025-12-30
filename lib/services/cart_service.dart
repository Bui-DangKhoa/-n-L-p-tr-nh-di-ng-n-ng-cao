import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_item_model.dart';
import '../models/order_model.dart';

class CartService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Lấy ID giỏ hàng của user (format: cart_userId)
  String _getCartId(String userId) => 'cart_$userId';

  /// Lấy giỏ hàng của user từ Firebase
  /// Giỏ hàng được lưu như một order với status = 'cart'
  Future<OrderModel?> getCart(String userId) async {
    try {
      final cartId = _getCartId(userId);
      final doc = await _firestore.collection('orders').doc(cartId).get();

      if (doc.exists) {
        return OrderModel.fromMap(doc.data()!);
      }
      return null;
    } catch (e) {
      print('Error getting cart: $e');
      return null;
    }
  }

  /// Stream để theo dõi giỏ hàng realtime
  Stream<OrderModel?> watchCart(String userId) {
    final cartId = _getCartId(userId);
    return _firestore.collection('orders').doc(cartId).snapshots().map((
      snapshot,
    ) {
      if (snapshot.exists) {
        return OrderModel.fromMap(snapshot.data()!);
      }
      return null;
    });
  }

  /// Thêm sản phẩm vào giỏ hàng
  Future<void> addItem(String userId, CartItemModel item) async {
    final cartId = _getCartId(userId);
    final docRef = _firestore.collection('orders').doc(cartId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) {
        // Tạo giỏ hàng mới
        final userRef = _firestore.collection('users').doc(userId);
        final newCart = OrderModel(
          id: cartId,
          userRef: userRef, // ✅ Sử dụng DocumentReference
          userName: '', // Sẽ được cập nhật khi checkout
          userPhone: '',
          deliveryAddress: '',
          items: [item],
          totalAmount: item.totalPrice,
          status: 'cart', // Đặc biệt: trạng thái cart cho giỏ hàng
          createdAt: DateTime.now(),
        );
        transaction.set(docRef, newCart.toMap());
      } else {
        // Cập nhật giỏ hàng có sẵn
        final cart = OrderModel.fromMap(snapshot.data()!);
        final items = List<CartItemModel>.from(cart.items);

        // Tìm sản phẩm trong giỏ
        final existingIndex = items.indexWhere(
          (i) => i.productId == item.productId,
        );

        if (existingIndex >= 0) {
          // Sản phẩm đã có => tăng số lượng
          items[existingIndex].quantity += item.quantity;
        } else {
          // Sản phẩm chưa có => thêm mới
          items.add(item);
        }

        // Tính lại tổng tiền
        final totalAmount = items.fold<double>(
          0.0,
          (sum, i) => sum + i.totalPrice,
        );

        transaction.update(docRef, {
          'items': items.map((i) => i.toMap()).toList(),
          'totalAmount': totalAmount,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  /// Xóa sản phẩm khỏi giỏ hàng
  Future<void> removeItem(String userId, String productId) async {
    final cartId = _getCartId(userId);
    final docRef = _firestore.collection('orders').doc(cartId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final cart = OrderModel.fromMap(snapshot.data()!);
      final items = List<CartItemModel>.from(cart.items);

      // Xóa sản phẩm
      items.removeWhere((i) => i.productId == productId);

      if (items.isEmpty) {
        // Nếu giỏ hàng rỗng => xóa luôn document
        transaction.delete(docRef);
      } else {
        // Tính lại tổng tiền
        final totalAmount = items.fold<double>(
          0.0,
          (sum, i) => sum + i.totalPrice,
        );

        transaction.update(docRef, {
          'items': items.map((i) => i.toMap()).toList(),
          'totalAmount': totalAmount,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  /// Cập nhật số lượng sản phẩm
  Future<void> updateQuantity(
    String userId,
    String productId,
    int newQuantity,
  ) async {
    if (newQuantity <= 0) {
      await removeItem(userId, productId);
      return;
    }

    final cartId = _getCartId(userId);
    final docRef = _firestore.collection('orders').doc(cartId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final cart = OrderModel.fromMap(snapshot.data()!);
      final items = List<CartItemModel>.from(cart.items);

      // Tìm và cập nhật số lượng
      final index = items.indexWhere((i) => i.productId == productId);
      if (index >= 0) {
        items[index].quantity = newQuantity;

        // Tính lại tổng tiền
        final totalAmount = items.fold<double>(
          0.0,
          (sum, i) => sum + i.totalPrice,
        );

        transaction.update(docRef, {
          'items': items.map((i) => i.toMap()).toList(),
          'totalAmount': totalAmount,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  /// Tăng số lượng sản phẩm
  Future<void> increaseQuantity(String userId, String productId) async {
    final cartId = _getCartId(userId);
    final docRef = _firestore.collection('orders').doc(cartId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final cart = OrderModel.fromMap(snapshot.data()!);
      final items = List<CartItemModel>.from(cart.items);

      final index = items.indexWhere((i) => i.productId == productId);
      if (index >= 0) {
        items[index].quantity++;

        final totalAmount = items.fold<double>(
          0.0,
          (sum, i) => sum + i.totalPrice,
        );

        transaction.update(docRef, {
          'items': items.map((i) => i.toMap()).toList(),
          'totalAmount': totalAmount,
          'updatedAt': DateTime.now().millisecondsSinceEpoch,
        });
      }
    });
  }

  /// Giảm số lượng sản phẩm
  Future<void> decreaseQuantity(String userId, String productId) async {
    final cartId = _getCartId(userId);
    final docRef = _firestore.collection('orders').doc(cartId);

    await _firestore.runTransaction((transaction) async {
      final snapshot = await transaction.get(docRef);

      if (!snapshot.exists) return;

      final cart = OrderModel.fromMap(snapshot.data()!);
      final items = List<CartItemModel>.from(cart.items);

      final index = items.indexWhere((i) => i.productId == productId);
      if (index >= 0) {
        if (items[index].quantity > 1) {
          items[index].quantity--;

          final totalAmount = items.fold<double>(
            0.0,
            (sum, i) => sum + i.totalPrice,
          );

          transaction.update(docRef, {
            'items': items.map((i) => i.toMap()).toList(),
            'totalAmount': totalAmount,
            'updatedAt': DateTime.now().millisecondsSinceEpoch,
          });
        } else {
          // Số lượng = 1 => xóa sản phẩm
          items.removeAt(index);

          if (items.isEmpty) {
            transaction.delete(docRef);
          } else {
            final totalAmount = items.fold<double>(
              0.0,
              (sum, i) => sum + i.totalPrice,
            );

            transaction.update(docRef, {
              'items': items.map((i) => i.toMap()).toList(),
              'totalAmount': totalAmount,
              'updatedAt': DateTime.now().millisecondsSinceEpoch,
            });
          }
        }
      }
    });
  }

  /// Xóa toàn bộ giỏ hàng
  Future<void> clearCart(String userId) async {
    final cartId = _getCartId(userId);
    await _firestore.collection('orders').doc(cartId).delete();
  }

  /// Chuyển giỏ hàng thành đơn hàng (khi checkout)
  /// Tạo order mới và xóa cart
  Future<String> convertCartToOrder(
    String userId,
    String userName,
    String userPhone,
    String deliveryAddress,
  ) async {
    final cartId = _getCartId(userId);
    final cartDoc = await _firestore.collection('orders').doc(cartId).get();

    if (!cartDoc.exists) {
      throw Exception('Cart is empty');
    }

    final cart = OrderModel.fromMap(cartDoc.data()!);

    // Tạo order mới với ID mới
    final orderId = _firestore.collection('orders').doc().id;
    final userRef = _firestore.collection('users').doc(userId);
    final order = OrderModel(
      id: orderId,
      userRef: userRef, // ✅ Sử dụng DocumentReference
      userName: userName,
      userPhone: userPhone,
      deliveryAddress: deliveryAddress,
      items: cart.items,
      totalAmount: cart.totalAmount,
      status: 'pending', // Trạng thái đơn hàng mới
      createdAt: DateTime.now(),
    );

    // Thực hiện trong transaction
    await _firestore.runTransaction((transaction) async {
      // Tạo đơn hàng mới
      transaction.set(
        _firestore.collection('orders').doc(orderId),
        order.toMap(),
      );

      // Xóa giỏ hàng
      transaction.delete(_firestore.collection('orders').doc(cartId));
    });

    return orderId;
  }
}
