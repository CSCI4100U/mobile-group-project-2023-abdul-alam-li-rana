import 'package:flutter/material.dart';
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'sidebar.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double buttonSize = 175.0;
    TextStyle buttonTextStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.leave_bags_at_home),
          )
        ],
        backgroundColor: Colors.lightBlue,
        title: Text('Vehicle Management App'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.transparent, // Make the background transparent
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
}

