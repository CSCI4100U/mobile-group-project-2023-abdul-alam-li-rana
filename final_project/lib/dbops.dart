import 'vehicle.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'package:path/path.dart';
import 'vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';



final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> insertVehicle(Vehicle vehicle) async {
  await firestore.collection('vehicles').doc(vehicle.id.toString()).set(vehicle.toMap());
}

Future<List<Vehicle>> getVehicle() async {
  print("are vehicles  gotten?");
  QuerySnapshot querySnapshot = await firestore.collection('vehicles').get();
  List<Vehicle> result = [];

  for (QueryDocumentSnapshot document in querySnapshot.docs) {
    result.add(Vehicle.fromMap(document.data() as Map<String, dynamic>));
  }
  print(result.length);
  return result;
}

Future<void> updateVehicle(Vehicle vehicle) async {
  await firestore.collection('vehicles').doc(vehicle.id.toString()).update(vehicle.toMap());
}

Future<void> deleteVehicle(String id) async {
  await firestore.collection('vehicles').doc(id).delete();
}