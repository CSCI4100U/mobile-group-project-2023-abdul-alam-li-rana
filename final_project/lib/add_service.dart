import 'package:final_project/service.dart';
import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'notification_helper.dart';
import 'vehicle_dropdown.dart';

class AddService extends StatefulWidget {
  @override
  _AddServiceState createState() => _AddServiceState();
}

class _AddServiceState extends State<AddService> {
  final TextEditingController serviceNameController = TextEditingController();
  final TextEditingController serviceDateController = TextEditingController();
  final TextEditingController serviceCostController = TextEditingController();
  final TextEditingController serviceMileageController = TextEditingController();
  final TextEditingController serviceDescriptionController =
      TextEditingController();

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
    setState(() {
      _userVehicles = vehicles;
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

  String generateUniqueId() {
    String uniqueId = DateTime.now().toUtc().toIso8601String();
    return uniqueId;
  }

  String errorMessage = '';

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
        backgroundColor: Colors.grey[900],
        title: Text('Add Service'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
                        
            children: <Widget>[
              VehicleDropdown(
                vehicles: _userVehicles,
                onVehicleSelected: _onVehicleSelected,
                dropdownColor: Colors.red[300]!,
              ),
              _buildTextField('Service Name*', serviceNameController),
              _buildTextField('Date of Service*', serviceDateController),
              _buildTextField('Cost of Service*', serviceCostController),
              _buildTextField('Mileage at Time of Service*', serviceMileageController),
              _buildTextField(
                  'Service Description*', serviceDescriptionController),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String serviceName = serviceNameController.text;
          String serviceDate = serviceDateController.text;
          String serviceCost = serviceCostController.text;
          String serviceMileage = serviceMileageController.text;
          String serviceDescription = serviceDescriptionController.text;

          String id = generateVerificationCode();
          Service newService = Service(
            vehicle: vehicleFullName!,
            carId: id,
            serviceName: serviceName,
            serviceDate: serviceDate,
            serviceCost: serviceCost,
            serviceDescription: serviceDescription,
            serviceMileage: serviceMileage,      
          );

          insertService(newService); 
          Navigator.pop(context, newService);

        },
        backgroundColor: Colors.grey[900],
        child: Icon(Icons.save),
      ),
      backgroundColor: Colors.redAccent,
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
