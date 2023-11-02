import 'package:sqflite/sqflite.dart';
import 'db_utils.dart';
import 'vehicle.dart';

class VehiclesModel{

    Future<int> insertVehicle(Vehicles vehicle) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.insert(
      'vehicles',
      vehicle.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

    Future getAllVehicles() async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    final List maps = await db.query('vehicles');
    List result = [];
    for (int i = 0; i < maps.length; i++){
      result.add(
        Vehicles.fromMap(maps[i])
      );
    }
    return result;
  }

    Future<int> updateVehicle(Vehicles vehicle) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.update(
      'vehicles',
      vehicle.toMap(),
      where: 'vin = ?',
      whereArgs: [vehicle.vin],
    );
  }

  Future<int> deleteGradeByVin(String vin) async{
    //This needs to be present in any queries, updates, etc.
    //you do with your database
    final db = await DBUtils.init();
    return db.delete(
      'vehicles',
      where: 'vin = ?',
      whereArgs: [vin],
    );
  }
}