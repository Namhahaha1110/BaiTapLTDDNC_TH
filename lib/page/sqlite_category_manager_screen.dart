import 'package:flutter/material.dart';

import '../data/sqlite_database_helper.dart';

class SqliteCategoryManagerScreen extends StatefulWidget {
  const SqliteCategoryManagerScreen({super.key});

  @override
  State<SqliteCategoryManagerScreen> createState() =>
      _SqliteCategoryManagerScreenState();
}

class _SqliteCategoryManagerScreenState
    extends State<SqliteCategoryManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  final SqliteDatabaseHelper _db = SqliteDatabaseHelper();

  int? _editingId;
  bool _isLoading = true;
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final data = await _db.getCategories();
    if (!mounted) return;
    setState(() {
      _categories = data;
      _isLoading = false;
    });
  }

  Future<void> _saveCategory() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final name = _nameController.text.trim();
    final imageName = _imageController.text.trim();

    if (_editingId == null) {
      await _db.insertCategory(name: name, imageName: imageName);
    } else {
      await _db.updateCategory(
        id: _editingId!,
        name: name,
        imageName: imageName,
      );
    }

    _clearForm();
    await _loadCategories();
  }

  Future<void> _deleteCategory(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa danh mục này?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Hủy'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Xóa', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      await _db.deleteCategory(id);
      await _loadCategories();
    }
  }

  void _startEdit(Map<String, dynamic> category) {
    setState(() {
      _editingId = category['category_id'] as int;
      _nameController.text = (category['category_name'] ?? '').toString();
      _imageController.text = (category['image_name'] ?? '').toString();
    });
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _imageController.clear();
    });
  }

  Widget _imagePreview(String imageName, {double size = 52}) {
    final value = imageName.trim();
    if (value.isEmpty) {
      return CircleAvatar(
        radius: size / 2,
        child: const Icon(Icons.image_not_supported),
      );
    }

    if (value.startsWith('http://') || value.startsWith('https://')) {
      return ClipOval(
        child: Image.network(
          value,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => CircleAvatar(
            radius: size / 2,
            child: const Icon(Icons.broken_image),
          ),
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        'assets/images/$value',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          final label = value.split('.').first;
          return CircleAvatar(
            radius: size / 2,
            child: Text(
              label.length <= 3 ? label : label.substring(0, 3),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Quản lý danh mục'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _editingId == null
                            ? 'Thêm danh mục mới'
                            : 'Cập nhật danh mục',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên danh mục',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên danh mục';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _imageController,
                        keyboardType: TextInputType.url,
                        decoration: const InputDecoration(
                          labelText: 'Đường link hình ảnh (URL)',
                          hintText: 'https://example.com/image.jpg',
                          prefixIcon: Icon(Icons.link),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 14),
                      Row(
                        children: [
                          _imagePreview(_imageController.text),
                          const Spacer(),
                          if (_editingId != null)
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: OutlinedButton(
                                onPressed: _clearForm,
                                child: const Text('Hủy'),
                              ),
                            ),
                          ElevatedButton.icon(
                            onPressed: _saveCategory,
                            icon: Icon(
                              _editingId == null ? Icons.add : Icons.save,
                            ),
                            label: Text(_editingId == null ? 'Thêm' : 'Lưu'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.list, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  'Danh sách danh mục (${_categories.length})',
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: CircularProgressIndicator(),
              )
            else if (_categories.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Chưa có danh mục nào'),
                ),
              )
            else
              Column(
                children: _categories.map((cat) {
                  return Card(
                    child: ListTile(
                      leading: _imagePreview(
                        (cat['image_name'] ?? '').toString(),
                      ),
                      title: Text(
                        (cat['category_name'] ?? '').toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        'ID: ${(cat['category_id'] ?? '').toString()}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _startEdit(cat),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteCategory(cat['category_id'] as int),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}
