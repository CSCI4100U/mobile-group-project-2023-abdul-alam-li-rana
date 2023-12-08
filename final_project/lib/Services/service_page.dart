import 'dart:async';
import 'package:final_project/Services/add_service.dart';
import 'package:final_project/Functionality/dbops.dart';
import 'package:final_project/Services/service.dart';
import 'package:flutter/material.dart';
import 'service_details_page.dart';
import 'package:final_project/MainPages/sidebar.dart';
import 'package:final_project/Services/edit_service.dart';


class ServicePage extends StatefulWidget {
  @override
  _ServiceHomePageState createState() => _ServiceHomePageState();
}

class _ServiceHomePageState extends State<ServicePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late Service noSelection;
  late Service selectedService;
  late StreamController<List<dynamic>> _servicesStreamController;
  late ServiceHoverController _hoverController;

  @override
  void initState() {
    super.initState();
    noSelection = Service(
      vehicle: '',
      serviceName: '',
      serviceDate: '',
      serviceCost: '',
      serviceMileage: '',
      serviceDescription: '',
      carId: '',
    );
    selectedService = noSelection;
    _servicesStreamController = StreamController<List<dynamic>>.broadcast();
    _hoverController = ServiceHoverController();
    fetchServices();
  }

  Future<void> fetchServices() async {
    final fetchedServices = await getService();
    _servicesStreamController.add(fetchedServices);
  }

  @override
  void dispose() {
    _servicesStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[900],
        title: Text('Service List', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.white, // Set the color to white
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        actions: [
          if (selectedService.carId != '')
            Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.edit,
                    color: Colors.white, // Set the color to white
                  ),
                  onPressed: () {
                    _editService(selectedService);
                  },
                ),
                IconButton(
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.white, // Set the color to white
                  ),
                  onPressed: () {
                    _expandService(selectedService);
                  },
                ),
              ],
            ),
        ],
      ),
      body: Container(
        color: Colors.redAccent,
        child: StreamBuilder<List<dynamic>>(
          stream: _servicesStreamController.stream,
          initialData: [],
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Display a circular progress indicator while data is being fetched.
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              // Handle the error state.
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
            final List<dynamic> services = snapshot.data ?? [];
            return (services.isEmpty
                ? Center(child: Text('No data'))
                : ListView.builder(
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return Dismissible(
                        key: Key(service.carId),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          _deleteService(service);
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
                        child: ServiceHoverRegion(
                          service: service,
                          hoverController: _hoverController,
                          onTap: () {
                            setState(() {
                              selectedService = service;
                            });
                          },
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.symmetric(
                                horizontal: 10.0, vertical: 5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedService.carId == service.carId
                                      ? Colors.black
                                      : Colors.transparent,
                                  width: 2.0,
                                ),
                              ),
                              child: ListTile(
                                title: Text(
                                  '${service.serviceName} (${service.vehicle})',
                                  style: TextStyle(
                                    fontSize: 22,
                                    color: _hoverController.isHovered(service)
                                        ? Colors.blue
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ));
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _navigateToAddService();
        },
        backgroundColor: Colors.grey[900], // Set your desired background color
        foregroundColor: Colors.white, // Set text/icon color
        icon: Icon(Icons.add),
        label: Text('Add a Service'),
      ),
      drawer: SideMenu(parentContext: context),
    );
  }

  void _navigateToAddService() async {
    final addedService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddService(),
      ),
    );

    if (addedService != null) {
      fetchServices();
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
                  _editService(selectedService);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  _deleteService(selectedService);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _editService(Service service) async {
    final updatedService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditService(serviceToEdit: service),
      ),
    );

    if (updatedService != null) {
      fetchServices();
      setState(() {
        selectedService = noSelection;
      });
    }
  }



  void _expandService(Service service) async {
    final updatedService = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ServiceDetails(service: service),
      ),
    );
  }

  void _deleteService(Service service) async {
    await deleteService(service.id);
    await fetchServices();
    setState(() {
      selectedService = noSelection;
    });
  }
}

class ServiceHoverController {
  final Set<Service> _hoveredServices = {};

  void hover(Service service) {
    _hoveredServices.add(service);
  }

  void unhover(Service service) {
    _hoveredServices.remove(service);
  }

  bool isHovered(Service service) {
    return _hoveredServices.contains(service);
  }
}

class ServiceHoverRegion extends StatefulWidget {
  final Service service;
  final ServiceHoverController hoverController;
  final VoidCallback onTap;
  final Widget child;

  ServiceHoverRegion({
    required this.service,
    required this.hoverController,
    required this.onTap,
    required this.child,
  });

  @override
  _ServiceHoverRegionState createState() => _ServiceHoverRegionState();
}

class _ServiceHoverRegionState extends State<ServiceHoverRegion> {
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap();
        setState(() {
          isTapped = true;
        });
        Future.delayed(Duration(milliseconds: 150), () {
          setState(() {
            isTapped = false;
          });
        });
      },
      child: MouseRegion(
        onEnter: (_) {
          widget.hoverController.hover(widget.service);
        },
        onExit: (_) {
          widget.hoverController.unhover(widget.service);
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: isTapped
                  ? Colors.blue
                  : widget.hoverController.isHovered(widget.service)
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
