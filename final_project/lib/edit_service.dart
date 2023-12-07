import 'package:flutter/material.dart';
import 'service.dart';
import 'dbops.dart';
import 'vehicle.dart';
import 'vehicle_dropdown.dart';

class EditService extends StatefulWidget {
  final Service serviceToEdit;
  EditService({required this.serviceToEdit});

  @override
  _EditServiceState createState() =>
      _EditServiceState(serviceToEdit: serviceToEdit);
}

class _EditServiceState extends State<EditService> {
  final TextEditingController serviceNameController;
  final TextEditingController serviceDateController;
  final TextEditingController serviceCostController;
  final TextEditingController serviceMileageController;
  final TextEditingController serviceDescriptionController;

  String selectedType = '';
  final Service serviceToEdit;
  String errorMessage = '';

  Vehicle? _selectedVehicle;
  List<Vehicle> _userVehicles = [];

  String? vehicleFullName;

  @override
  void initState() {
    super.initState();
    _loadUserVehicles(); // Load user's vehicles when the page is initialized
  }

  Future<void> _loadUserVehicles() async {
    // Load user's vehicles when the page is initialized
    List<Vehicle> vehicles = await getVehicle();

    print("User Vehicles: $vehicles");

    Vehicle foundVehicle;
    if (vehicles.isNotEmpty) {
      foundVehicle = vehicles.firstWhere(
            (vehicle) => vehicle.id == serviceToEdit.carId,
        orElse: () => vehicles.first, // Default to the first vehicle if not found
      );

      print("Found Vehicle: $foundVehicle");
    } else {
      print("Error: No vehicles found");
      return;
    }

    setState(() {
      _userVehicles = vehicles;
      _selectedVehicle = foundVehicle;
      _onVehicleSelected(_selectedVehicle);
    });
  }

  void _onVehicleSelected(Vehicle? selectedVehicle) {
    setState(() {
      _selectedVehicle = selectedVehicle;
      vehicleFullName = '${_selectedVehicle!.make} ${_selectedVehicle!.model}';
    });

    if (_selectedVehicle != null) {
      final snackBar = SnackBar(
        content: Text(
            '${_selectedVehicle!.make} ${_selectedVehicle!.model} (${_selectedVehicle!.year}) Selected.'),
        duration: Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _EditServiceState({required this.serviceToEdit})
      : serviceNameController =
  TextEditingController(text: serviceToEdit.serviceName),
        serviceDateController =
        TextEditingController(text: serviceToEdit.serviceDate),
        serviceCostController =
        TextEditingController(text: serviceToEdit.serviceCost),
        serviceMileageController =
        TextEditingController(text: serviceToEdit.serviceMileage),
        serviceDescriptionController =
        TextEditingController(text: serviceToEdit.serviceDescription);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.grey[900],
        title: Text('Edit Service Details', style: TextStyle(color: Colors.white)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              VehicleDropdown(
                vehicles: _userVehicles,
                onVehicleSelected: _onVehicleSelected,
                dropdownColor: Colors.red[300]!,
              ),
              _buildTextField('Service Name*', serviceNameController),
              _buildTextField('Date of Service*', serviceDateController),
              _buildTextField('Cost of Service*', serviceCostController),
              _buildTextField(
                  'Mileage at Time of Service*', serviceMileageController),
              _buildTextField(
                  'Service Description*', serviceDescriptionController),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveChanges();
        },
        backgroundColor: Colors.grey[900], // Set grey background color for the button
        child: Icon(Icons.save, color: Colors.white), // Set icon color to white
      ),
      backgroundColor: Colors.redAccent,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.black), // Black border color
          ),
          labelStyle: TextStyle(color: Colors.white),
          hintStyle: TextStyle(color: Colors.white),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.black), // Black border color
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(color: Colors.black), // Black border color
          ),
        ),
        style: TextStyle(color: Colors.white),
        onChanged: (value) {
          setState(() {
            errorMessage = '';
          });
        },
      ),
    );
  }

  void _saveChanges() {
    String serviceName = serviceNameController.text;
    String serviceDate = serviceDateController.text;
    String serviceCost = serviceCostController.text;
    String serviceMileage = serviceMileageController.text;
    String serviceDescription = serviceDescriptionController.text;

    Service updatedService = Service(
      id: serviceToEdit.id,
      vehicle: vehicleFullName!,
      carId: _selectedVehicle?.id ?? "",
      serviceName: serviceName,
      serviceDate: serviceDate,
      serviceCost: serviceCost,
      serviceDescription: serviceDescription,
      serviceMileage: serviceMileage,
    );
    updateService(updatedService);
    Navigator.pop(context, updatedService);
  }
}
