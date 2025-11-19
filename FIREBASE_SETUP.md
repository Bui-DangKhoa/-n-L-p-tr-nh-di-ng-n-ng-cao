# 🔥 Cấu hình Firebase Firestore

## ⚠️ LỖI QUAN TRỌNG: Cần tạo Index

App đang gặp lỗi vì Firebase Firestore yêu cầu tạo **composite index** cho các truy vấn phức tạp.

### 📝 Các bước khắc phục:

#### 1. **Tạo Index cho Collection `addresses`**

Nhấn vào link này để tạo index tự động:

```
https://console.firebase.google.com/v1/r/project/di-dong-nang-cao/firestore/indexes?create_composite=ClJwcm9qZWN0cy9kaS1kb25nLW5hbmctY2FvL2RhdGFiYXNlcy8oZGVmYXVsdCkvY29sbGVjdGlvbkdyb3Vwcy9hZGRyZXNzZXMvaW5kZXhlcy9fEAEaCgoGdXNlcklkEAEaDQoJaXNEZWZhdWx0EAIaDQoJY3JlYXRlZEF0EAIaDAoIX19uYW1lX18QAg
```

Hoặc tạo thủ công:

1. Mở Firebase Console: https://console.firebase.google.com/
2. Chọn project: `di-dong-nang-cao`
3. Vào **Firestore Database** > **Indexes** tab
4. Nhấn **Create Index**
5. Điền thông tin:

   - **Collection**: `addresses`
   - **Fields to index**:
     - `userId` - Ascending
     - `isDefault` - Descending
     - `createdAt` - Descending

6. Nhấn **Create Index**
7. Đợi vài phút để index được tạo (status: Building → Enabled)

---

## 🗂️ Kiểm tra Collection Names

### Collections hiện tại:

- ✅ `users` - Người dùng
- ✅ `products` - Sản phẩm
- ✅ `orders` - Đơn hàng
- ✅ `cart` - Giỏ hàng
- ⚠️ `wishlists` hoặc `wishlist` - **CẦN KIỂM TRA!**
- 🆕 `addresses` - Địa chỉ giao hàng
- 🆕 `notifications` - Thông báo
- 🆕 `categories` - Danh mục
- 🆕 `reviews` - Đánh giá
- 🆕 `coupons` - Mã giảm giá

### 🔍 Kiểm tra Wishlist Collection:

1. Vào Firebase Console > Firestore Database
2. Xem có collection nào trong số:

   - `wishlist` (số ít)
   - `wishlists` (số nhiều)

3. **Nếu là `wishlist`** (số ít):

   - Code đã được update thành `wishlists`
   - Bạn cần **đổi tên collection** hoặc **cập nhật lại code**

4. **Cách đổi tên collection**:
   - Firebase không hỗ trợ đổi tên trực tiếp
   - Cần export data và import lại với tên mới
   - Hoặc để code sử dụng tên cũ `wishlist`

---

## 🛠️ Sửa nhanh: Dùng lại tên collection cũ

Nếu collection trên Firebase là `wishlist` (không có 's'), hãy đổi lại code:

### File cần sửa: `lib/services/wishlist_service.dart`

Đổi tất cả `'wishlists'` thành `'wishlist'`:

```dart
// Từ:
.collection('wishlists')

// Thành:
.collection('wishlist')
```

---

## ✅ Sau khi hoàn thành:

1. Chạy hot reload: nhấn `r` trong terminal
2. Thử thêm sản phẩm vào wishlist
3. Vào màn hình "Danh sách yêu thích"
4. Kiểm tra console logs để xem dữ liệu

---

## 📊 Debug Console Logs

Khi app chạy, bạn sẽ thấy các logs:

```
💖 WishlistService: Getting wishlist for userId: xxx
💖 WishlistService: Received X wishlist items
📦 Received X wishlist items
🔍 Loading product: productId
✅ Product loaded: Product Name
```

Nếu thấy:

- `Received 0 wishlist items` → Collection name sai hoặc không có dữ liệu
- `Product not found` → ProductId không tồn tại trong `products`

---

## 🎯 Checklist

- [ ] Tạo index cho `addresses` collection
- [ ] Kiểm tra collection name: `wishlist` hay `wishlists`?
- [ ] Update code nếu cần (đổi về `wishlist` nếu đó là tên trên Firebase)
- [ ] Hot reload app
- [ ] Test thêm sản phẩm vào wishlist
- [ ] Test xem danh sách wishlist
- [ ] Kiểm tra Firebase Console để xem dữ liệu

---

## 🆘 Nếu vẫn gặp lỗi:

1. Kiểm tra Firebase Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Wishlist - User chỉ đọc/ghi wishlist của mình
    match /wishlists/{wishlistId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }

    // Addresses - User chỉ đọc/ghi địa chỉ của mình
    match /addresses/{addressId} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == resource.data.userId;
    }
  }
}
```

2. Xem Firebase Console logs
3. Kiểm tra network tab trong DevTools
