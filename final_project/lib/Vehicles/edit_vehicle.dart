import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:final_project/Vehicles/vehicle.dart';
import 'package:final_project/Functionality/dbops.dart';

class EditVehicle extends StatefulWidget {
  final Vehicle vehicleToEdit;

  EditVehicle({required this.vehicleToEdit});

  @override
  _EditVehicleState createState() =>
      _EditVehicleState(vehicleToEdit: vehicleToEdit);
}

class _EditVehicleState extends State<EditVehicle> {
  final TextEditingController makeController;
  final TextEditingController modelController;
  final TextEditingController yearController;
  final TextEditingController colorController;
  final TextEditingController vinController;
  final TextEditingController mileageController;
  final TextEditingController fuelCapacityController;
  final TextEditingController fuelEconomyController;

  // Validation function for color
  bool isValidColor(String color) {
    // Customize this based on your color validation criteria
    return color.isEmpty || RegExp(r'^[a-zA-Z]+$').hasMatch(color);
  }

  // Validation function for VIN (allowing letters and numbers)
  bool isValidVIN(String vin) {
    // Customize this based on your VIN validation criteria
    return vin.isEmpty || RegExp(r'^[a-zA-Z0-9]+$').hasMatch(vin);
  }

  // Validation function for mileage (should only be numbers)
  bool isValidMileage(String mileage) {
    // Customize this based on your mileage validation criteria
    return mileage.isEmpty || RegExp(r'^[0-9]+$').hasMatch(mileage);
  }

  // Validation function for fuel capacity (should only be numbers)
  bool isValidFuelCapacity(String fuelCapacity) {
    // Customize this based on your fuel capacity validation criteria
    return fuelCapacity.isEmpty || RegExp(r'^[0-9]+$').hasMatch(fuelCapacity);
  }

  // Validation function for fuel economy (should be numbers and decimals)
  bool isValidFuelEconomy(String fuelEconomy) {
    // Customize this based on your fuel economy validation criteria
    return fuelEconomy.isEmpty ||
        double.tryParse(fuelEconomy.replaceAll(',', '')) != null;
  }

  String selectedType = '';
  final Vehicle vehicleToEdit;
  String errorMessage = '';

  _EditVehicleState({required this.vehicleToEdit})
      : makeController = TextEditingController(text: vehicleToEdit.make),
        modelController = TextEditingController(text: vehicleToEdit.model),
        yearController = TextEditingController(text: vehicleToEdit.year),
        colorController = TextEditingController(text: vehicleToEdit.color),
        vinController = TextEditingController(text: vehicleToEdit.vin),
        mileageController = TextEditingController(text: vehicleToEdit.mileage),
        fuelCapacityController =
        TextEditingController(text: vehicleToEdit.fuelCapacity),
        fuelEconomyController =
        TextEditingController(text: vehicleToEdit.fuelEconomy);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.grey[900],
        title: Text(
          'Edit your Vehicle',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green, Colors.tealAccent],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _buildTextField('Make*', makeController),
                  _buildTextField('Model*', modelController),
                  _buildTextField('Year*', yearController),
                  _buildTextField('Color', colorController),
                  _buildTextField('VIN', vinController),
                  _buildTextField('Mileage (KM)', mileageController),
                  _buildTextField('Fuel Capacity (L)', fuelCapacityController),
                  _buildTextField(
                      'Fuel Economy (L/100km)', fuelEconomyController),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
        },
        backgroundColor: Colors.grey[900],
        child: Icon(Icons.save, color: Colors.white), // Set the color property to Colors.white
      ),
    );
  }

  void _saveChanges() {
    String make = makeController.text;
    String model = modelController.text;
    String year = yearController.text;
    String color = colorController.text;
    String vin = vinController.text;
    String mileage = mileageController.text;
    String fuelCapacity = fuelCapacityController.text;
    String fuelEconomy = fuelEconomyController.text;

    if (make.isNotEmpty && model.isNotEmpty && year.isNotEmpty &&
        isValidColor(color) &&
        isValidVIN(vin) &&
        isValidMileage(mileage) &&
        isValidFuelCapacity(fuelCapacity) &&
        isValidFuelEconomy(fuelEconomy)) {
      Vehicle updatedVehicle = Vehicle(
        id: vehicleToEdit.id,
        make: make,
        model: model,
        year: year,
        color: color,
        vin: vin,
        mileage: mileage,
        fuelCapacity: fuelCapacity,
        fuelEconomy: fuelEconomy,
      );
      updateVehicle(updatedVehicle);
      Navigator.pop(context, updatedVehicle);
    } else {
      setState(() {
        errorMessage = 'Please fill in the required fields with valid values.';
      });

      _showErrorDialog(errorMessage);
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          errorText: errorMessage.isNotEmpty ? errorMessage : null,
        ),
        onChanged: (value) {
          setState(() {
            errorMessage = '';
          });
        },
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.green,
          title: Text('Error'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              SizedBox(height: 16.0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
