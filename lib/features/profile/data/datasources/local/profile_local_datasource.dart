import 'dart:io';

import 'package:cash_admin_app/features/profile/data/models/admin.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class ProfileLocalDb {
  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path,"cash_admin.db");

    return await openDatabase(
        path,
        version: 1,
        onCreate: (Database db,int version) async{
          await db.execute("""
          CREATE TABLE Admin(
          id TEXT PRIMARY KEY,
          username TEXT,
          email TEXT,
          commissionRate REAL
          )"""
          );
        });
  }

  Future<int> addAdmin(Admin admin) async{ //returns number of items inserted as an integer
    final db = await init(); //open database

    return db.insert("Admin", admin.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateAdmin(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Admin",
        update,
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteAdmin() async {
    final db = await init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Admin");
    print(deleted);
    return deleted;
  }

  Future<Admin> getAdmin() async{ //returns the memos as a list (array)

    final db = await init();
    final maps = await db.query("Admin"); //query all the rows in a table as an array of maps

    print("Recieved admin data in the Local Database");
    print(maps[0]);

    return Admin.fromJson(maps[0]);
  }
}