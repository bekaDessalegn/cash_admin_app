import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/profile/data/models/admin.dart';
import 'package:sqflite/sqflite.dart';

class ProfileLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addAdmin(Admin admin) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("Admin", admin.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateAdmin(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "Admin",
        update,
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteAdmin() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Admin");
    print(deleted);
    return deleted;
  }

  Future<Admin> getAdmin() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("Admin"); //query all the rows in a table as an array of maps

    print("Recieved admin data in the Local Database");
    print(maps[0]);

    return Admin.fromJson(maps[0]);
  }
}