import 'package:flutter/material.dart';

import '../getdata/category_data.dart';
import '../getdata/product_data.dart';
import '../model/category.dart';
import '../model/product.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final CategoryData _categoryData = CategoryData();
  final ProductData _productData = ProductData();

  bool _isLoading = true;
  String? _error;
  List<Category> _categories = [];
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final categories = await _categoryData.getCategories();
      final products = await _productData.getProducts();

      if (!mounted) return;
      setState(() {
        _categories = categories;
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = 'Không thể tải dữ liệu: $e';
        _isLoading = false;
      });
    }
  }

  int _countProductsByCategory(int categoryId) {
    return _products.where((p) => p.categoryId == categoryId).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm (List)'),
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

    return ListView.separated(
      itemCount: _categories.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final category = _categories[index];
        final total = _countProductsByCategory(category.id);

        return ListTile(
          leading: const CircleAvatar(child: Icon(Icons.category)),
          title: Text(category.name),
          subtitle: Text('$total sản phẩm'),
          trailing: const Icon(Icons.arrow_forward_ios, size: 16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListByCategoryScreen(
                  category: category,
                  products: _products,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ProductListByCategoryScreen extends StatelessWidget {
  final Category category;
  final List<Product> products;

  const ProductListByCategoryScreen({
    super.key,
    required this.category,
    required this.products,
  });

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} đ';
  }

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) => p.categoryId == category.id).toList();

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView.builder(
        itemCount: filtered.length,
        itemBuilder: (context, index) {
          final product = filtered[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product.imageUrl,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                ),
              ),
              title: Text(product.name),
              subtitle: Text(_formatPrice(product.price)),
            ),
          );
        },
      ),
    );
  }
}
