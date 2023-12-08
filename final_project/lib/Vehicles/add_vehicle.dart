import 'package:flutter/material.dart';
import 'package:final_project/Vehicles/vehicle.dart';
import 'package:final_project/Functionality/dbops.dart';

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
  final TextEditingController fuelEconomyController = TextEditingController();

  String generateUniqueId() {
    String uniqueId = DateTime.now().toUtc().toIso8601String();
    return uniqueId;
  }

  String errorMessage = '';

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
          'Register a Vehicle!',
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
                children: <Widget>[
                  _buildTextField('Make*', makeController),
                  _buildTextField('Model*', modelController),
                  _buildTextField('Year*', yearController),
                  _buildTextField('Color', colorController,
                      validator: isValidColor),
                  _buildTextField('VIN', vinController, validator: isValidVIN),
                  _buildTextField('Mileage (KM)', mileageController,
                      validator: isValidMileage),
                  _buildTextField('Fuel Capacity (L)', fuelCapacityController,
                      validator: isValidFuelCapacity),
                  _buildTextField(
                      'Fuel Economy(L/100km)', fuelEconomyController,
                      validator: isValidFuelEconomy),
                ],
              ),
            ),
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
          String fuelEconomy = fuelEconomyController.text;

          if (make.isNotEmpty && model.isNotEmpty && year.isNotEmpty &&
              isValidColor(color) && isValidVIN(vin) &&
              isValidMileage(mileage) && isValidFuelCapacity(fuelCapacity) &&
              isValidFuelEconomy(fuelEconomy)) {
            String id = generateUniqueId();
            Vehicle newVehicle = Vehicle(
              id: id,
              make: make,
              model: model,
              year: year,
              color: color,
              vin: vin,
              mileage: mileage,
              fuelCapacity: fuelCapacity,
              fuelEconomy: fuelEconomy,
            );

            insertVehicle(newVehicle);
            Navigator.pop(context, newVehicle);
          } else {
            setState(() {
              errorMessage = 'Please fill in the required fields with valid values.';
            });

            _showErrorDialog(errorMessage);
          }
        },
        backgroundColor: Colors.grey[900],
          child: Icon(Icons.save, color: Colors.white)
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool Function(String)? validator}) {
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
          if (validator != null && !validator(value)) {
            setState(() {
              errorMessage = 'Invalid value for $label';
            });
          } else {
            setState(() {
              errorMessage = '';
            });
          }
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
