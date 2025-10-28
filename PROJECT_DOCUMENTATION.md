# Flutter Shopping App - Ứng dụng mua sắm trực tuyến

## 📱 Tổng quan dự án

Ứng dụng mua sắm trực tuyến được phát triển bằng Flutter với Firebase backend, hỗ trợ phân quyền người dùng và admin.

## 🚀 Tính năng đã hoàn thiện

### 🔐 Xác thực người dùng (Authentication)

- [x] Đăng ký tài khoản mới
- [x] Đăng nhập với email/password
- [x] Phân quyền User/Admin
- [x] Quản lý profile người dùng
- [x] Đổi mật khẩu
- [x] Xóa tài khoản với xác nhận mật khẩu
- [x] Đăng xuất

### 🛍️ Tính năng mua sắm (Customer)

- [x] Xem danh sách sản phẩm với hình ảnh thực từ Unsplash
- [x] Tìm kiếm sản phẩm theo tên
- [x] Xem chi tiết sản phẩm
- [x] Lọc sản phẩm theo danh mục
- [x] Thêm sản phẩm vào giỏ hàng
- [x] Quản lý giỏ hàng (xem, sửa, xóa)
- [x] Tính toán tổng tiền tự động
- [x] Hiển thị số lượng sản phẩm trong giỏ hàng

### 🛠️ Tính năng quản trị (Admin)

- [x] **Menu admin** - Chỉ hiển thị cho tài khoản admin
- [x] **Quản lý sản phẩm** - CRUD operations
  - [x] Xem danh sách tất cả sản phẩm
  - [x] Tìm kiếm sản phẩm trong admin panel
  - [x] Thêm sản phẩm mới với form validation
  - [x] Sửa thông tin sản phẩm
  - [x] Xóa sản phẩm với xác nhận
  - [x] Preview hình ảnh sản phẩm
- [x] **Phân quyền** - Kiểm tra role trước khi truy cập admin functions

### 🎨 Giao diện người dùng (UI/UX)

- [x] Material Design 3
- [x] Responsive layout
- [x] Loading states với circular progress indicators
- [x] Error handling với SnackBar
- [x] Form validation
- [x] Image preview và error handling
- [x] Search functionality
- [x] Category filtering
- [x] Shopping cart badge với số lượng

### 🔧 Technical Features

- [x] **State Management** - Provider pattern
- [x] **Database** - Cloud Firestore với real-time updates
- [x] **Authentication** - Firebase Auth
- [x] **Image handling** - Network images với error fallback
- [x] **Navigation** - Named routes với parameters
- [x] **Data Models** - Structured models cho User, Product, Cart, Order
- [x] **Services Layer** - Separation of concerns
- [x] **Debug Tools** - Firebase debug screen cho troubleshooting

## 📁 Cấu trúc project

```
lib/
├── main.dart                     # Entry point
├── firebase_options.dart         # Firebase configuration
├── models/                       # Data models
│   ├── user_model.dart
│   ├── product_model.dart
│   ├── cart_item_model.dart
│   └── order_model.dart
├── providers/                    # State management
│   ├── auth_provider.dart
│   └── cart_provider.dart
├── services/                     # Business logic
│   ├── auth_service.dart
│   ├── product_service.dart
│   └── order_service.dart
├── screens/                      # UI screens
│   ├── auth/                    # Authentication screens
│   ├── home/                    # Home & product listing
│   ├── cart/                    # Shopping cart
│   ├── account/                 # User profile management
│   ├── admin/                   # Admin panel
│   │   ├── product_management_screen.dart
│   │   └── add_edit_product_screen.dart
│   └── debug/                   # Debug tools
```

## 🔑 Tài khoản demo

### Admin Account

- Email: admin@admin.com
- Password: 123456
- Role: admin

### User Account

- Email: user@user.com
- Password: 123456
- Role: customer

## 🎯 Hướng dẫn sử dụng

### Cho người dùng thường (Customer):

1. Đăng ký/Đăng nhập
2. Browse sản phẩm trên trang chủ
3. Tìm kiếm hoặc lọc theo danh mục
4. Thêm sản phẩm vào giỏ hàng
5. Quản lý giỏ hàng và checkout
6. Cập nhật profile trong Account

### Cho admin:

1. Đăng nhập với tài khoản admin
2. Nhấn icon admin panel (⚙️) ở góc phải AppBar
3. Chọn "Quản lý sản phẩm"
4. Thực hiện các thao tác CRUD:
   - Thêm sản phẩm mới với nút "+"
   - Sửa sản phẩm bằng menu popup "✏️"
   - Xóa sản phẩm bằng menu popup "🗑️"
   - Tìm kiếm sản phẩm trong danh sách

## 🚧 Tính năng có thể mở rộng

- [ ] Order management system
- [ ] Payment integration
- [ ] Push notifications
- [ ] Product reviews & ratings
- [ ] Wishlist functionality
- [ ] Multiple image upload
- [ ] Advanced filtering (price range, brand)
- [ ] Inventory management
- [ ] Sales analytics dashboard
- [ ] Customer support chat

## 🛠️ Công nghệ sử dụng

- **Framework**: Flutter 3.35.3
- **Backend**: Firebase (Auth, Firestore)
- **State Management**: Provider
- **UI**: Material Design 3
- **Images**: Unsplash API
- **Language**: Dart

## 💻 Cài đặt và chạy

1. Clone repository
2. Chạy `flutter pub get`
3. Cấu hình Firebase (đã có sẵn firebase_options.dart)
4. Chạy `flutter run`

---

## 📝 Ghi chú phát triển

Project đã hoàn thiện các tính năng core của một ứng dụng shopping với role-based access control. Code được tổ chức tốt với separation of concerns, error handling đầy đủ, và UI/UX intuitive.

**Điểm mạnh:**

- Codebase clean và maintainable
- Complete CRUD operations cho admin
- Proper error handling
- Good UI/UX design
- Real-time data updates
- Role-based access control

**Last Updated**: October 28, 2025
