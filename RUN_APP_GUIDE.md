# Hướng dẫn chạy app trên các platform

## 🚀 Cách chạy ứng dụng

### 1️⃣ Android Emulator

**Cách 1: Dùng script tự động**

```bash
run_android.bat
```

**Cách 2: Thủ công**

```bash
# Xem danh sách emulator
flutter emulators

# Khởi động emulator
flutter emulators --launch Medium_Phone

# Đợi emulator khởi động xong (30-60 giây), sau đó chạy:
flutter run -d android
```

### 2️⃣ Windows Desktop

**Cách 1: Dùng script**

```bash
run_windows.bat
```

**Cách 2: Thủ công**

```bash
flutter run -d windows
```

### 3️⃣ Web Browser

**Cách 1: Dùng script**

```bash
run_web.bat
```

**Cách 2: Thủ công**

```bash
# Chrome
flutter run -d chrome

# Edge
flutter run -d edge
```

## 📱 Kiểm tra devices có sẵn

```bash
flutter devices
```

## 🔧 Troubleshooting

### Lỗi: No devices found

```bash
# Kiểm tra Flutter doctor
flutter doctor

# Kiểm tra Android SDK
flutter doctor --android-licenses
```

### Emulator không khởi động

```bash
# Xem chi tiết lỗi
flutter emulators -v

# Tạo emulator mới
flutter emulators --create
```

### Windows build lỗi

```bash
# Clean và rebuild
flutter clean
flutter pub get
flutter run -d windows
```

## 💡 Tips

- **Android**: Lần đầu build có thể mất 3-5 phút
- **Windows**: Lần đầu build có thể mất 2-3 phút
- **Web**: Build nhanh nhất, chỉ 30-60 giây
- Sau lần build đầu, các lần sau sẽ nhanh hơn nhiều (hot reload)

## 🎯 Chạy trên device cụ thể

```bash
# Xem device IDs
flutter devices

# Chạy trên device cụ thể
flutter run -d <device_id>
```
