import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_gl/mapbox_gl.dart';
import '../Functionality/address_complete.dart';
import '../Functionality/network_utility.dart';
import '../Functionality/api_utils.dart';
import 'package:mapbox_polyline_points/mapbox_polyline_points.dart';
import '../MainPages/sidebar.dart';
import 'package:final_project/Vehicles/vehicle.dart';
import '../Functionality/dbops.dart';
import 'package:final_project/Trip/trip_details.dart';
import 'package:final_project/Vehicles/vehicle_dropdown.dart';

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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  MapboxMapController? _controller;
  String? routeGeometry;
  LatLng? _userLocation;
  bool isRoutePlotted = false;
  double? _totalDistance;
  double? _gasPrice;
  List<PointLatLng>? routePoints;

  Vehicle? _selectedVehicle;
  List<Vehicle> _userVehicles = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadUserVehicles();
  }

  Future<void> _loadUserVehicles() async {
    List<Vehicle> vehicles = await getVehicle();
    setState(() {
      _userVehicles = vehicles;
    });
  }

  void _onVehicleSelected(Vehicle? selectedVehicle) {
    setState(() {
      _selectedVehicle = selectedVehicle;
    });

    if (_selectedVehicle != null) {
      final snackBar = SnackBar(
        content: Text(
          '${_selectedVehicle!.make} ${_selectedVehicle!.model} (${_selectedVehicle!.year}) Selected.',
        ),
        duration: Duration(seconds: 2),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future<void> fetchRouteInformation() async {
    String mapboxApiKey =
        "sk.eyJ1IjoianVzdGZhbCIsImEiOiJjbHBoMnFzOGYwM2o5MmlxeGM1MW5wamZoIn0.RFlNRhyj0xccr7MPoULncg";

    clearPolyline();
    String sourceAddress = sourceController.text;
    String destinationAddress = destinationController.text;
    double routeDistance = 0.0;

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
        _controller?.animateCamera(CameraUpdate.newLatLng(sourceLatLng));

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

          for (int i = 0; i < routePoints!.length - 1; i++) {
            double segmentDistance = Geolocator.distanceBetween(
              routePoints![i].latitude,
              routePoints![i].longitude,
              routePoints![i + 1].latitude,
              routePoints![i + 1].longitude,
            );

            routeDistance += segmentDistance;
          }

          setState(() {
            _totalDistance = routeDistance / 1000.0; // Convert to kilometers
          });

          //use routePoints to draw polylines on the map or perform other tasks.
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

      if (_controller != null) {
        _controller!.animateCamera(CameraUpdate.newLatLng(_userLocation!));
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _checkGasPrice() async {
    try {
      String? gasPriceString =
      await getGasPrice(); // Assuming getGasPrice() returns a Future<String>

      double? gasPrice;

      if (gasPriceString != null && gasPriceString != "None") {
        print(gasPriceString);
        gasPrice = double.tryParse(gasPriceString);

        if (gasPrice == null) {
          print('Error: Unable to parse gasPriceString to double');
        }
      } else {
        print('Warning: Gas price is null. Using default value.');
      }

      setState(() {
        _gasPrice =
            gasPrice ?? 2.50; // Use the parsed gas price or default to $2.50
        print(_gasPrice);
      });
    } catch (error) {
      print('Error fetching or processing gas price: $error');
      setState(() {
        _gasPrice = 2.50; // Default to $2.50 in case of an error
      });
    }
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
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Trip Planner',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Builder(
        builder: (BuildContext scaffoldContext) => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height -
                Scaffold.of(scaffoldContext).appBarMaxHeight!,
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                StyledInputBox(
                  controller: sourceController,
                  hintText: 'From',
                  icon: Icons.location_pin,
                ),

                if (sourcePredictions.isNotEmpty)
                  StyledPredictionsList(
                    predictions: sourcePredictions,
                    onTap: (selectedLocation) {
                      updateSearchBar(selectedLocation, sourceController);
                      FocusScope.of(context).unfocus();
                    },
                  ),

                SizedBox(height: 20),

                StyledInputBox(
                  controller: destinationController,
                  hintText: 'To',
                  icon: Icons.location_pin,
                ),

                if (destinationPredictions.isNotEmpty)
                  StyledPredictionsList(
                    predictions: destinationPredictions,
                    onTap: (selectedLocation) {
                      updateSearchBar(selectedLocation, destinationController);
                      FocusScope.of(context).unfocus();
                    },
                  ),

                VehicleDropdown(
                  vehicles: _userVehicles,
                  onVehicleSelected: _onVehicleSelected,
                  dropdownColor: Colors.indigo[300]!,
                ),

                SizedBox(height: 20),

                StyledButton(
                  onPressed: () {
                    _checkGasPrice();
                    FocusScope.of(context).unfocus();
                  },
                  label: 'Check Gas Price',
                  icon: Icons.local_gas_station,  // Provide the icon parameter here
                  buttonColor: Colors.indigo[600]!,
                  labelColor: Colors.white,
                ),

                StyledButton(
                  onPressed: () {
                    if (!isRoutePlotted) {
                      fetchRouteInformation();
                      FocusScope.of(context).unfocus();
                    }
                  },
                  label: 'Plot Route',
                  icon: Icons.not_interested,  // Empty or placeholder icon
                  buttonColor: Colors.indigo[600]!,
                  labelColor: Colors.white,
                ),


                Container(
                  height: 300,
                  child: MapboxMap(
                    accessToken:
                    "sk.eyJ1IjoianVzdGZhbCIsImEiOiJjbHBoMnFzOGYwM2o5MmlxeGM1MW5wamZoIn0.RFlNRhyj0xccr7MPoULncg",
                    initialCameraPosition: CameraPosition(
                      target: _userLocation ?? LatLng(0.0, 0.0),
                      zoom: 12.0,
                    ),
                    onMapCreated: (MapboxMapController controller) {
                      _controller = controller;
                      if (isRoutePlotted) {
                        fetchRouteInformation();
                      }
                    },
                  ),
                ),

                TripDetailsWidget(
                  totalDistance: _totalDistance,
                  gasPrice: _gasPrice,
                  vehicle: _selectedVehicle ?? null,
                ),
              ],
            ),
          ),
        ),
      ),
      backgroundColor: Colors.indigo[400],
      drawer: SideMenu(parentContext: context),
    );
  }
}

class StyledInputBox extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;

  const StyledInputBox({
    required this.controller,
    required this.hintText,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: TextField(
        style: TextStyle(color: Colors.white),
        controller: controller,
        onChanged: (value) {
          // Your existing onChanged logic
        },
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: Icon(icon, color: Colors.indigo[300]),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.indigo[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.indigo[300]!),
          ),
        ),
      ),
    );
  }
}

class StyledPredictionsList extends StatelessWidget {
  final List<AutocompletePrediction> predictions;
  final Function(String?) onTap;

  const StyledPredictionsList({
    required this.predictions,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          final prediction = predictions[index];
          return ListTile(
            title: Text(prediction.description ?? ""),
            onTap: () {
              onTap(prediction.description);
            },
          );
        },
      ),
    );
  }
}

class StyledButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String label;
  final IconData icon;  // Add this line
  final Color buttonColor;
  final Color labelColor;

  const StyledButton({
    required this.onPressed,
    required this.label,
    required this.icon,  // Add this line
    required this.buttonColor,
    required this.labelColor,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white),
            SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(color: labelColor, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}

