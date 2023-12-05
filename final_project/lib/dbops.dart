import 'vehicle.dart';
import 'package:sqflite/sqflite.dart';
import 'main.dart';
import 'package:path/path.dart';
import 'vehicle.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage firestorage = FirebaseStorage.instance;
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




String generateVerificationCode() {
  // Generate a random 6-digit verification code
  final random = Random();
  return (100000 + random.nextInt(900000)).toString();
}

Future<void> addImage(String vehicleId, String imagePath) async {
  try {
    print(vehicleId);

    await FirebaseFirestore.instance.collection('vehicles').doc(vehicleId).collection('images').add({
      'imageUrl': imagePath,
    });

  } catch (e) {
    print('Error uploading image: $e');
  }
}