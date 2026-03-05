import 'package:flutter/material.dart';
import 'dart:async';

import '../data/firebase_helper.dart';

class FirebaseProductListScreen extends StatefulWidget {
  const FirebaseProductListScreen({super.key});

  @override
  State<FirebaseProductListScreen> createState() =>
      _FirebaseProductListScreenState();
}

class _FirebaseProductListScreenState extends State<FirebaseProductListScreen> {
  final FirebaseHelper _helper = FirebaseHelper();

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

  String _categoryName(String? categoryId) {
    if (categoryId == null) return 'Không rõ';
    final found = _categories.where((c) => c['id'] == categoryId).toList();
    if (found.isEmpty) return 'Không rõ';
    return (found.first['name'] ?? 'Không rõ').toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hiển thị sản phẩm')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _products.isEmpty
          ? const Center(child: Text('Chưa có sản phẩm Firebase'))
          : ListView.builder(
              itemCount: _products.length,
              itemBuilder: (context, index) {
                final p = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    leading: (p['image'] ?? '').toString().isNotEmpty
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              p['image'].toString(),
                              width: 54,
                              height: 54,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) =>
                                  const Icon(Icons.image_not_supported),
                            ),
                          )
                        : const Icon(Icons.image),
                    title: Text((p['name'] ?? '').toString()),
                    subtitle: Text(
                      'Loại: ${_categoryName(p['categoryId']?.toString())}\nGiá: ${(p['price'] ?? 0).toString()}',
                    ),
                    isThreeLine: true,
                  ),
                );
              },
            ),
    );
  }

  @override
  void dispose() {
    _productsSub?.cancel();
    _categoriesSub?.cancel();
    super.dispose();
  }
}
