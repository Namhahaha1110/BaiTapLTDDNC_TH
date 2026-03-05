import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static final FirebaseHelper _instance = FirebaseHelper._internal();
  factory FirebaseHelper() => _instance;
  FirebaseHelper._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get categoriesCollection =>
      _firestore.collection('categories');

  CollectionReference<Map<String, dynamic>> get productsCollection =>
      _firestore.collection('products');

  Future<String> insertCategory(Map<String, dynamic> data) async {
    final payload = <String, dynamic>{
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final doc = await categoriesCollection.add(payload);
    return doc.id;
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final snapshot = await categoriesCollection.get();
    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
    items.sort((a, b) {
      final aAt = a['createdAt'];
      final bAt = b['createdAt'];
      if (aAt is Timestamp && bAt is Timestamp) {
        return bAt.compareTo(aAt);
      }
      if (aAt is Timestamp) return -1;
      if (bAt is Timestamp) return 1;
      return 0;
    });
    return items;
  }

  Future<void> updateCategory(String id, Map<String, dynamic> data) async {
    final payload = <String, dynamic>{
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await categoriesCollection.doc(id).update(payload);
  }

  Future<void> deleteCategory(String id) async {
    final products = await productsCollection
        .where('categoryId', isEqualTo: id)
        .get();
    for (final product in products.docs) {
      await product.reference.delete();
    }
    await categoriesCollection.doc(id).delete();
  }

  Future<String> insertProduct(Map<String, dynamic> data) async {
    final payload = <String, dynamic>{
      ...data,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    final doc = await productsCollection.add(payload);
    return doc.id;
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final snapshot = await productsCollection.get();
    final items = snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return data;
    }).toList();
    items.sort((a, b) {
      final aAt = a['createdAt'];
      final bAt = b['createdAt'];
      if (aAt is Timestamp && bAt is Timestamp) {
        return bAt.compareTo(aAt);
      }
      if (aAt is Timestamp) return -1;
      if (bAt is Timestamp) return 1;
      return 0;
    });
    return items;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    final payload = <String, dynamic>{
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    await productsCollection.doc(id).update(payload);
  }

  Future<void> deleteProduct(String id) async {
    await productsCollection.doc(id).delete();
  }

  Stream<List<Map<String, dynamic>>> getCategoriesStream() {
    return categoriesCollection.snapshots().map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      items.sort((a, b) {
        final aAt = a['createdAt'];
        final bAt = b['createdAt'];
        if (aAt is Timestamp && bAt is Timestamp) {
          return bAt.compareTo(aAt);
        }
        if (aAt is Timestamp) return -1;
        if (bAt is Timestamp) return 1;
        return 0;
      });

      return items;
    });
  }

  Stream<List<Map<String, dynamic>>> getProductsStream() {
    return productsCollection.snapshots().map((snapshot) {
      final items = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();

      items.sort((a, b) {
        final aAt = a['createdAt'];
        final bAt = b['createdAt'];
        if (aAt is Timestamp && bAt is Timestamp) {
          return bAt.compareTo(aAt);
        }
        if (aAt is Timestamp) return -1;
        if (bAt is Timestamp) return 1;
        return 0;
      });

      return items;
    });
  }
}
