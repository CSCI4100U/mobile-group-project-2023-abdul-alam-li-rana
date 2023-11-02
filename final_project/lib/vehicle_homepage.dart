import 'package:final_project/vehicle_formpage.dart';
import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'add_vehicle.dart';
import 'edit_vehicle.dart';

class VehicleHomePage extends StatefulWidget {
  @override
  _VehicleHomePageState createState() => _VehicleHomePageState();
}

class _VehicleHomePageState extends State<VehicleHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Vehicle noSelection = Vehicle(
    id: '',
    make: '',
    model: '',
    year: '',
    vin: '',
    color: '',
  );
  Vehicle selectedVehicle = Vehicle(
    id: '',
    make: '',
    model: '',
    year: '',
    vin: '',
    color: '',
  );
  List<dynamic> vehicles = [];

  @override
  void initState() {
    super.initState();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final fetchedVehicles = await getVehicle();
    setState(() {
      vehicles = fetchedVehicles;
    });
    print("Vehicles fetched!");
    print(vehicles.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.greenAccent,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('Vehicle List'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              if (selectedVehicle.id != "") {
                deleteVehicle(selectedVehicle.id);
                fetchVehicles();
                setState(() {
                  selectedVehicle = noSelection;
                });
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () async {
              if (selectedVehicle.id != "") {
                final updatedVehicle = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        EditVehicle(vehicleToEdit: selectedVehicle),
                  ),
                );

                if (updatedVehicle != null) {
                  setState(() {
                    fetchVehicles();
                  });
                }
              }
            },
          ),
        ],
      ),
      body: (vehicles.isEmpty
          ? Center(child: Text('No data'))
          : ListView.builder(
              itemCount: vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = vehicles[index];
                return ListTile(
                  title: Text(
                    '${vehicle.make} ${vehicle.model} (${vehicle.year})',
                    style: TextStyle(
                      fontSize: 22,
                      color:
                          (selectedVehicle == vehicle) ? Colors.lightGreen : Colors.black,
                    ),
                  ),
                  tileColor:
                      (selectedVehicle.id == vehicle.id) ? Colors.lightBlue : null,
                  onTap: () {
                    setState(() {
                      print("Vehicle is selected");
                      selectedVehicle = vehicle;
                    });
                  },
                );
              },
            )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final addedVehicle = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddVehicle(),
            ),
          );

          if (addedVehicle != null) {
            setState(() {
              fetchVehicles();
            });
          }
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
      ),
      drawer: SideMenu(), // Add the SideMenu to the Drawer
       
    );
  }
}
