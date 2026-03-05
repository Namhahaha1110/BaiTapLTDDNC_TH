import 'dart:convert';

import 'package:flutter/services.dart';

import '../config/default.dart';
import '../model/product.dart';

class ProductData {
  Future<List<Product>> getProducts() async {
    final jsonString = await rootBundle.loadString(productJsonPath);
    final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;

    return jsonData
        .map((item) => Product.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
