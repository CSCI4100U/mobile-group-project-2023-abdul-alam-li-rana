import 'package:flutter/material.dart';
import 'package:final_project/Vehicles/vehicle_homepage.dart';
import 'Trip/trip_page.dart';
import 'AI/help_page.dart';
import 'package:final_project/Services/service_page.dart';
import 'MainPages/sidebar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'MainPages/home_page.dart';
import 'MainPages/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'MainPages/verification_screen.dart';
import 'package:workmanager/workmanager.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';


void main() async {
  
  
    WidgetsFlutterBinding.ensureInitialized();

  const FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyBw4q31TrgZ3aitI6fP94_6xkeCRrrVj9A",
    authDomain: "vroom-vroom-app.firebaseapp.com",
    projectId: "vroom-vroom-app",
    storageBucket: "vroom-vroom-app.appspot.com",
    messagingSenderId: "1:191947024815:android:b2972e3f4d59099071e75a",
    appId: "1:1021555712825:android:5bf312f690a25fecaa3ee8",
  );

  await Firebase.initializeApp(options: options);
  FirebaseAuth auth = FirebaseAuth.instance;
  
  Workmanager().initialize(
      callbackDispatcher,
      isInDebugMode: false
  );
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    frequency: Duration(minutes: 15),
  );


  runApp(MyApp());
}

  void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {


    
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();

    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var settings = new InitializationSettings(android:android);

    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}
Future _showNotificationWithDefaultSound(flip) async {
  
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'Vroom',
      'VroomVehicleManagement',
      importance: Importance.max,
      priority: Priority.high
  );
   
  var platformChannelSpecifics = new NotificationDetails(
      android:androidPlatformChannelSpecifics,
  );
  await flip.show(0, 'Vroom',
    'Remember to update your Vehicle Milage!',
    platformChannelSpecifics, payload: 'Default_Sound'
  );
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





