import 'package:final_project/ai_help.dart';
import 'package:flutter/material.dart';
import 'sidebar.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0; // Index of the selected bottom navigation bar item

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orangeAccent,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text('FAQs'),
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 200.0,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search...',
                  hintStyle: TextStyle(color: Colors.white),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          _buildInfoRow(context, 'What is Vroom Vroom?',
              '''Vroom Vroom is a new multipurpose vehicle management app!
          \n\nAdd your vehicles, calculate mileage for trips, and view service/maintainence tips for your vehicle.
          \n\nWelcome to Vroom Vroom!'''),

          _buildInfoRow(context, 'How do I add vehicles?',
              '''To add vehicles, visit the vehicle page and press the "plus" button.
          \n\nThis will send you to the vehicle registration page. Enter your vehicle details and press the "save" button to confirm your changes.
          \n\nYour vehicle is now saved!'''),

          _buildInfoRow(context, 'How do I edit and delete vehicles?',
              '''When in the vehicle page, press the vehicle you"d like to edit/delete. Once selected, press either the "edit" or "trash" icons in the appbar.
          \n\nEditing will send you back to the vehicle registration page, allowing you to change any details about your vehicle.
          \n\nDeleting will delete it from our database.'''),

          _buildInfoRow(
              context,
              'How do I check my mileage for a trip in my vehicle?',
              '''To check your estimated mileage, head to the trip page and enter your route details (origin and destination points).
          \n\nSelect your vehicle from the vehicle page in the dropdown menu, and press the "plot route" button.
          \n\nThe app will then display the distance of the trip, and your estimated mileage according to your vehicle details.'''),

          _buildInfoRow(
              context,
              'Where do I go to view any details regarding vehicle service?',
              '''All service related details will be in the service page.
              \n\nThe service page displays a multitude of information for your vehicle. Check the page regularly for perioidic tips and tricks to keep your car in optimal condition.'''),

          _buildInfoRow(context, 'Can I ask for advice about my vehicles?',
              '''Certainly! Check out the AI help tool below to ask for advice regarding anything vehicle related!'''),

          _buildInfoRow(context, 'How do I navigate between the pages?',
              '''Press the 'hamburger' icon in the top-left corner of the screen. This will open a sidebar allowing you to navigate between all pages in the app!'''),
          // Add more rows as needed
        ],
      ),
      drawer: SideMenu(),
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
            label: 'AI Help',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String title, String details) {
    final searchText = _searchController.text.toLowerCase();

    // Check if the title or details contain the search text
    final bool matchesSearch = title.toLowerCase().contains(searchText) ||
        details.toLowerCase().contains(searchText);

    // Only show the item if it matches the search text
    if (searchText.isEmpty || matchesSearch) {
      return ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () {
          // Show a dialog with the row's details
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(title),
                content: Text(details),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Close the dialog
                    },
                    child: Text('OK'),
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      // If the item doesn't match the search, return an empty container
      return Container();
    }
  }

  // Handle bottom navigation bar item tap
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Navigate to another page for the second option
      if (_selectedIndex == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AiHelp(), // Replace with the actual second page
          ),
        );
      }
    });
  }
}
