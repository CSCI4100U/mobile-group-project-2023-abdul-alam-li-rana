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
import 'verification_screen.dart';

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
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  await user?.reload();
  user = auth.currentUser;

  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
  return MaterialApp(
  home: StreamBuilder(
    stream: FirebaseAuth.instance.authStateChanges(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.active) {
        final user = snapshot.data as User?;
        if (user != null) {
          if (user.emailVerified) {
            return HomePage();
          } else {
            // Check if the user signed out, and show the login form accordingly.
            return EmailVerificationScreen();
            print("after sign out?");
          }
        } else {
          return LoginForm();
        }
      }
      return CircularProgressIndicator();
    },
  ),
);
}
}





