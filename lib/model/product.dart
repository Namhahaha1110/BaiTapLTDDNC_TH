class Product {
  final int id;
  final String name;
  final int categoryId;
  final double price;
  final String imageUrl;

  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      categoryId: json['categoryId'] as int,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
    );
  }
}
