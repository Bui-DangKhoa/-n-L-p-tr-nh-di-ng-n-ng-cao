# 🔗 FIREBASE FIRESTORE RELATIONSHIPS - LIÊN KẾT GIỮA CÁC BẢNG

## ❌ Vấn đề ban đầu

Trước đây, các model chỉ lưu ID dạng **String đơn thuần**:

```dart
class OrderModel {
  final String userId;  // ❌ Chỉ là text, không có liên kết thực sự
  final String productId;
  // ...
}
```

**Nhược điểm:**

- ❌ Không có liên kết thực sự giữa các collections
- ❌ Không thể populate/join dữ liệu dễ dàng
- ❌ Firebase không biết mối quan hệ giữa các bảng
- ❌ Không tận dụng được tính năng `DocumentReference` của Firestore

---

## ✅ Giải pháp: Sử dụng DocumentReference

Firebase Firestore cung cấp kiểu `DocumentReference` để tạo **liên kết thực sự** giữa các collections.

### Cách hoạt động:

```dart
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  final DocumentReference userRef;  // ✅ Liên kết thực sự với users collection

  // Helper để lấy ID khi cần
  String get userId => userRef.id;
}
```

---

## 📊 CẤU TRÚC LIÊN KẾT MỚI

### 1. **AddressModel** → Users

```dart
class AddressModel {
  final String id;
  final DocumentReference userRef; // ✅ users/{userId}
  final String recipientName;
  final String phoneNumber;
  // ...

  // Helper
  String get userId => userRef.id;
}
```

**Quan hệ:** Một user có nhiều addresses (1-N)

---

### 2. **OrderModel** → Users & Products (qua CartItems)

```dart
class OrderModel {
  final String id;
  final DocumentReference userRef; // ✅ users/{userId}
  final List<CartItemModel> items; // ✅ Mỗi item có productRef
  final double totalAmount;
  final String status;
  // ...

  // Helper
  String get userId => userRef.id;
}
```

**Quan hệ:**

- Một user có nhiều orders (1-N)
- Một order chứa nhiều products qua CartItems (N-M)

---

### 3. **CartItemModel** → Products

```dart
class CartItemModel {
  final DocumentReference productRef; // ✅ products/{productId}
  final String productName;
  final double price;
  final String imageUrl;
  int quantity;

  // Helper
  String get productId => productRef.id;
}
```

**Quan hệ:** Một cart item liên kết với một product

---

### 4. **ReviewModel** → Users & Products

```dart
class ReviewModel {
  final String id;
  final DocumentReference productRef; // ✅ products/{productId}
  final DocumentReference userRef;    // ✅ users/{userId}
  final String userName;
  final double rating;
  final String comment;
  // ...

  // Helpers
  String get productId => productRef.id;
  String get userId => userRef.id;
}
```

**Quan hệ:**

- Một user có nhiều reviews (1-N)
- Một product có nhiều reviews (1-N)

---

### 5. **WishlistModel** → Users & Products

```dart
class WishlistModel {
  final String id;
  final DocumentReference userRef;    // ✅ users/{userId}
  final DocumentReference productRef; // ✅ products/{productId}
  final DateTime createdAt;

  // Helpers
  String get userId => userRef.id;
  String get productId => productRef.id;
}
```

**Quan hệ:**

- Một user có nhiều wishlist items (1-N)
- Một product có thể được nhiều users wishlist (N-M)

---

### 6. **NotificationModel** → Users

```dart
class NotificationModel {
  final String id;
  final DocumentReference userRef; // ✅ users/{userId}
  final String title;
  final String body;
  final String type;
  final bool isRead;
  // ...

  // Helper
  String get userId => userRef.id;
}
```

**Quan hệ:** Một user có nhiều notifications (1-N)

---

## 🔄 CÁCH SỬ DỤNG

### 1. Tạo DocumentReference

```dart
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Tạo reference đến user document
DocumentReference userRef = _firestore.collection('users').doc(userId);

// Tạo reference đến product document
DocumentReference productRef = _firestore.collection('products').doc(productId);
```

### 2. Lưu vào Firestore

```dart
// Tạo wishlist với references
final wishlist = WishlistModel(
  id: 'wish_001',
  userRef: _firestore.collection('users').doc('user_001'),
  productRef: _firestore.collection('products').doc('prod_001'),
  createdAt: DateTime.now(),
);

// Lưu vào Firestore (DocumentReference tự động được lưu đúng)
await _firestore.collection('wishlist').doc(wishlist.id).set(wishlist.toMap());
```

### 3. Đọc từ Firestore và Populate dữ liệu

```dart
// Đọc wishlist
final doc = await _firestore.collection('wishlist').doc('wish_001').get();
final wishlist = WishlistModel.fromMap(doc.data()!);

// Populate product từ reference
final productDoc = await wishlist.productRef.get();
final product = ProductModel.fromMap(productDoc.data()!);

// Populate user từ reference
final userDoc = await wishlist.userRef.get();
final user = UserModel.fromMap(userDoc.data()!);

print('User ${user.name} wishlisted product ${product.name}');
```

### 4. Query với DocumentReference

```dart
// Lấy tất cả wishlist của một user
final userRef = _firestore.collection('users').doc(userId);

final snapshot = await _firestore
    .collection('wishlist')
    .where('userRef', isEqualTo: userRef)
    .get();

final wishlists = snapshot.docs
    .map((doc) => WishlistModel.fromMap(doc.data()))
    .toList();
```

---

## 📈 LỢI ÍCH

### 1. **Integrity & Validation**

Firebase biết rõ mối quan hệ, có thể validate references tồn tại.

### 2. **Easy Populate/Join**

```dart
// Dễ dàng lấy dữ liệu liên quan
final productDoc = await wishlist.productRef.get();
```

### 3. **Type Safety**

TypeScript/Dart compile-time checking với `DocumentReference`.

### 4. **Firebase Console**

Trên Firebase Console, bạn sẽ thấy links giữa các documents, dễ debug.

### 5. **Future-proof**

Nếu sau này Firebase hỗ trợ foreign key constraints hoặc cascade operations, code này sẽ tương thích.

---

## 🗺️ SƠ ĐỒ QUAN HỆ

```
Users (users)
  ├── 1-N → Addresses (addresses)
  ├── 1-N → Orders (orders)
  ├── 1-N → Reviews (reviews)
  ├── 1-N → Wishlist (wishlist)
  └── 1-N → Notifications (notifications)

Products (products)
  ├── 1-N → Reviews (reviews)
  ├── 1-N → CartItems (qua Orders)
  └── N-M → Wishlist (wishlist)

Orders (orders)
  ├── N-1 → Users
  └── N-M → Products (qua items: CartItemModel[])

CartItemModel (embedded trong Orders)
  └── N-1 → Products

Reviews (reviews)
  ├── N-1 → Users
  └── N-1 → Products

Wishlist (wishlist)
  ├── N-1 → Users
  └── N-1 → Products

Addresses (addresses)
  └── N-1 → Users

Notifications (notifications)
  └── N-1 → Users
```

---

## ⚠️ LƯU Ý QUAN TRỌNG

### 1. Migration Data cũ

Nếu đã có dữ liệu với `userId: String`, cần migrate sang `userRef: DocumentReference`:

```dart
Future<void> migrateWishlistData() async {
  final snapshot = await _firestore.collection('wishlist').get();

  for (var doc in snapshot.docs) {
    final data = doc.data();

    // Chuyển String ID thành DocumentReference
    await doc.reference.update({
      'userRef': _firestore.collection('users').doc(data['userId']),
      'productRef': _firestore.collection('products').doc(data['productId']),
    });

    // Xóa fields cũ nếu cần
    await doc.reference.update({
      'userId': FieldValue.delete(),
      'productId': FieldValue.delete(),
    });
  }
}
```

### 2. Backward Compatibility

Trong quá trình chuyển đổi, có thể hỗ trợ cả 2 cách:

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

  // Tương tự cho productRef...
}
```

### 3. Performance

- DocumentReference queries hiệu quả như String queries
- Populate data sẽ tốn thêm read operations
- Cache kết quả populate để tối ưu

---

## 🎯 KẾT LUẬN

Việc sử dụng **DocumentReference** thay vì **String ID** là best practice của Firebase Firestore, giúp:

✅ **Tạo liên kết thực sự** giữa các collections  
✅ **Dễ dàng populate/join** dữ liệu liên quan  
✅ **Type-safe** với compile-time checking  
✅ **Chuẩn Firebase** được khuyến nghị  
✅ **Dễ maintain** và scale trong tương lai

Giảng viên của bạn hoàn toàn đúng - bây giờ các bảng đã có **liên kết thực sự** với nhau! 🎉
