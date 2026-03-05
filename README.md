# 📱 BaiTapLTDDNC_TH

Ứng dụng Flutter phục vụ môn **Lập trình thiết bị di động nâng cao - Thực hành**.

Project hiện tại đã được mở rộng từ các màn hình Welcome/Login/Register ban đầu sang luồng **đăng nhập/đăng ký có lưu nhiều tài khoản**, có **Guest mode**, có **màn hình chỉnh sửa thông tin**, và **chọn avatar từ thư viện ảnh**.

---

## 👨‍🎓 Thông tin sinh viên

- **Họ tên**: Lê Hoàng Nam
- **MSSV**: 23DH114467
- **Môn học**: Lập trình thiết bị di động nâng cao - Thực hành

---

## ✨ Tính năng chính (theo code hiện tại)

### 1) Authentication (Login / Register)
- **Đăng ký** (`lib/page/register.dart`)
  - Nhập: Fullname, Email, Password, Confirm Password
  - Chọn **Gender** (Male/Female/Other)
  - Chọn **Favorite** (Music/Movie/Book) (có thể chọn nhiều)
  - Validate dữ liệu (email đúng định dạng, password >= 6, confirm khớp, ...)
  - Lưu account vào bộ nhớ cục bộ (SharedPreferences)

- **Đăng nhập** (`lib/page/login.dart`)
  - Đăng nhập bằng **Email + Password**
  - Có **Guest login** (vào app mà không cần đăng ký)

### 2) Lưu nhiều user + quản lý session
- Lưu danh sách account (nhiều user) bằng `SharedPreferences`
- Session/state tập trung trong:
  - `lib/state/session.dart`
  - Model:
    - `lib/model/user.dart`
    - `lib/model/user_account.dart`

### 3) Mainpage + Drawer + BottomNavigation
- `lib/mainpage.dart`
- Có Drawer hiển thị:
  - Tên, email user hiện tại
  - Avatar (nếu có)
- BottomNavigation gồm các tab:
  - Home
  - Contact
  - Info (khi đã đăng nhập) hoặc Register (khi guest / chưa có user hợp lệ)

### 4) Cập nhật thông tin & chọn Avatar
- Tab **Info**: `lib/page/info_tab.dart`
  - Cho phép cập nhật fullname/email/gender/favorite
  - Cho phép chọn **avatar từ Gallery** (image_picker)
  - Avatar được lưu theo account (qua `avatarPath`)

---

## 🛠️ Công nghệ sử dụng

- **Framework**: Flutter
- **Ngôn ngữ**: Dart
- Lưu dữ liệu local: `shared_preferences`
- Chọn ảnh: `image_picker`

---

## 📁 Cấu trúc thư mục (cập nhật)

```txt
lib/
├── main.dart
├── mainpage.dart
├── model/
│   ├── user.dart
│   └── user_account.dart
├── page/
│   ├── defaultwidget.dart
│   ├── detail.dart
│   ├── info_tab.dart
│   ├── login.dart
│   └── register.dart
└── state/
    └── session.dart
```

> Ghi chú: README cũ đang ghi `lib/screen/...` và `welcome.dart` nhưng code hiện tại dùng `lib/page/...` và app khởi động vào `LoginPage`.

---

## 🔄 Luồng hoạt động (high-level)

```txt
App start
  ↓
LoginPage
  ├─ Login thành công → Mainpage (Home/Contact/Info)
  └─ Guest login      → Mainpage (Home/Contact/Register)
```

---

## 🚀 Cài đặt và chạy

### Yêu cầu
- Flutter SDK
- Android Studio / VS Code (Flutter extension)

### Chạy dự án
```bash
git clone https://github.com/Namhahaha1110/BaiTapLTDDNC_TH.git
cd BaiTapLTDDNC_TH
flutter pub get
flutter run
```

---

## 📝 Ghi chú
- Đây là dự án học tập, chưa có backend.
- Dữ liệu tài khoản được lưu local bằng SharedPreferences (phù hợp demo / bài tập).
