import 'package:flutter/material.dart';
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'main.dart';
import 'home_page.dart';
class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.grey, // Background color for the header
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white, // Text color for the header
                fontSize: 24.0,
              ),
            ),
          ),
          ListTile(
            title: Text('Home'),
            tileColor: const Color.fromARGB(160, 255, 255, 255),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HomePage(),
              ));
            },
          ),
          ListTile(
            title: Text('Vehicles'),
            tileColor: Colors.green,
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => VehicleHomePage(),
              ));
            },
          ),
          ListTile(
            tileColor: Colors.blue,
            title: Text('Trips'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => TripPage(),
              ));
            },
          ),
          ListTile(
            tileColor: Colors.red,
            title: Text('Service'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => ServicePage(),
              ));
            },
          ),
          ListTile(
            tileColor: Colors.orange,
            title: Text('Help'),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => HelpPage(),
              ));
            },
          ),
        ],
      ),
    );
  }
}