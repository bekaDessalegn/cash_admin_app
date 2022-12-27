import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/orders/data/models/local_order.dart';
import 'package:sqflite/sqflite.dart';

class OrderLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addOrder(LocalOrder order) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("Localorder", order.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateOrder(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "Localorder",
        update,
        where: "orderId = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future<int> deleteOrder(String id) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.delete(
        "Localorder",
        where: "orderId = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteAllOrder() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Localorder");
    print(deleted);
    return deleted;
  }

  Future<LocalOrder> getOrder() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("Localorder"); //query all the rows in a table as an array of maps

    print("Recieved order data in the Local Database");
    print(maps[0]);

    return LocalOrder.fromJson(maps[0]);
  }

  Future<List<LocalOrder>> getListOrders() async {
    final db = await databaseHelper.init();
    final maps = await db.query("Localorder"); //query all the rows in a table as an array of maps

    List<LocalOrder> orders = [];
    for(var order in maps){
      orders.add(LocalOrder.fromJson(order));
    }

    return orders;
  }
}