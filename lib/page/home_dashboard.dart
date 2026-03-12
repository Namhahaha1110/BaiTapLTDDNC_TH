import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/firebase_helper.dart';
import '../data/sqlite_database_helper.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard> {
  final FirebaseHelper _firebaseHelper = FirebaseHelper();
  final SqliteDatabaseHelper _sqliteDb = SqliteDatabaseHelper();
  final NumberFormat _currency = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  List<Map<String, dynamic>> _sqliteProducts = [];
  bool _sqliteLoading = true;
  String? _sqliteError;

  @override
  void initState() {
    super.initState();
    _loadSqliteProducts();
  }

  Future<void> _loadSqliteProducts() async {
    try {
      final products = await _sqliteDb.getProducts();
      if (!mounted) return;
      setState(() {
        _sqliteProducts = products;
        _sqliteLoading = false;
        _sqliteError = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _sqliteLoading = false;
        _sqliteError = 'Không thể tải sản phẩm SQLite: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firebaseHelper.getProductsStream(),
        builder: (context, snapshot) {
          final firebaseProducts = snapshot.data ?? <Map<String, dynamic>>[];
          final firebaseLoading =
              snapshot.connectionState == ConnectionState.waiting;
          final firebaseError = snapshot.hasError
              ? 'Không thể tải sản phẩm Firebase'
              : null;

          return RefreshIndicator(
            onRefresh: _loadSqliteProducts,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(firebaseProducts.length, _sqliteProducts.length),
                const SizedBox(height: 20),

                _buildSectionTitle(
                  icon: Icons.cloud,
                  title: 'Sản phẩm Firebase',
                  color: Colors.orange,
                  count: firebaseProducts.length,
                ),
                const SizedBox(height: 10),
                _buildFirebaseBody(
                  isLoading: firebaseLoading,
                  error: firebaseError,
                  items: firebaseProducts,
                ),

                const SizedBox(height: 20),

                _buildSectionTitle(
                  icon: Icons.storage,
                  title: 'Sản phẩm SQLite',
                  color: Colors.blue,
                  count: _sqliteProducts.length,
                ),
                const SizedBox(height: 10),
                _buildSqliteBody(),

                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int firebaseCount, int sqliteCount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Trang chủ sản phẩm',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hiển thị sản phẩm từ Firebase và SQLite',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _headerChip('Firebase: $firebaseCount'),
              _headerChip('SQLite: $sqliteCount'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _headerChip(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildSectionTitle({
    required IconData icon,
    required String title,
    required Color color,
    required int count,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$count',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFirebaseBody({
    required bool isLoading,
    required String? error,
    required List<Map<String, dynamic>> items,
  }) {
    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (error != null) {
      return _buildMessageBox(error);
    }

    if (items.isEmpty) {
      return _buildMessageBox('Chưa có sản phẩm Firebase.');
    }

    return _buildHorizontalProductList(
      items: items,
      getName: (item) => (item['name'] ?? '').toString(),
      getImage: (item) => (item['image'] ?? '').toString(),
      getPrice: (item) => _toDouble(item['price']),
      getCategory: (item) => (item['categoryName'] ?? '').toString(),
    );
  }

  Widget _buildSqliteBody() {
    if (_sqliteLoading) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_sqliteError != null) {
      return _buildMessageBox(_sqliteError!);
    }

    if (_sqliteProducts.isEmpty) {
      return _buildMessageBox('Chưa có sản phẩm SQLite.');
    }

    return _buildHorizontalProductList(
      items: _sqliteProducts,
      getName: (item) => (item['product_name'] ?? '').toString(),
      getImage: (item) => (item['image_name'] ?? '').toString(),
      getPrice: (item) => _toDouble(item['unit_price']),
      getCategory: (item) => (item['category_name'] ?? '').toString(),
    );
  }

  Widget _buildMessageBox(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.grey.shade700),
      ),
    );
  }

  Widget _buildHorizontalProductList({
    required List<Map<String, dynamic>> items,
    required String Function(Map<String, dynamic>) getName,
    required String Function(Map<String, dynamic>) getImage,
    required double Function(Map<String, dynamic>) getPrice,
    required String Function(Map<String, dynamic>) getCategory,
  }) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final item = items[index];
          final name = getName(item);
          final image = getImage(item);
          final price = getPrice(item);
          final category = getCategory(item);

          return Container(
            width: 170,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: _buildImage(image, height: 108, width: 170),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      if (category.isNotEmpty)
                        Text(
                          category,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 12,
                          ),
                        ),
                      const SizedBox(height: 6),
                      Text(
                        _currency.format(price),
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(
    String url, {
    required double height,
    required double width,
  }) {
    if (url.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.image, size: 30, color: Colors.grey),
        ),
      );
    }

    if (url.startsWith('http://') || url.startsWith('https://')) {
      return Image.network(
        url,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: width,
          height: height,
          color: Colors.grey.shade200,
          child: const Center(
            child: Icon(Icons.broken_image, size: 30, color: Colors.grey),
          ),
        ),
      );
    }

    return Image.asset(
      'assets/images/$url',
      width: width,
      height: height,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => Container(
        width: width,
        height: height,
        color: Colors.grey.shade200,
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 30, color: Colors.grey),
        ),
      ),
    );
  }

  double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0;
  }
}
