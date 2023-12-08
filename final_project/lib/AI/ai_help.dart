import 'package:flutter/material.dart';
import 'package:final_project/Vehicles/vehicle.dart';
import 'package:final_project/Vehicles/vehicle_dropdown.dart';
import '../MainPages/sidebar.dart';
import '../Functionality/dbops.dart';
import 'help_page.dart';
import '../Functionality/api_utils.dart';

class AiHelp extends StatefulWidget {
  @override
  _AiHelpState createState() => _AiHelpState();
}

class _AiHelpState extends State<AiHelp> {
  int _selectedIndex = 1;
  List<Vehicle> _userVehicles = [];
  Vehicle? _selectedVehicle;
  String _description = '';
  String _apiResponse = '';

  final TextEditingController _descriptionController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _loadUserVehicles();
  }

  Future<void> _loadUserVehicles() async {
    List<Vehicle> vehicles = await getVehicle();
    setState(() {
      _userVehicles = vehicles;
    });
  }
  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
  void _getHelp() async {
    if (_selectedVehicle == null || _description.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Missing Information'),
            content: Text('Please select a vehicle and enter a description.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(); // Dismiss the dialog
                },
              ),
            ],
          );
        },
      );
      return;
    }


    FocusScope.of(context).unfocus();

    showLoadingIndicator();
    String apiResult = await getAIHelp(_description, _selectedVehicle);

    Navigator.of(context, rootNavigator: true).pop();

    if (apiResult == "False") {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('AI help is not available right now.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      // If API call succeeds
      setState(() {
        _apiResponse = apiResult;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('AI Help'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: SideMenu(parentContext: context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VehicleDropdown(
              vehicles: _userVehicles,
              onVehicleSelected: _onVehicleSelected,
            ),
            SizedBox(height: 20),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                labelText: 'Describe your problem',
              ),
              maxLength: 500,
              maxLines: null,
              onChanged: (value) {
                _description = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getHelp,
              style: ElevatedButton.styleFrom(
                primary: Colors.amber,
                padding: EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: Text(
                'Get Help',
                style: TextStyle(fontSize: 18),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    _apiResponse,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.grey[800],
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[500],
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'General Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'AI Help',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HelpPage(),
          ),
        );
      }
    });
  }

  void _onVehicleSelected(Vehicle? selectedVehicle) {
    setState(() {
      _selectedVehicle = selectedVehicle;
    });
  }
}