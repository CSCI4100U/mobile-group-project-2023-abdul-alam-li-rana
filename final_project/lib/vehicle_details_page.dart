import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class VehicleDetails extends StatefulWidget {
  final Vehicle vehicle;

  VehicleDetails({required this.vehicle});

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  List<String> images = [];

  @override
  void initState() {
    super.initState();
    // Load existing images for the vehicle
    loadImages();
  }

  // Function to load existing images for the vehicle
  void loadImages() {
    // Replace 'vehicleId' with the actual field from your Vehicle class that represents the ID
    // Also, replace 'images' with the actual field that stores image metadata in Firestore
    // E.g., widget.vehicle.id and widget.vehicle.images
    FirebaseFirestore.instance
        .collection('vehicles')
        .doc(widget.vehicle.id)
        .collection('images')
        .get()
        .then((querySnapshot) {
      setState(() {
        images = querySnapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      });
    });
  }

  // Function to add a new image to the vehicle from the camera roll
  Future<void> pickImageFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await uploadAndSaveImage(pickedFile);
    }
  }

  // Function to add a new image to the vehicle from the camera
  Future<void> pickImageFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await uploadAndSaveImage(pickedFile);
    }
  }

  // Function to upload and save the image to Firestore
  Future<void> uploadAndSaveImage(XFile? image) async {

    print("attempting to upload image to firestorage");
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages=referenceRoot.child('images');
    Reference referenceImageToUpload=referenceDirImages.child(uniqueFileName);
    print("finished references");

    print("try catch before");

    try {
      await referenceImageToUpload.putFile(File(image!.path));
      var imageURL = await referenceImageToUpload.getDownloadURL();
      addImage(widget.vehicle.id, imageURL);
      print("try catch after");

    }
    catch (error) {
      print("Error when trying to upload image");
    }


    // String vehicleId = widget.vehicle.id;
    // String imageUrl = await uploadImage(vehicleId, imagePath);
    //
    // await FirebaseFirestore.instance
    //     .collection('vehicles')
    //     .doc(vehicleId)
    //     .collection('images')
    //     .add({'imageUrl': imageUrl});

    // Reload images after adding a new one
    loadImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Make: ${widget.vehicle.make}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Model: ${widget.vehicle.model}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Year: ${widget.vehicle.year}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Color: ${widget.vehicle.color}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'VIN: ${widget.vehicle.vin}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Mileage: ${widget.vehicle.mileage}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Fuel Capacity: ${widget.vehicle.fuelCapacity}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Pictures',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Display existing images as tiles
            Container(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: images.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(images[index]),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  );
                },
              ),
            ),
            // Buttons to add new images
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: pickImageFromGallery,
                  icon: Icon(Icons.photo),
                  label: Text('Gallery'),
                ),
                ElevatedButton.icon(
                  onPressed: pickImageFromCamera,
                  icon: Icon(Icons.camera_alt),
                  label: Text('Camera'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}



