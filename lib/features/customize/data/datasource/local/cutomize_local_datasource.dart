import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/customize/data/model/logo_image.dart';
import 'package:sqflite/sqflite.dart';

class LogoImageLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addLogoImage(LogoImage logoImage) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("LogoImage", logoImage.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateLogoImage(Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "LogoImage",
        update
    );
    return result;
  }

  Future deleteLogoImage() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from LogoImage");
    print(deleted);
    return deleted;
  }

  Future<LogoImage> getLogoImage() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("LogoImage"); //query all the rows in a table as an array of maps

    print("Recieved LogoImage data in the Local Database");
    print(maps[0]);

    return LogoImage.fromJson(maps[0]);
  }
}