import 'package:flutter/material.dart';
import '../state/session.dart';
import '../mainpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _hidePass = true;
  bool _hideRePass = true;

  /// Gender: 0 = Male, 1 = Female, 2 = Other
  int _gender = 0;

  /// Favorite
  bool _music = false;
  bool _movie = false;
  bool _book = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  // ================= VALIDATION =================

  String? _required(String? v, String label) {
    if ((v ?? '').trim().isEmpty) {
      return 'Vui lòng nhập $label';
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập email';
    final ok = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value);
    if (!ok) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String? _validateConfirm(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (value != _passwordController.text.trim()) {
      return 'Mật khẩu xác nhận không khớp';
    }
    return null;
  }

  // ================= DATA HELPER =================

  String _genderText() {
    if (_gender == 0) return 'Male';
    if (_gender == 1) return 'Female';
    return 'Other';
  }

  String _favoriteText() {
    final list = <String>[];
    if (_music) list.add('Music');
    if (_movie) list.add('Movie');
    if (_book) list.add('Book');
    return list.isEmpty ? 'None' : list.join(', ');
  }

  // ================= REGISTER =================

  Future<void> _register() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final session = SessionScope.of(context);

    final ok = await session.register(
      fullname: _nameController.text.trim(),
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      gender: _genderText(),
      favorite: _favoriteText(),
    );

    if (!ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email đã tồn tại, hãy dùng email khác!')),
      );
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const Mainpage()),
      (_) => false,
    );
  }

  // ================= UI =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Đăng ký')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                // ===== FULL NAME =====
                TextFormField(
                  controller: _nameController,
                  validator: (v) => _required(v, 'họ và tên'),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.person),
                    hintText: 'Họ và tên',
                  ),
                ),
                const SizedBox(height: 12),

                // ===== EMAIL =====
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _validateEmail,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email',
                  ),
                ),
                const SizedBox(height: 12),

                // ===== PASSWORD =====
                TextFormField(
                  controller: _passwordController,
                  obscureText: _hidePass,
                  validator: _validatePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    hintText: 'Mật khẩu',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hidePass ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _hidePass = !_hidePass),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // ===== CONFIRM PASSWORD =====
                TextFormField(
                  controller: _confirmController,
                  obscureText: _hideRePass,
                  validator: _validateConfirm,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock_outline),
                    hintText: 'Xác nhận mật khẩu',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _hideRePass ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () =>
                          setState(() => _hideRePass = !_hideRePass),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== GENDER =====
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Giới tính',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: [
                          ChoiceChip(
                            label: const Text('Male'),
                            selected: _gender == 0,
                            onSelected: (_) => setState(() => _gender = 0),
                          ),
                          ChoiceChip(
                            label: const Text('Female'),
                            selected: _gender == 1,
                            onSelected: (_) => setState(() => _gender = 1),
                          ),
                          ChoiceChip(
                            label: const Text('Other'),
                            selected: _gender == 2,
                            onSelected: (_) => setState(() => _gender = 2),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ===== FAVORITE =====
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Sở thích',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      CheckboxListTile(
                        title: const Text('Music'),
                        value: _music,
                        onChanged: (v) => setState(() => _music = v ?? false),
                      ),
                      CheckboxListTile(
                        title: const Text('Movie'),
                        value: _movie,
                        onChanged: (v) => setState(() => _movie = v ?? false),
                      ),
                      CheckboxListTile(
                        title: const Text('Book'),
                        value: _book,
                        onChanged: (v) => setState(() => _book = v ?? false),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 22),

                // ===== BUTTON REGISTER =====
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _register,
                    child: const Text(
                      'ĐĂNG KÝ',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
