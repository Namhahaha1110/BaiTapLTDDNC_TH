import 'package:flutter/material.dart';
import '../model/user.dart';

class Session extends ChangeNotifier {
  User? _user;

  // Lưu thông tin đăng ký (demo local, trong RAM)
  String? _registeredEmail;
  String? _registeredPassword;

  String? _registeredFullname;
  String? _registeredGender;
  String? _registeredFavorite;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get hasRegisteredAccount => _registeredEmail != null;

  /// Đăng ký → lưu toàn bộ data + tạo user
  void register({
    required String fullname,
    required String email,
    required String password,
    required String gender,
    required String favorite,
  }) {
    _registeredFullname = fullname;
    _registeredEmail = email;
    _registeredPassword = password;
    _registeredGender = gender;
    _registeredFavorite = favorite;

    _user = User(
      fullname: fullname,
      email: email,
      gender: gender,
      favorite: favorite,
    );

    notifyListeners();
  }

  /// Login → nếu đúng email/password thì dựng lại User từ data đã lưu
  bool login({required String email, required String password}) {
    if (_registeredEmail == null || _registeredPassword == null) return false;

    final ok = email == _registeredEmail && password == _registeredPassword;
    if (!ok) return false;

    // rebuild user (vì logout đã set _user = null)
    _user = User(
      fullname: _registeredFullname ?? 'User',
      email: _registeredEmail!,
      gender: _registeredGender ?? 'Other',
      favorite: _registeredFavorite ?? 'None',
    );

    notifyListeners();
    return true;
  }

  void guestLogin() {
    // chỉ tạo 1 user "guest" để không bị Guest/— trống
    _user = const User(
      fullname: 'Guest',
      email: 'guest@demo.local',
      gender: 'Other',
      favorite: 'None',
    );
    notifyListeners();
  }

  /// Cập nhật thông tin từ tab Info (đồng thời update account đã đăng ký)
  void updateUser({
    required String fullname,
    required String email,
    required String gender,
    required String favorite,
  }) {
    if (_registeredEmail == null) return; // chưa từng đăng ký

    _registeredFullname = fullname;
    _registeredEmail = email;
    _registeredGender = gender;
    _registeredFavorite = favorite;

    // nếu đang login thì cập nhật luôn user đang hiển thị
    if (_user != null) {
      _user = User(
        fullname: fullname,
        email: email,
        gender: gender,
        favorite: favorite,
      );
    }

    notifyListeners();
  }

  /// Logout: chỉ thoát phiên (không xoá thông tin đăng ký)
  void logout() {
    _user = null;
    notifyListeners();
  }

  /// (Tuỳ chọn) Nếu bạn muốn xoá hẳn tài khoản đã đăng ký
  void clearRegisteredAccount() {
    _user = null;
    _registeredEmail = null;
    _registeredPassword = null;
    _registeredFullname = null;
    _registeredGender = null;
    _registeredFavorite = null;
    notifyListeners();
  }
}

class SessionScope extends InheritedNotifier<Session> {
  const SessionScope({
    super.key,
    required Session notifier,
    required Widget child,
  }) : super(notifier: notifier, child: child);

  static Session of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<SessionScope>();
    if (scope == null || scope.notifier == null) {
      throw Exception('SessionScope not found');
    }
    return scope.notifier!;
  }
}
