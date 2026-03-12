import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/sqlite_database_helper.dart';

class SqliteProductManagerScreen extends StatefulWidget {
  const SqliteProductManagerScreen({super.key});

  @override
  State<SqliteProductManagerScreen> createState() =>
      _SqliteProductManagerScreenState();
}

class _SqliteProductManagerScreenState
    extends State<SqliteProductManagerScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageController = TextEditingController();
  final _descriptionController = TextEditingController();

  final SqliteDatabaseHelper _db = SqliteDatabaseHelper();
  final NumberFormat _currency = NumberFormat('#,###', 'vi_VN');

  int? _editingId;
  int? _selectedCategoryId;
  bool _isLoading = true;
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await _db.getCategories();
    final products = await _db.getProducts();

    if (!mounted) return;
    setState(() {
      _categories = categories;
      _products = products;
      _isLoading = false;
    });
  }

  Future<void> _saveProduct() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedCategoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn loại sản phẩm')),
      );
      return;
    }

    final name = _nameController.text.trim();
    final price = double.tryParse(_priceController.text.trim()) ?? 0;
    final imageName = _imageController.text.trim();
    final description = _descriptionController.text.trim();

    if (_editingId == null) {
      await _db.insertProduct(
        name: name,
        price: price,
        imageName: imageName,
        description: description,
        categoryId: _selectedCategoryId!,
      );
    } else {
      await _db.updateProduct(
        id: _editingId!,
        name: name,
        price: price,
        imageName: imageName,
        description: description,
        categoryId: _selectedCategoryId!,
      );
    }

    _clearForm();
    await _loadData();
  }

  Future<void> _deleteProduct(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Xác nhận xóa'),
          content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
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
      await _db.deleteProduct(id);
      await _loadData();
    }
  }

  void _startEdit(Map<String, dynamic> product) {
    setState(() {
      _editingId = product['product_id'] as int;
      _nameController.text = (product['product_name'] ?? '').toString();
      _priceController.text = (product['unit_price'] ?? '').toString();
      _imageController.text = (product['image_name'] ?? '').toString();
      _descriptionController.text = (product['product_description'] ?? '')
          .toString();
      _selectedCategoryId = product['category_ref_id'] as int?;
    });
  }

  void _clearForm() {
    setState(() {
      _editingId = null;
      _selectedCategoryId = null;
      _nameController.clear();
      _priceController.clear();
      _imageController.clear();
      _descriptionController.clear();
    });
  }

  String _formatPrice(dynamic value) {
    final price = (value is num) ? value.toDouble() : 0;
    return '${_currency.format(price)} VND';
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
      return ClipRRect(
        borderRadius: BorderRadius.circular(8),
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

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
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
    _priceController.dispose();
    _imageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Quản lý sản phẩm'),
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
                            ? 'Thêm sản phẩm mới'
                            : 'Cập nhật sản phẩm',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Tên sản phẩm',
                          prefixIcon: Icon(Icons.shopping_bag),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Vui lòng nhập tên sản phẩm';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _priceController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: const InputDecoration(
                          labelText: 'Giá',
                          prefixIcon: Icon(Icons.attach_money),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          final parsed = double.tryParse((value ?? '').trim());
                          if (parsed == null || parsed <= 0) {
                            return 'Vui lòng nhập giá hợp lệ';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<int>(
                        initialValue: _selectedCategoryId,
                        decoration: const InputDecoration(
                          labelText: 'Chọn loại',
                          prefixIcon: Icon(Icons.category),
                          border: OutlineInputBorder(),
                        ),
                        items: _categories
                            .map(
                              (cat) => DropdownMenuItem<int>(
                                value: cat['category_id'] as int,
                                child: Text(
                                  (cat['category_name'] ?? '').toString(),
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedCategoryId = value;
                          });
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
                      const SizedBox(height: 10),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 2,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả',
                          prefixIcon: Icon(Icons.description),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                            onPressed: _saveProduct,
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
                  'Danh sách sản phẩm (${_products.length})',
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
            else if (_products.isEmpty)
              const Card(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text('Chưa có sản phẩm nào'),
                ),
              )
            else
              Column(
                children: _products.map((product) {
                  return Card(
                    child: ListTile(
                      leading: _imagePreview(
                        (product['image_name'] ?? '').toString(),
                      ),
                      title: Text(
                        (product['product_name'] ?? '').toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Giá: ${_formatPrice(product['unit_price'])}',
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Loại: ${(product['category_name'] ?? '').toString()}',
                          ),
                          Text(
                            'Mô tả: ${(product['product_description'] ?? '').toString()}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _startEdit(product),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _deleteProduct(product['product_id'] as int),
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
