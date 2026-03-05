# 📱 BaiTapLTDDNC_TH

Ứng dụng Flutter phục vụ môn **Lập trình thiết bị di động nâng cao - Thực hành**.

Project hiện tại gồm đầy đủ các phần:
- Đăng nhập/đăng ký, quản lý session local và chỉnh sửa thông tin người dùng
- Hiển thị sản phẩm theo **List / Grid / Table** từ dữ liệu JSON (async/await)
- CRUD **Categories / Products** với **Firebase Firestore** (realtime)
- Home Dashboard mới, hiển thị các sản phẩm đã tạo từ Firebase

---

## 👨‍🎓 Thông tin sinh viên

- **Họ tên**: Lê Hoàng Nam
- **MSSV**: 23DH114467
- **Môn học**: Lập trình thiết bị di động nâng cao - Thực hành

---

## ✨ Tính năng chính 

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

### 5) Sản phẩm từ JSON (Tuần 05 - async/await)
- Đọc dữ liệu từ file JSON trong assets bằng `Future` + `async/await`
- Hiển thị dữ liệu ở 3 màn hình:
  - `lib/page/product_list_screen.dart`
  - `lib/page/product_grid_screen.dart`
  - `lib/page/product_table_screen.dart`
- Tách lớp lấy dữ liệu:
  - `lib/getdata/category_data.dart`
  - `lib/getdata/product_data.dart`

### 6) Firebase Firestore CRUD (Tuần 07)
- CRUD danh mục: `lib/page/firebase_category_manager_screen.dart`
- CRUD sản phẩm: `lib/page/firebase_product_manager_screen.dart`
- Màn hình hiển thị sản phẩm Firebase:
  - `lib/page/firebase_product_list_screen.dart`
- Realtime update sau khi thêm/sửa/xóa
- Xử lý thao tác Firestore tập trung tại:
  - `lib/data/firebase_helper.dart`

### 7) Home Dashboard mới
- Trang Home được thiết kế lại theo dạng dashboard
- Hiển thị danh sách sản phẩm mới nhất từ Firebase
- File: `lib/page/home_dashboard.dart`

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
├── config/
│   └── default.dart
├── data/
│   ├── app_data_info.dart
│   └── firebase_helper.dart
├── getdata/
│   ├── category_data.dart
│   └── product_data.dart
├── model/
│   ├── category.dart
│   ├── product.dart
│   ├── user.dart
│   ├── user_account.dart
│   └── user_profile.dart
├── page/
│   ├── defaultwidget.dart
│   ├── detail.dart
│   ├── firebase_category_manager_screen.dart
│   ├── firebase_product_list_screen.dart
│   ├── firebase_product_manager_screen.dart
│   ├── home_dashboard.dart
│   ├── info_tab.dart
│   ├── login.dart
│   ├── product_grid_screen.dart
│   ├── product_list_screen.dart
│   ├── product_table_screen.dart
│   └── register.dart
└── state/
    └── session.dart
```

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

