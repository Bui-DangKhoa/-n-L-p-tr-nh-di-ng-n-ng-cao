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

### 👥 Chức năng người dùng:

- Xem và tìm kiếm sản phẩm theo danh mục
- Thêm sản phẩm vào giỏ hàng với đồng bộ Firebase realtime
- **Lưu sản phẩm yêu thích (Wishlist)** 🆕
- Quản lý tài khoản cá nhân
- **Xem thông báo và khuyến mãi** 🆕
- **Quản lý địa chỉ giao hàng** 🆕
- **Áp dụng mã giảm giá** 🆕
- Xem giỏ hàng và thanh toán

### 👑 Chức năng Admin:

- Quản lý sản phẩm (Thêm/Sửa/Xóa)
- **Quản lý danh mục động** 🆕
- **Quản lý mã giảm giá (Coupons)** 🆕
- **Quản lý Banner trang chủ** 🆕
- **Quản lý thương hiệu (Brands)** 🆕
- Xem danh sách đơn hàng

**Công nghệ sử dụng:**

- Flutter (Frontend)
- Firebase Authentication (Đăng nhập/Đăng ký)
- Cloud Firestore (Database - 12+ Collections)
- Provider (State Management)
- Firebase Storage (Lưu trữ hình ảnh)

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

### 7. Danh sách Yêu thích (Wishlist) 🆕

**Thêm vào Wishlist:**

1. Vào trang chi tiết sản phẩm
2. Nhấn icon **❤️ (Trái tim)**
3. Thông báo "Đã thêm vào yêu thích"

**Xem Wishlist:**

1. Vào menu → **"Danh sách yêu thích"**
2. Hoặc nhấn icon **❤️** trên AppBar
3. Xem tất cả sản phẩm đã lưu

**Từ Wishlist có thể:**

- ✅ Xem chi tiết sản phẩm (nhấn vào sản phẩm)
- ✅ Thêm nhanh vào giỏ (nút "Thêm")
- ✅ Xóa khỏi wishlist (icon 🗑️)
- ✅ Xóa tất cả (icon 🗑️ trên AppBar)

**Hiển thị thông tin:**

- Hình ảnh sản phẩm
- Tên sản phẩm
- Giá bán
- Nút thêm giỏ và xóa

**Lợi ích:**

- Lưu sản phẩm để mua sau
- So sánh nhiều sản phẩm
- Theo dõi giá sản phẩm
- Không bị mất khi đăng xuất

### 8. Quản lý tài khoản

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

## 🔥 Chức năng mới đã triển khai

### 1. 🛒 Quản lý Giỏ hàng với Firebase (Cart Management)

**Mô tả:** Giỏ hàng được lưu trữ và đồng bộ realtime trên Firebase

**Collection:** `orders` (với status = 'cart')
**Service:** `CartService`
**Provider:** `CartProvider`

**Tính năng:**

- ✅ Lưu giỏ hàng trên Firebase (mỗi user có 1 cart duy nhất)
- ✅ Đồng bộ realtime giữa các thiết bị
- ✅ Thêm/xóa/sửa sản phẩm trong giỏ
- ✅ Cập nhật số lượng sản phẩm
- ✅ Tính tổng tiền tự động
- ✅ Áp dụng mã giảm giá
- ✅ Chuyển đổi giỏ hàng thành đơn hàng khi checkout

**Cách sử dụng:**

1. Thêm sản phẩm vào giỏ từ bất kỳ màn hình nào
2. Xem giỏ hàng qua icon 🛒 trên AppBar
3. Điều chỉnh số lượng hoặc xóa sản phẩm
4. Áp dụng mã giảm giá (nếu có)
5. Nhấn "Thanh toán" để hoàn tất

### 2. 📁 Quản lý Danh mục động (Category Management)

**Mô tả:** Admin quản lý danh mục sản phẩm, hiển thị động trên trang chủ

**Collection:** `categories`
**Service:** `CategoryService`
**Model:** `CategoryModel`

**Tính năng:**

- ✅ CRUD danh mục sản phẩm (Thêm/Sửa/Xóa)
- ✅ Hiển thị danh mục trên trang chủ với hình ảnh
- ✅ Xem sản phẩm theo danh mục
- ✅ Đếm số lượng sản phẩm trong danh mục
- ✅ Admin: Quản lý qua Account → Quản trị viên → Quản lý danh mục
- ✅ User: Nhấn vào danh mục để xem sản phẩm

**Cách sử dụng Admin:**

1. Đăng nhập admin@admin.com
2. Account → Quản trị viên → Quản lý danh mục
3. Nhấn nút "+" để thêm danh mục mới
4. Nhập: Tên, Mô tả, URL hình ảnh
5. Long press trên danh mục để Sửa/Xóa

**Cách sử dụng User:**

1. Xem danh mục trên trang chủ (cuộn ngang)
2. Nhấn vào danh mục để xem sản phẩm
3. Thêm sản phẩm vào giỏ hàng hoặc wishlist

### 3. ❤️ Wishlist (Danh sách Yêu thích)

**Mô tả:** Lưu sản phẩm yêu thích của người dùng

**Collection:** `wishlist`
**Service:** `WishlistService`
**Provider:** `WishlistProvider`

**Tính năng:**

- ✅ Thêm/xóa sản phẩm yêu thích
- ✅ Xem danh sách wishlist
- ✅ Thêm từ wishlist vào giỏ hàng
- ✅ Đồng bộ realtime với Firebase
- ✅ Icon trái tim trên mỗi sản phẩm

**Cách sử dụng:**

1. Nhấn icon ❤️ trên card sản phẩm để thêm/xóa
2. Vào Account → Danh sách yêu thích để xem tất cả
3. Nhấn "Thêm vào giỏ" từ wishlist

### 4. 🎟️ Hệ thống Mã giảm giá (Coupon System)

**Mô tả:** Admin tạo và quản lý mã giảm giá, user áp dụng khi thanh toán

**Collection:** `coupons`
**Service:** `CouponService`
**Model:** `CouponModel`

**Tính năng:**

- ✅ Tạo mã giảm giá theo % hoặc số tiền cố định
- ✅ Thiết lập điều kiện: đơn tối thiểu, hạn sử dụng
- ✅ Giới hạn số lần sử dụng
- ✅ Bật/tắt mã giảm giá
- ✅ Áp dụng mã khi thanh toán

**Admin - Quản lý Coupons:**

1. Account → Quản trị viên → Quản lý mã giảm giá
2. Nhấn "+" để tạo coupon mới
3. Nhập: Mã, Tiêu đề, Mô tả, Loại (% hoặc Fixed)
4. Thiết lập: Giá trị giảm, Đơn tối thiểu, Giảm tối đa
5. Chọn ngày bắt đầu và kết thúc

**User - Sử dụng Coupon:**

1. Thêm sản phẩm vào giỏ hàng
2. Trong màn hình giỏ hàng, nhấn "Chọn mã giảm giá"
3. Chọn mã phù hợp (kiểm tra điều kiện)
4. Xem số tiền giảm và tổng thanh toán

### 5. 📍 Quản lý Địa chỉ (Address Management)

**Mô tả:** User quản lý địa chỉ giao hàng

**Collection:** `addresses`
**Service:** `AddressService`
**Provider:** `AddressProvider`

**Tính năng:**

- ✅ Thêm nhiều địa chỉ giao hàng
- ✅ Đặt địa chỉ mặc định
- ✅ Sửa/xóa địa chỉ
- ✅ Chọn địa chỉ khi checkout

**Cách sử dụng:**

1. Account → Địa chỉ giao hàng
2. Nhấn "+" để thêm địa chỉ mới
3. Nhập: Tên, SĐT, Địa chỉ đầy đủ
4. Bật "Địa chỉ mặc định" nếu muốn
5. Sửa/xóa bằng icon tương ứng

### 6. 🔔 Hệ thống Thông báo (Notification System)

**Mô tả:** Thông báo cho user về đơn hàng, khuyến mãi

**Collection:** `notifications`
**Service:** `NotificationService`
**Provider:** `NotificationProvider`

**Tính năng:**

- ✅ Nhận thông báo realtime
- ✅ Đánh dấu đã đọc
- ✅ Xóa thông báo
- ✅ Phân loại: Đơn hàng, Khuyến mãi, Hệ thống
- ✅ Badge số lượng chưa đọc

**Cách sử dụng:**

1. Nhấn icon 🔔 trên AppBar (có badge nếu có thông báo mới)
2. Xem danh sách thông báo
3. Nhấn vào thông báo để xem chi tiết
4. Vuốt sang trái để xóa

### 7. 🎨 Quản lý Banner & Brand (Admin)

**Mô tả:** Admin quản lý banner trang chủ và thương hiệu

**Collections:** `banners`, `brands`
**Services:** `BannerService`, `BrandService`
**Providers:** `BannerProvider`, `BrandProvider`

**Banner - Tính năng:**

- ✅ Thêm/sửa/xóa banner trang chủ
- ✅ Tải ảnh lên Firebase Storage
- ✅ Thiết lập link điều hướng
- ✅ Bật/tắt hiển thị
- ✅ Sắp xếp thứ tự hiển thị

**Brand - Tính năng:**

- ✅ Quản lý danh sách thương hiệu
- ✅ Logo và mô tả thương hiệu
- ✅ Lọc sản phẩm theo brand
- ✅ Hiển thị trên trang chủ

**Admin - Cách sử dụng:**

1. Banner: Account → Quản lý Banner
2. Brand: Account → Quản lý Thương hiệu
3. Thêm/Sửa/Xóa qua UI trực quan

### 8. ⭐ Hệ thống Đánh giá (Review System) - Đã có Model

**Mô tả:** Đánh giá và nhận xét sản phẩm (Model đã tạo, chờ tích hợp UI)

**Collection:** `reviews`
**Service:** `ReviewService`
**Model:** `ReviewModel`

- toggleWishlist()
- isInWishlist()

**Screen:** `WishlistScreen`

- ✅ Xem danh sách yêu thích
- ✅ Thêm vào giỏ hàng từ wishlist
- ✅ Xóa khỏi wishlist
- ✅ Xóa tất cả
- ✅ Hiển thị thông tin sản phẩm

**Tính năng:**

- ✅ Thêm/xóa sản phẩm yêu thích
- ✅ Xem danh sách đầy đủ
- ✅ Nhanh chóng thêm vào giỏ
- ✅ Đồng bộ real-time với Firebase
- ✅ Badge hiển thị số lượng

### 4. 🔔 Notifications (Thông báo)

**Mô tả:** Hệ thống thông báo cho người dùng

**Model:** `NotificationModel`

- id, userId, title, message
- type (order, promo, system, review)
- isRead, data (JSON metadata)
- createdAt

**Service:** `NotificationService`

- getUserNotifications(userId)
- createNotification()
- markAsRead()
- markAllAsRead()
- deleteNotification()

**Provider:** `NotificationProvider`

- notifications, unreadCount
- loadNotifications()
- markAsRead()
- markAllAsRead()
- deleteNotification()

**Tính năng:**

- ✅ Thông báo đơn hàng
- ✅ Thông báo khuyến mãi
- ✅ Thông báo hệ thống
- ✅ Thông báo review mới
- ✅ Đếm số thông báo chưa đọc
- ✅ Đánh dấu đã đọc
- ✅ Real-time updates

### 5. 📍 Addresses (Địa chỉ Giao hàng)

**Mô tả:** Quản lý địa chỉ giao hàng của người dùng

**Model:** `AddressModel`

- id, userId, name (Nhà/Công ty)
- recipientName, phone
- street, ward, district, city
- isDefault
- createdAt, updatedAt

**Service:** `AddressService`

- getUserAddresses(userId)
- getDefaultAddress(userId)
- createAddress()
- updateAddress()
- deleteAddress()
- setDefaultAddress()

**Provider:** `AddressProvider`

- addresses, defaultAddress
- loadAddresses()
- addAddress()
- updateAddress()
- deleteAddress()
- setDefault()

**Tính năng:**

- ✅ Thêm nhiều địa chỉ
- ✅ Đặt địa chỉ mặc định
- ✅ Sửa/xóa địa chỉ
- ✅ Phân loại (Nhà, Công ty, Khác)
- ✅ Validation số điện thoại
- ✅ Chọn địa chỉ khi đặt hàng

### 6. 🎫 Coupons (Mã Giảm giá)

**Mô tả:** Hệ thống mã giảm giá và khuyến mãi

**Model:** `CouponModel`

- id, code (mã coupon)
- description
- discountType (percentage/fixed)
- discountValue
- minOrderValue (đơn tối thiểu)
- maxDiscountAmount (giảm tối đa)
- startDate, endDate
- usageLimit, usedCount
- isActive, createdAt

**Service:** `CouponService`

- getAllCoupons()
- getActiveCoupons()
- getCouponByCode(code)
- validateCoupon()
- applyCoupon()
- createCoupon() - Admin
- updateCoupon() - Admin
- deactivateCoupon() - Admin

**Tính năng:**

- ✅ Giảm theo phần trăm (%)
- ✅ Giảm cố định (VNĐ)
- ✅ Điều kiện đơn hàng tối thiểu
- ✅ Giới hạn số lần sử dụng
- ✅ Thời gian có hiệu lực
- ✅ Giảm tối đa
- ✅ Validate mã trước khi áp dụng
- ✅ Tracking số lần đã dùng

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

### 4. Wishlist (Yêu thích) 🆕

- ✅ Thêm/xóa sản phẩm yêu thích
- ✅ Xem danh sách wishlist
- ✅ Thêm nhanh vào giỏ từ wishlist
- ✅ Xóa tất cả sản phẩm
- ✅ Real-time sync với Firebase
- ✅ Badge hiển thị số lượng

### 5. Categories (Danh mục) 🆕

- ✅ Quản lý danh mục động
- ✅ CRUD danh mục (Admin)
- ✅ Đếm số sản phẩm
- ✅ Bật/tắt hiển thị
- ✅ Hình ảnh đại diện

### 6. Reviews (Đánh giá) 🆕

- ✅ Đánh giá 1-5 sao
- ✅ Viết nhận xét
- ✅ Đính kèm hình ảnh
- ✅ Xác thực đã mua hàng
- ✅ Đánh dấu hữu ích
- ✅ Tính điểm trung bình

### 7. Notifications (Thông báo) 🆕

- ✅ Thông báo đơn hàng
- ✅ Thông báo khuyến mãi
- ✅ Thông báo hệ thống
- ✅ Đếm chưa đọc
- ✅ Đánh dấu đã đọc
- ✅ Real-time updates

### 8. Addresses (Địa chỉ) 🆕

- ✅ Thêm nhiều địa chỉ
- ✅ Đặt mặc định
- ✅ Sửa/xóa địa chỉ
- ✅ Phân loại (Nhà/Công ty)
- ✅ Validation
- ✅ Chọn khi đặt hàng

### 9. Coupons (Mã giảm giá) 🆕

- ✅ Giảm % hoặc cố định
- ✅ Điều kiện tối thiểu
- ✅ Giới hạn sử dụng
- ✅ Thời gian hiệu lực
- ✅ Validate mã
- ✅ Tracking số lần dùng

### 10. Admin Panel

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

## � Bảng chức năng chi tiết

### Bảng 1: Chức năng Authentication

| Chức năng         | User | Admin | Mô tả                                |
| ----------------- | ---- | ----- | ------------------------------------ |
| Đăng ký tài khoản | ✅   | ✅    | Tạo tài khoản mới với email/password |
| Đăng nhập         | ✅   | ✅    | Xác thực với Firebase Auth           |
| Đăng xuất         | ✅   | ✅    | Thoát khỏi phiên đăng nhập           |
| Quên mật khẩu     | ✅   | ✅    | Reset password qua email             |
| Đổi mật khẩu      | ✅   | ✅    | Thay đổi password hiện tại           |
| Xem profile       | ✅   | ✅    | Thông tin tài khoản                  |
| Sửa profile       | ✅   | ✅    | Cập nhật thông tin cá nhân           |
| Phân quyền        | ✅   | ✅    | Role: customer/admin                 |

### Bảng 2: Chức năng Sản phẩm

| Chức năng         | User | Admin | Mô tả                         |
| ----------------- | ---- | ----- | ----------------------------- |
| Xem danh sách     | ✅   | ✅    | Grid view tất cả sản phẩm     |
| Xem chi tiết      | ✅   | ✅    | Thông tin đầy đủ sản phẩm     |
| Tìm kiếm          | ✅   | ✅    | Search theo tên/danh mục      |
| Lọc theo danh mục | ✅   | ✅    | 4 danh mục chính              |
| Sắp xếp           | ✅   | ✅    | Giá tăng/giảm, tên A-Z        |
| Thêm sản phẩm mới | ❌   | ✅    | CRUD - Create                 |
| Sửa sản phẩm      | ❌   | ✅    | CRUD - Update                 |
| Xóa sản phẩm      | ❌   | ✅    | CRUD - Delete                 |
| Upload ảnh        | ❌   | ✅    | Via URL hoặc Firebase Storage |

### Bảng 3: Chức năng Giỏ hàng

| Chức năng      | User | Admin | Mô tả                         |
| -------------- | ---- | ----- | ----------------------------- |
| Thêm vào giỏ   | ✅   | ✅    | Add to cart từ nhiều màn hình |
| Xem giỏ hàng   | ✅   | ✅    | Danh sách sản phẩm đã chọn    |
| Tăng số lượng  | ✅   | ✅    | Increment quantity            |
| Giảm số lượng  | ✅   | ✅    | Decrement quantity            |
| Xóa sản phẩm   | ✅   | ✅    | Remove from cart              |
| Xóa tất cả     | ✅   | ✅    | Clear cart                    |
| Tính tổng tiền | ✅   | ✅    | Auto calculate total          |
| Badge số lượng | ✅   | ✅    | Icon cart với badge           |
| Lưu giỏ hàng   | ✅   | ✅    | Provider state management     |

### Bảng 4: Chức năng UI/UX

| Chức năng         | Trạng thái | Platform | Mô tả                   |
| ----------------- | ---------- | -------- | ----------------------- |
| Material Design 3 | ✅         | All      | Theme hiện đại          |
| Responsive Layout | ✅         | All      | Tự động điều chỉnh      |
| Dark Mode         | ❌         | -        | Chưa implement          |
| Loading Indicator | ✅         | All      | Circular progress       |
| Error Handling    | ✅         | All      | Try-catch + UI feedback |
| Snackbar          | ✅         | All      | Thông báo ngắn          |
| Dialog            | ✅         | All      | Confirm actions         |
| Bottom Sheet      | ✅         | All      | Filters, options        |
| Pull to Refresh   | ✅         | Mobile   | Cập nhật dữ liệu        |
| Skeleton Loading  | ❌         | -        | Chưa có                 |
| Animation         | ✅         | All      | Page transitions        |
| Localization      | ❌         | -        | Chỉ tiếng Việt          |

### Bảng 5: Chức năng Firebase

| Service         | Status | Chức năng          | Mô tả              |
| --------------- | ------ | ------------------ | ------------------ |
| Authentication  | ✅     | Login/Register     | Email & Password   |
| Firestore       | ✅     | Database           | NoSQL real-time DB |
| Storage         | ❌     | File Upload        | Chưa implement     |
| Cloud Functions | ❌     | Backend Logic      | Chưa có            |
| Analytics       | ❌     | User Tracking      | Chưa có            |
| Crashlytics     | ❌     | Error Tracking     | Chưa có            |
| FCM             | ❌     | Push Notifications | Chưa có            |
| Remote Config   | ❌     | Feature Flags      | Chưa có            |
| Hosting         | ❌     | Web Hosting        | Chưa deploy        |

### Bảng 6: Trạng thái Development

| Module            | Hoàn thành | Testing | Bug | Note                            |
| ----------------- | ---------- | ------- | --- | ------------------------------- |
| Authentication    | 100%       | ✅      | 0   | Hoàn thiện                      |
| Product List      | 100%       | ✅      | 0   | Hoàn thiện                      |
| Product Detail    | 100%       | ✅      | 0   | Hoàn thiện                      |
| Cart              | 100%       | ✅      | 0   | Fixed CartProvider              |
| Search            | 100%       | ✅      | 0   | Hoàn thiện                      |
| Category          | 100%       | ✅      | 0   | Hoàn thiện                      |
| Admin Panel       | 100%       | ✅      | 0   | CRUD hoàn chỉnh                 |
| User Profile      | 80%        | ⚠️      | 0   | Cần thêm edit                   |
| **Wishlist**      | **100%**   | **✅**  | 0   | **MỚI - Hoàn thiện**            |
| **Categories**    | **90%**    | **✅**  | 0   | **MỚI - Models/Services done**  |
| **Reviews**       | **90%**    | **✅**  | 0   | **MỚI - Models/Services done**  |
| **Notifications** | **90%**    | **✅**  | 0   | **MỚI - Models/Providers done** |
| **Addresses**     | **90%**    | **✅**  | 0   | **MỚI - Models/Providers done** |
| **Coupons**       | **90%**    | **✅**  | 0   | **MỚI - Models/Services done**  |
| Order History     | 0%         | ❌      | -   | Chưa có                         |
| Payment           | 0%         | ❌      | -   | Chưa có                         |
| Shipping          | 0%         | ❌      | -   | Chưa có                         |

### Bảng 7: Firebase Collections

| Collection        | Status | Documents | Usage                  |
| ----------------- | ------ | --------- | ---------------------- |
| users             | ✅     | Dynamic   | User profiles & auth   |
| products          | ✅     | Dynamic   | Product catalog        |
| orders            | ✅     | Dynamic   | Order history          |
| cart              | ✅     | Dynamic   | Shopping cart items    |
| **categories**    | **✅** | Dynamic   | **Product categories** |
| **reviews**       | **✅** | Dynamic   | **Product reviews**    |
| **wishlist**      | **✅** | Dynamic   | **User wishlists**     |
| **notifications** | **✅** | Dynamic   | **User notifications** |
| **addresses**     | **✅** | Dynamic   | **Delivery addresses** |
| **coupons**       | **✅** | Dynamic   | **Discount coupons**   |
| **banners**       | **✅** | Dynamic   | **Homepage banners**   |
| **brands**        | **✅** | Dynamic   | **Product brands**     |

**Tổng cộng:** 12+ Firebase Collections hoạt động

---

## 📦 Feature Branches (GitHub Organization)

Dự án được tổ chức thành các nhánh chức năng độc lập:

| Branch                      | Chức năng                                | Status |
| --------------------------- | ---------------------------------------- | ------ |
| **main**                    | Nhánh chính (stable)                     | ✅     |
| **cart-management**         | Cart với Firebase (orders collection)    | ✅     |
| **category-management**     | CRUD Categories + Dynamic Home           | ✅     |
| **wishlist**                | Yêu thích sản phẩm                       | ✅     |
| **coupon-system**           | Mã giảm giá                              | ✅     |
| **address-management**      | Địa chỉ giao hàng                        | ✅     |
| **notification-system**     | Thông báo realtime                       | ✅     |
| **banner-brand-management** | Banner trang chủ + Brand                 | ✅     |
| **review-system**           | Đánh giá sản phẩm (model, service đã có) | ✅     |

**Workflow:**

1. Mỗi nhánh chứa 1 chức năng riêng
2. Test trên nhánh trước khi merge vào `main`
3. Commit message rõ ràng, có prefix (feat:, fix:, docs:)
4. Pull request để review code
5. Merge vào main khi stable

**Git Commands:**

```bash
# Chuyển nhánh
git checkout cart-management

# Xem tất cả nhánh
git branch -a

# Pull code mới nhất
git pull origin main

# Merge nhánh vào main (sau khi test)
git checkout main
git merge cart-management
git push origin main
```

---

## 🎯 Công nghệ Chi tiết

### Backend: Firebase

- **Authentication:** Email/Password với role-based access
- **Firestore:** NoSQL realtime database (12+ collections)
- **Firebase Storage:** Chưa dùng (dự kiến cho upload ảnh)
- **Security Rules:** Custom rules cho từng collection

### Frontend: Flutter

- **Framework:** Flutter 3.x
- **Language:** Dart 3.x
- **State Management:** Provider pattern
- **Navigation:** Named routes + onGenerateRoute
- **Architecture:** Clean architecture với Services/Providers/Models

### Services Layer

- `AuthService` - Authentication
- `ProductService` - Sản phẩm CRUD
- `CartService` - Giỏ hàng Firebase (orders collection)
- `CategoryService` - Danh mục CRUD
- `WishlistService` - Yêu thích
- `CouponService` - Mã giảm giá
- `AddressService` - Địa chỉ giao hàng
- `NotificationService` - Thông báo
- `BannerService` - Banner trang chủ
- `BrandService` - Thương hiệu
- `ReviewService` - Đánh giá (đã tạo)

### Providers

- `AuthProvider` - User state
- `CartProvider` - Cart state + Firebase sync
- `WishlistProvider` - Wishlist state
- `AddressProvider` - Address state
- `NotificationProvider` - Notification state
- `BannerProvider` - Banner state
- `BrandProvider` - Brand state

### Models

- `UserModel`, `ProductModel`, `OrderModel`, `CartItemModel`
- `CategoryModel`, `WishlistModel`, `CouponModel`
- `AddressModel`, `NotificationModel`
- `BannerModel`, `BrandModel`, `ReviewModel`

---

## 📞 Liên hệ & Hỗ trợ

**GitHub Repository:**
https://github.com/Bui-DangKhoa/-n-L-p-tr-nh-di-ng-n-ng-cao

**Email hỗ trợ:**
[Thêm email của bạn]

**Phiên bản:** 2.0.0  
**Ngày cập nhật:** November 2025  
**Thay đổi mới:** Cart Firebase integration, Dynamic Categories, Feature Branches, 12+ Collections

**Tổng cộng:** 10 Firebase Collections hoạt động

---

## �📞 Liên hệ & Hỗ trợ

**GitHub Repository:**
https://github.com/Bui-DangKhoa/-n-L-p-tr-nh-di-ng-n-ng-cao

**Email hỗ trợ:**
[Thêm email của bạn]

**Phiên bản:** 1.1.0  
**Ngày cập nhật:** November 18, 2025  
**Thay đổi mới:** Thêm 6 chức năng mới (Categories, Reviews, Wishlist, Notifications, Addresses, Coupons)

---

## 🎓 Tài liệu kỹ thuật

Xem thêm:

- [README.md](README.md) - Thông tin dự án
- [RUN_APP_GUIDE.md](RUN_APP_GUIDE.md) - Hướng dẫn chạy app

---

**© 2025 - Ứng dụng Mua Sắm**
