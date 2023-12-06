import 'package:flutter/material.dart';
import 'sidebar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'oil_change_interval_page.dart'; // Import the OilChangeIntervalPage

class ServicePage extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.redAccent,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Service Tab'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StaggeredGridView.countBuilder(
          crossAxisCount: 2,
          itemCount: services.length,
          staggeredTileBuilder: (int index) =>
              StaggeredTile.fit(index.isEven ? 1 : 2),
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          itemBuilder: (BuildContext context, int index) {
            if (services[index].title == 'Oil Change Interval') {
              return _buildOilChangeButton(context, services[index]);
            } else {
              return _buildServiceCard(context, services[index]);
            }
          },
        ),
      ),
      drawer: SideMenu(parentContext: context),
    );
  }

  Widget _buildServiceCard(BuildContext context, Service service) {
    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle service item click
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                service.icon,
                height: 80.0,
                width: 80.0,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              SizedBox(height: 16.0),
              Text(
                service.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOilChangeButton(BuildContext context, Service service) {
    // Assuming you have a vehicleId available, replace 'your_vehicle_id' with the actual id
    String vehicleId = 'your_vehicle_id';

    return Card(
      elevation: 4.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the OilChangeIntervalPage when tapped
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OilChangeIntervalPage(vehicleId: vehicleId),
            ),
          );
        },
        borderRadius: BorderRadius.circular(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                service.icon,
                height: 80.0,
                width: 80.0,
                color: Theme
                    .of(context)
                    .primaryColor,
              ),
              SizedBox(height: 16.0),
              Text(
                service.title,
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8.0),
              Text(
                service.description,
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

  class Service {
  final String icon;
  final String title;
  final String description;

  Service({
    required this.icon,
    required this.title,
    required this.description,
  });
}

final List<Service> services = [
  Service(
    icon: 'assets/icons/car.svg',
    title: 'Vehicle Maintenance',
    description: 'Regular checkups and maintenance for your vehicles.',
  ),

  Service(
    icon: 'assets/icons/trip.svg',
    title: 'Trip Planning',
    description: 'Plan your trips efficiently with our trip planning services.',
  ),
  Service(
    icon: 'assets/icons/service.svg',
    title: 'Service Requests',
    description: 'Request and schedule services for your vehicles.',
  ),
  Service(
    icon: 'assets/icons/help.svg',
    title: '24/7 Support',
    description: 'Always here to assist you with our 24/7 customer support.',
  ),

  Service(
    icon: 'assets/icons/oil-change.svg',
    title: 'Oil Change Interval',
    description: 'Track and schedule your oil change intervals.',
  ),
];
