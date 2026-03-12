import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqliteDatabaseHelper {
  SqliteDatabaseHelper._internal();

  static final SqliteDatabaseHelper _instance = SqliteDatabaseHelper._internal();

  factory SqliteDatabaseHelper() => _instance;

  static const String _dbName = 'db_23dh114467.db';
  static const int _dbVersion = 1;

  static const String categoryTable = 'phone_categories';
  static const String productTable = 'phone_products';

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, _dbName);

    return openDatabase(
      path,
      version: _dbVersion,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $categoryTable(
        category_id INTEGER PRIMARY KEY AUTOINCREMENT,
        category_name TEXT NOT NULL,
        image_name TEXT,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    await db.execute('''
      CREATE TABLE $productTable(
        product_id INTEGER PRIMARY KEY AUTOINCREMENT,
        product_name TEXT NOT NULL,
        unit_price REAL NOT NULL,
        image_name TEXT,
        product_description TEXT,
        category_ref_id INTEGER NOT NULL,
        created_at TEXT DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (category_ref_id)
          REFERENCES $categoryTable(category_id)
          ON DELETE CASCADE
      )
    ''');
  }

  Future<int> insertCategory({
    required String name,
    required String imageName,
  }) async {
    final db = await database;
    return db.insert(categoryTable, {
      'category_name': name,
      'image_name': imageName,
    });
  }

  Future<List<Map<String, dynamic>>> getCategories() async {
    final db = await database;
    return db.query(categoryTable, orderBy: 'category_id DESC');
  }

  Future<int> updateCategory({
    required int id,
    required String name,
    required String imageName,
  }) async {
    final db = await database;
    return db.update(
      categoryTable,
      {
        'category_name': name,
        'image_name': imageName,
      },
      where: 'category_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteCategory(int id) async {
    final db = await database;
    return db.delete(
      categoryTable,
      where: 'category_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertProduct({
    required String name,
    required double price,
    required String imageName,
    required String description,
    required int categoryId,
  }) async {
    final db = await database;
    return db.insert(productTable, {
      'product_name': name,
      'unit_price': price,
      'image_name': imageName,
      'product_description': description,
      'category_ref_id': categoryId,
    });
  }

  Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return db.rawQuery('''
      SELECT p.*, c.category_name
      FROM $productTable p
      LEFT JOIN $categoryTable c
      ON p.category_ref_id = c.category_id
      ORDER BY p.product_id DESC
    ''');
  }

  Future<int> updateProduct({
    required int id,
    required String name,
    required double price,
    required String imageName,
    required String description,
    required int categoryId,
  }) async {
    final db = await database;
    return db.update(
      productTable,
      {
        'product_name': name,
        'unit_price': price,
        'image_name': imageName,
        'product_description': description,
        'category_ref_id': categoryId,
      },
      where: 'product_id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteProduct(int id) async {
    final db = await database;
    return db.delete(
      productTable,
      where: 'product_id = ?',
      whereArgs: [id],
    );
  }
}
