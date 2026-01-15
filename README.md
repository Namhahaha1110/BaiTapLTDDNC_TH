# 📱 BaiTapLTDDNC_TH

Ứng dụng Flutter demo với các màn hình Welcome, Login và Register cho môn **Lập trình thiết bị di động nâng cao - Thực hành**. 

## 📝 Mô tả

Đây là bài tập thực hành tuần 1 (Tuan_01) xây dựng giao diện người dùng cơ bản với Flutter, bao gồm: 
- Màn hình Welcome giới thiệu
- Màn hình Login với xác thực form
- Màn hình Register với validation đầy đủ

## 👨‍🎓 Thông tin sinh viên

- **Họ tên**: Lê Hoàng Nam
- **MSSV**: 23DH114467
- **Môn học**: Lập trình thiết bị di động nâng cao - Thực hành

## ✨ Tính năng

### 1. Màn hình Welcome (`welcome. dart`)
- Hiển thị ảnh chào mừng
- Thông tin sinh viên
- Nút "Continue" để chuyển sang màn hình Login

### 2. Màn hình Login (`login.dart`)
- Form đăng nhập với validation: 
  - Username: Không được để trống
  - Password:  Tối thiểu 6 ký tự
- Checkbox "Remember me"
- Link "Forgot Password"
- Link chuyển sang màn hình Register
- Hiển thị thông báo khi đăng nhập thành công

### 3. Màn hình Register (`register.dart`)
- Form đăng ký với validation đầy đủ:
  - Username: Tối thiểu 3 ký tự
  - Email: Phải có định dạng hợp lệ (@, .)
  - Password: Tối thiểu 6 ký tự, có nút hiện/ẩn mật khẩu
  - Confirm Password: Phải khớp với mật khẩu
- Checkbox đồng ý điều khoản
- Nút "CREATE ACCOUNT"
- Link "Back to Login"

## 🛠️ Công nghệ sử dụng

- **Framework**: Flutter
- **Ngôn ngữ**: Dart
- **SDK**: ^3.10.7
- **Dependencies**:
  - `flutter` (SDK)
  - `cupertino_icons:  ^1.0.8`

## 📁 Cấu trúc thư mục

```
lib/
├── main.dart              # Entry point của ứng dụng
└── screen/
    ├── welcome. dart       # Màn hình Welcome
    ├── login.dart         # Màn hình Login
    └── register.dart      # Màn hình Register
assets/
└── images/                # Thư mục chứa hình ảnh
```

## 🚀 Cài đặt và Chạy

### Yêu cầu
- Flutter SDK (phiên bản ^3.10.7 trở lên)
- Dart SDK
- Android Studio / VS Code với Flutter extension
- Thiết bị Android/iOS hoặc Emulator

### Các bước cài đặt

1. **Clone repository**
```bash
git clone https://github.com/Namhahaha1110/BaiTapLTDDNC_TH.git
cd BaiTapLTDDNC_TH
```

2. **Cài đặt dependencies**
```bash
flutter pub get
```

3. **Chạy ứng dụng**
```bash
flutter run
```

### Chạy trên các nền tảng khác nhau

```bash
# Android
flutter run -d android

# iOS (chỉ trên macOS)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# Linux
flutter run -d linux

# macOS
flutter run -d macos
```

## 🔄 Luồng điều hướng

```
Welcome Screen
    ↓
  [Continue]
    ↓
Login Screen ←──┐
    ↓           │
  [Register]    │
    ↓           │
Register Screen │
    ↓           │
[Back to Login]─┘
```

## ⚙️ Chi tiết kỹ thuật

### Validation Rules

**Login:**
- Username: Không để trống
- Password: Không để trống, tối thiểu 6 ký tự

**Register:**
- Username:  Không để trống, tối thiểu 3 ký tự
- Email:  Không để trống, phải chứa @ và . 
- Password: Không để trống, tối thiểu 6 ký tự
- Confirm Password: Phải khớp với password
- Terms Agreement: Phải đồng ý điều khoản

### State Management
- Sử dụng `StatefulWidget` cho các màn hình có tương tác
- `TextEditingController` để quản lý input
- `GlobalKey<FormState>` để validate form

## 📝 Ghi chú

- Đây là ứng dụng demo, chưa có backend thật
- Chức năng đăng nhập/đăng ký chỉ hiển thị SnackBar thông báo
- Một số hình ảnh sử dụng network image (có thể thay bằng local assets)

## 🔮 Phát triển tương lai

- [ ] Tích hợp backend API
- [ ] Lưu trữ thông tin người dùng với SQLite/SharedPreferences
- [ ] Thêm chức năng Forgot Password
- [ ] Xác thực email
- [ ] Login với Google/Facebook
- [ ] Dark mode support
- [ ] Đa ngôn ngữ (i18n)

## 👨‍💻 Tác giả

**Lê Hoàng Nam** - [Namhahaha1110](https://github.com/Namhahaha1110)

## 📄 License

Dự án này được phát triển cho mục đích học tập. 

## 🤝 Đóng góp

Mọi đóng góp đều được chào đón!  Nếu bạn muốn cải thiện dự án: 
1. Fork repository
2. Tạo branch mới (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Mở Pull Request

## 📞 Liên hệ

Nếu có thắc mắc về dự án, vui lòng tạo issue trên GitHub. 

---

**Note**:  Đây là bài tập thực hành môn Lập trình thiết bị di động nâng cao - Thực hành