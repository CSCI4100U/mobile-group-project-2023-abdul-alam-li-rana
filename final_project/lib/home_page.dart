import 'dart:typed_data';
import 'vehicle_homepage.dart';

import 'package:final_project/account.dart';
import 'package:final_project/account_model.dart';
import 'package:final_project/db_utils.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'trip_page.dart';
import 'help_page.dart';
import 'service_page.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vroom Vroom',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool snackbarFlag = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ImagePicker _picker = ImagePicker();
  File? _profilepic;
  List<Account> accounts = <Account>[];

  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser?.reload();
    _readAccounts();
  }

  @override
  Widget build(BuildContext context) {
    double buttonWidth = 150.0;
    double buttonHeight = 100.0;
    TextStyle buttonTextStyle = TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    );

    if (!snackbarFlag) {
      WidgetsBinding.instance?.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('You are Logged in')));
        snackbarFlag = true;
      });
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          )
        ],
        backgroundColor: Colors.grey[900],
        title: Text('Vroom Vroom'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
      ),
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          _buildGradientBackground(),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFancyButton(
                  "Vehicles",
                  Colors.teal,
                  Icons.directions_car,
                  buttonTextStyle,
                  400.0, // Adjust the width
                  100.0, // Adjust the height
                      () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => VehicleHomePage()));
                  },
                ),

                _buildFancyButton(
                  "Trip",
                  Colors.indigo,
                  Icons.airplanemode_active,
                  buttonTextStyle,
                  400.0, // Adjust the width
                  100.0, // Adjust the height
                      () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TripPage()));
                  },
                ),
                _buildFancyButton(
                  "Service",
                  Colors.pink,
                  Icons.build,
                  buttonTextStyle,
                  400.0, // Adjust the width
                  100.0, // Adjust the height
                      () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ServicePage()));
                  },
                ),
                _buildFancyButton(
                  "Help",
                  Colors.amber,
                  Icons.help,
                  buttonTextStyle,
                  400.0, // Adjust the width
                  100.0, // Adjust the height
                      () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HelpPage()));
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: _buildUserDrawer(),
    );
  }

  void _readAccounts() async {
    final allAccounts = await AccountModel().getAllAccounts();
    if (mounted) {
      setState(() {
        accounts = allAccounts.cast<Account>();
      });
    }
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (accounts.every((account) => account.email != user.email)) {
        Account newUserAccount = Account(email: user.email, profilePicture: null);
        await AccountModel().insertAccount(newUserAccount);
      }
    }

    if (accounts.isEmpty) {
      print('No accounts found in the database.');
    } else {
      print('All accounts in the database:');
      for (var account in accounts) {
        print('Email: ${account.email}, Profile Picture: ${account.profilePicture}');
      }
    }
  }

  Widget _buildUserDrawer() {
    User? user = FirebaseAuth.instance.currentUser;
    String? fullName = user?.displayName;
    String? email = user?.email;

    return FutureBuilder(
      future: _getProfilePicture(),
      builder: (context, AsyncSnapshot<Uint8List?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final profilePicture = snapshot.data;

          return Drawer(
            child: Container(
              color: Colors.grey[900],
              child: ListView(
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _showDialog(context);
                          },
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                            ),
                            child: profilePicture == null
                                ? Icon(
                              Icons.account_circle,
                              size: 60,
                              color: Colors.grey,
                            )
                                : ClipOval(
                              child: Image.memory(
                                profilePicture,
                                width: 80,
                                height: 80,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      ListTile(
                        title: Text(
                          'Username: $fullName',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          'Email: $email',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Future<Uint8List?> _getProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      Account? userAccount = await AccountModel().getAccountByEmail(user.email);

      if (userAccount != null && userAccount.profilePicture != null) {
        return Uint8List.fromList(userAccount.profilePicture!);
      }
    }
    return null;
  }

  Widget _buildGradientBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF3366FF),
            Color(0xFF6633FF),
          ],
        ),
      ),
    );
  }

  Widget _buildFancyButton(
      String label,
      Color color,
      IconData icon,
      TextStyle textStyle,
      double buttonWidth,
      double buttonHeight,
      void Function() onPressed,
      ) {
    return SizedBox(
      width: buttonWidth,
      height: buttonHeight,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: Colors.white,
            ),
            SizedBox(height: 10),
            Text(
              label,
              textAlign: TextAlign.center,
              style: textStyle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _showDialog(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Profile Picture'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: const Text('Take a picture'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _takePicture();
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: GestureDetector(
                    child: const Text('Choose from gallery'),
                    onTap: () {
                      Navigator.of(context).pop();
                      _pickImage();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _takePicture() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      _profilepic = File(pickedFile.path);
      _updateProfilePicture();
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profilepic = File(pickedFile.path);
      _updateProfilePicture();
    }
  }

  Future<void> _updateProfilePicture() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      if (_profilepic != null) {
        List<int> imageBytes = await _profilepic!.readAsBytes();
        await AccountModel().updateProfilePicture(user.email!, Uint8List.fromList(imageBytes));
        setState(() {});
      }
    }
  }
}
