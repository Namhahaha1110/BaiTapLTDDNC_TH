import 'package:flutter/material.dart';
import 'info.dart';

enum Gender { nam, nu, khac }

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();
  final _phoneCtl = TextEditingController();
  final _passCtl = TextEditingController();
  final _repassCtl = TextEditingController();
  final _imgUrlCtl = TextEditingController();

  bool _hidePass = true;
  bool _hideRePass = true;

  Gender _gender = Gender.nam;
  bool _hMusic = false;
  bool _hMovie = false;
  bool _hBook = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    _phoneCtl.dispose();
    _passCtl.dispose();
    _repassCtl.dispose();
    _imgUrlCtl.dispose();
    super.dispose();
  }

  String? _validateRequired(String? v, String label) {
    if ((v ?? '').trim().isEmpty) return 'Vui lòng nhập $label';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập email';
    final ok = RegExp(r'^[\w\.-]+@[\w\.-]+\.\w+$').hasMatch(value);
    if (!ok) return 'Email không hợp lệ';
    return null;
  }

  String? _validatePhone(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập số điện thoại';
    final ok = RegExp(r'^\d{9,11}$').hasMatch(value);
    if (!ok) return 'Số điện thoại phải 9-11 chữ số';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng nhập mật khẩu';
    if (value.length < 6) return 'Mật khẩu tối thiểu 6 ký tự';
    return null;
  }

  String? _validateRePassword(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Vui lòng xác nhận mật khẩu';
    if (value != _passCtl.text.trim()) return 'Mật khẩu xác nhận không khớp';
    return null;
  }

  String _genderText(Gender g) {
    switch (g) {
      case Gender.nam:
        return 'Nam';
      case Gender.nu:
        return 'Nữ';
      case Gender.khac:
        return 'Khác';
    }
  }

  List<String> _hobbyList() {
    final list = <String>[];
    if (_hMusic) list.add('Âm nhạc');
    if (_hMovie) list.add('Phim ảnh');
    if (_hBook) list.add('Sách');
    return list;
  }

  void _submit() {
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Info(
          fullName: _nameCtl.text.trim(),
          email: _emailCtl.text.trim(),
          phone: _phoneCtl.text.trim(),
          gender: _genderText(_gender),
          hobbies: _hobbyList(),
          imageUrl: _imgUrlCtl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 6),
              const Text(
                'ĐĂNG KÝ TÀI KHOẢN',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF2196F3),
                ),
              ),
              const SizedBox(height: 18),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _nameCtl,
                      validator: (v) => _validateRequired(v, 'họ và tên'),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        hintText: 'Họ và tên',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtl,
                      keyboardType: TextInputType.emailAddress,
                      validator: _validateEmail,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.email),
                        hintText: 'Email',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtl,
                      keyboardType: TextInputType.phone,
                      validator: _validatePhone,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.phone),
                        hintText: 'Số điện thoại',
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _passCtl,
                      obscureText: _hidePass,
                      validator: _validatePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        hintText: 'Mật khẩu',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hidePass = !_hidePass),
                          icon: Icon(
                            _hidePass ? Icons.visibility_off : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _repassCtl,
                      obscureText: _hideRePass,
                      validator: _validateRePassword,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock_outline),
                        hintText: 'Xác nhận mật khẩu',
                        suffixIcon: IconButton(
                          onPressed: () =>
                              setState(() => _hideRePass = !_hideRePass),
                          icon: Icon(
                            _hideRePass
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _imgUrlCtl,
                      validator: (v) => _validateRequired(v, 'URL hình ảnh'),
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.image),
                        hintText: 'URL hình ảnh',
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Giới tính
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<Gender>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Nam'),
                                  value: Gender.nam,
                                  groupValue: _gender,
                                  onChanged: (v) =>
                                      setState(() => _gender = v ?? Gender.nam),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<Gender>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Nữ'),
                                  value: Gender.nu,
                                  groupValue: _gender,
                                  onChanged: (v) =>
                                      setState(() => _gender = v ?? Gender.nu),
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<Gender>(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Khác'),
                                  value: Gender.khac,
                                  groupValue: _gender,
                                  onChanged: (v) => setState(
                                    () => _gender = v ?? Gender.khac,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Sở thích
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
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
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Âm nhạc'),
                                  value: _hMusic,
                                  onChanged: (v) =>
                                      setState(() => _hMusic = v ?? false),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Phim ảnh'),
                                  value: _hMovie,
                                  onChanged: (v) =>
                                      setState(() => _hMovie = v ?? false),
                                ),
                              ),
                              Expanded(
                                child: CheckboxListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: const Text('Sách'),
                                  value: _hBook,
                                  onChanged: (v) =>
                                      setState(() => _hBook = v ?? false),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF5A5F),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _submit,
                              icon: const Icon(Icons.save),
                              label: const Text(
                                'ĐĂNG KÝ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFFFF5A5F),
                                side: const BorderSide(
                                  color: Color(0xFFFF5A5F),
                                  width: 2,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.logout),
                              label: const Text(
                                'Thoát',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Đã có tài khoản?  ',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Text(
                            'Đăng nhập',
                            style: TextStyle(
                              color: Color(0xFF2196F3),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
