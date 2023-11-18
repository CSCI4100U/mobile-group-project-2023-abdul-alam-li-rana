// vehicle_details_page.dart
import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'edit_vehicle.dart';

class VehicleDetailsPage extends StatefulWidget {
  final Vehicle vehicle;
  final Function(Vehicle) onVehicleUpdated;

  VehicleDetailsPage({required this.vehicle, required this.onVehicleUpdated});

  @override
  _VehicleDetailsPageState createState() => _VehicleDetailsPageState();
}

class _VehicleDetailsPageState extends State<VehicleDetailsPage> {
  late Vehicle _currentVehicle;

  @override
  void initState() {
    super.initState();
    _currentVehicle = widget.vehicle;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Vehicle Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              final updatedVehicle = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditVehicle(vehicleToEdit: _currentVehicle),
                ),
              );

              if (updatedVehicle != null) {
                widget.onVehicleUpdated(updatedVehicle);
                setState(() {
                  _currentVehicle = updatedVehicle;
                });
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Display the image at the top
            Container(
              height: 200, // Adjust the height as needed
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/journey.png'), // Temporary image, will add API implementation that will
                                                           // load the image based on current vehicle
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16),
            // Display the details using a Table
            Table(
              columnWidths: {0: FlexColumnWidth(1.5), 1: FlexColumnWidth(2)},
              children: [
                _buildTableRow('Make', _currentVehicle.make),
                _buildTableRow('Model', _currentVehicle.model),
                _buildTableRow('Year', _currentVehicle.year),
                _buildTableRow('Color', _currentVehicle.color),
                _buildTableRow('VIN', _currentVehicle.vin),
                _buildTableRow('Mileage', _currentVehicle.mileage),
                _buildTableRow('Fuel Capacity', _currentVehicle.fuelCapacity),
                // Add other properties as needed
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(value),
        ),
      ],
    );
  }
}
