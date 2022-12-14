import 'dart:io';

import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDb {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,"cash_admin.db");

    return await openDatabase(
        path,
        version: 2,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Product(
          productId TEXT PRIMARY KEY,
          productName TEXT,
          mainImage BLOB,
          price REAL,
          published BOOLEAN,
          featured BOOLEAN,
          topSeller BOOLEAN,
          viewCount INTEGER
          )"""
          );
        },
        onUpgrade: (Database db, int oldVersion, int newVersion)async{
          // In this case, oldVersion is 1, newVersion is 2
          if (oldVersion == 1) {
            await db.execute("""
          CREATE TABLE Product(
          productId TEXT PRIMARY KEY,
          productName TEXT,
          mainImage BLOB,
          price REAL,
          published BOOLEAN,
          featured BOOLEAN,
          topSeller BOOLEAN,
          viewCount INTEGER
          )"""
            ); // create new Table
          }}
    );
  }

  Future<int> addProduct(LocalProducts product) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    return db.insert("Product", product.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateProduct(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Product",
        update,
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteProduct() async {
    final db = await init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Product");
    print(deleted);
    return deleted;
  }

  Future<LocalProducts> getProduct() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Product"); //query all the rows in a table as an array of maps

    print("Recieved product data in the Local Database");
    print(maps[0]);

    return LocalProducts.fromJson(maps[0]);
  }

  Future<List<LocalProducts>> getListProducts() async {
    final db = await init();
    final maps = await db.query("Product"); //query all the rows in a table as an array of maps

    List<LocalProducts> products = [];
    for(var product in maps){
      products.add(LocalProducts.fromJson(product));
    }

    print("Recieved Products data in the Local Database");
    print(products[0].mainImage);

    return products;
  }
}