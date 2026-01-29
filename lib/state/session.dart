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

  /// Có user đăng ký trong máy (dùng cho logic tổng quát)
  bool get hasRegisteredAccount => _accounts.isNotEmpty;

  /// ================= INIT =================
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

  /// ================= REGISTER =================
  Future<bool> register({
    required String fullname,
    required String email,
    required String password,
    required String gender,
    required String favorite,
  }) async {
    final e = email.trim().toLowerCase();
    if (_accounts.any((a) => a.user.email.trim().toLowerCase() == e)) {
      return false; // email đã tồn tại
    }

    final user = User(
      fullname: fullname.trim(),
      email: email.trim(),
      gender: gender,
      favorite: favorite,
    );

    _accounts.add(UserAccount(user: user, password: password));
    await _persist();

    _user = user;
    _isGuest = false;

    notifyListeners();
    return true;
  }

  /// ================= LOGIN =================
  bool login({required String email, required String password}) {
    final e = email.trim().toLowerCase();
    final found = _accounts.where(
      (a) => a.user.email.trim().toLowerCase() == e,
    );

    if (found.isEmpty) return false;
    final acc = found.first;
    if (acc.password != password) return false;

    _user = acc.user;
    _isGuest = false;

    notifyListeners();
    return true;
  }

  /// ================= GUEST =================
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

  /// ================= UPDATE USER (INFO TAB) =================
  Future<void> updateUser({
    required String fullname,
    required String email,
    required String gender,
    required String favorite,
  }) async {
    if (_user == null || _isGuest) return;

    final currentEmail = _user!.email.trim().toLowerCase();
    final newEmail = email.trim().toLowerCase();

    // check email trùng user khác
    final conflict = _accounts.any(
      (a) =>
          a.user.email.trim().toLowerCase() == newEmail &&
          a.user.email.trim().toLowerCase() != currentEmail,
    );

    if (conflict) {
      throw Exception('Email đã tồn tại');
    }

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

    _accounts[idx] = UserAccount(user: newUser, password: oldAcc.password);

    await _persist();

    _user = newUser;
    notifyListeners();
  }

  /// ================= LOGOUT =================
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
