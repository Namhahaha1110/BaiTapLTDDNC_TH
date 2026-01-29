import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user.dart';
import '../model/user_account.dart';

class Session extends ChangeNotifier {
  static const _kAccountsKey = 'accounts_v1';

  User? _user;
  bool _isGuest = false;

  User? get user => _user;
  bool get isGuest => _isGuest;

  final List<UserAccount> _accounts = [];
  List<UserAccount> get accounts => List.unmodifiable(_accounts);

  bool get hasRegisteredAccount => _accounts.isNotEmpty;

  /// ✅ avatar của user đang login (null nếu guest hoặc chưa có)
  String? get avatarPath {
    if (_user == null || _isGuest) return null;
    final e = _user!.email.trim().toLowerCase();
    final idx = _accounts.indexWhere(
      (a) => a.user.email.trim().toLowerCase() == e,
    );
    if (idx == -1) return null;
    return _accounts[idx].avatarPath;
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kAccountsKey);
    if (raw == null || raw.isEmpty) return;

    final list = (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    _accounts
      ..clear()
      ..addAll(list.map(UserAccount.fromJson));

    notifyListeners();
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(_accounts.map((e) => e.toJson()).toList());
    await prefs.setString(_kAccountsKey, raw);
  }

  Future<bool> register({
    required String fullname,
    required String email,
    required String password,
    required String gender,
    required String favorite,
    String? avatarPath, // ✅ mới
  }) async {
    final e = email.trim().toLowerCase();
    if (_accounts.any((a) => a.user.email.trim().toLowerCase() == e))
      return false;

    final user = User(
      fullname: fullname.trim(),
      email: email.trim(),
      gender: gender,
      favorite: favorite,
    );

    _accounts.add(
      UserAccount(user: user, password: password, avatarPath: avatarPath),
    );
    await _persist();

    _user = user;
    _isGuest = false;
    notifyListeners();
    return true;
  }

  bool login({required String email, required String password}) {
    final e = email.trim().toLowerCase();
    final found = _accounts
        .where((a) => a.user.email.trim().toLowerCase() == e)
        .toList();
    if (found.isEmpty) return false;

    final acc = found.first;
    if (acc.password != password) return false;

    _user = acc.user;
    _isGuest = false;
    notifyListeners();
    return true;
  }

  void guestLogin() {
    _user = const User(
      fullname: 'Guest',
      email: 'guest@demo.local',
      gender: 'Other',
      favorite: 'None',
    );
    _isGuest = true;
    notifyListeners();
  }

  Future<void> updateUser({
    required String fullname,
    required String email,
    required String gender,
    required String favorite,
  }) async {
    if (_user == null || _isGuest) return;

    final currentEmail = _user!.email.trim().toLowerCase();
    final newEmail = email.trim().toLowerCase();

    final conflict = _accounts.any(
      (a) =>
          a.user.email.trim().toLowerCase() == newEmail &&
          a.user.email.trim().toLowerCase() != currentEmail,
    );
    if (conflict) throw Exception('Email đã tồn tại');

    final idx = _accounts.indexWhere(
      (a) => a.user.email.trim().toLowerCase() == currentEmail,
    );
    if (idx == -1) return;

    final oldAcc = _accounts[idx];

    final newUser = User(
      fullname: fullname.trim(),
      email: email.trim(),
      gender: gender,
      favorite: favorite,
    );

    _accounts[idx] = oldAcc.copyWith(user: newUser);
    await _persist();

    _user = newUser;
    notifyListeners();
  }

  /// ✅ cập nhật avatar cho user đang đăng nhập
  Future<void> updateAvatar(String? newPath) async {
    if (_user == null || _isGuest) return;

    final e = _user!.email.trim().toLowerCase();
    final idx = _accounts.indexWhere(
      (a) => a.user.email.trim().toLowerCase() == e,
    );
    if (idx == -1) return;

    final oldAcc = _accounts[idx];
    _accounts[idx] = oldAcc.copyWith(avatarPath: newPath);
    await _persist();
    notifyListeners();
  }

  void logout() {
    _user = null;
    _isGuest = false;
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
