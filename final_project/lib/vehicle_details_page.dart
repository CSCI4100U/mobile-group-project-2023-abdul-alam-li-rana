import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'expanded_image.dart';

class VehicleDetails extends StatefulWidget {
  final Vehicle vehicle;

  VehicleDetails({required this.vehicle});

  @override
  _VehicleDetailsState createState() => _VehicleDetailsState();
}

class _VehicleDetailsState extends State<VehicleDetails> {
  List<String> images = [];
  int selectedImageIndex = -1; // I
  @override
  void initState() {
    super.initState();
    loadImages();
  }

  void loadImages() {
    FirebaseFirestore.instance
        .collection('vehicles')
        .doc(widget.vehicle.id)
        .collection('images')
        .get()
        .then((querySnapshot) {
      setState(() {
        images =
            querySnapshot.docs.map((doc) => doc['imageUrl'] as String).toList();
      });
    });
  }

  Future<void> pickImageFromGallery() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      await uploadAndSaveImage(pickedFile);
    }
  }

  Future<void> pickImageFromCamera() async {
    XFile? pickedFile =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (pickedFile != null) {
      await uploadAndSaveImage(pickedFile);
    }
  }

  Future<void> uploadAndSaveImage(XFile? image) async {
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(File(image!.path));

      var imageURL = await referenceImageToUpload.getDownloadURL();
      addImage(widget.vehicle.id, imageURL);
    } catch (error) {
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

  void toggleImageSelection(int index) {
    setState(() {
      selectedImageIndex = (selectedImageIndex == index) ? -1 : index;
    });
  }

  void deleteSelectedImage() async {
    if (selectedImageIndex != -1) {
      await FirebaseStorage.instance
          .refFromURL(images[selectedImageIndex])
          .delete();

      await FirebaseFirestore.instance
          .collection('vehicles')
          .doc(widget.vehicle.id)
          .collection('images')
          .where('imageUrl', isEqualTo: images[selectedImageIndex])
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          doc.reference.delete();
        });
      });

      setState(() {
        selectedImageIndex = -1;
      });

      loadImages();
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text('Vehicle Details', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.cyan, Colors.blue],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Vehicle Data Box

              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Make: ${widget.vehicle.make}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Model: ${widget.vehicle.model}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Year: ${widget.vehicle.year}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Color: ${widget.vehicle.color}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'VIN: ${widget.vehicle.vin}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
              // Fuel Data Box
              Container(
                width: screenWidth,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Mileage (KM): ${widget.vehicle.mileage}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Fuel Capacity (L): ${widget.vehicle.fuelCapacity}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Fuel Economy (L/100KM): ${widget.vehicle.fuelEconomy}\n',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),

              // Display existing images as tiles
              // ... (ListView.builder)

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
                    onPressed: pickImageFromGallery,
                    icon: Icon(Icons.photo),
                    label: Text('Gallery'),
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[900]),
                    onPressed: pickImageFromCamera,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Camera'),
                  ),
                ],
              ),

              // Expanded Image View
              if (selectedImageIndex != -1)
                Container(
                  constraints: BoxConstraints(
                    minHeight: 0,
                    maxHeight: MediaQuery.of(context).size.height,
                  ),
                  child: ExpandedImageView(
                    imageUrl: images[selectedImageIndex],
                    onDelete: deleteSelectedImage,
                    onUnexpand: () {
                      setState(() {
                        selectedImageIndex = -1;
                      });
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
