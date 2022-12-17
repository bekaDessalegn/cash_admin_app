import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/affiliate/data/models/local_affiliate.dart';
import 'package:sqflite/sqflite.dart';

class AffiliateLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addAffiliate(LocalAffiliate affiliate) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("Affiliate", affiliate.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateAffiliate(String id, Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "Affiliate",
        update,
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

  Future deleteAffiliate() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Affiliate");
    print(deleted);
    return deleted;
  }

  Future<LocalAffiliate> getAffiliate() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("Affiliate"); //query all the rows in a table as an array of maps

    print("Recieved affiliate data in the Local Database");
    print(maps[0]);

    return LocalAffiliate.fromJson(maps[0]);
  }

  Future<List<LocalAffiliate>> getListAffiliates() async {
    final db = await databaseHelper.init();
    final maps = await db.query("Affiliate"); //query all the rows in a table as an array of maps

    List<LocalAffiliate> affiliates = [];
    for(var affiliate in maps){
      affiliates.add(LocalAffiliate.fromJson(affiliate));
    }

    return affiliates;
  }
}