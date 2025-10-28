# 🚀 Quick Start Guide - Flutter Shopping App

## 🎯 Khởi chạy nhanh

### 1. Chạy ứng dụng

```bash
flutter run
```

### 2. Đăng nhập thử nghiệm

#### 👑 Admin Account (Full Access)

```
Email: admin@admin.com
Password: 123456
Role: admin
```

**Features**: Mua sắm + Quản lý sản phẩm

#### 👤 Customer Account (Shopping Only)

```
Email: user@user.com
Password: 123456
Role: customer
```

**Features**: Chỉ mua sắm

## 🛍️ Test Customer Features

1. **Browse Products** - Xem danh sách sản phẩm trên Home
2. **Search** - Tìm kiếm sản phẩm theo tên
3. **Categories** - Filter theo danh mục (Điện thoại, Laptop, etc.)
4. **Add to Cart** - Thêm sản phẩm vào giỏ hàng
5. **Cart Management** - Xem, sửa, xóa trong giỏ hàng
6. **Profile** - Quản lý thông tin cá nhân

## 🔧 Test Admin Features

### Truy cập Admin Panel:

1. Đăng nhập với tài khoản admin
2. Nhấn icon **⚙️** (Admin Panel) ở góc phải AppBar
3. Chọn **"Quản lý sản phẩm"**

### Test CRUD Operations:

1. **View Products** - Xem danh sách tất cả sản phẩm
2. **Search** - Tìm kiếm trong admin panel
3. **Add Product** - Nhấn nút "+" để thêm sản phẩm mới
4. **Edit Product** - Menu popup "⋮" → "Sửa"
5. **Delete Product** - Menu popup "⋮" → "Xóa" (có confirmation)

## 📝 Test Data Samples

### Sample Product để thêm:

```
Tên: iPhone 15 Pro Max
Mô tả: Smartphone cao cấp với chip A17 Pro, camera 48MP, màn hình 6.7 inch
Giá: 29990000
Danh mục: Điện thoại
URL ảnh: https://images.unsplash.com/photo-1512499617640-c74ae3a79d37
```

### URL hình ảnh test:

- Điện thoại: `https://images.unsplash.com/photo-1512499617640-c74ae3a79d37`
- Laptop: `https://images.unsplash.com/photo-1496181133206-80ce9b88a853`
- Tablet: `https://images.unsplash.com/photo-1544244015-0df4b3ffc6b0`

## 🧪 Test Scenarios

### Scenario 1: Customer Journey

1. Đăng ký tài khoản mới
2. Browse products và search
3. Add multiple items to cart
4. Update quantities in cart
5. Check profile và edit info

### Scenario 2: Admin Workflow

1. Login as admin
2. Access admin panel
3. Add new product với validation
4. Edit existing product
5. Delete product với confirmation
6. Search products in admin panel

### Scenario 3: Permission Testing

1. Login as customer
2. Verify no admin menu visible
3. Try direct navigation to admin routes (should fail)
4. Login as admin
5. Verify admin menu appears

## 🚨 Kiểm tra lỗi

### Nếu app không start:

```bash
flutter clean
flutter pub get
flutter run
```

### Nếu Firebase connection issue:

1. Kiểm tra internet connection
2. Vào Account → Firebase Debug để xem logs
3. Restart app

### Nếu emulator không detect:

```bash
flutter devices
flutter emulators --launch <emulator_name>
```

## 🎨 UI Features để test

- **Loading states** - Circular progress khi loading
- **Error handling** - SnackBar messages
- **Form validation** - Required fields và format checking
- **Image preview** - Auto preview khi nhập URL
- **Search functionality** - Real-time search
- **Navigation** - Smooth transitions between screens

## 📱 Supported Platforms

- ✅ Android (Emulator + Physical device)
- ✅ iOS (Simulator + Physical device)
- ✅ Web (Chrome, Edge)
- ✅ Windows Desktop

## 🎉 Ready to Demo!

Project hoàn toàn sẵn sàng để demo với đầy đủ tính năng:

- Complete shopping experience
- Professional admin panel
- Modern UI/UX
- Production-ready code quality

---

💡 **Tip**: Bắt đầu với customer account để test shopping features, sau đó chuyển sang admin account để test management features!
