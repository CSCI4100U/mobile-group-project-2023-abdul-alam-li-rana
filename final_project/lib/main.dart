import 'package:flutter/material.dart';
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'sidebar.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
    final FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyBw4q31TrgZ3aitI6fP94_6xkeCRrrVj9A",
    authDomain: "vroom-vroom-app.firebaseapp.com",
    projectId: "vroom-vroom-app",
    storageBucket: "vroom-vroom-app.appspot.com",
    messagingSenderId: "1:191947024815:android:b2972e3f4d59099071e75a",
    appId: "1:1021555712825:android:5bf312f690a25fecaa3ee8",
  );

  // Initialize Firebase with the constructed options
  await Firebase.initializeApp(options: options);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double buttonWidth = MediaQuery.of(context).size.width - 75;
    double buttonHeight = 175.0;

    TextStyle buttonTextStyle = TextStyle(
      fontSize: 30.0,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(160, 255, 255, 255),
        title: Text('Vehicle Management App'),
        centerTitle: true,
        automaticallyImplyLeading: false, // Prevent back arrow
      ),
      backgroundColor: Colors.grey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleHomePage()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  child: Text('Vehicles', style: buttonTextStyle),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripPage()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.blue),
                  child: Text('Trip', style: buttonTextStyle),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
              child: SizedBox(
                width: buttonWidth,
                height: buttonHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicePage()));
                  },
                  style: ElevatedButton.styleFrom(primary: Colors.red),
                  child: Text('Service', style: buttonTextStyle),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpPage()));
                    },
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                    child: Text('Help', style: buttonTextStyle),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


