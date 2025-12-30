# 🧪 HƯỚNG DẪN TEST CÁC CHỨC NĂNG MỚI

## 📋 Danh sách chức năng đã thêm

### ✅ Đã tích hợp vào app:

1. **Wishlist (Danh sách Yêu thích)** - 100% hoàn thành

### ⚙️ Đã tạo nhưng chưa có UI:

2. Categories (Quản lý Danh mục)
3. Reviews (Đánh giá Sản phẩm)
4. Notifications (Thông báo)
5. Addresses (Địa chỉ Giao hàng)
6. Coupons (Mã Giảm giá)

---

## 🧪 Test Wishlist (Danh sách Yêu thích)

### Bước 1: Đăng nhập

```
Email: admin@admin.com
Password: 123456
```

Hoặc đăng ký tài khoản mới

### Bước 2: Kiểm tra icon Wishlist

- ✅ Trên **Home Screen** → Tìm icon **❤️ (trái tim)** màu hồng bên cạnh giỏ hàng
- ✅ Badge hiển thị số lượng sản phẩm yêu thích (nếu có)

### Bước 3: Thêm sản phẩm vào Wishlist

Có 3 cách:

**Cách 1: Từ trang Home Screen** ⭐ MỚI - KHUYÊN DÙNG

1. Tìm icon **❤️** ở góc trên phải của mỗi product card
2. Nhấn vào icon → Đổi màu hồng (đã thêm)
3. Thông báo "Đã thêm vào danh sách yêu thích"
4. Badge trên AppBar tăng lên

**Cách 2: Từ trang chi tiết sản phẩm** ⭐ MỚI

1. Nhấn vào sản phẩm bất kỳ
2. Tìm icon **❤️** trên AppBar (bên trái giỏ hàng)
3. Nhấn vào → Icon đổi màu hồng
4. Thông báo "Đã thêm vào danh sách yêu thích"

**Cách 3: Từ Category/Search Screen** (Tương tự Home Screen)

- Icon ❤️ ở góc trên phải mỗi product card
- Nhấn để toggle thêm/xóa

### Bước 4: Xem Wishlist

1. Nhấn icon **❤️** trên Home Screen
2. Hoặc vào **Tài khoản** → **"Danh sách yêu thích"**
3. Xem danh sách sản phẩm đã lưu

### Bước 5: Thao tác với Wishlist

- ✅ **Xem chi tiết**: Nhấn vào sản phẩm
- ✅ **Thêm vào giỏ**: Nhấn nút "Thêm" màu xanh
- ✅ **Xóa sản phẩm**: Nhấn icon 🗑️ màu đỏ
- ✅ **Xóa tất cả**: Nhấn icon 🗑️ trên AppBar

### Bước 6: Kiểm tra đồng bộ

1. Thêm 3-5 sản phẩm vào wishlist
2. Đăng xuất
3. Đăng nhập lại
4. Vào Wishlist → Kiểm tra sản phẩm vẫn còn (đã lưu Firebase)

---

## 📊 Kiểm tra Firebase

### Cách kiểm tra:

1. Vào [Firebase Console](https://console.firebase.google.com/)
2. Chọn project của bạn
3. Vào **Firestore Database**
4. Kiểm tra các Collections:

#### Collection: `wishlist`

```
{
  id: "unique_id",
  userId: "user_uid",
  productId: "product_id",
  createdAt: Timestamp
}
```

#### Collection: `categories` (Đã tạo model/service)

```
{
  id: "cat_001",
  name: "Electronics",
  description: "...",
  imageUrl: "...",
  productCount: 10,
  isActive: true,
  createdAt: Timestamp,
  updatedAt: Timestamp
}
```

#### Collection: `reviews` (Đã tạo model/service)

```
{
  id: "rev_001",
  productId: "prod_001",
  userId: "user_001",
  userName: "John Doe",
  rating: 5,
  comment: "Great!",
  images: [],
  isVerifiedPurchase: true,
  helpfulCount: 0,
  createdAt: Timestamp
}
```

#### Collection: `notifications` (Đã tạo model/provider)

```
{
  id: "notif_001",
  userId: "user_001",
  title: "Order Shipped",
  message: "Your order...",
  type: "order",
  isRead: false,
  data: {},
  createdAt: Timestamp
}
```

#### Collection: `addresses` (Đã tạo model/provider)

```
{
  id: "addr_001",
  userId: "user_001",
  name: "Home",
  recipientName: "John Doe",
  phone: "0123456789",
  street: "123 Main St",
  ward: "Ward 1",
  district: "District 1",
  city: "Ho Chi Minh",
  isDefault: true,
  createdAt: Timestamp
}
```

#### Collection: `coupons` (Đã tạo model/service)

```
{
  id: "cpn_001",
  code: "SALE50",
  description: "50% off",
  discountType: "percentage",
  discountValue: 50,
  minOrderValue: 100000,
  maxDiscountAmount: 500000,
  startDate: Timestamp,
  endDate: Timestamp,
  usageLimit: 100,
  usedCount: 0,
  isActive: true,
  createdAt: Timestamp
}
```

---

## 🐛 Các vấn đề có thể gặp

### 1. Không thấy icon ❤️ trên Home Screen

**Nguyên nhân:** Provider chưa được thêm vào main.dart
**Giải pháp:** Restart app (Hot reload không đủ)

### 2. Lỗi khi nhấn vào Wishlist

**Nguyên nhân:** Route chưa được đăng ký
**Kiểm tra:** File `lib/main.dart` có dòng:

```dart
'/wishlist': (context) => const WishlistScreen(),
```

### 3. Badge không hiển thị số lượng

**Nguyên nhân:** WishlistProvider chưa được khởi tạo
**Kiểm tra:** User đã đăng nhập chưa?

### 4. Sản phẩm không lưu vào Firebase

**Nguyên nhân:** Firebase rules hoặc authentication
**Kiểm tra:**

- User đã đăng nhập?
- Firebase rules cho phép write?

---

## ✅ Checklist Test

### Wishlist

- [ ] Hiển thị icon ❤️ trên Home Screen
- [ ] Badge hiển thị số lượng đúng
- [ ] Thêm sản phẩm vào wishlist thành công
- [ ] Xem danh sách wishlist
- [ ] Xóa sản phẩm khỏi wishlist
- [ ] Xóa tất cả sản phẩm
- [ ] Thêm từ wishlist vào giỏ hàng
- [ ] Dữ liệu đồng bộ với Firebase
- [ ] Dữ liệu vẫn còn sau khi đăng xuất/nhập lại
- [ ] Menu "Danh sách yêu thích" trong Account Screen

### UI/UX

- [ ] Loading indicator khi tải dữ liệu
- [ ] Empty state khi wishlist trống
- [ ] Snackbar thông báo các hành động
- [ ] Confirm dialog khi xóa tất cả
- [ ] Hình ảnh sản phẩm hiển thị đúng
- [ ] Giá sản phẩm hiển thị đúng format

---

## 🚀 Các chức năng tiếp theo cần implement

### Độ ưu tiên cao:

1. **Reviews UI** - Màn hình đánh giá sản phẩm
2. **Notifications UI** - Màn hình thông báo
3. **Addresses UI** - Quản lý địa chỉ giao hàng

### Độ ưu tiên trung bình:

4. **Categories Management** - Admin quản lý danh mục
5. **Coupons UI** - Áp dụng mã giảm giá

### Cần tích hợp:

- Thêm nút ❤️ trên ProductDetailScreen
- Thêm toggle wishlist trong grid products
- Hiển thị số review trên product card
- Badge thông báo chưa đọc

---

## 📝 Ghi chú

### Files đã tạo:

```
lib/
├── models/
│   ├── category_model.dart ✅
│   ├── review_model.dart ✅
│   ├── wishlist_model.dart ✅
│   ├── notification_model.dart ✅
│   ├── address_model.dart ✅
│   └── coupon_model.dart ✅
├── services/
│   ├── category_service.dart ✅
│   ├── review_service.dart ✅
│   ├── wishlist_service.dart ✅
│   ├── notification_service.dart ✅
│   ├── address_service.dart ✅
│   └── coupon_service.dart ✅
├── providers/
│   ├── wishlist_provider.dart ✅
│   ├── notification_provider.dart ✅
│   └── address_provider.dart ✅
└── screens/
    └── wishlist/
        └── wishlist_screen.dart ✅
```

### Files đã cập nhật:

- `lib/main.dart` - Thêm providers và routes
- `lib/screens/home/home_screen.dart` - Thêm icon wishlist
- `lib/screens/account/account_screen.dart` - Thêm menu wishlist

### Cần tạo tiếp:

- `lib/screens/notification/notification_screen.dart`
- `lib/screens/address/address_list_screen.dart`
- `lib/screens/address/address_form_screen.dart`
- `lib/screens/review/product_reviews_screen.dart`
- `lib/screens/review/write_review_screen.dart`
- `lib/screens/coupon/coupon_list_screen.dart`
- `lib/screens/admin/category_management_screen.dart`

---

## 🎯 Kết luận

Hiện tại app đã có:

- ✅ **1 chức năng mới hoàn chỉnh**: Wishlist (có UI đầy đủ)
- ✅ **5 chức năng backend sẵn sàng**: Categories, Reviews, Notifications, Addresses, Coupons

Để sử dụng 5 chức năng còn lại, cần:

1. Tạo UI screens
2. Thêm routes vào main.dart
3. Thêm menu/buttons để truy cập
4. Test với Firebase

**Thời gian ước tính:**

- Mỗi UI screen: 30-60 phút
- Tổng: 3-5 giờ để hoàn thiện tất cả

**Hoặc có thể sử dụng trực tiếp:**

- Gọi Services từ code
- Test bằng Firebase Console
- Tích hợp dần vào các màn hình hiện có
