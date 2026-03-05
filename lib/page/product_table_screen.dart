import 'package:flutter/material.dart';

import '../getdata/category_data.dart';
import '../getdata/product_data.dart';
import '../model/category.dart';
import '../model/product.dart';

class ProductTableScreen extends StatefulWidget {
  const ProductTableScreen({super.key});

  @override
  State<ProductTableScreen> createState() => _ProductTableScreenState();
}

class _ProductTableScreenState extends State<ProductTableScreen> {
  final ProductData _productData = ProductData();
  final CategoryData _categoryData = CategoryData();

  bool _isLoading = true;
  String? _error;
  List<Product> _products = [];
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final products = await _productData.getProducts();
      final categories = await _categoryData.getCategories();

      if (!mounted) return;
      setState(() {
        _products = products;
        _categories = categories;
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

  String _formatPrice(double price) {
    return '${price.toStringAsFixed(0)} đ';
  }

  String _categoryName(int id) {
    for (final c in _categories) {
      if (c.id == id) return c.name;
    }
    return 'Không rõ';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng sản phẩm (Table)')),
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

    return LayoutBuilder(
      builder: (context, constraints) {
        final nameWidth = constraints.maxWidth * 0.44;
        final typeWidth = constraints.maxWidth * 0.24;
        final priceWidth = constraints.maxWidth * 0.24;

        return SingleChildScrollView(
          child: DataTable(
            columnSpacing: 8,
            horizontalMargin: 8,
            columns: [
              DataColumn(
                label: SizedBox(
                  width: nameWidth,
                  child: const Text('Tên sản phẩm'),
                ),
              ),
              DataColumn(
                label: SizedBox(width: typeWidth, child: const Text('Loại')),
              ),
              DataColumn(
                label: SizedBox(
                  width: priceWidth,
                  child: const Text('Giá', textAlign: TextAlign.right),
                ),
              ),
            ],
            rows: _products
                .map(
                  (product) => DataRow(
                    cells: [
                      DataCell(
                        SizedBox(
                          width: nameWidth,
                          child: Text(
                            product.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: typeWidth,
                          child: Text(
                            _categoryName(product.categoryId),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                      DataCell(
                        SizedBox(
                          width: priceWidth,
                          child: Text(
                            _formatPrice(product.price),
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        );
      },
    );
  }
}
