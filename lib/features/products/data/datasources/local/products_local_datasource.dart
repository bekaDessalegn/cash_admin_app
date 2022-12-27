import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/products/data/models/local_products.dart';
import 'package:sqflite/sqflite.dart';

class ProductLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addProduct(LocalProducts product) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("Product", product.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateProduct(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "Product",
        update,
        where: "productId = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future<int> deleteProduct(String id) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.delete(
        "Product",
        where: "productId = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteAllProduct() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Product");
    print(deleted);
    return deleted;
  }

  Future<LocalProducts> getProduct() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("Product"); //query all the rows in a table as an array of maps

    print("Recieved product data in the Local Database");
    print(maps[0]);

    return LocalProducts.fromJson(maps[0]);
  }

  Future<List<LocalProducts>> getListProducts() async {
    final db = await databaseHelper.init();
    final maps = await db.query("Product"); //query all the rows in a table as an array of maps

    List<LocalProducts> products = [];
    for(var product in maps){
      products.add(LocalProducts.fromJson(product));
    }

    return products;
  }
}