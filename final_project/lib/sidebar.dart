// sidebar.dart

import 'package:flutter/material.dart';
import 'home_page.dart';  // Import the necessary files
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'service_page.dart';
import 'help_page.dart';

class SideMenu extends StatelessWidget {
  final BuildContext parentContext;

  SideMenu({required this.parentContext});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Colors.grey[900],
        child: Column(
          children: <Widget>[
            Container(
              height: 50.0,
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
    final bool isSelected = ModalRoute.of(parentContext)!.settings.name == page.toString();

    return HoveringWidget(
      onTap: () {
        Navigator.of(parentContext).pushReplacement(MaterialPageRoute(builder: (context) => page));
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
      ),
    );
  }
}
class HoveringWidget extends StatefulWidget {
  final VoidCallback onTap;
  final Function(bool) onHover;
  final Widget child;

  HoveringWidget({
    required this.onTap,
    required this.onHover,
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
        widget.onHover(true);
      },
      onExit: (_) {
        widget.onHover(false);
      },
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: isHover ? Colors.grey[800] : null,
          child: widget.child,
        ),
      ),
    );
  }
}


