import 'dart:convert';

import 'package:flutter/services.dart';

import '../config/default.dart';
import '../model/category.dart';

class CategoryData {
  Future<List<Category>> getCategories() async {
    final jsonString = await rootBundle.loadString(categoryJsonPath);
    final List<dynamic> jsonData = jsonDecode(jsonString) as List<dynamic>;

    return jsonData
        .map((item) => Category.fromJson(item as Map<String, dynamic>))
        .toList();
  }
}
