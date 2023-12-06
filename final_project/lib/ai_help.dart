import 'package:flutter/material.dart';
import 'vehicle.dart';
import 'vehicle_dropdown.dart';
import 'sidebar.dart';
import 'dbops.dart';
import 'help_page.dart';
import 'api_utils.dart';

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

    String apiResult = await getAIHelp(_description, _selectedVehicle);
    if (apiResult == "False") {
      // If API call fails or returns false
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
        backgroundColor: Color(0xFF4CAF50), // Green color for the AppBar
        title: Text('AI Help'),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: SideMenu(parentContext: context),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Container(
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
                  border: OutlineInputBorder(),
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
                  primary: Color(0xFF4CAF50), // Green color for the button
                ),
                child: Text('Get Help'),
              ),
              SizedBox(height: 20),
              Container(
                height: 100,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    _apiResponse,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFF2E353F), // Dark gray color
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
      // Navigate to another page for the first option
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
