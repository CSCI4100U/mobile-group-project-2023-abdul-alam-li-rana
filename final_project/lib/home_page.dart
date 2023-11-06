import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  File? _profilepic;

  @override
  Widget build(BuildContext context) {
    double buttonSize = 175.0;
    TextStyle buttonTextStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.lightBlue,
        title: Text('Vehicle Management App'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu), // Menu icon
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer(); // Open the drawer when the menu icon is pressed
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildGradientBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShadedButton(
                  buttonSize,
                  Colors.teal,
                  Icons.directions_car,
                  'Vehicles',
                  buttonTextStyle,
                  () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleHomePage()));
                  },
                ),
                _buildShadedButton(
                  buttonSize,
                  Colors.indigo,
                  Icons.airplanemode_active,
                  'Trip',
                  buttonTextStyle,
                  () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripPage()));
                  },
                ),
                _buildShadedButton(
                  buttonSize,
                  Colors.pink,
                  Icons.build,
                  'Service',
                  buttonTextStyle,
                  () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicePage()));
                  },
                ),
                _buildShadedButton(
                  buttonSize,
                  Colors.amber,
                  Icons.help,
                  'Help',
                  buttonTextStyle,
                  () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildUserDrawer(),
    );
  }

  Widget _buildUserDrawer() {
  User? user = FirebaseAuth.instance.currentUser;
  String? fullName = user?.displayName;
  String? email = user?.email;

  return Drawer(
    child: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3366FF),
            Color(0xFF6633FF),
          ],
        ),
      ),
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.transparent, // Make the header background transparent
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    // Handle the profile picture edit action here
                    _showDialog(context);
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: _profilepic == null ? Icon(
                      Icons.account_circle,
                      size: 60,
                      color: Colors.grey,
                    ) : ClipOval(child: Image.file(_profilepic!,width: 80,height: 80,))
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              ListTile(
                title: Text(
                  'Username: $fullName',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                  ),
                ),
              ),
              ListTile(
                title: Text(
                  'Email: $email',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3366FF), // Adjust gradient colors as per your preference
            Color(0xFF6633FF),
          ],
        ),
      ),
    );
  }

  Widget _buildShadedButton(
    double buttonSize,
    Color color,
    IconData iconData,
    String label,
    TextStyle textStyle,
    void Function() onPressed,
  ) {
    return Container(
      width: buttonSize,
      height: buttonSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.6),
            spreadRadius: 3,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: CircleBorder(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(iconData, size: 80, color: Colors.white),
              SizedBox(height: 10),
              Text(label, style: textStyle.copyWith(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Future _getImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _profilepic = File(pickedFile.path);
      }
    });
  }

  Future _getImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _profilepic= File(pickedFile.path);
      }
    });
  }

  Future<void> _showDialog(BuildContext context) async {
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Choose an option'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Camera Roll'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _getImageFromGallery();
              },
            ),
            ListTile(
              title: Text('Camera'),
              onTap: () {
                Navigator.of(context).pop(); // Close the dialog
                _getImageFromCamera();
              },
            ),
          ],
        ),
      );
    },
  );
}
}