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
        title: Text(
          'FAQs',
          style: TextStyle(color: Colors.black)
          ),
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: Colors.black,
            ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search for FAQs:',
                    hintStyle: TextStyle(color: Colors.black),
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
              \n\nThis will send you to the vehicle registration page. Enter your vehicle details and press the 'save' button to confirm your changes.
              \n\nYour vehicle is now saved!'''),
      
            _buildInfoRow(context, 'How do I edit and delete vehicles?',
              '''When in the vehicle page, press the vehicle you'd like to edit/delete. Once selected, press either the 'edit' or 'trash' icons in the appbar.
              \n\nEditing will send you back to the vehicle registration page, allowing you to change any details about your vehicle.
              \n\nDeleting will delete it from our database.'''),
      
            _buildInfoRow(context, 'How do I check my mileage for a trip in my vehicle?',
              '''To check your estimated mileage, head to the trip page and enter your route details (origin and destination points).
              \n\nSelect your vehicle from the vehicle page in the dropdown menu, and press the 'plot route' button.
              \n\nThe app will then display the distance of the trip, and your estimated mileage according to your vehicle details.'''),
      
            _buildInfoRow(context, 'Where do I go to view any details regarding vehicle service?',
              '''All service related details will be in the service page.
              \n\nThe service page displays a multitude of information for your vehicle. Check the page regularly for perioidic tips and tricks to keep your car in optimal condition.'''),
    
            _buildInfoRow(context, 'Can I ask for advice about my vehicles?',
              '''Certainly! Check out the AI help tool below to ask for advice regarding anything vehicle related!'''),
      
            _buildInfoRow(context, 'How do I navigate between the pages?',
              '''Press the 'hamburger' icon in the top-left corner of the screen. This will open a sidebar allowing you to navigate between all pages in the app!'''),
      
            _buildInfoRow(context, '''I can't access the trip page!''',
              '''Your location permissions may not be activated for this app. Location services are required for trip page usage.
              \n\nPlease go into your device settings and enable location services for trip page access.'''),
      
            _buildInfoRow(context, '''Why can't I add my profile picture?''',
              '''Your camera roll and camera access may not be activated for this app. Profile picture functionality requires camera and photo access.
              \n\nPlease go into your device settings and enable location services for profile picture functionality.'''),

            _buildInfoRow(context, 'Why is my vehicle not being saved?',
              '''Please ensure that you have entered all mandatory details for your vehicle prior to saving.
              \n\nFields such as make, model, and year are required in order to save a vehicle.'''),
            
            _buildInfoRow(context, 'The trip page is not displaying my route!',
              '''Please ensure that your source and destination addresses contain
              \n- Street Number
              \n- Street Name
              \n- City
              \n- Province/State
              \n- Country
              \n\nAlternatively, use our autocorrect feature to select your desired address!'''),

            _buildInfoRow(context, 'My route distance is not the same as another mapping app!',
              '''Our app calculates the distance of your route by calculating the distance of each 'leg' or turn in your route and summing it together.
              \n\nPlease be aware that there will be small discrepencies in distance calculation among several mapping applications.'''),

            _buildInfoRow(context, 'Do I have to always sign in to use the app?',
              '''Not at all! Due to our account integration with Firestore cloud services, your session will persist even if you close the app!
              \n\n(Please note that this app will not persist on Chrome/Desktop instances of this app. Please use the "Stay Signed in" button on the sign-in page).'''),

            _buildInfoRow(context, 'Can I use the same email address for multiple accounts?',
              '''Unfortunately, email addresses cannot be used more than once for an account. Please use a different email address if you would like to create another account.'''),
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
      return Column(
        children: [
          SingleChildScrollView(
            child: ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                // Show a dialog with the row's details
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.orange,
                      title: Text(title),
                      content: Text(details),
                      actions: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context); // Close the dialog
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent),
                            child: Text(
                              'OK',
                              style: TextStyle(color: Colors.black),
                            )),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          Divider(
            height: 1,
            color: Colors.black,
          ),
        ],
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
