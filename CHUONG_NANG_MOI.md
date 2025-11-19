# HƯỚNG DẪN 6 CHỨC NĂNG MỚI CHO APP

## ✅ ĐÃ TẠO XONG

### 1. Models (6 files)

- ✅ `lib/models/category_model.dart` - Quản lý danh mục sản phẩm
- ✅ `lib/models/review_model.dart` - Đánh giá sản phẩm (rating, comment)
- ✅ `lib/models/wishlist_model.dart` - Danh sách yêu thích
- ✅ `lib/models/notification_model.dart` - Thông báo cho user
- ✅ `lib/models/address_model.dart` - Địa chỉ giao hàng
- ✅ `lib/models/coupon_model.dart` - Mã giảm giá

### 2. Services (6 files)

- ✅ `lib/services/category_service.dart` - CRUD categories
- ✅ `lib/services/review_service.dart` - CRUD reviews
- ✅ `lib/services/wishlist_service.dart` - Thao tác wishlist
- ✅ `lib/services/notification_service.dart` - Quản lý thông báo
- ✅ `lib/services/address_service.dart` - Quản lý địa chỉ
- ✅ `lib/services/coupon_service.dart` - Validate & áp dụng coupon

### 3. Providers (3 files)

- ✅ `lib/providers/wishlist_provider.dart` - State management wishlist
- ✅ `lib/providers/notification_provider.dart` - State management notifications
- ✅ `lib/providers/address_provider.dart` - State management addresses

## 📊 CẤU TRÚC FIREBASE COLLECTIONS MỚI

### Collection: categories

```
{
  "id": "cat001",
  "name": "Điện tử",
  "description": "Các sản phẩm điện tử, công nghệ",
  "imageUrl": "https://...",
  "productCount": 25,
  "createdAt": 1700000000000,
  "updatedAt": null
}
```

### Collection: reviews

```
{
  "id": "rev001",
  "productId": "prod001",
  "userId": "user001",
  "userName": "Nguyễn Văn A",
  "rating": 4.5,
  "comment": "Sản phẩm rất tốt!",
  "images": ["https://...", "https://..."],
  "createdAt": 1700000000000,
  "updatedAt": null
}
```

### Collection: wishlist

```
{
  "id": "wish001",
  "userId": "user001",
  "productId": "prod001",
  "createdAt": 1700000000000
}
```

### Collection: notifications

```
{
  "id": "notif001",
  "userId": "user001",
  "title": "Đơn hàng đã giao",
  "body": "Đơn hàng #123 đã được giao thành công",
  "type": "order", // 'order', 'promotion', 'system', 'product'
  "imageUrl": "https://...",
  "actionId": "order123",
  "isRead": false,
  "createdAt": 1700000000000
}
```

### Collection: addresses

```
{
  "id": "addr001",
  "userId": "user001",
  "recipientName": "Nguyễn Văn A",
  "phoneNumber": "0901234567",
  "street": "123 Nguyễn Huệ",
  "ward": "Phường Bến Nghé",
  "district": "Quận 1",
  "city": "TP. Hồ Chí Minh",
  "zipCode": "700000",
  "isDefault": true,
  "createdAt": 1700000000000,
  "updatedAt": null
}
```

### Collection: coupons

```
{
  "id": "coupon001",
  "code": "GIAM50K",
  "title": "Giảm 50K cho đơn từ 200K",
  "description": "Áp dụng cho tất cả sản phẩm",
  "type": "fixed", // 'percentage' or 'fixed'
  "value": 50000,
  "minOrderAmount": 200000,
  "maxDiscountAmount": 100000,
  "usageLimit": 100,
  "usedCount": 25,
  "startDate": 1700000000000,
  "endDate": 1705000000000,
  "isActive": true,
  "createdAt": 1700000000000
}
```

## 🎯 CHỨC NĂNG CHI TIẾT

### 1. CATEGORIES (Quản lý danh mục)

**Features:**

- Admin tạo, sửa, xóa danh mục
- Tự động đếm số sản phẩm trong mỗi danh mục
- Hiển thị danh mục với ảnh đại diện
- Lọc sản phẩm theo danh mục

**API Methods:**

- `createCategory(CategoryModel)`
- `getCategories()` - Stream
- `updateCategory(CategoryModel)`
- `deleteCategory(String id)`
- `updateProductCount(String categoryId, int count)`

### 2. REVIEWS (Đánh giá sản phẩm)

**Features:**

- User review sản phẩm (rating 1-5 sao + comment)
- Upload ảnh review (tối đa 5 ảnh)
- Tính rating trung bình của sản phẩm
- Kiểm tra user đã review chưa
- Chỉ cho phép review sau khi mua hàng

**API Methods:**

- `createReview(ReviewModel)`
- `getProductReviews(String productId)` - Stream
- `getUserReviews(String userId)` - Stream
- `updateReview(ReviewModel)`
- `deleteReview(String id)`
- `getProductRatingStats(String productId)`
- `getUserReviewForProduct(String userId, String productId)`

### 3. WISHLIST (Danh sách yêu thích)

**Features:**

- Thêm/xóa sản phẩm khỏi wishlist
- Badge hiển thị số lượng wishlist
- Icon trái tim đỏ khi đã yêu thích
- Xem danh sách sản phẩm yêu thích
- Thêm vào giỏ hàng từ wishlist

**API Methods:**

- `addToWishlist(WishlistModel)`
- `removeFromWishlist(String id)`
- `getUserWishlist(String userId)` - Stream
- `isInWishlist(String userId, String productId)`
- `getWishlistCount(String userId)`

### 4. NOTIFICATIONS (Thông báo)

**Features:**

- Nhận thông báo về đơn hàng
- Thông báo khuyến mãi
- Thông báo hệ thống
- Badge số thông báo chưa đọc
- Đánh dấu đã đọc/chưa đọc
- Admin gửi thông báo broadcast

**API Methods:**

- `createNotification(NotificationModel)`
- `getUserNotifications(String userId)` - Stream
- `getUnreadNotifications(String userId)` - Stream
- `markAsRead(String id)`
- `markAllAsRead(String userId)`
- `deleteNotification(String id)`
- `sendBroadcastNotification()` - Admin only

### 5. ADDRESSES (Quản lý địa chỉ)

**Features:**

- Thêm nhiều địa chỉ giao hàng
- Đánh dấu địa chỉ mặc định
- Chỉnh sửa/xóa địa chỉ
- Chọn địa chỉ khi checkout
- Auto-fill địa chỉ mặc định

**API Methods:**

- `createAddress(AddressModel)`
- `getUserAddresses(String userId)` - Stream
- `getDefaultAddress(String userId)`
- `updateAddress(AddressModel)`
- `setDefaultAddress(String userId, String addressId)`
- `deleteAddress(String id)`

### 6. COUPONS (Mã giảm giá)

**Features:**

- Admin tạo/quản lý coupon
- 2 loại: % hoặc số tiền cố định
- Giới hạn số lần sử dụng
- Thời gian hiệu lực
- Đơn hàng tối thiểu
- Validate coupon trước khi áp dụng
- Tự động tính discount

**API Methods:**

- `createCoupon(CouponModel)` - Admin
- `getAllCoupons()` - Admin
- `getActiveCoupons()` - User
- `getCouponByCode(String code)`
- `updateCoupon(CouponModel)` - Admin
- `deleteCoupon(String id)` - Admin
- `validateCoupon(String code, double orderAmount)`
- `incrementUsageCount(String couponId)`

## 📱 CÁC SCREEN CẦN TẠO

### User Screens

1. `lib/screens/wishlist/wishlist_screen.dart` - Danh sách yêu thích
2. `lib/screens/notification/notification_screen.dart` - Danh sách thông báo
3. `lib/screens/profile/address_list_screen.dart` - Danh sách địa chỉ
4. `lib/screens/profile/address_form_screen.dart` - Thêm/sửa địa chỉ
5. `lib/screens/product/review_list_screen.dart` - Danh sách đánh giá sản phẩm
6. `lib/screens/product/review_form_screen.dart` - Viết đánh giá
7. `lib/screens/checkout/coupon_screen.dart` - Chọn mã giảm giá

### Admin Screens

8. `lib/screens/admin/category_management_screen.dart` - Quản lý danh mục
9. `lib/screens/admin/coupon_management_screen.dart` - Quản lý mã giảm giá
10. `lib/screens/admin/notification_broadcast_screen.dart` - Gửi thông báo

## 🔧 CÁCH TÍCH HỢP VÀO APP

### 1. Đăng ký Providers trong main.dart

```dart
MultiProvider(
  providers: [
    // ... existing providers ...
    ChangeNotifierProvider(create: (_) => WishlistProvider()),
    ChangeNotifierProvider(create: (_) => NotificationProvider()),
    ChangeNotifierProvider(create: (_) => AddressProvider()),
  ],
  child: MyApp(),
)
```

### 2. Thêm vào Navigation

- Wishlist: Nút trên AppBar hoặc Bottom Navigation
- Notifications: Badge icon trên AppBar
- Addresses: Trong Profile Screen
- Reviews: Trong Product Detail Screen
- Coupons: Trong Checkout Screen

### 3. Firebase Security Rules

```javascript
// Categories - Read all, Write admin only
match /categories/{categoryId} {
  allow read: if true;
  allow write: if isAdmin();
}

// Reviews - CRUD với validation
match /reviews/{reviewId} {
  allow read: if true;
  allow create: if isAuthenticated() && isOwner(request.resource.data.userId);
  allow update, delete: if isAuthenticated() && isOwner(resource.data.userId);
}

// Wishlist - User riêng
match /wishlist/{wishlistId} {
  allow read, write: if isAuthenticated() && isOwner(resource.data.userId);
}

// Notifications - User riêng
match /notifications/{notificationId} {
  allow read: if isAuthenticated() && isOwner(resource.data.userId);
  allow create: if isAdmin();
  allow update, delete: if isAuthenticated() && isOwner(resource.data.userId);
}

// Addresses - User riêng
match /addresses/{addressId} {
  allow read, write: if isAuthenticated() && isOwner(resource.data.userId);
}

// Coupons - Read all, Write admin only
match /coupons/{couponId} {
  allow read: if true;
  allow write: if isAdmin();
}

// Helper functions
function isAuthenticated() {
  return request.auth != null;
}

function isOwner(userId) {
  return request.auth.uid == userId;
}

function isAdmin() {
  return isAuthenticated() &&
         get(/databases/$(database)/documents/users/$(request.auth.uid)).data.role == 'admin';
}
```

## 🎨 UI/UX SUGGESTIONS

### Wishlist Icon

- Heart outline: Chưa thêm
- Heart filled (red): Đã thêm
- Có animation khi tap

### Notification Badge

- Badge đỏ với số lượng unread
- Dot đỏ nếu có thông báo mới
- Auto-refresh real-time

### Address Card

- Default address: Green border
- Action buttons: Edit, Delete, Set Default
- Icon: Home, Work, Other

### Coupon Code

- Input field với button "Áp dụng"
- Hiển thị discount amount màu xanh
- List available coupons
- Copy code button

### Review Stars

- Interactive star rating
- Show average rating
- Progress bars for each star level

## 🚀 NEXT STEPS

1. Tạo UI screens cho từng chức năng
2. Test Firebase queries và indexes
3. Implement Firebase Security Rules
4. Add animations và loading states
5. Test trên nhiều devices
6. Add error handling và validation

## 📝 NOTES

- Tất cả models đã support `toMap()` và `fromMap()` cho Firestore
- Services sử dụng Streams cho real-time updates
- Providers implement ChangeNotifier pattern
- Đã có validation logic trong models (ví dụ: Coupon.isValid)
- Support both online và offline với Firestore cache

---

**Created:** November 18, 2025
**Version:** 1.0
**Status:** Models & Services Complete, UI Pending
