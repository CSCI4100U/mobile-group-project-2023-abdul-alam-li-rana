import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'address_complete.dart';
import 'network_utility.dart';
import 'gas.dart';

class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String _country = 'Unknown';
  String _source = 'Source';
  String _destination = 'Destination';
  List<AutocompletePrediction> sourcePredictions = [];
  List<AutocompletePrediction> destinationPredictions = [];

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Future<void> placeAutocomplete(String query, bool isSource) async {
    // ... (same as before)
  }

  Future<void> getLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        return;
      }
    }

    // Now you have the permission to access the location
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      double latitude = position.latitude;
      double longitude = position.longitude;

      List<Placemark> placemarks =
          await placemarkFromCoordinates(latitude, longitude);

      if (placemarks != null && placemarks.isNotEmpty) {
        Placemark mostLikely = placemarks[0];
        setState(() {
          _country = mostLikely.country ?? 'Unknown';
          _source = _country; // Set the source to the country for demonstration
        });
        print('Country: $_country');
      } else {
        setState(() {
          _country = 'Unknown';
          _source = _country;
        });
      }
    } catch (e) {
      print(e.toString());
      setState(() {
        _country = 'Error';
        _source = _country;
      });
    }
  }

  void updateSearchBar(String? selectedLocation, TextEditingController controller) {
    controller.text = selectedLocation ?? '';
    setState(() {
      sourcePredictions = [];
      destinationPredictions = [];
    });
  }

  @override
  void initState() {
    super.initState();
    getLocation();
  }
  

  void _checkGasPrice() {
    String gasPrice = "2.50";
    getGasPrice(); 
    _displayGasPrice(gasPrice);
  }

  void _displayGasPrice(String gasPrice) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Container(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_gas_station, color: Colors.blue),
              SizedBox(width: 10),
              Text(
                'Gas Price for $_country: \$ $gasPrice',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        duration: Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trip Planner'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sourceController,
                    onChanged: (value) {
                      placeAutocomplete(value,true);
                    },
                    decoration: InputDecoration(
                      labelText: 'From',
                      prefixIcon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              ],
            ),
            if (sourcePredictions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: sourcePredictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(sourcePredictions[index].description ?? ''),
                        onTap: () {
                          updateSearchBar(
                              sourcePredictions[index].description,
                              sourceController);
                        },
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: destinationController,
                    onChanged: (value) {
                      placeAutocomplete(value,false);
                    },
                    decoration: InputDecoration(
                      labelText: 'To',
                      prefixIcon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              ],
            ),
            if (destinationPredictions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: destinationPredictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(destinationPredictions[index].description ?? ''),
                        onTap: () {
                          updateSearchBar(
                              destinationPredictions[index].description,
                              destinationController);
                        },
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),


            GestureDetector(
              onTap: _checkGasPrice,
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_gas_station, color: Colors.white),
                    SizedBox(width: 10),
                    Text(
                      'Check Gas Price',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




