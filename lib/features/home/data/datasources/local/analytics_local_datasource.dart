import 'dart:io';

import 'package:cash_admin_app/core/services/database_helper.dart';
import 'package:cash_admin_app/features/home/data/models/analytics.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class AnalyticsLocalDb {

  DatabaseHelper databaseHelper = DatabaseHelper();

  Future<int> addAnalytics(Analytics analytics) async{ //returns number of items inserted as an integer
    final db = await databaseHelper.init(); //open database

    return db.insert("Analytics", analytics.toJson(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<int> updateAnalytics(Map<String, dynamic> update) async{ // returns the number of rows updated

    final db = await databaseHelper.init();

    int result = await db.update(
        "Analytics",
        update
    );
    return result;
  }

  Future deleteAnalytics() async {
    final db = await databaseHelper.init();
    // return db.delete("delete from "+ TABLE_NAME);
    int deleted = await db.rawDelete("Delete from Analytics");
    print(deleted);
    return deleted;
  }

  Future<Analytics> getAnalytics() async{ //returns the memos as a list (array)

    final db = await databaseHelper.init();
    final maps = await db.query("Analytics"); //query all the rows in a table as an array of maps

    print("Recieved analytics data in the Local Database");
    print(maps[0]);

    return Analytics.fromJson(maps[0]);
  }
}