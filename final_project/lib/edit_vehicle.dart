import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'dbops.dart';
class EditVehicle extends StatefulWidget {
  final Vehicle vehicleToEdit;

  EditVehicle({required this.vehicleToEdit});

  @override
  _EditVehicleState createState() => _EditVehicleState(vehicleToEdit: vehicleToEdit);

}


class _EditVehicleState extends State<EditVehicle> {
  final Vehicle vehicleToEdit;

  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController vinController;
  String errorMessage = '';

  _EditVehicleState({required this.vehicleToEdit})
      : makeController = TextEditingController(text: vehicleToEdit.make),
        modelController = TextEditingController(text: vehicleToEdit.model),
        yearController = TextEditingController(text: vehicleToEdit.year),
        colorController = TextEditingController(text: vehicleToEdit.color),
        vinController = TextEditingController(text: vehicleToEdit.vin);

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
        title: Text('Edit your Vehicle'),
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
            Vehicle updatedVehicle = Vehicle(
            id: vehicleToEdit.id,
            make: make,
            model: model,
            year: year,
            color: color,
            vin: vin,
            );
            updateVehicle(updatedVehicle);
            Navigator.pop(context, updatedVehicle);
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