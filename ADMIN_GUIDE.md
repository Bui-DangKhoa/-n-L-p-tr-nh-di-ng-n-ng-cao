# 🔧 Hướng dẫn sử dụng Admin Panel

## 🎯 Truy cập Admin Panel

### Đăng nhập Admin

1. Mở app và đăng nhập với tài khoản admin:

   - **Email**: admin@admin.com
   - **Password**: 123456

2. Sau khi đăng nhập thành công, bạn sẽ thấy icon **Admin Panel** (⚙️) ở góc phải AppBar

### Phân quyền

- Chỉ tài khoản có `role: 'admin'` mới thấy được menu admin
- User thường sẽ không thấy icon admin panel

## 📦 Quản lý sản phẩm (Product Management)

### Truy cập danh sách sản phẩm

1. Nhấn vào icon **Admin Panel** (⚙️)
2. Chọn **"Quản lý sản phẩm"**
3. Màn hình hiển thị danh sách tất cả sản phẩm

### Tìm kiếm sản phẩm

- Sử dụng ô tìm kiếm ở đầu danh sách
- Nhập tên sản phẩm để lọc kết quả real-time
- Hỗ trợ tìm kiếm không phân biệt hoa thường

## ➕ Thêm sản phẩm mới

### Bước 1: Mở form thêm sản phẩm

- Nhấn nút **"+"** (Floating Action Button) ở góc phải màn hình

### Bước 2: Điền thông tin sản phẩm

1. **Tên sản phẩm** (_bắt buộc_)
   - Nhập tên đầy đủ của sản phẩm
2. **Mô tả** (_bắt buộc_)
   - Mô tả chi tiết về sản phẩm
   - Hỗ trợ nhiều dòng text
3. **Giá** (_bắt buộc_)
   - Nhập số tiền (VND)
   - Chỉ chấp nhận số dương
   - Hỗ trợ số thập phân (VD: 999999.99)
4. **Danh mục** (_bắt buộc_)
   - Chọn từ dropdown:
     - Điện thoại
     - Laptop
     - Máy tính bảng
     - Phụ kiện
     - Khác
5. **URL hình ảnh** (_bắt buộc_)
   - Nhập URL hợp lệ (http/https)
   - Preview ảnh sẽ hiển thị tự động
   - Nhấn icon refresh để cập nhật preview

### Bước 3: Lưu sản phẩm

- Nhấn nút **"LƯU"** ở AppBar
- Hệ thống sẽ validate form trước khi lưu
- Thông báo thành công sẽ hiển thị

## ✏️ Sửa sản phẩm

### Bước 1: Chọn sản phẩm cần sửa

- Trong danh sách sản phẩm, nhấn icon **"⋮"** (menu popup)
- Chọn **"Sửa"** (icon ✏️)

### Bước 2: Chỉnh sửa thông tin

- Form sẽ mở với thông tin hiện tại đã điền sẵn
- Chỉnh sửa các field cần thiết
- Validation sẽ kiểm tra tính hợp lệ

### Bước 3: Cập nhật

- Nhấn **"CẬP NHẬT SẢN PHẨM"**
- Thông báo thành công sẽ hiển thị

## 🗑️ Xóa sản phẩm

### Bước 1: Chọn sản phẩm cần xóa

- Nhấn icon **"⋮"** (menu popup)
- Chọn **"Xóa"** (icon 🗑️)

### Bước 2: Xác nhận xóa

- Dialog xác nhận sẽ hiển thị
- Nhấn **"Xóa"** để confirm
- **Lưu ý**: Thao tác này không thể hoàn tác

## 🎨 Giao diện Admin Panel

### Features của Product Management Screen:

- **Header**: Title + Search bar
- **Floating Action Button**: Thêm sản phẩm mới
- **Product List**:
  - Card layout với hình ảnh
  - Thông tin: tên, giá, danh mục
  - Popup menu cho edit/delete
- **Loading States**: Circular progress khi loading
- **Error Handling**: SnackBar thông báo lỗi

### Features của Add/Edit Product Screen:

- **AppBar**: Title động + nút Save
- **Image Preview**: Hiển thị ảnh khi nhập URL
- **Form Validation**: Real-time validation
- **Category Dropdown**: Easy selection
- **Loading Button**: Disable khi đang save

## 📝 Tips sử dụng

### Hình ảnh sản phẩm:

- Sử dụng URL từ Unsplash cho chất lượng tốt
- Format: `https://images.unsplash.com/photo-...`
- Kiểm tra preview trước khi lưu

### Best Practices:

1. **Tên sản phẩm**: Rõ ràng, có thương hiệu và model
2. **Mô tả**: Chi tiết specs, tính năng nổi bật
3. **Giá**: Cập nhật theo thị trường
4. **Danh mục**: Chọn đúng để customer dễ tìm

### Keyboard Shortcuts:

- **Ctrl+S**: Lưu form (khi focus trên form)
- **Esc**: Đóng dialog/form
- **Enter**: Submit form khi validation pass

## 🚨 Lưu ý quan trọng

### Quyền hạn:

- Chỉ admin mới có thể CRUD products
- Customer không thể truy cập admin routes
- Kiểm tra role được thực hiện ở cả frontend và backend

### Data Safety:

- Xóa sản phẩm là hard delete (permanent)
- Không có trash/recycle bin
- Backup dữ liệu trước khi xóa nhiều

### Performance:

- Danh sách sản phẩm load real-time từ Firestore
- Search được optimize với debounce
- Image loading có fallback error handling

---

💡 **Tip**: Nếu gặp lỗi, check Firebase Debug Screen ở menu Account để troubleshoot connectivity issues.
