import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path/path.dart' as path;

class DBUtils{
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'vehicles.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE vehicles(vin TEXT PRIMARY KEY, make TEXT, model TEXT, year INTEGER, type TEXT)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}