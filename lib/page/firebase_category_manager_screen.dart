import 'package:flutter/material.dart';
import 'dart:async';

import '../data/firebase_helper.dart';

class FirebaseCategoryManagerScreen extends StatefulWidget {
  const FirebaseCategoryManagerScreen({super.key});

  @override
  State<FirebaseCategoryManagerScreen> createState() =>
      _FirebaseCategoryManagerScreenState();
}

class _FirebaseCategoryManagerScreenState
    extends State<FirebaseCategoryManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  final FirebaseHelper _helper = FirebaseHelper();

  String? _editingId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  StreamSubscription<List<Map<String, dynamic>>>? _categoriesSub;

  @override
  void initState() {
    super.initState();
    _categoriesSub = _helper.getCategoriesStream().listen((data) {
      if (!mounted) return;
      setState(() {
        _categories = data;
        _isLoading = false;
      });
    });
  }

  Future<void> _saveCategory() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = {
      'name': _nameController.text.trim(),
      'image': _imageController.text.trim(),
    };

    try {
      if (_editingId == null) {
        await _helper.insertCategory(data);
      } else {
        await _helper.updateCategory(_editingId!, data);
      }
      _clearForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi lưu danh mục: $e')));
    }
  }

  Future<void> _deleteCategory(String id) async {
    try {
      await _helper.deleteCategory(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi xóa danh mục: $e')));
    }
  }

  void _startEdit(Map<String, dynamic> category) {
    setState(() {
      _editingId = category['id'] as String;
      _nameController.text = (category['name'] ?? '').toString();
      _imageController.text = (category['image'] ?? '').toString();
    });
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _imageController.clear();
    });
  }

  Widget _imagePreview(String? url, {double size = 44}) {
    final value = (url ?? '').trim();
    if (value.isEmpty) {
      return Icon(Icons.image, size: size * 0.8, color: Colors.grey);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        value,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) =>
            Icon(Icons.broken_image, size: size * 0.8, color: Colors.redAccent),
      ),
    );
  }

  @override
  void dispose() {
    _categoriesSub?.cancel();
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase - Danh mục')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên danh mục',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nhập tên danh mục'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Ảnh URL',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _imagePreview(_imageController.text, size: 56),
                      const SizedBox(width: 10),
                      const Expanded(child: Text('Xem trước ảnh từ URL')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveCategory,
                          child: Text(_editingId == null ? 'Thêm' : 'Cập nhật'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_editingId != null)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _clearForm,
                            child: const Text('Hủy sửa'),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.fromLTRB(12, 10, 12, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Danh mục vừa tạo (mới nhất ở trên)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final item = _categories[index];
                      return ListTile(
                        leading: _imagePreview(
                          (item['image'] ?? '').toString(),
                          size: 44,
                        ),
                        title: Text((item['name'] ?? '').toString()),
                        subtitle: Text((item['image'] ?? '').toString()),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _startEdit(item),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteCategory(item['id'] as String),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
