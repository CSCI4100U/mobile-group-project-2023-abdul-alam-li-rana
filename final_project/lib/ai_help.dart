import 'package:final_project/help_page.dart';
import 'package:flutter/material.dart';

class AiHelp extends StatefulWidget {
  @override
  _AiHelpState createState() => _AiHelpState();
}

class _AiHelpState extends State<AiHelp> {
  int _selectedIndex = 1; // Set to 1 for the second option
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('AI Help'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: Center(
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'General Help',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Ai Help',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  // Handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to another page for the second option
      if (_selectedIndex == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HelpPage(), // Replace with the actual second page
          ),
        );
      }
    });
  }
}
