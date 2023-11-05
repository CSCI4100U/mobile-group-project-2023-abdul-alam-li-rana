import 'package:flutter/material.dart';
import 'vehicle_homepage.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';
import 'login.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginForm();
        }
      },
    ));
  }
}

