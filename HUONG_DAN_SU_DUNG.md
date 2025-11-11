# 📱 HƯỚNG DẪN SỬ DỤNG ỨNG DỤNG MUA SẮM

## 📋 Mục lục

1. [Giới thiệu](#giới-thiệu)
2. [Tài khoản mẫu](#tài-khoản-mẫu)
3. [Hướng dẫn cho người dùng](#hướng-dẫn-cho-người-dùng)
4. [Hướng dẫn cho Admin](#hướng-dẫn-cho-admin)
5. [Các tính năng chính](#các-tính-năng-chính)
6. [Xử lý sự cố](#xử-lý-sự-cố)

---

## 🎯 Giới thiệu

Ứng dụng Mua Sắm là một ứng dụng thương mại điện tử được phát triển bằng Flutter, cho phép người dùng:

- Xem và tìm kiếm sản phẩm
- Thêm sản phẩm vào giỏ hàng
- Quản lý tài khoản cá nhân
- Admin có thể quản lý sản phẩm (Thêm/Sửa/Xóa)

**Công nghệ sử dụng:**

- Flutter (Frontend)
- Firebase Authentication (Đăng nhập/Đăng ký)
- Cloud Firestore (Database)
- Provider (State Management)

---

## 🔑 Tài khoản mẫu

### Tài khoản Admin

```
Email: admin@admin.com
Password: 123456
```

**Quyền hạn:** Quản lý sản phẩm, xem tất cả dữ liệu

### Tài khoản User (Tự tạo)

Người dùng có thể đăng ký tài khoản mới từ màn hình đăng ký

---

## 👤 Hướng dẫn cho Người dùng

### 1. Đăng ký tài khoản mới

1. Mở ứng dụng
2. Nhấn nút **"Đăng ký"** ở màn hình đăng nhập
3. Nhập thông tin:
   - Email (phải hợp lệ)
   - Password (tối thiểu 6 ký tự)
   - Xác nhận password
4. Nhấn **"Đăng ký"**
5. Hệ thống sẽ tự động đăng nhập và chuyển đến trang chủ

### 2. Đăng nhập

1. Nhập email và password
2. Nhấn **"Đăng nhập"**
3. Nếu thành công → Chuyển đến trang chủ

### 3. Xem danh sách sản phẩm

**Trang chủ:**

- Hiển thị tất cả sản phẩm dạng lưới (Grid)
- Mỗi sản phẩm hiển thị:
  - Hình ảnh
  - Tên sản phẩm
  - Giá
  - Nút "Thêm vào giỏ"

**Lọc theo danh mục:**

- Vuốt ngang phần "Danh mục" ở đầu trang
- Nhấn vào danh mục muốn xem:
  - 📱 Điện thoại
  - 💻 Laptop
  - 🖥️ Máy tính bảng
  - 🎧 Phụ kiện

### 4. Tìm kiếm sản phẩm

1. Nhấn icon **🔍 Tìm kiếm** trên AppBar
2. Nhập từ khóa vào ô tìm kiếm
3. Kết quả hiển thị ngay khi gõ
4. Có thể lọc theo:
   - Danh mục
   - Khoảng giá
   - Tên sản phẩm

### 5. Xem chi tiết sản phẩm

1. Nhấn vào **tên sản phẩm** hoặc **hình ảnh**
2. Màn hình chi tiết hiển thị:
   - Hình ảnh lớn
   - Tên sản phẩm
   - Giá
   - Mô tả chi tiết
   - Danh mục
3. Nhấn **"Thêm vào giỏ"** để thêm sản phẩm

### 6. Quản lý giỏ hàng

**Thêm sản phẩm vào giỏ:**

1. Nhấn nút **"Thêm vào giỏ"** ở bất kỳ đâu
2. Thông báo xác nhận xuất hiện
3. Icon giỏ hàng hiển thị số lượng sản phẩm

**Xem giỏ hàng:**

1. Nhấn icon **🛒 Giỏ hàng** trên AppBar
2. Hiển thị danh sách sản phẩm đã thêm với:
   - Hình ảnh
   - Tên
   - Giá
   - Số lượng
   - Tổng tiền từng sản phẩm

**Điều chỉnh số lượng:**

- Nhấn **+** để tăng số lượng
- Nhấn **-** để giảm số lượng
- Nhấn icon **🗑️** để xóa sản phẩm

**Tổng tiền:**

- Hiển thị ở cuối giỏ hàng
- Cập nhật tự động khi thay đổi số lượng

### 7. Quản lý tài khoản

**Xem thông tin:**

1. Nhấn icon **👤 Tài khoản** trên AppBar
2. Hiển thị:
   - Email đăng nhập
   - Tên người dùng
   - Thông tin cá nhân

**Đổi mật khẩu:**

1. Vào **Tài khoản** → **Đổi mật khẩu**
2. Nhập:
   - Mật khẩu hiện tại
   - Mật khẩu mới
   - Xác nhận mật khẩu mới
3. Nhấn **"Đổi mật khẩu"**

**Đăng xuất:**

1. Nhấn nút **"Đăng xuất"** ở màn hình tài khoản
2. Xác nhận đăng xuất
3. Quay về màn hình đăng nhập

---

## 👨‍💼 Hướng dẫn cho Admin

### 1. Đăng nhập Admin

```
Email: admin@admin.com
Password: 123456
```

**Nhận biết tài khoản Admin:**

- Icon ⚙️ (bánh răng) xuất hiện trên AppBar
- Menu "Quản lý sản phẩm" có sẵn

### 2. Truy cập Admin Panel

**Cách 1:**

- Nhấn icon **⚙️** trên AppBar
- Chọn **"Quản lý sản phẩm"**

**Cách 2:**

- Vào menu điều hướng
- Chọn **"Admin Panel"**

### 3. Xem danh sách sản phẩm

Admin Panel hiển thị:

- Tổng số sản phẩm
- Danh sách tất cả sản phẩm với:
  - Hình ảnh
  - Tên
  - Danh mục
  - Giá
  - Nút Sửa/Xóa

**Tìm kiếm sản phẩm:**

- Dùng ô tìm kiếm ở đầu trang
- Tìm theo tên hoặc danh mục

### 4. Thêm sản phẩm mới

1. Nhấn nút **"+ Thêm sản phẩm"** (nút tròn màu xanh)
2. Nhập thông tin:
   - **Tên sản phẩm** (bắt buộc)
   - **Giá** (số, bắt buộc)
   - **Mô tả** (bắt buộc)
   - **Danh mục** (chọn từ dropdown)
   - **URL hình ảnh** (link hợp lệ)
3. Nhấn **"Lưu"**
4. Sản phẩm xuất hiện ngay trên trang chủ

**Lưu ý:**

- URL hình ảnh phải là link công khai (http:// hoặc https://)
- Giá phải là số nguyên dương
- Tất cả trường đều bắt buộc

### 5. Sửa sản phẩm

1. Tìm sản phẩm cần sửa trong danh sách
2. Nhấn icon **✏️ Sửa**
3. Chỉnh sửa thông tin cần thiết
4. Nhấn **"Cập nhật"**
5. Thay đổi được lưu ngay lập tức

### 6. Xóa sản phẩm

1. Tìm sản phẩm cần xóa
2. Nhấn icon **🗑️ Xóa**
3. Xác nhận xóa trong hộp thoại
4. Sản phẩm bị xóa vĩnh viễn khỏi database

**Cảnh báo:**

- Không thể khôi phục sau khi xóa
- Sản phẩm trong giỏ hàng của user sẽ bị ảnh hưởng

### 7. Thêm dữ liệu mẫu (Seed Data)

**Khi nào cần dùng:**

- Database trống, không có sản phẩm
- Muốn test app với dữ liệu có sẵn

**Cách thực hiện:**

1. Đăng nhập admin
2. Vào **Firebase Debug** (từ màn hình login hoặc setting)
3. Nhấn **"🗄️ Thêm dữ liệu mẫu"**
4. Nhấn **"THÊM DỮ LIỆU MẪU"**
5. Đợi 5-10 giây
6. Kiểm tra thông báo thành công
7. Quay về trang chủ → Sẽ thấy 8 sản phẩm mẫu

**Dữ liệu mẫu bao gồm:**

- 2 Điện thoại (iPhone 15, Samsung S24)
- 2 Laptop (MacBook Pro, Dell XPS)
- 1 Máy tính bảng (iPad Air)
- 3 Phụ kiện (AirPods, Apple Watch, Sony WH-1000XM5)

---

## 🎨 Các tính năng chính

### 1. Authentication (Xác thực)

- ✅ Đăng ký tài khoản mới
- ✅ Đăng nhập với email/password
- ✅ Đăng xuất
- ✅ Phân quyền User/Admin
- ✅ Đổi mật khẩu

### 2. Quản lý sản phẩm (User)

- ✅ Xem danh sách sản phẩm (Grid view)
- ✅ Xem chi tiết sản phẩm
- ✅ Tìm kiếm sản phẩm
- ✅ Lọc theo danh mục
- ✅ Hình ảnh responsive (180px height)

### 3. Giỏ hàng

- ✅ Thêm sản phẩm vào giỏ
- ✅ Xem danh sách giỏ hàng
- ✅ Tăng/giảm số lượng
- ✅ Xóa sản phẩm
- ✅ Tính tổng tiền tự động
- ✅ Badge hiển thị số lượng

### 4. Admin Panel

- ✅ Quản lý sản phẩm (CRUD)
- ✅ Thêm sản phẩm mới
- ✅ Sửa thông tin sản phẩm
- ✅ Xóa sản phẩm
- ✅ Tìm kiếm trong admin
- ✅ Upload ảnh qua URL

### 5. UI/UX

- ✅ Material Design 3
- ✅ Responsive layout
- ✅ Loading states
- ✅ Error handling
- ✅ Snackbar notifications
- ✅ Bottom navigation
- ✅ Search với debounce

### 6. Firebase Integration

- ✅ Real-time database (Firestore)
- ✅ Authentication
- ✅ Auto sync data
- ✅ Offline support (cache)

---

## 🔧 Xử lý sự cố

### Vấn đề: Không thể đăng nhập

**Nguyên nhân:**

- Email/password sai
- Tài khoản chưa được tạo
- Kết nối Firebase lỗi

**Giải pháp:**

1. Kiểm tra email và password
2. Thử đăng ký tài khoản mới
3. Kiểm tra kết nối internet
4. Restart app

### Vấn đề: Không thấy sản phẩm

**Nguyên nhân:**

- Database trống
- Kết nối Firestore lỗi

**Giải pháp:**

1. Đăng nhập admin
2. Vào Firebase Debug
3. Thêm dữ liệu mẫu (Seed Data)
4. Hoặc Admin thêm sản phẩm thủ công

### Vấn đề: Hình ảnh không hiển thị

**Nguyên nhân:**

- URL hình ảnh không hợp lệ
- Link bị chặn CORS (web)
- Kết nối internet chậm

**Giải pháp:**

1. Kiểm tra URL hình ảnh có công khai không
2. Dùng link từ: Unsplash, Imgur, hoặc Firebase Storage
3. Đảm bảo link bắt đầu bằng http:// hoặc https://

### Vấn đề: Không thêm được vào giỏ hàng

**Nguyên nhân:**

- Lỗi CartProvider
- App chưa được rebuild sau update

**Giải pháp:**

1. Restart app
2. Hot reload (nhấn R trong terminal)
3. Kiểm tra console log

### Vấn đề: Admin menu không hiện

**Nguyên nhân:**

- Role chưa được set trong Firestore

**Giải pháp:**

1. Đăng nhập admin@admin.com
2. Vào màn hình login → **Quick Admin Fix**
3. Nhấn **"Sửa quyền Admin"**
4. Đăng xuất và đăng nhập lại

### Vấn đề: App crash trên Android

**Nguyên nhân:**

- MultiDex chưa enable
- Firebase không được init đúng

**Giải pháp:**

1. Đã fix: MultiDex enabled
2. Chạy: `flutter clean`
3. Chạy: `flutter run`

---

## 📊 Thống kê tính năng

| Tính năng     | User | Admin |
| ------------- | ---- | ----- |
| Xem sản phẩm  | ✅   | ✅    |
| Tìm kiếm      | ✅   | ✅    |
| Chi tiết SP   | ✅   | ✅    |
| Thêm giỏ hàng | ✅   | ✅    |
| Quản lý giỏ   | ✅   | ✅    |
| Thêm SP       | ❌   | ✅    |
| Sửa SP        | ❌   | ✅    |
| Xóa SP        | ❌   | ✅    |
| Seed Data     | ❌   | ✅    |

---

## 🚀 Platform Support

| Platform | Status    | Lưu ý                  |
| -------- | --------- | ---------------------- |
| Android  | ✅ Tested | API 21+ (Android 5.0+) |
| iOS      | ✅ Ready  | Chưa test              |
| Web      | ✅ Tested | Chrome, Edge           |
| Windows  | ✅ Tested | Desktop app            |
| macOS    | ✅ Ready  | Chưa test              |
| Linux    | ✅ Ready  | Chưa test              |

---

## 📞 Liên hệ & Hỗ trợ

**GitHub Repository:**
https://github.com/Bui-DangKhoa/-n-L-p-tr-nh-di-ng-n-ng-cao

**Email hỗ trợ:**
[Thêm email của bạn]

**Phiên bản:** 1.0.0  
**Ngày cập nhật:** November 11, 2025

---

## 🎓 Tài liệu kỹ thuật

Xem thêm:

- [README.md](README.md) - Thông tin dự án
- [RUN_APP_GUIDE.md](RUN_APP_GUIDE.md) - Hướng dẫn chạy app

---

**© 2025 - Ứng dụng Mua Sắm**
