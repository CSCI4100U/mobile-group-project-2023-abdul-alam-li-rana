import 'dart:async';
import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'add_vehicle.dart';
import 'edit_vehicle.dart';
import 'vehicle_details_page.dart';

class VehicleHomePage extends StatefulWidget {
  @override
  _VehicleHomePageState createState() => _VehicleHomePageState();
}

class _VehicleHomePageState extends State<VehicleHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Vehicle noSelection;
  late Vehicle selectedVehicle;
  late StreamController<List<dynamic>> _vehiclesStreamController;
  late VehicleHoverController _hoverController;

  @override
  void initState() {
    super.initState();
    noSelection = Vehicle(id: '', make: '', model: '', year: '', vin: '', color: '');
    selectedVehicle = noSelection;
    _vehiclesStreamController = StreamController<List<dynamic>>.broadcast();
    _hoverController = VehicleHoverController();
    fetchVehicles();
  }

  Future<void> fetchVehicles() async {
    final fetchedVehicles = await getVehicle();
    _vehiclesStreamController.add(fetchedVehicles);
  }

  @override
  void dispose() {
    _vehiclesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Vehicle List'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          if (selectedVehicle.id != '')
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editVehicle(selectedVehicle);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _deleteVehicle(selectedVehicle);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.favorite),
                  onPressed: () {
                    _expandVehicle(selectedVehicle);
                  },
                ),
              ],
            ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.cyan, Colors.blue],
          ),
        ),
        child: StreamBuilder<List<dynamic>>(
          stream: _vehiclesStreamController.stream,
          initialData: [],
          builder: (context, snapshot) {
            final List<dynamic> vehicles = snapshot.data ?? [];
            return (vehicles.isEmpty
                ? Center(child: Text('No data'))
                : ListView.builder(
                    itemCount: vehicles.length,
                    itemBuilder: (context, index) {
                      final vehicle = vehicles[index];
                      return Dismissible(
                        key: Key(vehicle.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteVehicle(vehicle);
                        },
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.only(right: 16),
                          alignment: Alignment.centerRight,
                          child: Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: VehicleHoverRegion(
                          vehicle: vehicle,
                          hoverController: _hoverController,
                          onTap: () {
                            setState(() {
                              selectedVehicle = vehicle;
                            });
                          },
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                            child: ListTile(
                              title: Text(
                                '${vehicle.make} ${vehicle.model} (${vehicle.year})',
                                style: TextStyle(
                                  fontSize: 22,
                                  color: _hoverController.isHovered(vehicle)
                                      ? Colors.blue
                                      : Colors.black,
                          ),
                        ),
                      ),
                    ),
                ));
              },
            ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _navigateToAddVehicle();
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      drawer: SideMenu(parentContext: context),
    );
  }


  void _navigateToAddVehicle() async {
    final addedVehicle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddVehicle(),
      ),
    );

    if (addedVehicle != null) {
      fetchVehicles();
    }
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.edit),
                title: Text('Edit'),
                onTap: () {
                  Navigator.pop(context);
                  _editVehicle(selectedVehicle);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteVehicle(selectedVehicle);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editVehicle(Vehicle vehicle) async {
    final updatedVehicle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditVehicle(vehicleToEdit: vehicle),
      ),
    );

    if (updatedVehicle != null) {
      fetchVehicles();
      setState(() {
        selectedVehicle = noSelection;
      });
    }
  }


  void _expandVehicle(Vehicle vehicle) async {
    final updatedVehicle = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VehicleDetails(vehicle: vehicle),
      ),
    );


  }

  void _deleteVehicle(Vehicle vehicle) async {
    await deleteVehicle(vehicle.id);
    await fetchVehicles();
    setState(() {
      selectedVehicle = noSelection;
    });
  }
}

class VehicleHoverController {
  final Set<Vehicle> _hoveredVehicles = {};

  void hover(Vehicle vehicle) {
    _hoveredVehicles.add(vehicle);
  }

  void unhover(Vehicle vehicle) {
    _hoveredVehicles.remove(vehicle);
  }

  bool isHovered(Vehicle vehicle) {
    return _hoveredVehicles.contains(vehicle);
  }
}

class VehicleHoverRegion extends StatefulWidget {
  final Vehicle vehicle;
  final VehicleHoverController hoverController;
  final VoidCallback onTap;
  final Widget child;

  VehicleHoverRegion({
    required this.vehicle,
    required this.hoverController,
    required this.onTap,
    required this.child,
  });

  @override
  _VehicleHoverRegionState createState() => _VehicleHoverRegionState();
}

class _VehicleHoverRegionState extends State<VehicleHoverRegion> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) {
          widget.hoverController.hover(widget.vehicle);
        },
        onExit: (_) {
          widget.hoverController.unhover(widget.vehicle);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: widget.hoverController.isHovered(widget.vehicle)
                  ? Colors.blue
                  : Colors.transparent,
              width: 2.0,
            ),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}