# 🔄 MIGRATION GUIDE - Chuyển đổi sang DocumentReference

## ⚠️ QUAN TRỌNG: Breaking Changes

Các model đã được cập nhật để sử dụng `DocumentReference` thay vì `String ID`. Điều này yêu cầu cập nhật code ở nhiều nơi.

---

## 📋 CÁC MODEL ĐÃ THAY ĐỔI

### 1. **CartItemModel**

```dart
// ❌ CŨ
CartItemModel(
  productId: 'product_123',  // String
  productName: 'Sản phẩm A',
  price: 100000,
  imageUrl: 'url',
)

// ✅ MỚI
CartItemModel(
  productRef: FirebaseFirestore.instance.collection('products').doc('product_123'),
  productName: 'Sản phẩm A',
  price: 100000,
  imageUrl: 'url',
)
```

### 2. **OrderModel**

```dart
// ❌ CŨ
OrderModel(
  id: 'order_123',
  userId: 'user_123',  // String
  userName: 'Nguyễn Văn A',
  // ...
)

// ✅ MỚI
OrderModel(
  id: 'order_123',
  userRef: FirebaseFirestore.instance.collection('users').doc('user_123'),
  userName: 'Nguyễn Văn A',
  // ...
)
```

### 3. **WishlistModel**

```dart
// ❌ CŨ
WishlistModel(
  id: 'wish_123',
  userId: 'user_123',     // String
  productId: 'prod_123',  // String
  createdAt: DateTime.now(),
)

// ✅ MỚI
WishlistModel(
  id: 'wish_123',
  userRef: FirebaseFirestore.instance.collection('users').doc('user_123'),
  productRef: FirebaseFirestore.instance.collection('products').doc('prod_123'),
  createdAt: DateTime.now(),
)
```

### 4. **ReviewModel**

```dart
// ❌ CŨ
ReviewModel(
  id: 'review_123',
  productId: 'prod_123',  // String
  userId: 'user_123',     // String
  userName: 'Nguyễn Văn A',
  rating: 5.0,
  comment: 'Tuyệt vời!',
  createdAt: DateTime.now(),
)

// ✅ MỚI
ReviewModel(
  id: 'review_123',
  productRef: FirebaseFirestore.instance.collection('products').doc('prod_123'),
  userRef: FirebaseFirestore.instance.collection('users').doc('user_123'),
  userName: 'Nguyễn Văn A',
  rating: 5.0,
  comment: 'Tuyệt vời!',
  createdAt: DateTime.now(),
)
```

### 5. **AddressModel**

```dart
// ❌ CŨ
AddressModel(
  id: 'addr_123',
  userId: 'user_123',  // String
  recipientName: 'Nguyễn Văn A',
  phoneNumber: '0123456789',
  // ...
)

// ✅ MỚI
AddressModel(
  id: 'addr_123',
  userRef: FirebaseFirestore.instance.collection('users').doc('user_123'),
  recipientName: 'Nguyễn Văn A',
  phoneNumber: '0123456789',
  // ...
)
```

### 6. **NotificationModel**

```dart
// ❌ CŨ
NotificationModel(
  id: 'notif_123',
  userId: 'user_123',  // String
  title: 'Đơn hàng đã giao',
  body: 'Đơn hàng #123 đã được giao thành công',
  type: 'order',
  createdAt: DateTime.now(),
)

// ✅ MỚI
NotificationModel(
  id: 'notif_123',
  userRef: FirebaseFirestore.instance.collection('users').doc('user_123'),
  title: 'Đơn hàng đã giao',
  body: 'Đơn hàng #123 đã được giao thành công',
  type: 'order',
  createdAt: DateTime.now(),
)
```

---

## 🔧 CÁC NỚI CẦN CẬP NHẬT

### 1. **Screens sử dụng CartItemModel**

Tìm kiếm pattern: `CartItemModel(`

**Các file cần update:**

- `lib/screens/wishlist/wishlist_screen.dart` (line ~230)
- `lib/screens/product/product_detail_screen.dart` (line ~302)
- `lib/screens/search/search_screen.dart` (line ~609)
- `lib/screens/home/home_screen.dart` (line ~843)
- `lib/screens/category/category_screen.dart` (line ~284)

**Ví dụ cập nhật:**

```dart
// ❌ CŨ
final cartItem = CartItemModel(
  productId: product.id,
  productName: product.name,
  price: product.price,
  imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
  quantity: 1,
);

// ✅ MỚI
final firestore = FirebaseFirestore.instance;
final cartItem = CartItemModel(
  productRef: firestore.collection('products').doc(product.id),
  productName: product.name,
  price: product.price,
  imageUrl: product.imageUrls.isNotEmpty ? product.imageUrls[0] : '',
  quantity: 1,
);
```

### 2. **Providers sử dụng models**

**WishlistProvider:**

```dart
// ❌ CŨ
final wishlist = WishlistModel(
  id: docId,
  userId: userId,
  productId: productId,
  createdAt: DateTime.now(),
);

// ✅ MỚI
final firestore = FirebaseFirestore.instance;
final wishlist = WishlistModel(
  id: docId,
  userRef: firestore.collection('users').doc(userId),
  productRef: firestore.collection('products').doc(productId),
  createdAt: DateTime.now(),
);
```

**AddressProvider:**

```dart
// ❌ CŨ
final address = AddressModel(
  id: '',
  userId: userId,
  recipientName: recipientName,
  // ...
);

// ✅ MỚI
final firestore = FirebaseFirestore.instance;
final address = AddressModel(
  id: '',
  userRef: firestore.collection('users').doc(userId),
  recipientName: recipientName,
  // ...
);
```

### 3. **Admin screens tạo reviews/notifications**

Tìm trong `lib/screens/admin/` các file tạo ReviewModel hoặc NotificationModel.

---

## 🔍 HELPER GETTERS

Mỗi model đã có helper getter để lấy ID:

```dart
// CartItemModel
String productId = cartItem.productId; // Lấy từ productRef.id

// OrderModel
String userId = order.userId; // Lấy từ userRef.id

// WishlistModel
String userId = wishlist.userId;       // Lấy từ userRef.id
String productId = wishlist.productId; // Lấy từ productRef.id

// ReviewModel
String userId = review.userId;         // Lấy từ userRef.id
String productId = review.productId;   // Lấy từ productRef.id

// AddressModel
String userId = address.userId; // Lấy từ userRef.id

// NotificationModel
String userId = notification.userId; // Lấy từ userRef.id
```

➡️ **Code sử dụng các getter này KHÔNG CẦN thay đổi!**

---

## 📝 CHECKLIST CẬP NHẬT

### Bước 1: Cập nhật import

Đảm bảo import FirebaseFirestore ở mọi file cần thiết:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
```

### Bước 2: Tìm và thay thế

Tìm tất cả các nơi tạo model với pattern:

```bash
# CartItemModel
productId:

# OrderModel, AddressModel, NotificationModel
userId:

# WishlistModel, ReviewModel
userId:.*productId:
```

### Bước 3: Thay thế bằng DocumentReference

```dart
final firestore = FirebaseFirestore.instance;

// Thay
productId: 'id'
// Bằng
productRef: firestore.collection('products').doc('id')

// Thay
userId: 'id'
// Bằng
userRef: firestore.collection('users').doc('id')
```

### Bước 4: Test

- ✅ Thêm sản phẩm vào giỏ hàng
- ✅ Thêm/xóa wishlist
- ✅ Tạo đơn hàng
- ✅ Tạo review
- ✅ Quản lý địa chỉ
- ✅ Nhận thông báo

---

## ⚡ SCRIPT TỰ ĐỘNG (Optional)

Có thể tạo script để find & replace tự động:

```bash
# Tìm tất cả CartItemModel(
grep -r "CartItemModel(" lib/screens/

# Hoặc dùng VS Code Find & Replace với regex
Find: productId: (\w+)\.id
Replace: productRef: FirebaseFirestore.instance.collection('products').doc($1.id)
```

---

## 🚨 LƯU Ý QUAN TRỌNG

### 1. **Backward Compatibility**

Nếu muốn hỗ trợ cả 2 cách trong thời gian chuyển đổi:

```dart
factory WishlistModel.fromMap(Map<String, dynamic> map) {
  DocumentReference? userRef;
  DocumentReference? productRef;

  // Thử đọc reference mới
  if (map['userRef'] != null) {
    userRef = map['userRef'] as DocumentReference;
  }
  // Fallback về String ID cũ
  else if (map['userId'] != null) {
    userRef = FirebaseFirestore.instance.collection('users').doc(map['userId']);
  }

  if (map['productRef'] != null) {
    productRef = map['productRef'] as DocumentReference;
  }
  else if (map['productId'] != null) {
    productRef = FirebaseFirestore.instance.collection('products').doc(map['productId']);
  }

  return WishlistModel(
    id: map['id'] ?? '',
    userRef: userRef!,
    productRef: productRef!,
    createdAt: DateTime.fromMillisecondsSinceEpoch(
      map['createdAt'] ?? DateTime.now().millisecondsSinceEpoch,
    ),
  );
}
```

### 2. **Migration dữ liệu trên Firebase**

Nếu đã có dữ liệu cũ với String ID, cần chạy migration script:

```dart
Future<void> migrateFirestoreData() async {
  final firestore = FirebaseFirestore.instance;

  // Migrate wishlist
  final wishlistSnapshot = await firestore.collection('wishlist').get();
  for (var doc in wishlistSnapshot.docs) {
    final data = doc.data();
    await doc.reference.update({
      'userRef': firestore.collection('users').doc(data['userId']),
      'productRef': firestore.collection('products').doc(data['productId']),
    });
  }

  // Migrate các collections khác tương tự...
}
```

### 3. **Testing**

Sau khi migration, test kỹ:

- ✅ Queries vẫn hoạt động
- ✅ CRUD operations vẫn OK
- ✅ UI hiển thị đúng
- ✅ Không có lỗi runtime

---

## 📊 TÓM TẮT

| Model             | Field cũ              | Field mới                       | Helper getter         |
| ----------------- | --------------------- | ------------------------------- | --------------------- |
| CartItemModel     | `productId: String`   | `productRef: DocumentReference` | `productId`           |
| OrderModel        | `userId: String`      | `userRef: DocumentReference`    | `userId`              |
| WishlistModel     | `userId`, `productId` | `userRef`, `productRef`         | `userId`, `productId` |
| ReviewModel       | `userId`, `productId` | `userRef`, `productRef`         | `userId`, `productId` |
| AddressModel      | `userId: String`      | `userRef: DocumentReference`    | `userId`              |
| NotificationModel | `userId: String`      | `userRef: DocumentReference`    | `userId`              |

---

## 🎯 KẾT LUẬN

Migration này tạo **liên kết thực sự** giữa các bảng trên Firebase, giúp:

- ✅ Code rõ ràng hơn về mối quan hệ
- ✅ Dễ populate dữ liệu liên quan
- ✅ Type-safe với Dart
- ✅ Tuân thủ best practices của Firebase

Mặc dù cần cập nhật nhiều nơi, nhưng lợi ích lâu dài rất đáng giá! 🚀
