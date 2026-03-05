import 'package:flutter/material.dart';
import 'dart:async';

import '../data/firebase_helper.dart';

class FirebaseProductManagerScreen extends StatefulWidget {
  const FirebaseProductManagerScreen({super.key});

  @override
  State<FirebaseProductManagerScreen> createState() =>
      _FirebaseProductManagerScreenState();
}

class _FirebaseProductManagerScreenState
    extends State<FirebaseProductManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  final FirebaseHelper _helper = FirebaseHelper();

  String? _editingId;
  String? _selectedCategoryId;
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;
  StreamSubscription<List<Map<String, dynamic>>>? _productsSub;
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

    _productsSub = _helper.getProductsStream().listen((data) {
      if (!mounted) return;
      setState(() {
        _products = data;
        _isLoading = false;
      });
    });
  }

  Future<void> _saveProduct() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Chọn danh mục')));
      return;
    }

    final data = {
      'name': _nameController.text.trim(),
      'price': double.tryParse(_priceController.text.trim()) ?? 0,
      'image': _imageController.text.trim(),
      'description': _descriptionController.text.trim(),
      'categoryId': _selectedCategoryId,
    };

    try {
      if (_editingId == null) {
        await _helper.insertProduct(data);
      } else {
        await _helper.updateProduct(_editingId!, data);
      }
      _clearForm();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi lưu sản phẩm: $e')));
    }
  }

  Future<void> _deleteProduct(String id) async {
    try {
      await _helper.deleteProduct(id);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi xóa sản phẩm: $e')));
    }
  }

  String _categoryName(String? id) {
    if (id == null) return 'Không rõ';
    final found = _categories.where((c) => c['id'] == id).toList();
    if (found.isEmpty) return 'Không rõ';
    return (found.first['name'] ?? 'Không rõ').toString();
  }

  void _startEdit(Map<String, dynamic> product) {
    setState(() {
      _editingId = product['id'] as String;
      _nameController.text = (product['name'] ?? '').toString();
      _priceController.text = (product['price'] ?? '').toString();
      _imageController.text = (product['image'] ?? '').toString();
      _descriptionController.text = (product['description'] ?? '').toString();
      _selectedCategoryId = product['categoryId']?.toString();
    });
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _selectedCategoryId = null;
    });
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    _categoriesSub?.cancel();
    _nameController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Firebase - Sản phẩm')),
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
                      labelText: 'Tên sản phẩm',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? 'Nhập tên sản phẩm'
                        : null,
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _priceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Giá',
                      border: OutlineInputBorder(),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Nhập giá' : null,
                  ),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem<String>(
                            value: c['id'] as String,
                            child: Text((c['name'] ?? '').toString()),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategoryId = v),
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _imageController,
                    decoration: const InputDecoration(
                      labelText: 'Ảnh URL',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    minLines: 2,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Mô tả',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _saveProduct,
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
                'Sản phẩm vừa tạo (mới nhất ở trên)',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final p = _products[index];
                      return ListTile(
                        leading: const Icon(Icons.inventory_2),
                        title: Text((p['name'] ?? '').toString()),
                        subtitle: Text(
                          'Loại: ${_categoryName(p['categoryId']?.toString())} | Giá: ${(p['price'] ?? 0).toString()}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _startEdit(p),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  _deleteProduct(p['id'] as String),
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
