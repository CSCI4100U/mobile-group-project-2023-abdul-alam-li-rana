import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dbops.dart';
import 'vehicle.dart';
class VehicleServicesList extends StatefulWidget {
  final Vehicle vehicle;

  VehicleServicesList({required this.vehicle});

  @override
  _VehicleServicesListState createState() => _VehicleServicesListState();
}

class _VehicleServicesListState extends State<VehicleServicesList> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadServices(widget.vehicle),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator(); // or a loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No services available.');
        } else {
          List<Map<String, dynamic>> services = snapshot.data!;
          double totalCost = services
              .map<double>((service) => (service['cost'] ?? 0.0) as double)
              .reduce((value, element) => value + element);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Services',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text('Total Services: ${services.length}'),
              Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
              SizedBox(height: 10),
              Container(
                height: 200, // Adjust the height accordingly
                child: ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    Map<String, dynamic> service = services[index];
                    return ListTile(
                      title: Text(service['name'] ?? ''),
                      subtitle: Text(
                        'Date: ${service['date'] ?? ''}\nCost: \$${(service['cost'] ?? 0.0).toStringAsFixed(2)}',
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }


}
