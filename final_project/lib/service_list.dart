import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'dbops.dart';
import 'edit_service.dart';
import 'service.dart';
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
        return CircularProgressIndicator();
      } else if (snapshot.hasError) {
        return Text('Error: ${snapshot.error}');
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('No services available.');
      } else {
        List<Map<String, dynamic>> services = snapshot.data!;
        double totalCost = calculateTotalCost(services);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Services',
                    style: TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Icon(Icons.local_car_wash),
                ],
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoCard('Total Services', '${services.length}'),
                  _buildInfoCard('Total Cost', '\$${totalCost.toStringAsFixed(2)}'),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 150,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: services.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> service = services[index];
                  Service serviceObj = Service(
                    id: service['id'] ?? '',
                    vehicle: service['vehicle'] ?? '',
                    serviceName: service['serviceName'] ?? '',
                    carId: service['carId'] ?? '',
                    serviceDate: service['serviceDate'] ?? '',
                    serviceCost: service['serviceCost'] ?? '0.0',
                    serviceDescription: service['serviceDescription'] ?? '',
                    serviceMileage: service['serviceMileage'] ?? '',
                  );
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditService(serviceToEdit: serviceObj),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                          side: BorderSide(color: Colors.yellow, width: 2.0),
                        ),
                        color: Colors.red,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                             
                              Text(
                                '${service['serviceName'] ?? ''}',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                    textAlign: TextAlign.center, // Center align text

                              ),
                              SizedBox(height: 8),

                              Text(
                                '${service['serviceDate'] ?? ''}',
                                style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                  textAlign: TextAlign.center, // Center align text

                              ),
                              SizedBox(height: 8),

                              Text(
                                '\$${service['serviceCost'] ?? '0.0'}',
                                style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    textAlign: TextAlign.center, // Center align text
                                        
                              ),
                            ],
                          ),
                        ),
                      ),
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

  double calculateTotalCost(List<Map<String, dynamic>> services) {
    return services
        .map<double>((service) {
      String costString = service['serviceCost'] ?? '0.0';
      return double.tryParse(costString) ?? 0.0;
    })
        .reduce((value, element) => value + element);
  }

}


Widget _buildInfoCard(String title, String value) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8.0),
      side: BorderSide(color: Colors.yellow, width: 2.0),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    ),
  );
}