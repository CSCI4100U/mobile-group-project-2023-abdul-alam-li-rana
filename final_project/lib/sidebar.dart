// sidebar.dart

import 'package:flutter/material.dart';
import 'home_page.dart';  // Import the necessary files
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'service_page.dart';
import 'help_page.dart';

class SideMenu extends StatefulWidget {
  final BuildContext parentContext;

  SideMenu({required this.parentContext});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  String selectedItem = '';

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: <Widget>[
            Container(
              height: 100.0,
              child: DrawerHeader(
                margin: EdgeInsets.zero,
                padding: EdgeInsets.all(0.0),
                decoration: BoxDecoration(
                  color: Colors.grey[000],
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                  ),
                ),
              ),
            ),
            _buildListTile('Home', Icons.home, Colors.blue, HomePage()),
            _buildListTile('Vehicles', Icons.directions_car, Colors.green, VehicleHomePage()),
            _buildListTile('Trips', Icons.map, Colors.purple, TripPage()),
            _buildListTile('Service', Icons.build, Colors.red, ServicePage()),
            _buildListTile('Help', Icons.help, Colors.orange, HelpPage()),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(String title, IconData icon, Color color, Widget page) {
    final bool isSelected = selectedItem == title;

    return HoveringWidget(
      isSelected: isSelected,
      onTap: () {
        if (isSelected) {
          // User clicked on the already selected item, handle accordingly (e.g., navigate to the page)
          Navigator.of(widget.parentContext).pushReplacement(MaterialPageRoute(builder: (context) => page));
        } else {
          // User clicked on a different item, update the selected item
          setState(() {
            selectedItem = title;
          });
        }
      },
      onHover: (val) {
        // Handle hover effect here if needed
      },
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[400],
          ),
        ),
        leading: Icon(
          icon,
          color: isSelected ? Colors.white : color,
        ),
        tileColor: isSelected ? Colors.grey[800] : null,
        shape: isSelected
            ? RoundedRectangleBorder(
          side: BorderSide(color: Colors.blue, width: 2.0),
          borderRadius: BorderRadius.circular(5.0),
        )
            : null,
      ),
    );
  }
}

class HoveringWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Function(bool) onHover;
  final bool isSelected; // Add this property
  final Widget child;

  HoveringWidget({
    required this.onTap,
    required this.onHover,
    required this.isSelected, // Add this line
    required this.child,
  });

  @override
  _HoveringWidgetState createState() => _HoveringWidgetState();
}

class _HoveringWidgetState extends State<HoveringWidget> {
  bool isHover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        if (!widget.isSelected) {
          widget.onHover(true);
        }
      },
      onExit: (_) {
        if (!widget.isSelected) {
          widget.onHover(false);
        }
      },
      child: GestureDetector(
        onTap: () {
          widget.onTap();
          if (widget.isSelected) {
            widget.onHover(false);
          } else {
            widget.onHover(true);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: isHover || widget.isSelected ? Colors.grey[800] : null,
          child: widget.child,
        ),
      ),
    );
  }
}
