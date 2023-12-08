import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;

class DBUtils {
  static Future init() async{
    //set up the database
    var database = openDatabase(
      path.join(await getDatabasesPath(), 'accountv3.db'),
      onCreate: (db, version){
        db.execute(
            'CREATE TABLE accounts(email TEXT PRIMARY KEY, profilePicture BLOB)'
        );
      },
      version: 1,
    );

    print("Created DB $database");
    return database;
  }
}
