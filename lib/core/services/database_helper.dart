import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper{

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
          await db.execute("""
          CREATE TABLE Analytics(
          totalProducts REAL,
          totalOrders REAL,
          acceptedOrders REAL,
          totalAffiliates REAL,
          totalEarned REAL,
          totalUnpaid REAL
          )"""
          );
          await db.execute("""
          CREATE TABLE Product(
          productId TEXT PRIMARY KEY,
          productName TEXT,
          price REAL,
          published BOOLEAN,
          featured BOOLEAN,
          topSeller BOOLEAN,
          viewCount INTEGER
          )"""
          );
          await db.execute("""
          CREATE TABLE Localorder(
          orderId TEXT PRIMARY KEY,
          productName TEXT,
          phone TEXT,
          fullName TEXT,
          orderedAt TEXT
          )"""
          );
          await db.execute("""
          CREATE TABLE Affiliate(
          userId TEXT PRIMARY KEY,
          fullName TEXT,
          phone TEXT,
          totalMade REAL
          )"""
          );
        },
    );
  }
}