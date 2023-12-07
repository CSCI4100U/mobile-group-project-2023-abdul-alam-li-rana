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
import 'package:workmanager/workmanager.dart';
import 'notifications.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



void main() async {
  
  
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(
     
      callbackDispatcher,
     
    
      isInDebugMode: true
  );
  Workmanager().registerPeriodicTask(
    "2",
     
    
    "simplePeriodicTask",
     
    
    frequency: Duration(minutes: 15),
  );
  Workmanager().registerPeriodicTask(
    "2",
    "simplePeriodicTask",
    frequency: Duration(minutes: 15),
  );


    final FirebaseOptions options = FirebaseOptions(
    apiKey: "AIzaSyBw4q31TrgZ3aitI6fP94_6xkeCRrrVj9A",
    authDomain: "vroom-vroom-app.firebaseapp.com",
    projectId: "vroom-vroom-app",
    storageBucket: "vroom-vroom-app.appspot.com",
    messagingSenderId: "1:191947024815:android:b2972e3f4d59099071e75a",
    appId: "1:1021555712825:android:5bf312f690a25fecaa3ee8",
  );

  await Firebase.initializeApp(options: options);
  FirebaseAuth auth = FirebaseAuth.instance;



  runApp(MyApp());
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) {
     
    // initialise the plugin of flutterlocalnotifications.
    FlutterLocalNotificationsPlugin flip = new FlutterLocalNotificationsPlugin();
     
    // app_icon needs to be a added as a drawable
    // resource to the Android head project.
    var android = new AndroidInitializationSettings('@mipmap/ic_launcher');
    var IOS = new IOSInitializationSettings();
     
    // initialise settings for both Android and iOS device.
    var settings = new InitializationSettings(android, IOS);
    flip.initialize(settings);
    _showNotificationWithDefaultSound(flip);
    return Future.value(true);
  });
}


Future _showNotificationWithDefaultSound(flip) async {
   
  // Show a notification after every 15 minute with the first
  // appearance happening a minute after invoking the method
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id',
      'your channel name',
      'your channel description',
      importance: Importance.Max,
      priority: Priority.High
  );
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
   
  // initialise channel platform for both Android and iOS device.
  var platformChannelSpecifics = new NotificationDetails(
      androidPlatformChannelSpecifics,
      iOSPlatformChannelSpecifics
  );
  await flip.show(0, 'GeeksforGeeks',
    'Your are one step away to connect with GeeksforGeeks',
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





