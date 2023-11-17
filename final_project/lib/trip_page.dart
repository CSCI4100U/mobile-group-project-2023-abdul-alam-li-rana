import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'address_complete.dart';
import 'network_utility.dart';
class TripPage extends StatefulWidget {
  @override
  _TripPageState createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String _country = 'Unknown';
  String _source = 'Source';
  String _destination = 'Destination';
  List<AutocompletePrediction> placePredictions = [];

  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  Future<void> placeAutocomplete(String query) async {
    Uri uri = Uri.https(
      "maps.googleapis.com",
      'maps/api/place/autocomplete/json',
      {
        "input": query,
        "key": 'AIzaSyCK3IDVz6IGqf09tf0dUHf1r_7Ig_tq4N0',
      },
    );
    String? response = await NetworkUtility.fetchUrl(uri);

    if (response != null) {
      PlaceAutocompleteResponse result =
          PlaceAutocompleteResponse.parseAutocompleteResult(response);
      if (result.predictions != null) {
        setState(() {
          placePredictions = result.predictions!;
        });
      }
    }
  }

  void updateSearchBar(String? selectedLocation, TextEditingController controller) {
  controller.text = selectedLocation ?? '';
  setState(() {
    placePredictions = [];
  });
}

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Handle denied permission
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        // Handle denied forever permission
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      String country = placemarks.first.country ?? 'Unknown';

      setState(() {
        _country = country;
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  void _checkGasPrice() {
    String gasPrice = '2.50'; // Placeholder value
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
            // Section for source and destination
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: sourceController,
                    onChanged: (value) {
                      placeAutocomplete(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'From',
                      prefixIcon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              ],
            ),
            if (placePredictions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: placePredictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(placePredictions[index].description ?? ''),
                        onTap: () {
                          updateSearchBar(
                              placePredictions[index].description,
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
                      placeAutocomplete(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'To',
                      prefixIcon: Icon(Icons.location_pin),
                    ),
                  ),
                ),
              ],
            ),
            if (placePredictions.isNotEmpty)
              Expanded(
                child: Container(
                  color: Colors.grey[200],
                  child: ListView.builder(
                    itemCount: placePredictions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(placePredictions[index].description ?? ''),
                        onTap: () {
                          updateSearchBar(
                              placePredictions[index].description,
                              destinationController);
                        },
                      );
                    },
                  ),
                ),
              ),
            SizedBox(height: 20),

            // Section for checking gas prices
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




