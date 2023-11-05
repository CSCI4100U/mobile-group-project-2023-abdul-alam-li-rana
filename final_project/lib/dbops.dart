import 'vehicle.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'package:path/path.dart';
import 'vehicle.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore firestore = FirebaseFirestore.instance;

// Function to insert a vehicle document for the currently authenticated user
Future<void> insertVehicle(Vehicle vehicle) async {
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    final vehicleData = vehicle.toMap();
    vehicleData['owner_uid'] = userUid;
    await firestore.collection('vehicles').doc(vehicle.id.toString()).set(vehicleData);
  }
}

// Function to retrieve vehicles associated with the currently authenticated user
Future<List<Vehicle>> getVehicle() async {
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    QuerySnapshot querySnapshot = await firestore
        .collection('vehicles')
        .where('owner_uid', isEqualTo: userUid)
        .get();

    List<Vehicle> result = [];

    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      result.add(Vehicle.fromMap(document.data() as Map<String, dynamic>));
    }
    return result;
  } else {
    return [];
  }
}

// Function to update a vehicle for the currently authenticated user
Future<void> updateVehicle(Vehicle vehicle) async {
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    await firestore.collection('vehicles').doc(vehicle.id.toString()).update(vehicle.toMap());
  }
}

// Function to delete a vehicle for the currently authenticated user
Future<void> deleteVehicle(String id) async {
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    await firestore.collection('vehicles').doc(id).get().then((document) {
      if (document.exists && document.data()?['owner_uid'] == userUid) {
        firestore.collection('vehicles').doc(id).delete();
      }
    });
  }
}