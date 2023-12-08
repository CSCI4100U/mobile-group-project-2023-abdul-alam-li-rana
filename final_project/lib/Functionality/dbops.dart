import 'package:final_project/Vehicles/vehicle.dart';
import 'package:sqflite/sqflite.dart';
import '../main.dart';
import 'package:path/path.dart';
import 'package:final_project/Vehicles/vehicle.dart';
import 'dart:math';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../Services/service.dart';

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


Future<void> insertService(Service service) async {
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    final serviceData = service.toMap();
    serviceData['owner_uid'] = userUid;

    final servicesCollection = firestore.collection('services');


    final newServiceRef = servicesCollection.doc();
    serviceData['id'] = newServiceRef.id;

    await newServiceRef.set(serviceData);


  }
}


// Function to retrieve vehicles associated with the currently authenticated user
Future<List<Service>> getService() async {
  print("hello");
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    QuerySnapshot querySnapshot = await firestore
        .collection('services')
        .where('owner_uid', isEqualTo: userUid)
        .get();

    List<Service> result = [];
    for (QueryDocumentSnapshot document in querySnapshot.docs) {
      result.add(Service.fromMap(document.data() as Map<String, dynamic>));
    }
    return result;
  } else {
    return [];
  }
}

// Function to update a vehicle for the currently authenticated user
Future<void> updateService(Service service) async {
  print("service obj?");
  print('$service');
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    await firestore.collection('services').doc(service.id).update(service.toMap());
  }
}

// Function to delete a vehicle for the currently authenticated user
Future<void> deleteService(String id) async {
  print("is id possibly null");
  print(id);
  final userUid = auth.currentUser?.uid;
  if (userUid != null) {
    await firestore.collection('services').doc(id).get().then((document) {
      if (document.exists && document.data()?['owner_uid'] == userUid) {
        firestore.collection('services').doc(id).delete();
      }
    });
  }
}


Future<List<Map<String, dynamic>>> loadServices(vehicle) async {
  print("$vehicle");
  print("attempting to find mapped services");
  QuerySnapshot<Map<String, dynamic>> querySnapshot = await firestore
      .collection('services')
      .where('carId', isEqualTo: vehicle.id)
      .get();

  return querySnapshot.docs.map((doc) => doc.data()).toList();
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