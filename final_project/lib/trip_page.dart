import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import 'address_complete.dart';
import 'network_utility.dart';
import 'gas.dart';
import 'package:mapbox_polyline_points/mapbox_polyline_points.dart';

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

  MapboxMapController? _controller;
  String? routeGeometry;
  LatLng? _userLocation;
  bool isRoutePlotted = false;
  List<PointLatLng>? routePoints;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> fetchRouteInformation() async {
    String mapboxApiKey =
        "sk.eyJ1IjoianVzdGZhbCIsImEiOiJjbHBoMnFzOGYwM2o5MmlxeGM1MW5wamZoIn0.RFlNRhyj0xccr7MPoULncg";

    clearPolyline();
    String sourceAddress = sourceController.text;
    String destinationAddress = destinationController.text;

    if (sourceAddress.isEmpty || destinationAddress.isEmpty) {
      // Handle the case where either source or destination address is empty
      return;
    }

    try {
      List<Location> sourceLocations = await locationFromAddress(sourceAddress);
      List<Location> destinationLocations =
          await locationFromAddress(destinationAddress);

      print('Source Locations: $sourceLocations');
      print('Destination Locations: $destinationLocations');

      if (sourceLocations.isNotEmpty && destinationLocations.isNotEmpty) {
        LatLng sourceLatLng =
            LatLng(sourceLocations[0].latitude, sourceLocations[0].longitude);
        LatLng destinationLatLng = LatLng(destinationLocations[0].latitude,
            destinationLocations[0].longitude);

        print('Source LatLng: $sourceLatLng');
        print('Destination LatLng: $destinationLatLng');

        MapboxpolylinePoints mapboxPolylinePoints = MapboxpolylinePoints();
        MapboxPolylineResult result =
            await mapboxPolylinePoints.getRouteBetweenCoordinates(
          mapboxApiKey,
          PointLatLng(
              latitude: sourceLatLng.latitude,
              longitude: sourceLatLng.longitude),
          PointLatLng(
              latitude: destinationLatLng.latitude,
              longitude: destinationLatLng.longitude),
          TravelType.driving, // Specify your desired travel mode
        );

        if (result.points.isNotEmpty) {
          // The route points are available in result.points

          routePoints = result.points[0];

          // Now you can use the routePoints to draw polylines on the map or perform other tasks.
          drawPolylineOnMap();
          print('Route Points: $routePoints');
        } else {
          print('No route points available');
        }
      } else {
        print('Error geocoding addresses');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void drawPolylineOnMap() {
    // Check if the MapboxMapController is initialized
    if (_controller != null) {
      // Clear existing polylines on the map
      _controller!.clearLines();

      // Create a list of LatLng from PointLatLng
      List<LatLng> polylineLatLngs = routePoints!
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      // Draw polyline on the map
      _controller!.addLine(
        LineOptions(
          geometry: polylineLatLngs,
          lineColor: '#FF0000', // Adjust the color as needed
          lineWidth: 3.0, // Adjust the width as needed
        ),
      );
    }
  }

  void clearPolyline() {
  // Check if the MapboxMapController is initialized
  if (_controller != null) {
    // Clear existing polylines on the map
    _controller!.clearLines();
  }
}

  Future<void> placeAutocomplete(String query, bool isSource) async {
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
          if (isSource) {
            sourcePredictions = result.predictions!;
          } else {
            destinationPredictions = result.predictions!;
          }
        });
      }
    }
  }

  void updateSearchBar(
      String? selectedLocation, TextEditingController controller) {
    controller.text = selectedLocation ?? '';
    setState(() {
      sourcePredictions = [];
      destinationPredictions = [];
      isRoutePlotted = false;
    });
  }

  Future<void> _getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
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
        _userLocation = LatLng(position.latitude, position.longitude);
        _country = country;
      });
    } catch (e) {
      print('Error: $e');
    }
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
                      placeAutocomplete(value, true);
                      clearPolyline();
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
                          updateSearchBar(sourcePredictions[index].description,
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
                      placeAutocomplete(value, false);
                      clearPolyline();
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
                        title: Text(
                            destinationPredictions[index].description ?? ''),
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
            // Button to plot GPS route
            ElevatedButton(
              onPressed: () {
                // Check if the route is already plotted
                if (!isRoutePlotted) {
                  // Call the method to fetch and plot the route
                  fetchRouteInformation();
                }
              },
              child: Text('Plot Route'),
            ),
            Container(
              height: 300, // Adjust the height as needed
              child: MapboxMap(
                accessToken:
                    "sk.eyJ1IjoianVzdGZhbCIsImEiOiJjbHBoMnFzOGYwM2o5MmlxeGM1MW5wamZoIn0.RFlNRhyj0xccr7MPoULncg",
                initialCameraPosition: CameraPosition(
                  target:
                      LatLng(_userLocation!.latitude, _userLocation!.longitude),
                      //LatLng(43.9515, -78.8567),
                  zoom: 12.0,
                ),
                onMapCreated: (MapboxMapController controller) {
                  _controller = controller;
                  // Ensure that the route is plotted when the map is created
                  if (isRoutePlotted) {
                    fetchRouteInformation();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
