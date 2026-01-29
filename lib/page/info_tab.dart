import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final session = SessionScope.of(context);

    try {
      await session.updateUser(
        fullname: _nameCtl.text.trim(),
        email: _emailCtl.text.trim(),
        gender: _genderText(),
        favorite: _favoriteText(),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã cập nhật thông tin!')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi: $e')));
    }
  }

  Future<void> _pickAvatar() async {
    final session = SessionScope.of(context);

    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    if (xfile == null) return;

    await session.updateAvatar(xfile.path);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã cập nhật avatar!')));
  }

  Future<void> _removeAvatar() async {
    final session = SessionScope.of(context);
    await session.updateAvatar(null);

    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Đã xoá avatar!')));
  }

  @override
  Widget build(BuildContext context) {
    final session = SessionScope.of(context);
    final user = session.user;

    if (user == null || session.isGuest) {
      return const Center(child: Text('Bạn chưa đăng nhập bằng tài khoản.'));
    }

    final avatarPath = session.avatarPath;

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

            // ===== AVATAR ROW =====
            Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundImage: (avatarPath != null)
                      ? FileImage(File(avatarPath))
                      : null,
                  child: (avatarPath == null)
                      ? const Icon(Icons.person, size: 32)
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickAvatar,
                    icon: const Icon(Icons.photo),
                    label: const Text('Chọn / Đổi avatar'),
                  ),
                ),
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: _removeAvatar,
                  child: const Text('Xóa'),
                ),
              ],
            ),

            const SizedBox(height: 16),

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
            const SizedBox(height: 8),

            Wrap(
              alignment: WrapAlignment.center,
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

            const SizedBox(height: 16),

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

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text(
                  'LƯU THAY ĐỔI',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
