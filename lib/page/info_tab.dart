import 'package:flutter/material.dart';
import '../state/session.dart';

class InfoTab extends StatefulWidget {
  const InfoTab({super.key});

  @override
  State<InfoTab> createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtl = TextEditingController();
  final _emailCtl = TextEditingController();

  int _gender = 0; // 0 Male, 1 Female, 2 Other
  bool _music = false;
  bool _movie = false;
  bool _book = false;

  @override
  void dispose() {
    _nameCtl.dispose();
    _emailCtl.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final session = SessionScope.of(context);
    final user = session.user;

    if (user != null) {
      _nameCtl.text = user.fullname;
      _emailCtl.text = user.email;

      _gender = (user.gender == 'Female')
          ? 1
          : (user.gender == 'Other')
          ? 2
          : 0;

      final fav = user.favorite;
      _music = fav.contains('Music');
      _movie = fav.contains('Movie');
      _book = fav.contains('Book');
      setState(() {});
    }
  }

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

  String? _required(String? v, String label) {
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

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final session = SessionScope.of(context);
    session.updateUser(
      fullname: _nameCtl.text.trim(),
      email: _emailCtl.text.trim(),
      gender: _genderText(),
      favorite: _favoriteText(),
    );

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật thông tin!')));
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    if (user == null) {
      return const Center(child: Text('Bạn chưa đăng ký/đăng nhập.'));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(18),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thông tin',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _nameCtl,
              validator: (v) => _required(v, 'họ và tên'),
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.person),
                hintText: 'Họ và tên',
              ),
            ),
            const SizedBox(height: 12),

            TextFormField(
              controller: _emailCtl,
              validator: _validateEmail,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.email),
                hintText: 'Email',
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              'Giới tính',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Male'),
                    value: 0,
                    groupValue: _gender,
                    onChanged: (v) => setState(() => _gender = v ?? 0),
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Female'),
                    value: 1,
                    groupValue: _gender,
                    onChanged: (v) => setState(() => _gender = v ?? 1),
                  ),
                ),
                Expanded(
                  child: RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Other'),
                    value: 2,
                    groupValue: _gender,
                    onChanged: (v) => setState(() => _gender = v ?? 2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            const Text(
              'Sở thích',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Music'),
              value: _music,
              onChanged: (v) => setState(() => _music = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Movie'),
              value: _movie,
              onChanged: (v) => setState(() => _movie = v ?? false),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Book'),
              value: _book,
              onChanged: (v) => setState(() => _book = v ?? false),
            ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text(
                  'LƯU THAY ĐỔI',
                  style: TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
