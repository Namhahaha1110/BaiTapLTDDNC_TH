import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/sqlite_database_helper.dart';

class SqliteProductDisplayScreen extends StatefulWidget {
  const SqliteProductDisplayScreen({super.key});

  @override
  State<SqliteProductDisplayScreen> createState() =>
      _SqliteProductDisplayScreenState();
}

class _SqliteProductDisplayScreenState extends State<SqliteProductDisplayScreen> {
  final SqliteDatabaseHelper _db = SqliteDatabaseHelper();
  final NumberFormat _currency = NumberFormat('#,###', 'vi_VN');

  bool _isLoading = true;
  String? _error;
  List<Map<String, dynamic>> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await _db.getProducts();
      if (!mounted) return;
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải sản phẩm SQLite: $e';
        _isLoading = false;
      });
    }
  }

  String _formatPrice(dynamic value) {
    final price = (value is num) ? value.toDouble() : 0;
    return '${_currency.format(price)} VND';
  }

  Widget _buildImage(String imageName, {double size = 56}) {
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
        errorBuilder: (context, error, stackTrace) => CircleAvatar(
          radius: size / 2,
          child: const Icon(Icons.image),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm SQLite đã tạo'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(_error!, textAlign: TextAlign.center),
        ),
      );
    }

    if (_products.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Chưa có sản phẩm SQLite nào.'),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadProducts,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          final imageName = (product['image_name'] ?? '').toString();
          final name = (product['product_name'] ?? '').toString();
          final categoryName = (product['category_name'] ?? '').toString();
          final description = (product['product_description'] ?? '').toString();

          return Card(
            child: ListTile(
              leading: _buildImage(imageName),
              title: Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Loại: $categoryName'),
                  Text(
                    'Giá: ${_formatPrice(product['unit_price'])}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  if (description.isNotEmpty)
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}