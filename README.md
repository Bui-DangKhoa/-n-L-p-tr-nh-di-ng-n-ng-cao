# Flutter Shopping App

Ứng dụng mua sắm trực tuyến được phát triển bằng Flutter với Firebase.

## Tính năng chính

### 🔐 Xác thực người dùng

- Đăng ký tài khoản mới
- Đăng nhập/Đăng xuất
- Chỉnh sửa thông tin cá nhân
- Đổi mật khẩu

### 🛍️ Quản lý sản phẩm

- Xem danh sách sản phẩm theo danh mục
- Tìm kiếm sản phẩm
- Xem chi tiết sản phẩm
- Hình ảnh sản phẩm thật từ Unsplash

### 🛒 Giỏ hàng

- Thêm/xóa sản phẩm khỏi giỏ hàng
- Cập nhật số lượng sản phẩm
- Tính toán tổng tiền tự động

### 📱 Giao diện

- Thiết kế responsive
- Điều hướng dễ sử dụng
- Loading states và error handling

## Công nghệ sử dụng

- **Flutter**: Framework phát triển ứng dụng
- **Firebase Auth**: Xác thực người dùng
- **Cloud Firestore**: Cơ sở dữ liệu NoSQL
- **Provider**: State management
- **Unsplash API**: Hình ảnh sản phẩm

## Cài đặt và chạy

### Yêu cầu

- Flutter SDK
- Android Studio/VS Code
- Firebase account

### Cài đặt

1. Clone repository:

```bash
git clone <repository-url>
cd do_an_ltddnc
```

2. Cài đặt dependencies:

```bash
flutter pub get
```

3. Cấu hình Firebase:

   - Tạo project Firebase mới
   - Thêm ứng dụng Android/iOS
   - Tải file `google-services.json` và đặt vào `android/app/`
   - Tải file `GoogleService-Info.plist` và đặt vào `ios/Runner/`

4. Chạy ứng dụng:

```bash
flutter run
```

## Cấu trúc project

```
lib/
├── models/          # Data models
├── providers/       # State management
├── screens/         # UI screens
│   ├── auth/        # Authentication screens
│   ├── home/        # Home screen
│   ├── cart/        # Cart screen
│   ├── account/     # Account management
│   ├── category/    # Category screen
│   ├── search/      # Search screen
│   └── product/     # Product detail screen
└── services/        # Business logic services
```

## Screenshots

(Thêm screenshots của ứng dụng ở đây)

## Đóng góp

Mọi đóng góp đều được chào đón! Vui lòng tạo issue hoặc pull request.

## License

MIT License
