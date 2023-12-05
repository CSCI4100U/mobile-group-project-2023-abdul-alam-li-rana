import 'package:flutter/material.dart';
import 'vehicle.dart';

class VehicleDropdown extends StatefulWidget {
  final List<Vehicle> vehicles;
  final Function(Vehicle?) onVehicleSelected;
  final Color dropdownColor;

  const VehicleDropdown({
    required this.vehicles,
    required this.onVehicleSelected,
    this.dropdownColor = Colors.white,
    Key? key,
  }) : super(key: key);

  @override
  _VehicleDropdownState createState() => _VehicleDropdownState();
}

class _VehicleDropdownState extends State<VehicleDropdown> {
  Vehicle? _selectedVehicle;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DropdownMenuItem<Vehicle>>>(
      future: _buildDropdownMenuItems(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          return DropdownButton<Vehicle>(
            dropdownColor: widget.dropdownColor,
            value: _selectedVehicle,
            items: snapshot.data ?? [],
            onChanged: (selectedVehicle) {
              setState(() {
                _selectedVehicle = selectedVehicle;
              });
              widget.onVehicleSelected(selectedVehicle);
            },
            hint: Text('Select a Vehicle'),
            isExpanded: true,
            underline: Container(),
          );
        }
      },
    );
  }

  Future<List<DropdownMenuItem<Vehicle>>> _buildDropdownMenuItems() async {
    return widget.vehicles.map((Vehicle vehicle) {
      return DropdownMenuItem<Vehicle>(
        value: vehicle,
        key: ValueKey<String>(vehicle.id),
        child: Text("${vehicle.make} ${vehicle.model} (${vehicle.year})"),
      );
    }).toList();
  }
}
