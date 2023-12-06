import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OilChangeIntervalPage extends StatefulWidget {
  final String vehicleId;

  OilChangeIntervalPage({required this.vehicleId});

  @override
  _OilChangeIntervalPageState createState() => _OilChangeIntervalPageState();
}

class _OilChangeIntervalPageState extends State<OilChangeIntervalPage> {
  final TextEditingController _currentMileageController = TextEditingController();
  final TextEditingController _lastOilChangeMileageController = TextEditingController();
  final int fixedOilChangeInterval = 8000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Oil Change Interval'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Calculate Oil Change: ${widget.vehicleId}',
              style: TextStyle(fontSize: 20.0),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _currentMileageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Current Mileage'),
            ),
            SizedBox(height: 10.0),
            TextField(
              controller: _lastOilChangeMileageController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(labelText: 'Last Oil Change Mileage'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                _calculateNextOilChangeInterval();
              },
              child: Text('Calculate Next Oil Change Interval'),
            ),
            SizedBox(height: 20.0),
            Text(
              'Next Oil Change Interval: ${_calculateNextOilChangeInterval()} kms',
              style: TextStyle(fontSize: 16.0),
            ),
          ],
        ),
      ),
    );
  }

  int _calculateNextOilChangeInterval() {
    int currentMileage = int.tryParse(_currentMileageController.text) ?? 0;
    int lastOilChangeMileage = int.tryParse(_lastOilChangeMileageController.text) ?? 0;
    int distanceSinceLastChange = currentMileage - lastOilChangeMileage;

    print('Current Mileage: $currentMileage');
    print('Last Oil Change Mileage: $lastOilChangeMileage');
    print('Distance Since Last Change: $distanceSinceLastChange');

    int nextOilChangeInterval = fixedOilChangeInterval - (distanceSinceLastChange % fixedOilChangeInterval);
    print('Next Oil Change Interval: $nextOilChangeInterval');

    return nextOilChangeInterval;
  }



  // Implement your own storage mechanism (e.g., use a database)
  void storeOilChangeInformation(String vehicleId, int currentMileage, int lastOilChangeMileage) {
    // In a real app, use a database or other persistent storage
    // Here, we're using shared preferences for simplicity
    // You can replace this with your preferred storage mechanism

    // Storing the information
    // This is just an example, you might need to use a database or other storage
    // to store and retrieve this information.
    // Also, handle error cases appropriately in a production scenario.
    // You may want to use a dedicated database for this purpose.
    // For simplicity, we're using shared preferences here.

    // In a real app, you would use a database instead of shared preferences
    // and handle the storage/retrieval more robustly.

    // Example using shared preferences (replace with your preferred storage):
    // Storing the information
    SharedPreferences.getInstance().then((prefs) {
      prefs.setInt('${vehicleId}_currentMileage', currentMileage);
      prefs.setInt('${vehicleId}_lastOilChangeMileage', lastOilChangeMileage);
    });
  }

  // You can retrieve the stored information similarly
  Future<Map<String, int>> retrieveOilChangeInformation(String vehicleId) async {
    // Retrieve the information
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentMileage = prefs.getInt('${vehicleId}_currentMileage') ?? 0;
    int lastOilChangeMileage = prefs.getInt('${vehicleId}_lastOilChangeMileage') ?? 0;

    return {'currentMileage': currentMileage, 'lastOilChangeMileage': lastOilChangeMileage};
  }
}
