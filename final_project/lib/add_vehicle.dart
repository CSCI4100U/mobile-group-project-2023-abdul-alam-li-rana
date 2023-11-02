import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'dbops.dart';

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

  String generateUniqueId() {
    String uniqueId = DateTime.now().toUtc().toIso8601String();
    return uniqueId;
  }

  String errorMessage = '';

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
      body: Padding(
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
            if (errorMessage.isNotEmpty)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String make = makeController.text;
          String model = modelController.text;
          String year = yearController.text;
          String color = colorController.text;
          String vin = vinController.text;

          if (make.isNotEmpty && model.isNotEmpty && year.isNotEmpty) {
            String id = generateUniqueId();
            Vehicle newVehicle = Vehicle(
              id: id,
              make: make,
              model: model,
              year: year,
              color: color,
              vin: vin,
            );

            insertVehicle(newVehicle);
            Navigator.pop(context, newVehicle);
          } else {
            setState(() {
              errorMessage = 'Please fill in the required fields.';
            });
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.save),
      ),
    );
  }
}