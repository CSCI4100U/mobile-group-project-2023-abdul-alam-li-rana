import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'notification_helper.dart';

class AddVehicle extends StatefulWidget {
  @override
  _AddVehicleState createState() => _AddVehicleState();
}

class _AddVehicleState extends State<AddVehicle> {
  final TextEditingController makeController = TextEditingController();
  final TextEditingController modelController = TextEditingController();
  final TextEditingController yearController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController vinController = TextEditingController();
  final TextEditingController mileageController = TextEditingController();
  final TextEditingController fuelCapacityController = TextEditingController();

  String generateUniqueId() {
    String uniqueId = DateTime.now().toUtc().toIso8601String();
    return uniqueId;
  }

  String errorMessage = '';

  // Validation function for color
  bool isValidColor(String color) {
    // Customize this based on your color validation criteria
    return color.isNotEmpty && RegExp(r'^[a-zA-Z]+$').hasMatch(color);
  }

// Validation function for VIN (allowing letters and numbers)
  bool isValidVIN(String vin) {
    // Customize this based on your VIN validation criteria
    return vin.isNotEmpty && RegExp(r'^[a-zA-Z0-9]+$').hasMatch(vin);
  }


  // Validation function for mileage (should only be numbers)
  bool isValidMileage(String mileage) {
    // Customize this based on your mileage validation criteria
    return mileage.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(mileage);
  }

  // Validation function for fuel capacity (should only be numbers)
  bool isValidFuelCapacity(String fuelCapacity) {
    // Customize this based on your fuel capacity validation criteria
    return fuelCapacity.isNotEmpty && RegExp(r'^[0-9]+$').hasMatch(fuelCapacity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.blue,
        title: Text('Register a Vehicle!'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: makeController,
                decoration: InputDecoration(
                  labelText: 'Make*',
                ),
              ),
              TextField(
                controller: modelController,
                decoration: InputDecoration(
                  labelText: 'Model*',
                ),
              ),
              TextField(
                controller: yearController,
                decoration: InputDecoration(
                  labelText: 'Year*',
                ),
              ),
              TextField(
                controller: colorController,
                decoration: InputDecoration(labelText: 'Color'),
              ),
              TextField(
                controller: vinController,
                decoration: InputDecoration(labelText: 'VIN'),
              ),
              TextField(
                controller: mileageController,
                decoration: InputDecoration(labelText: 'Mileage'),
              ),
              TextField(
                controller: fuelCapacityController,
                decoration: InputDecoration(labelText: 'Fuel Capacity'),
              ),
              if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String make = makeController.text;
          String model = modelController.text;
          String year = yearController.text;
          String color = colorController.text;
          String vin = vinController.text;
          String mileage = mileageController.text;
          String fuelCapacity = fuelCapacityController.text;

          if (make.isNotEmpty && model.isNotEmpty && year.isNotEmpty && isValidColor(color) && isValidVIN(vin) && isValidMileage(mileage) && isValidFuelCapacity(fuelCapacity)) {
            String id = generateUniqueId();
            Vehicle newVehicle = Vehicle(
              id: id,
              make: make,
              model: model,
              year: year,
              color: color,
              vin: vin,
              type: 'Sedan', // You should replace 'Sedan' with the actual type selected by the user
              mileage: mileage,
              fuelCapacity: fuelCapacity,
            );

            insertVehicle(newVehicle);
            Navigator.pop(context, newVehicle);
          } else {
            setState(() {
              errorMessage = 'Please fill in the required fields with valid values.';
              // Show notification when there is an error
              NotificationHelper.showNotification(
                'Error',
                'Please fill in all the required fields with valid values.',
              );
            });
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.save),
      ),
    );
  }
}

